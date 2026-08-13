#!/usr/bin/env python3
"""Fail closed when the public theorem inventory and dependency receipt drift."""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

inventory = json.loads((ROOT / "THEOREM_INVENTORY.json").read_text())
names = [entry["name"] for entry in inventory["declarations"]]

if len(names) != len(set(names)):
    raise SystemExit("duplicate declaration in THEOREM_INVENTORY.json")

audit_text = (ROOT / "Audit.lean").read_text()
audited = re.findall(r"^#print axioms\s+(\S+)\s*$", audit_text, re.MULTILINE)
if set(audited) != set(names) or len(audited) != len(names):
    missing = sorted(set(names) - set(audited))
    extra = sorted(set(audited) - set(names))
    raise SystemExit(f"inventory/receipt mismatch; missing={missing}; extra={extra}")

module_text = "\n".join(
    path.read_text() for path in sorted((ROOT / "APCILeanAudit").glob("*.lean"))
)
public_leaves = re.findall(r"^theorem\s+([A-Za-z0-9_']+)", module_text, re.MULTILINE)
inventory_leaves = [name.rsplit(".", 1)[-1] for name in names]
if sorted(public_leaves) != sorted(inventory_leaves):
    missing = sorted(set(public_leaves) - set(inventory_leaves))
    extra = sorted(set(inventory_leaves) - set(public_leaves))
    raise SystemExit(f"public theorem/inventory mismatch; missing={missing}; extra={extra}")

print(f"inventory exact: {len(names)} public declarations")
