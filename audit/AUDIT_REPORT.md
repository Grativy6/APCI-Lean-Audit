# APCI Lean audit report AR0001

Final classification: **LEAN_PROVED_BOUNDED**  
Verification date: 2026-08-13  
Verified source commit: `de0fc17996ac06e2be7a96c518745de636bf3fc7`

## Result

GitHub Actions run `31725279522`, job `94532003578`, completed successfully
under native Lean 4.32.1 (`f054605aea4b840552cca2e725580bffd1e1b704`).
It verified all 15 public declarations in `THEOREM_INVENTORY.json`.

Passed gates:

- empty Lake dependency manifest and core/local import boundary;
- exact 15-name theorem inventory;
- fail-closed source scan;
- `lake build` of `Interface`, `FiniteCapacity`, `Controls`, and the root library;
- bundled `leanchecker` replay;
- explicit `#print axioms` receipt; and
- rejection of any `sorryAx` occurrence in that receipt.

The uploaded receipt artifact is ID `9190984264`, size 474 bytes, with digest
`sha256:3f9b7f698261d8598d272c533e1c595ca341309a3d0c71496dc6f724948af99e`.
The downloaded ZIP reproduced that digest exactly. Its content is frozen in
`AXIOM_RECEIPT.txt`.

## Dependency interpretation

Four declarations are constructive at the receipt level: the two forward
fiber/certificate implications, left-inverse injectivity, and downstream
collision persistence. The empty-boundary controls are also dependency-free.

The reachable converse uses `Classical.choice` to select a representative of
each reachable fiber. The exact totalization theorems additionally report the
standard `propext` and `Quot.sound` dependencies introduced by their proof
machinery. The finite induction reports `propext` and `Quot.sound`; extracting
an explicit collision from non-injectivity additionally reports
`Classical.choice`. These are standard Lean dependencies, not user-declared
logical premises or incomplete proofs.

## Caged gremlins

1. A total decoder on every trace is not unconditionally equivalent to fiber
   constancy. The exact extra condition is `Nonempty (Trace → Answer)`; an
   inhabited answer type is a sufficient corollary.
2. The unconditional factorization theorem therefore lives on the explicit
   reachable-trace subtype `{t // ∃ x, trace x = t}`.
3. The finite-capacity theorem is an explicit induction, not a cardinality
   oracle imported from Mathlib.
4. A collision remains a collision only under post-processing of the same
   declared trace. Added side information changes the interface.
5. The external `nanoda` lane did not pass. It failed while parsing the Lean
   4.32.1 export before checking declarations; see `NANODA_COMPATIBILITY.md`.

## Authority verdict

`ACCEPT_BOUNDED`. The machine-checked result is the typed functional and finite
combinatorial core described in `AUDIT_SCOPE.md`. It proves no universal premise
about physical capacity, thermodynamic entropy, global certification, RH, or
P versus NP. No novelty claim is made for the elementary mathematics.
