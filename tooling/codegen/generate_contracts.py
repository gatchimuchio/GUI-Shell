from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[2]
SPECS = ROOT / "specs"
OUT = ROOT / "packages" / "shell_contracts" / "generated"

def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    index = []
    for path in sorted(SPECS.glob("*.schema.json")):
        data = json.loads(path.read_text(encoding="utf-8"))
        index.append({
            "file": path.name,
            "title": data.get("title", path.stem),
            "id": data.get("$id", "")
        })
    (OUT / "schema_index.json").write_text(
        json.dumps(index, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8"
    )
    print(f"generated {OUT / 'schema_index.json'}")

if __name__ == "__main__":
    main()
