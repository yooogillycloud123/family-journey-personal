# MOA R391 — Existing NAVER WebView session persistence / R393 forward restore (2026-11-12)

## User physical evidence and exact scope
- User reports: desktop PC and mobile Chrome NAVER login stable; only **inside MOA WebView**, after session expires, the NAVER receipt challenge recurs. User has now successfully authenticated inside MOA using NAVER one-time login number and checked **로그인 상태 유지**.
- Requirement is **retain the currently working MOA WebView login**, *not* automate or defeat CAPTCHA and not forcibly copy Chrome cookies.
- Existing R283 official NID Android-UA handling and CookieManager.flush were already in native classes13.dex. Past R373/R383 auth guard did **not** resolve later fresh-login challenge. Do not claim root cause proven.
- Current supplied source baseline: exact **R389** signed APK SHA256 \`3c90b908a4251a287daaa69a5976bc505c29862a7c7f92c288075593aac5f7ab\` (code389) from private Library.

## Additive, bounded mitigation
- GitHub branch \`feature/moa-r391-session-persist-20261112\`
- Native provider source \`experiments/moa-r391/MoaR391SessionPersistProvider.java\` and compile workflow \`.github/workflows/moa-r391-session-compile.yml\`.
- [CI 43215593154](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43215593154) **SUCCESS**. DEX SHA256 \`46205b836fa78d1502196bbe9809456f6b9bf69a978a6821dd3cc8066fbf24c9\` (4,188 bytes).
- Extra non-exported content provider \`com.juhyeon.familyjourney.MoaR391SessionPersistProvider\` registered in Manifest, authority \`com.juhyeon.familyjournea.r391session\`.
- Provider registers app ActivityLifecycleCallbacks. On Activity pause/stop, schedules a throttled, background \`CookieManager.getInstance().flush()\` for **existing WebView cookies only**. Reads **no cookie values**, never calls clear/remove/setCookie, does not make HTTP requests or perform login. Fail-open on exception; no UI, no additional launcher.
- This addresses a *possible durability gap*, NOT a proven reason for NAVER server logout. Existing R283 native cookie flush may already cover login completion. A server-invalidated session cannot be rescued by this helper. **Samsung real-world retention UNVERIFIED.**

## Signed APKs (original signer, no data wipe)
- \`MOA_R391_R389_NAVER_SESSION_PERSIST_SIGNED_BETA.apk\`: versionCode **391**, SHA256 **\`ef49bc1573536ad9be70bdee53816ffa8a28da2160ee0892cb7372ec46518b2e\`**, 8,916,809 bytes. Against R389: **138/139 original member payloads byte-identical**, only AndroidManifest changed; exactly **one additive classes17.dex**. All original 16 DEX, R345 NAVER writer/frame, Gallery/Diary/Voice, polished Moment recorder, and R389 pink home JS **exactly preserved**.
- \`MOA_R393_EXACT_R389_FUNCTIONS_FORWARD_RESTORE.apk\`: versionCode **393**, SHA256 **\`4e16edf341bf633eea6de525f9c8cada4564eb0ecf974cebec8ac6c9671bb602\`**, 8,912,415 bytes. Original R389 contents except Manifest code; no provider/new DEX. Use **only on severe R391 regression**, not an authentication fix. After R393, future version must exceed 393.
- Cert SHA256 original \`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15\`.
- Local independent APK Signature Scheme v2 RSA signature + **SHA-256 whole APK content digest cryptographic verification PASS**; ZIP CRC, STORED 4-byte alignment, all 16/17 DEX SHA1/Adler32, Android binary Manifest parse, matching cert PASS. These are **static only**.
- Full release ZIP \`MOA_R391_SESSION_PERSIST_R393_RECOVERY_BACKUP_QA.zip\` SHA256 \`a950356c538043bd5a0ca08cf87599c7247c7b13cd3f342ed80cb6bea3234458\`; contains both APKs, source, QA JSON, Korean README. Saved PRIVATE Library: \`/모아_프로젝트_근거_20261103/R391_SESSION_20261112/\`.
- Signing key/archive/password NEVER in GitHub or release ZIP. Immutable original R389 & R345 untouched.

## Install / test / do-not-do
1. For installed R389 or same-signature code <=390, install R391 **in-place only**, not uninstall; do not clear application data, cache, cookies, or NAVER app credentials.
2. Confirm first app opening and previously logged-in PC map still authenticated without re-login; inspect Diary, Gallery, Moment recording, favorite save, R389 pink home.
3. Then foreground/background + fully closing and reopening MOA; check login still present. Follow-up retention over days cannot be verified from static build.
4. If the NAVER session later expires or receipt CAPTCHA recurs, capture result but **do not spam authentication or assume R391 success**. Investigate exact NID redirect UA, native WebView process/data directory, cookie existence without values, and NAVER server expiry.
5. R393 emergency only if R391 causes meaningful regression. Do not install R393 automatically. If used, next candidate code>=394.
6. No AirPods/Android Auto code or runtime altered.

## Truth status
- Build / signer / archive integrity: **PASS**
- R391 Android installed: **NOT VERIFIED**
- User session preservation after update: **NOT VERIFIED**
- Future NAVER sign-in challenge prevention: **NOT GUARANTEED / NOT VERIFIED**
- NAVER account favorites save and general app regression: **NOT VERIFIED**
