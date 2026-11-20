# v0.1 roadmap and development gates

Task IDs refer to [tasks.csv](tasks.csv). This file records the evidence and sequencing for review. AI Project Manager owns task status. The CSV is a planning reference pending verification of its import format.

## M0 — Scope and design readiness

| Task | Documentation disposition | Evidence or remaining condition |
|---|---|---|
| T-001 | Scope complete | Approved v0.1 boundaries, Android/offline, Arabic RTL and currency assumptions in [Requirements](../docs/REQUIREMENTS.md) and [Decisions](../docs/DECISIONS.md) |
| T-002 | Approved personal rules documented | The [leave requirements](../docs/REQUIREMENTS.md#personal-leave-and-travel-rules-t-002) record the settings approved by the user and list unresolved details separately |
| T-003 | Model approved, operational inputs open | [Architecture](../docs/ARCHITECTURE.md) defines the ledger, pending remittance, cancellation, corrections and manual matching. Confirm real account roles and remittance routes, evidence for destination receipts, and effective dates of corrections affecting reconciled periods |
| T-004 | Design complete with conditional technical evidence | [Security](../docs/SECURITY.md) defines encryption, key handling and recovery. T-006 exercised the approach. Product implementation and physical-device evidence remain under M1 and M3 |
| T-005 | Wireflow documented; affected cases await T-003 | See the salary-day wireflow below. The T-003 operational inputs must be confirmed before accepting affected settlement and correction paths |
| T-006 | Isolated feasibility complete, accepted with conditions | [Toolchain and evidence](../docs/TOOLCHAIN.md) cover three final emulator runs. Physical arm64, physical 16 KB and full failure/migration coverage remain open. The separately authorized probe did not depend on the product salary wireflow |

Full M0 exit requires scope and design acceptance, documented user-approved personal leave settings and resolution of critical financial reconciliation rules. **Proposed finance-only gate:** the owner may separately authorize the synthetic-data financial foundation using the approved design and conditional T-006 baseline. Unresolved T-003 inputs block the affected remittance and reconciled-period correction workflows. Hold those substeps until their inputs are confirmed. This proposal requires owner approval under D-007 before any product coding.

### T-005 salary-day wireflow

1. Record USD salary in the source account. Choose the account, date and amount, preview the movement and save once. Show a similarity warning when appropriate.
2. Open the salary plan. Add destination or purpose allocations and show the unallocated remainder. Save as planned (`مخطط`).
3. Link part or all of an actual movement and show it as executed (`منفّذ`). A debited remittance awaiting receipt shows pending settlement (`قيد التسوية`). Allow the user to record known receipt values and purpose allocations.
4. Review observed receipt details or manual statement evidence. Confirm (`مؤكّد`) or leave open for matching. Show differences and earlier evidence. Route cancellations, refunds and corrections to their linked flows.
5. Present signed amounts, dates and currency codes in Arabic RTL. Show distinct totals for planned, executed, confirmed and unallocated amounts, with status text and field-level validation.

## M1 — Financial foundation and salary day

Start only after the owner approves the applicable M0 path and separately authorizes a bounded implementation task. The T-006 probe can inform implementation after source and license review. Keep all development and tests on synthetic data. Each row is a unit within the named existing task.

| Order and task | Inputs and dependencies | Output | Acceptance and completion | Codex scope |
|---|---|---|---|---|
| 1. T-008 — Storage foundation | Approved finance-only or full M0 gate, T-004 design, reviewed T-006 evidence and explicit bootstrap authorization | Product Android shell, Arabic RTL defaults, pinned build inputs, encrypted Drift storage and schema version 1 | Build and reopen a synthetic encrypted store offline on target Android. Verify correct and wrong key paths, recorded toolchain and reproducible dependency resolution | Bootstrap, local storage and focused tests only. Review probe before any reuse |
| 2. T-008 — Accounts and journal | Approved T-003 model, storage foundation, synthetic fixture accounts | Currency-aware accounts, optional openings, journal/postings, FX observations and account balance view | USD/NPR/EGP reconcile per currency. Reject unbalanced or duplicate writes. Verify missing opening and FX, atomic posting, an internal transfer and retry. Record fixture totals | Domain, persistence and related tests. No real bank or vendor identifiers |
| 3. T-007 — Salary and planning | Journal foundation and T-005 base wireflow | Salary deposit, budget allocations, partial execution links and confirmation view | Scenario 1 leaves USD 200 unallocated. Saving a plan leaves the book balance unchanged. Execution and confirmation remain separate and repeat-safe | Salary-day slice and its tests |
| 4. T-009 — Remittance and exceptions | T-008 journal, T-007 execution links and confirmed T-003 accounts/routes and settlement evidence | Pending and settled single-debit remittance, purpose allocations, cancellation and linked refund | Prove one debit across restart and retry, known net settlement, purpose limit, no assumed fees, and both cancellation paths. Confirm the real route assumptions in the evidence | Approved manual flows. Pause affected behavior when a critical rule is unresolved |
| 5. T-010 — USD cash withdrawals | T-008 journal and approved configurable withdrawal warning | Bank-to-cash transfer and monthly warning | USD 300 moves between personal accounts without spending. USD 550 in executed monthly withdrawals triggers the example USD 500 warning | Manual withdrawal recording and threshold tests |
| 6. T-011 — Reconciliation and offline regression | T-007 through T-010 and confirmed T-003 effective-date treatment for reconciled-period corrections | Manual statement matching, variance, linked reversal/replacement with re-matching, and recorded Android results | Keep history, balances and unmatched items correct through retry, correction and app restart. Run the salary-day fixture offline. Keep the affected correction path gated while its rule is open | Manual reconciliation and regression. Escalate a policy choice instead of inferring it |

**M1 exit:** approved salary-day paths balance, retain data across Android restart and pass offline with synthetic fixtures. [T-011 acceptance](../docs/T-011-ACCEPTANCE.md) remains conditional while T-003 decisions and physical-device validation are open. The earlier T-006 encryption and restore check remains feasibility evidence.

## M2 — Core v0.1 workflows

T-012 NPR expenses, T-013 personal leave balances, calendar and planning, T-014 leave savings and flight, T-015 physical gold and T-016 Thndr manual summary. T-013 uses the documented user-approved settings from T-002 and the local storage foundation from T-008. A pending user decision affects only the behavior that depends on it. T-014 builds on T-013 and T-007.

**M2 exit:** in-scope financial, leave, savings and asset workflows meet their [acceptance scenarios](../docs/ACCEPTANCE.md) with synthetic data, including offline persistence. Full backup and restore acceptance is evaluated under T-017 in M3.

## M3 — Recovery, device acceptance and delivery

T-017 protected backup, restore and migration coverage, T-018 privacy and licenses, T-019 physical-device usability and regression, and T-020 approved test APK and release notes.

**M3 exit:** prove clean-install restore and supported migrations with matching records and per-currency totals, verify failure and recovery on representative Android hardware, complete privacy and license review, and capture real-device evidence before the test APK gate. Physical 16 KB claims need matching physical hardware. Publishing a build requires separate authorization.

Codex may make reversible engineering choices, add focused tests and fix failures within an authorized unit. Pause for changes to approved financial semantics, scope changes, destructive work or external delivery. Keep task updates in AI Project Manager under existing IDs.
