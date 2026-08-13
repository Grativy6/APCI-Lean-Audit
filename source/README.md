# External source lock

`SOURCE_ARCHIVE.sha256` identifies the independently audited APCI Run 0001
archive from which this bounded formal target was extracted. The archive is not
published here by default and is not required to build or verify the Lean code.

Anyone auditing against an authorized copy can verify it with:

```bash
sha256sum Abstract_Physical_Certification_Impossibility_Run_0001.zip
```

The expected byte count is `53805`. See the repository-root `SOURCE_LOCK.md`
for the extracted-file hashes and authority boundary.
