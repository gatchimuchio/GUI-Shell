from __future__ import annotations

import argparse
import shutil
import subprocess
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


@dataclass(frozen=True)
class ValidationStep:
    name: str
    command: list[str]
    cwd: Path
    required_tool: str | None = None
    in_release_scope: bool = True
    post_v1_reason: str | None = None


def build_steps(include_mobile_release: bool) -> list[ValidationStep]:
    return [
        ValidationStep("schema_check", ["python3", "tooling/schema_check/check_schemas.py"], ROOT, "python3"),
        ValidationStep(
            "conformance_skeleton",
            ["python3", "tooling/conformance_tests/run_conformance_skeleton.py"],
            ROOT,
            "python3",
        ),
        ValidationStep("release_gate_check", ["python3", "tooling/release_gate_check.py"], ROOT, "python3"),
        ValidationStep("rust_helper_cargo_test", ["cargo", "test"], ROOT / "native" / "rust_helper", "cargo"),
        ValidationStep("desktop_flutter_analyze", ["flutter", "analyze"], ROOT / "apps" / "desktop_flutter", "flutter"),
        ValidationStep(
            "mobile_flutter_analyze",
            ["flutter", "analyze"],
            ROOT / "apps" / "mobile_flutter",
            "flutter",
            in_release_scope=include_mobile_release,
            post_v1_reason=None
            if include_mobile_release
            else "mobile full release is outside v1.0 desktop scope unless owner explicitly includes mobile",
        ),
    ]


def classify_not_run(step: ValidationStep, strict_release: bool) -> tuple[str, str, str, str]:
    if step.in_release_scope and strict_release:
        return ("release_blocker", "yes", f"{step.required_tool} not found on PATH", f"Install {step.required_tool} and rerun release validation.")
    if not step.in_release_scope:
        return ("post_v1_scope", "no", step.post_v1_reason or "outside v1.0 scope", "No v1.0 action required.")
    return ("release_blocker", "yes", f"{step.required_tool} not found on PATH", f"Install {step.required_tool} before release validation.")


def run_step(step: ValidationStep, strict_release: bool) -> dict:
    step_command = list(step.command)
    if strict_release and step.name == "release_gate_check":
        step_command.append("--strict-release")
    command = " ".join(step_command)
    if step.required_tool and shutil.which(step.required_tool) is None:
        classification, blocks_release, reason, required_action = classify_not_run(step, strict_release)
        return {
            "name": step.name,
            "command": command,
            "status": "not_run",
            "classification": classification,
            "blocks_release": blocks_release,
            "reason": reason,
            "required_action": required_action,
            "stdout": "",
            "stderr": "",
            "exit": "",
        }

    completed = subprocess.run(
        step_command,
        cwd=step.cwd,
        check=False,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    passed = completed.returncode == 0
    if not step.in_release_scope:
        classification = "post_v1_scope"
        blocks_release = "no"
        reason = step.post_v1_reason or "outside v1.0 scope"
        required_action = "No v1.0 action required unless owner includes this scope."
    else:
        classification = "none"
        blocks_release = "no"
        reason = ""
        required_action = ""
    if not passed and step.in_release_scope:
        classification = "release_blocker"
        blocks_release = "yes"
        reason = "validation command failed"
        required_action = "Fix the failing validation command and rerun."
    return {
        "name": step.name,
        "command": command,
        "status": "passed" if passed else "failed",
        "classification": classification,
        "blocks_release": blocks_release,
        "reason": reason,
        "required_action": required_action,
        "stdout": completed.stdout.rstrip(),
        "stderr": completed.stderr.rstrip(),
        "exit": str(completed.returncode),
    }


def print_report(mode: str, results: list[dict], blockers: list[dict]) -> None:
    print(f"validation_mode: {mode}")
    print("")
    print("checks:")
    for result in results:
        print(f"  - name: {result['name']}")
        print(f"    command: {result['command']}")
        print(f"    status: {result['status']}")
        print(f"    classification: {result['classification']}")
        print(f"    blocks_release: {result['blocks_release']}")
        print(f"    reason: {result['reason']}")
        if result["exit"]:
            print(f"    exit: {result['exit']}")
        if result["stdout"]:
            print("    stdout: |")
            for line in result["stdout"].splitlines():
                print(f"      {line}")
        if result["stderr"]:
            print("    stderr: |")
            for line in result["stderr"].splitlines():
                print(f"      {line}")
    print("")
    print("release_gate:")
    print(f"  status: {'fail' if blockers else 'pass'}")
    print("  blockers:")
    for blocker in blockers:
        print(f"    - item: {blocker['name']}")
        print(f"      reason: {blocker['reason']}")
        print(f"      required_action: {blocker['required_action']}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--strict-release", action="store_true")
    parser.add_argument(
        "--include-mobile-release",
        action="store_true",
        help="Treat mobile Flutter validation as in-scope for the release gate.",
    )
    args = parser.parse_args()

    mode = "strict_release" if args.strict_release else "development"
    results = [run_step(step, args.strict_release) for step in build_steps(args.include_mobile_release)]
    blockers = [
        result
        for result in results
        if result["classification"] == "release_blocker"
    ]
    print_report(mode, results, blockers)
    return 1 if blockers else 0


if __name__ == "__main__":
    raise SystemExit(main())
