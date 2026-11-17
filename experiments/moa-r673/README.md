# MOA R673 source patch / native PHOTO-ADD gesture and flicker mitigation

This feature branch is source/QA notes only; APKs are delivered in the user conversation/Library. User's exact R665 original PHOTO native Gallery remains immutable.

- Base: same-signer signed MOA R671 (versionCode671)
- R673: versionCode673; SHA256 `fbed6f62cc5ce23895c57474f42d63abf93b5970275591bebe7b980706abd5fe`; 9,473,717 bytes.
- R674: versionCode674; SHA256 `adf09483ea3ef6d0c494331631bb908f411354be9016bc8a67286148263e9efd`; 9,271,330 bytes; same user-physical R665 functional APK contents except manifest version.
- Original 18 Android DEX byte-identical R671/R665; only classes19.dex rebuilt for independent picker.
- Active JS change only: remove full-screen `view.replaceChildren(elem('p','moa-r592-loading','저장된 일기를 불러오는 중…'))` in `r592PrepareView`, leaving prior visible calendar/photo DOM until after asynchronous IndexedDB hydration then one render. No R507 original Gallery Java or direct native PHOTO owner code changed.
- NativePickerActivity separate from original R463/R507: main photo fling doesn't change index; one ACTION_UP touches at most one photo (190ms repeat guard); 41-thumb persistent window; bitmap LruCache, separate thumbnail decode executor, immediate scrollTo selection; black fullscreen native presentation. It is a **separate native implementation**, NOT the original Gallery engine.
- Official Android SDK35 apksigner, aapt, aapt2 manifest and zipalign checks all passed. Chromium 360/390/412 picker QA and native PHOTO mock + simulated 240ms IndexedDB loading-no-blank QA all passed. **Galaxy hardware R673 installation and end-to-end PHOTO-ADD behavior NOT TESTED**.
- APK output & exact changed source available in private ChatGPT Library: `/모아_프로젝트_근거_20261103/R673_NATIVE_PICKER_ONE_SWIPE_FLICKER_20261117`.
- Raw user videos 23408.mp4 and 23407.mp4 were inspected but NOT published to GitHub.
- Read canonical handoff [MOA R673](https://github.com/yooogillycloud123/family-journey-personal/blob/main/MOA_R671_USER_VIDEO_FLICKER_PICKER_SWIPE_R673_SIGNED_R674_RECOVERY_20261117.md).
