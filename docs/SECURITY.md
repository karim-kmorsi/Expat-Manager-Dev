# Security and privacy baseline

- Private GitHub repository; never upload real financial data, account IDs, recipient identities, actual balances, medical details, gold addresses, credentials, tokens or signing keys.
- Only fictional fixtures in tests or documentation.
- App must work offline for core functions. Design encrypted on-device storage/backups and recoverable export/import before processing real data.
- Record sick leave documentation presence/status, not medical diagnosis by default.
- No direct bank or Thndr authentication or automated transactions.
- Test backup restores, database migration, financial reconciliation and data integrity.
- Audit open-source dependency licenses before distribution; private repository alone is not sufficient secret protection.
- Exclude environment secrets, signing keys, private exports, databases, backups and local build artifacts from Git commits.