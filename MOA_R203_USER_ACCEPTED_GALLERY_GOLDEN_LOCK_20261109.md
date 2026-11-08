# MOA R203 — USER-ACCEPTED GALLERY GOLDEN LOCK (2026-11-09)

## Acceptance scope
On 2026-11-09 the user explicitly said regarding **installed R203**: “하단에 썸네일 스와이프 관성은 잘 구현했는데”, “일단 아주 만족스러워”, and “이 버전을 골든에도 추가해서 기록 남기고”. This is **direct physical-user acceptance of R203's native gallery inertial thumbnail swiping and existing playback/gallery baseline**, not a claim that all unrelated diary, backup, map, audio and external flows have passed full end-to-end regression. R203 is now the **user-accepted Gallery Golden**; retain original **R187 legacy scoped Golden** unchanged as an independent older baseline.

## Exact immutable R203 frozen binary and source identity
- Private original signed APK: `/모아_프로젝트_근거_20261103/MOA_R203_COMPACT_TOUCH_ALL_NATIVE_INERTIA_FLING_BETA.apk`; do not rename, mutate or overwrite. Package `com.juhyeon.familyjournea`, versionCode **203**, size **5,709,983 bytes**, SHA256 **6d85add0d0d97b08e90cec1fc13923cfa49faea1af66907350eb1f54a2b2c6a7**.
- Original signature certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, independently verified APK v2.
- Native source branch `feature/moa-r203-compact-center-pill-native-inertia-fling-20261109`, `experiments/moa-r175/MoaNativeGallery.java`, exact Git blob SHA `8be3bc864c21fd01d8cf19006448e9e0a32ef9af`, CI commit `592745659ebbd6e249c7c78cd7426529f90e978e`, run `42494987936` SUCCESS, DEX artifact `13623341631`, dex SHA256 `5e64ed65d6b3775490a820659d9c05f3811088a162b3fbda5e9b2a18557de47e`.
- Original R187 legacy Golden signed APK SHA256 **4380ca0a421c3a12cfad0334e860e659112b116f6cc7099f8989475c646a97e9** preserved byte-for-byte; R201 earlier fallback signed SHA256 **ffe9f1c1bbfb6e0cf81017eea903c9bbc45dd35145b35e170a14775ac5bcffaa** preserved. Do not use emergency forward APK automatically; no uninstall/data clear.
- R203 image/voice/video/diary and app signer artifacts remain private; no family photos, personal recordings, or signing keys in GitHub.

## Freeze and extension policy
1. **Preserve R203 native inertial VelocityTracker→OverScroller→final 150ms snap, stage/thumbnail fractional sync and image/video transitions**, plus existing original media/diary/voice/backup flows. New versions must be based on this exact R203 package and checked for unchanged payloads wherever not intentionally touched.
2. New enhancements requested AFTER the R203 acceptance: smaller Galaxy-like capture / playback / mute vector icons with accurate PHOTO icon inside viewfinder, sound/speaker icon matching Samsung reference; clear rounded boundaries and touch/ripple feedback; non-destructive photo/video capture preview popping up just above capture button; gentle Samsung Gallery-style **vertical wave/parallax phase** on thumbnail media rail while a fast inertial swipe travels and decelerates, returning smoothly to y=0. **Do not sacrifice kinetic scrolling to introduce wave animation.**
3. Pending device test: capture popup, button hit areas / feedback / accessibility, wave smoothness at speed, and regression of the accepted R203 inertial fling; no automatic elevation of a new build to Golden until the user confirms.

## Full history
See `MOA_R203_COMPACT_FULL_PILL_NATIVE_INERTIAL_GALLERY_HANDOFF_20261109.md` for underlying signed build evidence, and `MOA_RELEASE_LEDGER_CURRENT.md` for chronological source and QA status.
