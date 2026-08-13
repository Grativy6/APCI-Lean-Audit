# Authority ceiling

The Lean core proves statements about typed functions, equality, reachable
fibers, finite types, and left inverses. It earns no stronger conclusion merely
because an informal interpretation uses the words *abstract*, *physical*,
*entropy*, or *certification*.

In particular, this repository does **not** prove:

- that every physically realizable completed protocol has finite trace capacity;
- that every physical or computational step loses information;
- that microscopic dynamics are irreversible;
- that a finite record cannot be part of an unbounded family of finite records;
- that finite proofs cannot certify infinite, finitely generated invariants;
- that anything coherent or incoherent lies "outside mathematics";
- RH, `P = NP`, `P ≠ NP`, independence, or a runtime lower bound for SAT; or
- novelty or priority for factorization through fibers, finite pigeonhole, or
  left-inverse injectivity.

The admissible physical corollary is conditional: after a concrete protocol's
accessible trace type and side-information boundary are declared, a proved
collision between alternatives requiring different answers blocks exact
trace-only certification. Adding side information changes the interface and
must be modeled explicitly.

Reversible computation, variable-length encodings, finite generators for
infinite families, and algebraic/global reasoning remain mandatory
counter-boundaries against broader promotions.
