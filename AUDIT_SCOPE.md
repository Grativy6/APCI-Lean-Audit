# Audit scope

Run ID: `APCI-LEAN-AR0001`  
Controlling source lock: `APCI-0001-SOURCES-v1`  
Lean toolchain: `leanprover/lean4:v4.32.1`

## Formal targets

The repository audits four targets from the source packet:

1. **APC-T01, typed fiber factorization.** Exact decoding on the reachable image
   is equivalent to constancy of the requested answer on trace fibers. A decoder
   on the entire trace type additionally needs a totalization condition. The
   exact condition formalized here is `Nonempty (Trace → Answer)`; an inhabited
   answer type is recorded as a convenient sufficient corollary.
2. **APC-T02, left inverse.** A left inverse makes its encoder injective.
3. **APC-T03, collapse persistence.** Equal traces remain equal after every
   declared deterministic post-processing function.
4. **APC-T04, finite capacity.** A function from `Fin (n + 1)` to `Fin n` has a
   collision, so it admits no exact left-inverse decoder.

The empty-world/nonempty-trace/empty-answer control is retained because it
refutes an unqualified total-decoder version of APC-T01.

## Evidence contract

A result is machine-checked only when the pinned native CI run succeeds. The
source archive's earlier `LEAN_BLOCKED_RECEIPT.md` remains historically true:
the predecessor packet itself claimed no completed Lean proof. This repository
is the new verification layer; it does not rewrite that prior receipt.

The public declaration inventory is in `THEOREM_INVENTORY.json`. `Audit.lean`
prints each declaration's logical dependencies. CI rejects an incomplete-proof
dependency and publishes the receipt as an artifact.

## Non-goals

The formalization does not define physics, entropy, thermodynamic work,
operational distinguishability, an observer, an abstract-to-physical map, an
infinite global certificate, RH, or P versus NP. Applying the finite theorem to
any such system requires a separately justified model and bridge.
