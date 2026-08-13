# APCI Lean Audit

This repository machine-checks the finite mathematical core extracted from
**Abstract-to-Physical Certification Impossibility Run 0001** (APCI-0001).
It is deliberately smaller than the surrounding conceptual packet.

The formal target is an interface theorem:

> An answer can be certified from a declared trace exactly when it is constant
> on that trace's reachable fibers. If an interface collapses two alternatives,
> deterministic post-processing of that trace cannot separate them again.

The Lean project also checks the finite one-more-than-capacity corollary: no
map `Fin (n + 1) → Fin n` is injective, and therefore no decoder can be a left
inverse of such an encoder.

**Current result:** `LEAN_PROVED_BOUNDED`. Native CI run `31725279522` passed
the complete Lake build, bundled `leanchecker`, source/inventory policy, and the
15-declaration logical-dependency receipt with no `sorryAx` dependency.

## Audit boundary

- Lean is pinned to `v4.32.1`.
- The proof uses Lean core plus bundled `Std`, with no Mathlib or third-party
  theorem dependency.
- The original audited run is source-locked by byte count and SHA-256. The
  predecessor archive is not published by default and is not a proof dependency.
- CI builds the library, checks the explicit theorem inventory, emits dependency
  receipts, and runs the bundled `leanchecker` replay.
- Proof holes, custom logical postulates, nonempty dependency manifests, and
  selected proof escapes are rejected by policy.

Read [`AUDIT_SCOPE.md`](AUDIT_SCOPE.md) for the exact theorem boundary and
[`AUTHORITY_CEILING.md`](AUTHORITY_CEILING.md) before interpreting the result.
The attempted independent `nanoda` replay and its Lean 4.32.1 parser blocker are
recorded in [`audit/NANODA_COMPATIBILITY.md`](audit/NANODA_COMPATIBILITY.md).
The frozen native receipt is summarized in
[`audit/AUDIT_REPORT.md`](audit/AUDIT_REPORT.md).

## Reproduce

Install `elan`, then run:

```bash
lake build
./scripts/policy_scan.sh
./scripts/check_inventory.py
lake env lean Audit.lean
```

The repository description and theorem names use **APCI** as a project label;
they do not assert novelty for the underlying elementary mathematics.

## Stewardship

Research direction and release authority: **Christopher D. Pang**. AI systems
are used as formalization, audit, and red-team tools; they are not listed as
authors or independent sources of mathematical authority.
