# R269 Gold + NAVER Maps 6.7.2.1 split APK forensic/offscreen feasibility — 2026-11-10

**User requested no more manual testers and preservation of user-designated R269 Golden. No account writer APK is being falsely released.**

## Frozen baseline
- Immutable-named user-designated Gold source + metadata committed at [golden/moa-r269-user-designated-freeze-20261110](https://github.com/yooogillycloud123/family-journey-personal/blob/golden/moa-r269-user-designated-freeze-20261110/MOA_R269_USER_DESIGNATED_GOLDEN_LOCK_20261110.md).
- Exact signed APK versionCode269 `com.juhyeon.familyjournea`, SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920`, 8,932,642B; original certificate `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Conversation downloadable backup `MOA_R269_USER_GOLDEN_FREEZE_20261110.zip` SHA256 `d00d069243b1dbe33712517289268aff77c5734685ff0265c5c18cb8aa3f8016` contains original exact APK and 142-entry content-hash manifest. Library quota previously blocked APK upload; do not claim success there.
- User designates as Gold. R269 physical all-entry retest and nonoccupying save remain separate QA gates.

## Provided NAVER Map APK — actual static results, not guessed
Source `네이버지도-6.7.2.1-split-apks.zip` user-supplied private. **Never push proprietary APK/dex into GitHub**.
- Base `com.nhn.android.nmap` versionName6.7.2.1 versionCode60702000 min26 target35, 217,265,938 B SHA `4224516090af0fc34ca4391aec939c28c54c39b2714ab18dad737aa5700506d1`.
- ARM64 split SHA `1824dfa4e92db2eb6eb25c477ac74a8b4b0093881635e32b8ac4d086de0fc66a`; xxhdpi split SHA `97f9614fd6405e27d3d1515295a72146869cde74c77fd368f87eb15abbb9326e`.
- Base holds 42 dex. Parsed the binary AndroidManifest.xml via aapt, enumerated 139 Activity/Service/Provider/Receiver/alias declarations (22 explicitly exported).
- Exported `com.naver.map.LaunchActivity` aliases real `MainActivity` for geo:, nmap:, navermaps: and assorted first-party verified HTTPS app links; **no exported user favorite/create-folder/write contract** found. `NaverAuthenticationService` exported as `android.accounts.AccountAuthenticator`, not bookmark writer; internal map providers not exported.
- Parsed all 42 DEX string tables and decoded selected classes.dex: actual `BookmarkRepositoryImpl`, `PlacesAndFoldersLoader`, `BookmarkApi`, `BookmarkFolderApi`, `BookmarkPlaceDialogFragment`, and `WebBridgeAction$SaveBookmark` exist. These are **private NAVER process architecture**, not inter-app callable APIs. Avoid copying closed-source proprietary classes, token/CSRF/captcha bypass, app-signature impersonation.
- NAVER public URL scheme list provides map/place/search/route/navigation; no personal bookmarks write. NAVER Login OAuth scopes documented for permitted Open APIs, not private map bookmarks. Official: https://guide.ncloud-docs.com/docs/maps-url-scheme , https://developers.naver.com/products/intro/plan/plan.md . Android `exported=false` protection: https://developer.android.com/privacy-and-security/risks/android-exported .
- Existing user-verifiable foreground first-party NAVER Accessibility workflow `naverArm` must remain intact. On Android 15+, background activity launches are constrained, so hidden virtual display and faux overlay are not an authenticated offscreen writer. Android documentation: https://developer.android.com/guide/components/activities/secure-bal and https://developer.android.com/reference/android/accessibilityservice/AccessibilityService .
- Existing browser UI automation repositories e.g. https://github.com/dayeonisme/navermap-converter demonstrate desktop browser sessions, not APK-internal auth. An existing blog found direct private write returns `ncaptcha token is invalid`; do not bypass it. https://saramjh.github.io/naver-map-save-list-bulk-reorganize-guide/

## Concrete research implementation — source only, NOT a working NAVER account saver
Local audit artifacts provided with the current conversation:
1. `MOA_R269_GOLDEN_NAVER_6721_SECURITY_RESEARCH_20261110.zip`: full Korean report + scrubbed 139-component exported metadata JSON, SHA256 `78fe62ce10dad85c8191fede565c630465c4a2cb6c67625dc68f917b67eb028f`.
2. `MOA_R269_NAVER_6721_OFFSCREEN_RESEARCH_SOURCE_ONLY.zip`: `MoaNaverOffscreenBrowserProbe.java` (Android WebView attached to a 1×1 surface in MOA Activity; first-party-only public DOM inspection, no login or writes), `MoaNaverBookmarkTransaction.js` (first-party browser writer interface, idempotent folder/place/alias/memo write then exact readback, no false success), tests. Android Java SDK35 javac PASS, Node syntax + five synthetic tests PASS. **No real authenticated NAVER writer adapter exists in this source ZIP.** No user APK produced by this research.
3. Full report in the local `moa_naver_6721_audit/VERIFIED_FINDINGS_KO.md`.

## Sole plausible zero-screen-occupation track under original constraints
```
MOA original photo/QuickRecord GPS+address+text/memo+alias+folder
  -> exact Naver place ID identification (ambiguous = user confirmation, never guess)
  -> one-app persistent idempotent job queue
  -> user-consented, independent **same-MOA-process first-party authenticated web session**
  -> browser backend legitimately loads actual Naver Map saved-place UI without mobile-landing redirect
  -> first-party in-page UI actions (no undocumented private API/captcha bypass)
  -> exact Naver personal list/place SID/alias/memo readback
  -> CONFIRMED only on server-side exact match; otherwise PENDING/ERROR/NEEDS_USER
```
The **blocking gate** is Android browser engine + legitimate authenticated Naver first-party UI save/readback without app switching. R241 WebView mobile-root redirect and R235 standalone Place Save button not opening the modal demonstrate it is not solved. GeckoView/embedded Chromium are candidates but NAVER compatibility and login must be physically proven; Google/third-party SDK and OAuth token don't grant Map bookmarks. Do not ship another beta before passing that gate.

## Release safety
- Follow the R269 Golden and user-proven R261 foreground favorite flow as read-only baseline.
- Any build must use same package, original signer and >269 version, with narrow diff+DEX/ZIP/v2+actual Galaxy stage evidence. No uninstall, storage clear, auxiliary apps, PC workers, fake fullscreen screen cover or hardcoded private credentials.
