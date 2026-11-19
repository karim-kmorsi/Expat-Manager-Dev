# Decision log

| ID | Decision | State |
|---|---|---|
| D-001 | Name Expat Manager | Provisionally approved |
| D-002 | Tagline Work • Leave • Money • Home | Provisionally approved |
| D-003 | Android first, desktop later. Core workflows run offline | Approved |
| D-004 | Private, independent GitHub repository | Implemented |
| D-005 | Independent app using suitable OSS libraries | Approved direction |
| D-006 | Flutter 3.50.0 and bundled Dart 3.14.0, Drift 2.35.4, sqlite3 3.9.1 and SQLite3MultipleCiphers 2.6.1 | Tested baseline with conditional feasibility acceptance. See [T-006 evidence](TOOLCHAIN.md) |
| D-007 | Product programming requires explicit authorization and the applicable M0 gate | Approved |
| D-008 | Manual Thndr total summary for v0.1 | Approved |
| D-009 | Physical gold items tracked separately, with independent owner and custodian fields | Approved |
| D-010 | One outgoing bank remittance with multiple purposes. Record known costs and exchange data. Fee breakdown is optional | Approved |
| D-011 | AI Project Manager tracks tasks. GitHub holds code and docs | Approved |
| D-012 | Simplified double-entry ledger, distinct plan/execution/confirmation, optional opening balances and manual reconciliation. Support pending settlements, reversals and re-matching | Approved design. Operational inputs remain open under T-003 |
| D-013 | Arabic-first with RTL and legible dates, signed amounts, currency codes and bank references. USD, NPR and EGP initially, with additional currencies supported | Approved |
| D-014 | Keystore-wrapped local database keys. Password-encrypted portable backup with sodium 4.1.2+1 / libsodium 1.0.22. Verified staging and transactional replacement of live data | Approved design direction and conditionally accepted feasibility. Product and physical-device acceptance remain open |
| D-015 | Early isolated encryption/restore check under T-006. Full backup and restore acceptance under T-017 in M3 | Approved sequence |

## Open decisions

- T-002 needs the employer's official rules for casual/sick leave accounting, holidays, exceptions and flight eligibility.
- T-003 needs representative source and destination accounts and settlement evidence for the actual remittance routes. Confirm the financial effective-date treatment of corrections that affect a previously reconciled period.
- The finance-only M0 gate is a proposal for the owner to approve with a separate implementation authorization. See the [roadmap](../planning/ROADMAP.md).
- Brand availability and the final release license remain open before publication.
