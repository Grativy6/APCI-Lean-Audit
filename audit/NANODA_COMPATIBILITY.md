# Nanoda compatibility receipt

Status: **EXTERNAL CHECKER BLOCKED BEFORE DECLARATION CHECKING**

GitHub Actions run: `31724897997` (`APCI Lean audit`, run 8)  
Commit: `fee665e1e90e93c28283cd73b8d0c2016ea06620`  
Lean: `4.32.1`, commit `f054605aea4b840552cca2e725580bffd1e1b704`  
Lean action: `38fbc41a8c28c4cbaec22d7f7de508ec2e7c0dd9`

Before the external-checker attempt:

- all four Lake build targets passed;
- bundled `leanchecker` completed successfully; and
- no dependency receipt was yet emitted because the composite action stopped at
  the later external-checker step.

The action then cloned and built `lean4export` and `nanoda_lib` debug branch
(`nanoda_lib v0.3.2`). Export of `APCILeanAudit` completed:

```text
Export file size: 592193566 bytes
Export file lines: 10751497 lines
```

The checker exited before producing a declaration-level result:

```text
Error: invalid digit found in string
run with `-h` or `--help` for help
```

This is not a `nanoda` pass and is not evidence against any declaration. It is a
reproducible compatibility boundary between the action's current external
export/checker lane and Lean 4.32.1. The required CI gate therefore retains the
native build and bundled `leanchecker`; a future compatible independent checker
can be added without changing the theorem statements.
