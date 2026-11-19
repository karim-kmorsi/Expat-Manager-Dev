# T-011 financial acceptance

**PASS WITH LIMITATIONS.** The tested financial flows are ready for repository security review. Physical-device acceptance and the open T-003 rules still apply before real-data acceptance.

## Executed verification

| Check | Result |
|---|---|
| Linux host | 54 tests passed, including the prior regression suites. Seven writer processes received SIGKILL after their writes and before the enclosing SQLite commit. The cases covered salary, account transfer, expense, remittance debit and receipt, correction, and reconciliation. A separate kill after salary commit exercised an identical retry. Pre-commit cases retained the exact committed rows. All retries left one complete operation. |
| Failure during SQL writes and migration | Forced remittance metadata failure after posting retained the prior rows for debit and receipt. A forced v4-to-v5 migration failure retained the v4 rows and encrypted recovery copy. After removing the injected failure, v5 retained the same postings. The regression suite also passed supported v1–v4 migrations. SQLite integrity, foreign keys and per-currency balance checks passed. |
| Android offline | Six integration tests passed on API 36, x86_64, with 16,384-byte pages and no default network. These covered the full financial journey and the existing ledger, salary, cash, expense and remittance suites. The journey re-opened the encrypted store while the remittance was pending and again after reconciliation. A separate cold restart of the normal debug APK retained a synthetic account entered through the UI. |
| Privacy and encryption | The Keystore integration passed encrypted reopen and wrong-key rejection. The normal debug APK ledger and WAL contained no plaintext test marker. Nine sampled Android log files contained zero matches for the synthetic identifiers or sampled key-trace patterns. The release APK permission list excludes Internet permission. |
| Build | Static analysis passed. Android debug built and ran locally on x86_64. Android release built for both arm64-v8a and x86_64 and passed APK alignment verification using the 16 KB setting. |

The journey used a synthetic USD 2,000 salary and left USD 200 unallocated. After a cash withdrawal, cash spending, NPR bank and grouped spending, personal and family remittances, a linked reversal and correction, and balance reconciliation, the checks found USD 800 in the source bank, USD 260 added to the cash wallet, NPR 785 in the Nepal expense account, and EGP 6,000 in the personal destination. The EGP 7,500 family payment was recorded upon receipt. The NPR 5 balance difference went to the adjustment offset. Every journal entry in the fixture balanced independently by currency.

## Defect corrected

The common reversal path allowed a reversal or replacement to change an account in a reconciled period. The ledger now checks both the original and replacement account/date boundaries. It also protects reconciliation entries from generic reversal. Tests cover a replacement crossing into a different reconciled account, rollback of the attempted change, corrections in an open period, and exact retries after a later reconciliation.

## Open acceptance conditions

- T-003 still needs the real account routes and approved destination evidence, the effective-date rule and re-matching procedure for corrections in reconciled periods, handling for returns in a different currency, and the treatment of those returns in salary plans. The current app requires manually entered evidence, holds unsettled amounts open, records refunds in the source currency, and retains existing salary links after a refund. Reconciled-period corrections stay gated.
- Runtime verification covered the x86_64 emulator. Physical Android, arm64 runtime, physical 16 KB behavior and sudden power loss remain outside this evidence. The M3 portable backup and clean-install recovery gate remains open.
