# verifying release artifacts
```sh
slsa-verifier verify-artifact modpack-test-curseforge-0.1.0.zip \
  --provenance-path multiple.intoto.jsonl \
  --source-uri github.com/j-aub/modpack-test \
  --source-tag 0.1.0
```
