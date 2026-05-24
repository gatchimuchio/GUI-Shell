from __future__ import annotations

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


STEPS = [
    ValidationStep(
        name="schema_check",
        command=["python3", "tooling/schema_check/check_schemas.py"],
        cwd=ROOT,
        required_tool="python3",
    ),
    ValidationStep(
        name="conformance_skeleton",
        command=["python3", "tooling/conformance_tests/run_conformance_skeleton.py"],
        cwd=ROOT,
        required_tool="python3",
    ),
    ValidationStep(
        name="rust_helper_cargo_test",
        command=["cargo", "test"],
        cwd=ROOT / "native" / "rust_helper",
        required_tool="cargo",
    ),
    ValidationStep(
        name="desktop_flutter_analyze",
        command=["flutter", "analyze"],
        cwd=ROOT / "apps" / "desktop_flutter",
        required_tool="flutter",
    ),
    ValidationStep(
        name="mobile_flutter_analyze",
        command=["flutter", "analyze"],
        cwd=ROOT / "apps" / "mobile_flutter",
        required_tool="flutter",
    ),
]


def run_step(step: ValidationStep) -> str:
    command = " ".join(step.command)
    lines = [f"{step.name}:", f"command={command}"]
    if step.required_tool and shutil.which(step.required_tool) is None:
        lines.extend(["status=not run", f"reason={step.required_tool} not found on PATH"])
        return "\n".join(lines)

    completed = subprocess.run(
        step.command,
        cwd=step.cwd,
        check=False,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    status = "passed" if completed.returncode == 0 else "failed"
    lines.extend(
        [
            f"status={status}",
            f"exit={completed.returncode}",
            "stdout:",
            completed.stdout.rstrip(),
            "stderr:",
            completed.stderr.rstrip(),
        ]
    )
    return "\n".join(lines)


def main() -> int:
    reports = [run_step(step) for step in STEPS]
    print("\n\n".join(reports))
    failed = any("status=failed" in report for report in reports)
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
