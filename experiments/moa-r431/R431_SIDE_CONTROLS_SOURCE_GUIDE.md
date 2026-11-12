# MOA R431 reachable NAVER controls

Based on exact signed R427. Moves the tiny chevron away from top-right NAVER search and adds small pink native MOA return button. It calls original `setHidden(Activity,true)` to retain the current browser and authentication. Does not touch first-party NAVER account write, native Gallery, audio, or MOA UI.

Implementation lives in `experiments/moa-r391/MoaR391SessionPersistProvider.java` on this branch. It only changes `classes17.dex` in the final APK.