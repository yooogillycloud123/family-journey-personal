# MOA — Loglog actual APK technical evidence + family/PC sync architecture decision
**Date:** 2026-11-06. **Research/design only, no Loglog code copied into MOA, no live accounts/network traffic tested.**

## 1. Exact source provided by user and package-level evidence
- User-provided: `loglog-1.0.10-split-apks.zip`, 7,998,377 B. APK export `manifest.json`: **`com.klarwerk.loglog`**, appName `loglog`, versionName `1.0.10`, versionCode `14`, four split APKs. `base.apk` 14,816,864 B, SHA256 `1a0128e74cd2e04cb0feb51f661989f00d6e88b170148998a142ae190df21687`; arm64, ko and xxhdpi splits.
- `base.apk` contains Android DEX (three files) plus `assets/capacitor.config.json`, `assets/native-bridge.js`, `assets/public/index.html`, browser JavaScript bundles, `assets/public/sw.js`. Therefore a **Capacitor Android shell and shared web UI** is part of its architecture; this is not proof that every platform uses identical code.
- The ~2 MB web bundle contains Supabase client/realtime SDK and *application-specific subscriptions* to Postgres changes with `v3_*` task/list/section and workspace-scoped tables, and reconnect/visibility rechecks. This proves use of database-change subscriptions for parts of Loglog's shared workspace and delta detection; do not assume every feature has exactly same latency/merge policy.
- Bundled service worker `sw.js`: network-first navigation, cache-first fingerprinted same-origin static assets, excludes cross-origin Supabase requests and non-GET. The UI has visible `오프라인 · N건 대기`/`N건 보내는 중` states and an app-level outbox concept. No evidence for a 100 ms full round-trip SLA from code or docs.
- Android package contains Firebase messaging dependencies; do NOT conflate their existence with direct PC data sync or assume one exact push method.
- Official Google Play (app `com.klarwerk.loglog`): Mac/Windows and web offered at loglog.cloud. Apple official listing describes phone/web continuation, offline editing and auto upload on reconnection. Those are vendor claims, **not our independent real-time latency measurements**.
- Direct public GitHub source for this specific product was **not established** from indexed results at this checkpoint. Do not assume private compiled product source is permissively licensed or copy it. Supabase's separately licensed open SDK/realtime implementation is available publicly.

## 2. What Loglog actually suggests, vs what it does not prove
**Evidence-supported architecture pattern**:
1. Local-first optimistic edit immediately reflects within one device and enters durable outbox.
2. Authenticated network operation writes to shared database; revision/timestamp and server access policy constrain edits.
3. Other signed-in clients subscribe via persistent Realtime WebSockets to change feeds.
4. App rebases/reconciles on reconnect/foreground or missed events; snapshots/delta fetch correct gaps.
5. Static shell offline caching independent of operation/DB sync.

**Unproven**: always `0.1초` end-to-end between phone and Windows (network RTT, server, mobile idle/battery, offline). Nor is GitHub repository automatically a realtime data server. Without source server config and live tests exact conflict/queue rules cannot be asserted.

## 3. MOA-specific choices: Google Drive (Memoit-like) vs realtime backend
- **Google Drive**: excellent opt-in private backups/export, photos/ZIP or periodic snapshot sharing, low setup complexity, retains family ownership. Drive file API changes and notification channel/permission/network constraints are ill-suited for guaranteed sub-second bidirectional field-level edits; concurrent rewriting of one JSON file invites lost updates, schema/key collision and corruption. Preserve a separate backup/export route.
- **Supabase (recommended for future family schedule + PC)**: Auth, Postgres rows, per-family RLS, Realtime subscriptions (broadcast/Postgres changes), explicit offline op queue, two-device conflict handling, family invite/revoke. A browser-based PC MOA companion can work from Windows without an EXE, reusing compatible view logic and shared API; WebView app must be able to authenticate and refresh tokens securely. Requires server/account setup, privacy threat modelling, data access budget, persistent user consent.
- **Firestore alternative**: offline mobile client DB + realtime listeners; choose after cost/privacy vs Supabase assessment. Avoid creating both backends simultaneously.
- **GitHub**: versioned SOURCE/CI/QA/releases, not personal diary/child photo storage or collaborative family runtime backend. Never put private GPS, photos, credentials, auth secrets into a public repo. Supabase public `anon` publishable identifiers in compiled apps require rigorously enforced RLS; service-role secrets must remain server-only.
- **Hybrid recommendation**: MOA existing `familyjourney-diary-v1/curated` stays untouched/local authoritative, separate family-calendar `moa-family-calendar-v1` IndexedDB and outbox. Optionally sync selected event/metadata over server, not user's entire 13k photo library by default. Google Drive snapshot backup is a separate opt-in recovery feature, not realtime transport.

## 4. Concrete API/integrity design for later implementation
- Events use stable UUID IDs, `family_id`, `calendar_id`, `owner_uid`, `rev`, `updated_at`, `deleted_at`, `start_at_utc`, `timezone`, recurrence ID, participant ACL. `oplog` uses idempotency `op_id`, device ID, base revision; server assigns monotonic sequence / conflict response. Stable photo references on original device are not identical to spouse device MediaStore IDs.
- On user edit: IndexedDB transaction records new event + outbox; UI immediate `로컬 저장됨`, then server acknowledgement `동기화 완료`, offline `대기 n건`, conflict `검토 필요`. Broadcast incoming events should trigger idempotent delta fetch; never rely on WebSocket as only source of truth.
- On reconnect, app foreground, tab visibility, network change: pull missing changes since server cursor; push queued changes with bounded exponential backoff, handle duplicates, reorder and deletes. Never silently erase originals or repeat irreversible operations.
- For two devices editing same event, optimistic revision concurrency and intentional UI conflict resolution; bounded-clock and timezone/DST tests, offline double edit, permission revocation, repeated notifications, retention and export policy.
- Privacy: per-user/family ACL and Postgres RLS, invite expiration, token revocation, least-privilege database permissions, encryption in transit/at rest, selective media uploading, no child photos/precise home GPS in public logs, opt-in family sharing. For cloud photo sync, separate encrypted blobs, dedupe, quota and consent.
- Performance QA: phone↔Windows both online (p50/p95/P99 and SLA target not promised), device idle, Wi-Fi ↔ LTE, offline 30min, conflicts, reconnect, long-running app with 13k photo library, battery/notification restrictions.

## 5. Navigation correction (express user priority)
User explicitly rejected family events hidden under `기록`. Future dedicated fifth primary tab: **일기 | 가족 일정 | 나의 지도 | 기록 | 설정**. The new family calendar starts as its own view (month/week/day), not a subview of diary nor generic record. Existing four tabs and all old functions preserved until this isolated next release is user-approved. No calendar backend/realtime added to R123.

## 6. Exact external reference links (no copied third-party code)
- Official Loglog Google Play: https://play.google.com/store/apps/details?id=com.klarwerk.loglog
- Official Apple App Store: https://apps.apple.com/kr/app/loglog-%EB%A1%9D%EB%A1%9D/id6811599447
- Supabase Realtime reference: https://supabase.com/docs/guides/realtime
- Loglog official product web: https://loglog.cloud (not independently fetched via current web tool)
- Original private user-supplied APK resides only in conversation/Library, NOT on public GitHub.