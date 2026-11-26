.class public final Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;
.super Landroid/content/ContentProvider;
.source "MoaR507InlineGalleryProvider.java"

# interfaces
.implements Landroid/app/Application$ActivityLifecycleCallbacks;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;,
        Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$R594InfoDot;
    }
.end annotation


# static fields
.field private static final ARM_SNAPSHOT:Ljava/lang/String; = "(function(){try{var d=window.MoaR469SimpleDiary,s=d&&d.readOnlyStatus&&d.readOnlyStatus();var e=document.querySelector(\'#moa-r469-root .moa-r469-stage\');if(!window.__moaR511InlineArm||!s||!s.active||s.page!==\'day\'||!e)return JSON.stringify({active:false});var r=e.getBoundingClientRect();return JSON.stringify({active:true,x:r.left,y:r.top,w:r.width,h:r.height,vw:innerWidth,vh:innerHeight,cover:(window.__moaR507CoverId||\'\'),token:(window.__moaR527DayToken||0)});}catch(e){return JSON.stringify({active:false});}})()"

.field private static final R570_ROLES:[Ljava/lang/String;

.field private static final R657_STALE_EVAL_MS:J = 0xdacL

.field private static final SNAPSHOT:Ljava/lang/String; = "(function(){try{var d=window.MoaR469SimpleDiary,s=d&&d.readOnlyStatus&&d.readOnlyStatus();var e=document.querySelector(\'#moa-r469-root .moa-r469-stage\');if(!s||!s.active||s.page!==\'day\'||!(window.__moaR507NativePending===true||window.__moaR511InlineArm===true)||!e) return JSON.stringify({active:false});var r=e.getBoundingClientRect();return JSON.stringify({active:true,x:r.left,y:r.top,w:r.width,h:r.height,vw:innerWidth,vh:innerHeight,cover:(window.__moaR507CoverId||\'\'),token:(window.__moaR527DayToken||0)});}catch(e){return JSON.stringify({active:false});}})()"


# instance fields
.field private actionCapsule:Landroid/widget/LinearLayout;

.field private actionDeck:Landroid/widget/FrameLayout;

.field private advancedButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

.field private ambientMediaId:Ljava/lang/String;

.field private ambientParent:Landroid/view/ViewGroup;

.field private ambientPoster:Landroid/widget/ImageView;

.field private armDeadline:J

.field private armGuard:Landroid/view/ViewTreeObserver$OnPreDrawListener;

.field private armRoot:Landroid/widget/FrameLayout;

.field private armedState:Lorg/json/JSONObject;

.field private backOwner:Landroid/app/Activity;

.field private backgroundStartedAt:J

.field private baseX:I

.field private baseY:I

.field private compactDone:Z

.field private controlledRebuildInProgress:Z

.field private coverStar:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

.field private exitInFlight:Z

.field private favoriteButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

.field private fillPrepareAttempts:I

.field private foreground:Landroid/app/Activity;

.field private foregroundEpoch:I

.field private fullNativeLastId:Ljava/lang/String;

.field private fullNativeLastIndex:I

.field private fullNativeOpen:Z

.field private fullNativeSeenOpen:Z

.field private fullNativeStartedAt:J

.field private fullscreenOwnerActivity:Landroid/app/Activity;

.field private galleryRef:Ljava/lang/Object;

.field private hadMountedOnPause:Z

.field private inactiveAt:J

.field private initialCardChromeHidden:Z

.field private inlineArmed:Z

.field private inlineBack:Landroid/window/OnBackInvokedCallback;

.field private lastFillAt:J

.field private lastFillId:Ljava/lang/String;

.field private lastGeometrySnapshotAt:J

.field private lastGeometrySnapshotY:I

.field private lastH:I

.field private lastHello:J

.field private lastIndex:I

.field private lastMediaRefreshAt:J

.field private lastNativeBackAt:J

.field private lastPortInitAttempt:J

.field private lastPosition:J

.field private lastPositionMessageAt:J

.field private lastRebindAt:J

.field private lastResumeAt:J

.field private lastValidSnapshot:J

.field private lastVideoGeometryId:Ljava/lang/String;

.field private lastW:I

.field private lastX:I

.field private lastY:I

.field private lifecyclePauseInProgress:Z

.field private final main:Landroid/os/Handler;

.field private monitoredHost:Landroid/widget/FrameLayout;

.field private monitoredHostListener:Landroid/view/View$OnAttachStateChangeListener;

.field private nativeCloseDetectedAt:J

.field private nativeHost:Landroid/widget/FrameLayout;

.field private nativeLower:Landroid/widget/LinearLayout;

.field private nativeOwnerActivity:Landroid/app/Activity;

.field private ownedDayToken:I

.field private ownerDayAtPause:Ljava/lang/String;

.field private ownsGallery:Z

.field private positionPort:Landroid/webkit/WebMessagePort;

.field private positionPortSettingUp:Z

.field private positionWeb:Landroid/webkit/WebView;

.field private prePauseRetainAt:J

.field private prePausedOwnerActivity:Landroid/app/Activity;

.field private prePausedRetainedGallery:Ljava/lang/Object;

.field private processing:Z

.field private final r570Actions:Ljava/util/LinkedHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/LinkedHashMap<",
            "Ljava/lang/String;",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field

.field private r570OrderDialog:Landroid/app/AlertDialog;

.field private r570SaveDialog:Landroid/app/AlertDialog;

.field private r572FastRestoreDone:Z

.field private r572FastRestorePending:Z

.field private r572FastSeen:Z

.field private r572FastState:Z

.field private r572FirstPhotoDeadline:J

.field private r572FirstPhotoPending:Z

.field private r572LastVideoRail:Ljava/lang/Boolean;

.field private r572NativeMountAck:Z

.field private r592InfoRestoreDone:Z

.field private r594InfoDot:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$R594InfoDot;

.field private r594InfoDotOwner:Landroid/view/View;

.field private r596WarnedPhotoId:Ljava/lang/String;

.field private r602LastAppliedSignature:Ljava/lang/String;

.field private r602LastJavaSignal:Ljava/lang/String;

.field private r602LastJavaSignalAt:J

.field private r602LastPlaylistPollAt:J

.field private r602PlaylistPolling:Z

.field private r611AccessibilityObserver:Landroid/database/ContentObserver;

.field private r611HealthyCheckSeq:I

.field private r611LastNaverToggleAt:J

.field private r611NaverEnabled:I

.field private r611NaverToggleSeq:I

.field private r657EvalGeneration:I

.field private r657EvalKind:Ljava/lang/String;

.field private r657EvalStartedAt:J

.field private r657EvalWeb:Landroid/webkit/WebView;

.field private railExpanded:Z

.field private railToggle:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

.field private railToggleInstalled:Z

.field private railView:Landroid/view/View;

.field private resumed:Z

.field private returnCloseGuardUntil:J

.field private returnFromBackground:Z

.field private snapshotFailures:I

.field private suppressArmUntil:J

.field private final ticker:Ljava/lang/Runnable;


# direct methods
.method public static synthetic $r8$lambda$7N_VXcnpvAnJPhIiTT-RHwr0zoY(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;ILandroid/webkit/WebView;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$rebindAfterReturn$26(Landroid/app/Activity;ILandroid/webkit/WebView;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$E4KdnVYUil3KeU07EJuILD8eGzE(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;ILandroid/app/Activity;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$r611MarkNaverAccessChange$0(ILandroid/app/Activity;)V

    return-void
.end method

.method public static synthetic $r8$lambda$HW6QJPOhWn03iQ0of7r7bV17aNk(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/content/DialogInterface;I)V
    .locals 0

    invoke-direct/range {p0 .. p9}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$r570OpenFavorite$18(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/content/DialogInterface;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$LHbHZF2uBwBjnDz7NE6XP2zfuhk(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/webkit/WebView;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$installInlineBack$8(Landroid/app/Activity;Landroid/webkit/WebView;)V

    return-void
.end method

.method public static synthetic $r8$lambda$LwWD9kCS5jq40lfDiorb3_iHXUo(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$ensurePositionChannel$1(Landroid/webkit/WebView;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$PNxYt_baSGIJUbLaeXPyKilq9zg(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/content/DialogInterface;I)V
    .locals 0

    invoke-direct/range {p0 .. p9}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$r570OpenFavorite$17(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/content/DialogInterface;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$PvmN0TGVFpWHGqXOL4lgWhxCN58(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;ILjava/lang/Object;Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 0

    invoke-direct/range {p0 .. p5}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$rebindAfterReturn$24(Landroid/app/Activity;ILjava/lang/Object;Landroid/webkit/WebView;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$SB4QQQZhrV_184jclzpkYTDdO5c(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$installRailToggle$21(Landroid/app/Activity;Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$X4qMw2amOWOPTFSCN-ZLWH8k0pI(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;ILjava/lang/Object;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$rebindAfterReturn$25(Landroid/app/Activity;ILjava/lang/Object;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$Xr7cZv3z7ZoGQtwn_VHW5fTi37Y(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Ljava/lang/Object;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$tick$2(Ljava/lang/Object;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$Zhovn82yqs-96EFxRa3vdjc2NeA(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;I)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$onActivityResumed$27(Landroid/app/Activity;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$Zzuv4iL_AuK0qclwaNaLHMCXuDs(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$installInlineBack$7(Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$d5uv9J0cIPhlZ39-6osgSS7Xj5w(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$retireDayBackIfInactive$6(Landroid/app/Activity;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$hKKXGwWdI7-m8srHCAFaLVIKwNs(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Ljava/lang/Object;Landroid/widget/FrameLayout;ILjava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$refreshOriginalMediaIfBlank$23(Ljava/lang/Object;Landroid/widget/FrameLayout;ILjava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$jUgHd--Z9bgnBI7QfZjPGipxraw(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$compactNativeCard$10(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$k2ZV_aCWnjFoVSpwIm169Vl9gFI(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;ILandroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$maybeArm$4(ILandroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$nu_PZkCQl3jMrvOUzjDqskiV90U(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Ljava/lang/Object;Landroid/app/Activity;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$exitForegroundClosedGallery$5(Ljava/lang/Object;Landroid/app/Activity;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$oHgaRgfSreD_WAnb7K53ZoItbbA(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/util/ArrayList;[ILandroid/content/DialogInterface;I)V
    .locals 0

    invoke-direct/range {p0 .. p6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$r570OpenOrder$15(Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/util/ArrayList;[ILandroid/content/DialogInterface;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$qtlxzruSL1wJ508N1Urw91XoG_U(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/widget/LinearLayout;Landroid/view/View;)Z
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$r570InitActionOrder$12(Landroid/app/Activity;Landroid/widget/LinearLayout;Landroid/view/View;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$r279RQcfNNX0wKq8bbZ0rlzQnSI(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;I)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$onActivityResumed$28(Landroid/app/Activity;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$sf25HuFrWp6BU47qrabMMvBPwcw(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/util/ArrayList;[ILandroid/content/DialogInterface;I)V
    .locals 0

    invoke-direct/range {p0 .. p6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$r570OpenOrder$14(Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/util/ArrayList;[ILandroid/content/DialogInterface;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$vkYoEZsD1aUtsnezTJOD3KSCfrE(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/webkit/WebView;Ljava/lang/Object;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$compactNativeCard$11(Landroid/webkit/WebView;Ljava/lang/Object;Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$y8Jv57HUR4HAelCsZYFs3wzTc9w(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;ILandroid/app/Activity;Ljava/lang/Object;Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 0

    invoke-direct/range {p0 .. p5}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$tick$3(ILandroid/app/Activity;Ljava/lang/Object;Landroid/webkit/WebView;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$zk4MPa-9-kW17uooR9HsFgzRyDs(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Ljava/lang/Object;Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lambda$r602PollPlaylist$22(Ljava/lang/Object;Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$fgetarmDeadline(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)J
    .locals 2

    iget-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->armDeadline:J

    return-wide v0
.end method

.method static bridge synthetic -$$Nest$fgetarmRoot(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)Landroid/widget/FrameLayout;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->armRoot:Landroid/widget/FrameLayout;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetarmedState(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)Lorg/json/JSONObject;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->armedState:Lorg/json/JSONObject;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetcontrolledRebuildInProgress(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->controlledRebuildInProgress:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetforeground(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)Landroid/app/Activity;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetfullNativeOpen(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeOpen:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetgalleryRef(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)Ljava/lang/Object;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetinlineArmed(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inlineArmed:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetlifecyclePauseInProgress(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lifecyclePauseInProgress:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmain(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)Landroid/os/Handler;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->main:Landroid/os/Handler;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmonitoredHost(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)Landroid/widget/FrameLayout;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->monitoredHost:Landroid/widget/FrameLayout;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetnativeHost(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)Landroid/widget/FrameLayout;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetnativeOwnerActivity(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)Landroid/app/Activity;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetownsGallery(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetpositionPort(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)Landroid/webkit/WebMessagePort;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionPort:Landroid/webkit/WebMessagePort;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetpositionWeb(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)Landroid/webkit/WebView;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionWeb:Landroid/webkit/WebView;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetresumed(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->resumed:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$mattachCard(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Lorg/json/JSONObject;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->attachCard(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Lorg/json/JSONObject;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mdisarm(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->disarm()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mexitForegroundClosedGallery(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->exitForegroundClosedGallery(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monPositionMessage(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->onPositionMessage(Landroid/webkit/WebView;Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mr611OnNaverAccessChange(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611OnNaverAccessChange()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mtick(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->tick()V

    return-void
.end method

.method static bridge synthetic -$$Nest$smgalleryOpen(Ljava/lang/Object;)Z
    .locals 0

    invoke-static {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$smisTrustedWeb(Landroid/webkit/WebView;)Z
    .locals 0

    invoke-static {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->isTrustedWeb(Landroid/webkit/WebView;)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$smreadField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    .locals 0

    invoke-static {p0, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method static constructor <clinit>()V
    .locals 8

    .line 129
    const-string v6, "rail"

    const-string v7, "expand"

    const-string v0, "cover"

    const-string v1, "share"

    const-string v2, "naver"

    const-string v3, "info"

    const-string v4, "fast"

    const-string v5, "favorite"

    filled-new-array/range {v0 .. v7}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->R570_ROLES:[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 6

    .line 64
    invoke-direct {p0}, Landroid/content/ContentProvider;-><init>()V

    .line 66
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->main:Landroid/os/Handler;

    .line 72
    const-wide/16 v0, 0x0

    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnCloseGuardUntil:J

    .line 79
    const/4 v2, 0x0

    iput v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalGeneration:I

    .line 80
    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalStartedAt:J

    .line 81
    const-string v3, "idle"

    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalKind:Ljava/lang/String;

    .line 117
    const-string v3, ""

    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastFillId:Ljava/lang/String;

    .line 118
    const/4 v4, -0x1

    iput v4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastIndex:I

    .line 119
    const/high16 v5, -0x80000000

    iput v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastX:I

    iput v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastY:I

    .line 120
    iput v4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastW:I

    iput v4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastH:I

    .line 127
    new-instance v5, Ljava/util/LinkedHashMap;

    invoke-direct {v5}, Ljava/util/LinkedHashMap;-><init>()V

    iput-object v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    .line 130
    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->initialCardChromeHidden:Z

    .line 131
    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeOpen:Z

    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeSeenOpen:Z

    .line 132
    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeStartedAt:J

    .line 135
    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientMediaId:Ljava/lang/String;

    .line 137
    const/4 v5, 0x1

    iput-boolean v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railExpanded:Z

    .line 139
    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r592InfoRestoreDone:Z

    .line 144
    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FirstPhotoPending:Z

    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572NativeMountAck:Z

    .line 145
    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FirstPhotoDeadline:J

    .line 146
    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r596WarnedPhotoId:Ljava/lang/String;

    .line 147
    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastRestorePending:Z

    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastRestoreDone:Z

    .line 148
    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastSeen:Z

    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastState:Z

    .line 149
    const/4 v5, 0x0

    iput-object v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572LastVideoRail:Ljava/lang/Boolean;

    .line 169
    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastVideoGeometryId:Ljava/lang/String;

    .line 185
    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnFromBackground:Z

    .line 186
    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->backgroundStartedAt:J

    .line 187
    iput v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foregroundEpoch:I

    .line 188
    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->hadMountedOnPause:Z

    .line 189
    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastRebindAt:J

    .line 190
    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastMediaRefreshAt:J

    .line 195
    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->prePauseRetainAt:J

    .line 199
    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lifecyclePauseInProgress:Z

    .line 202
    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastResumeAt:J

    .line 203
    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->controlledRebuildInProgress:Z

    .line 204
    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownerDayAtPause:Ljava/lang/String;

    .line 206
    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602LastJavaSignalAt:J

    .line 207
    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602LastJavaSignal:Ljava/lang/String;

    .line 216
    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602LastPlaylistPollAt:J

    .line 217
    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602PlaylistPolling:Z

    .line 218
    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602LastAppliedSignature:Ljava/lang/String;

    .line 223
    iput v4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611NaverEnabled:I

    .line 224
    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611LastNaverToggleAt:J

    .line 225
    iput v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611NaverToggleSeq:I

    iput v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611HealthyCheckSeq:I

    .line 298
    iput v4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeLastIndex:I

    .line 299
    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeLastId:Ljava/lang/String;

    .line 329
    new-instance v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$2;

    invoke-direct {v0, p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$2;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)V

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ticker:Ljava/lang/Runnable;

    return-void
.end method

.method private actualMediaReady(Ljava/lang/Object;)Z
    .locals 4

    .line 1491
    invoke-static {p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_8

    return v1

    .line 1492
    :cond_8
    invoke-static {p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    .line 1493
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_13

    return v1

    .line 1494
    :cond_13
    const-string v2, "v"

    invoke-virtual {v0, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    const/4 v2, 0x1

    if-eqz v0, :cond_4a

    .line 1495
    const-string v0, "texture"

    invoke-static {p1, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .line 1496
    instance-of v3, v0, Landroid/view/TextureView;

    if-eqz v3, :cond_48

    check-cast v0, Landroid/view/TextureView;

    invoke-virtual {v0}, Landroid/view/TextureView;->isAvailable()Z

    move-result v0

    if-eqz v0, :cond_48

    sget-object v0, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    .line 1497
    const-string v3, "prepared"

    invoke-static {p1, v3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_48

    .line 1498
    const-string v0, "media"

    invoke-static {p1, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    instance-of p1, p1, Landroid/media/MediaPlayer;

    if-eqz p1, :cond_48

    move v1, v2

    goto :goto_49

    :cond_48
    nop

    .line 1496
    :goto_49
    return v1

    .line 1500
    :cond_4a
    const-string v0, "images"

    invoke-static {p1, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    .line 1501
    instance-of v0, p1, [Landroid/widget/ImageView;

    if-eqz v0, :cond_67

    .line 1502
    check-cast p1, [Landroid/widget/ImageView;

    .line 1503
    array-length v0, p1

    if-le v0, v2, :cond_66

    aget-object v0, p1, v2

    if-eqz v0, :cond_66

    aget-object p1, p1, v2

    invoke-virtual {p1}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object p1

    if-eqz p1, :cond_66

    move v1, v2

    :cond_66
    return v1

    .line 1505
    :cond_67
    return v1
.end method

.method private attachCard(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Lorg/json/JSONObject;)V
    .locals 21

    .line 738
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object/from16 v2, p2

    move-object/from16 v3, p3

    move-object/from16 v4, p4

    const-string v5, "host"

    invoke-static {v3, v5}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v5

    .line 739
    const-string v6, "stage"

    invoke-static {v3, v6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v6

    .line 740
    instance-of v7, v5, Landroid/widget/FrameLayout;

    if-eqz v7, :cond_223

    instance-of v7, v6, Landroid/widget/FrameLayout;

    if-nez v7, :cond_20

    goto/16 :goto_223

    .line 741
    :cond_20
    check-cast v5, Landroid/widget/FrameLayout;

    check-cast v6, Landroid/widget/FrameLayout;

    .line 742
    const v7, 0x1020002

    invoke-virtual {v1, v7}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v7

    check-cast v7, Landroid/widget/FrameLayout;

    .line 743
    if-eqz v7, :cond_21d

    invoke-virtual {v5}, Landroid/widget/FrameLayout;->getParent()Landroid/view/ViewParent;

    move-result-object v8

    if-ne v8, v7, :cond_21d

    invoke-virtual {v6}, Landroid/widget/FrameLayout;->getParent()Landroid/view/ViewParent;

    move-result-object v6

    if-eq v6, v5, :cond_3d

    goto/16 :goto_21d

    .line 746
    :cond_3d
    const-string v6, "vw"

    invoke-virtual {v4, v6}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;)D

    move-result-wide v8

    const-string v6, "vh"

    invoke-virtual {v4, v6}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;)D

    move-result-wide v10

    .line 747
    const-wide/high16 v12, 0x4059000000000000L    # 100.0

    cmpg-double v6, v8, v12

    if-ltz v6, :cond_21c

    cmpg-double v6, v10, v12

    if-gez v6, :cond_55

    goto/16 :goto_21c

    .line 748
    :cond_55
    invoke-virtual/range {p2 .. p2}, Landroid/webkit/WebView;->getWidth()I

    move-result v6

    int-to-double v12, v6

    div-double/2addr v12, v8

    invoke-virtual/range {p2 .. p2}, Landroid/webkit/WebView;->getHeight()I

    move-result v6

    int-to-double v8, v6

    div-double/2addr v8, v10

    .line 749
    const-wide v10, 0x3fc999999999999aL    # 0.2

    cmpg-double v6, v12, v10

    if-ltz v6, :cond_21b

    const-wide/high16 v14, 0x4024000000000000L    # 10.0

    cmpl-double v6, v12, v14

    if-gtz v6, :cond_21b

    cmpg-double v6, v8, v10

    if-ltz v6, :cond_21b

    cmpl-double v6, v8, v14

    if-lez v6, :cond_7a

    goto/16 :goto_21b

    .line 750
    :cond_7a
    const/4 v6, 0x2

    new-array v10, v6, [I

    new-array v6, v6, [I

    .line 751
    invoke-virtual {v2, v10}, Landroid/webkit/WebView;->getLocationInWindow([I)V

    invoke-virtual {v7, v6}, Landroid/widget/FrameLayout;->getLocationInWindow([I)V

    .line 753
    const/4 v11, 0x0

    aget v14, v10, v11

    aget v15, v6, v11

    sub-int/2addr v14, v15

    int-to-double v14, v14

    const-string v11, "x"

    invoke-virtual {v4, v11}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;)D

    move-result-wide v17

    mul-double v17, v17, v12

    add-double v14, v14, v17

    invoke-static {v14, v15}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->rounded(D)I

    move-result v11

    .line 754
    const/4 v14, 0x1

    aget v10, v10, v14

    aget v6, v6, v14

    sub-int/2addr v10, v6

    int-to-double v14, v10

    const-string v10, "y"

    invoke-virtual {v4, v10}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;)D

    move-result-wide v17

    mul-double v17, v17, v8

    add-double v14, v14, v17

    invoke-static {v14, v15}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->rounded(D)I

    move-result v10

    .line 755
    const-string v14, "w"

    invoke-virtual {v4, v14}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;)D

    move-result-wide v14

    mul-double/2addr v14, v12

    invoke-static {v14, v15}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->rounded(D)I

    move-result v12

    const-string v13, "h"

    invoke-virtual {v4, v13}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;)D

    move-result-wide v13

    mul-double/2addr v13, v8

    invoke-static {v13, v14}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->rounded(D)I

    move-result v8

    .line 756
    const/16 v9, 0x96

    if-lt v12, v9, :cond_21a

    const/16 v9, 0xb4

    if-ge v8, v9, :cond_cf

    goto/16 :goto_21a

    .line 757
    :cond_cf
    invoke-virtual {v7}, Landroid/widget/FrameLayout;->getWidth()I

    move-result v9

    const/4 v13, 0x3

    add-int/2addr v9, v13

    if-gt v12, v9, :cond_214

    invoke-virtual {v7}, Landroid/widget/FrameLayout;->getHeight()I

    move-result v9

    add-int/2addr v9, v13

    if-le v8, v9, :cond_e0

    goto/16 :goto_214

    .line 760
    :cond_e0
    iget-object v9, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    const-string v14, ""

    move-object v15, v7

    const-wide/16 v6, 0x0

    if-eq v5, v9, :cond_143

    .line 761
    const-string v9, "token"

    iget v13, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownedDayToken:I

    invoke-virtual {v4, v9, v13}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v9

    .line 762
    invoke-direct/range {p0 .. p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->clearCardMark()V

    iput-object v5, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    iput-object v3, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    iput-object v1, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    const/4 v13, 0x1

    iput-boolean v13, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    iput v9, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownedDayToken:I

    iput-wide v6, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastPositionMessageAt:J

    .line 763
    new-instance v9, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v9}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/high16 v13, -0x1000000

    invoke-virtual {v9, v13}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/high16 v13, 0x41b80000    # 23.0f

    invoke-static {v1, v13}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v13

    int-to-float v13, v13

    invoke-virtual {v9, v13}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    .line 764
    invoke-virtual {v5, v9}, Landroid/widget/FrameLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    const/4 v9, 0x1

    invoke-virtual {v5, v9}, Landroid/widget/FrameLayout;->setClipToOutline(Z)V

    invoke-virtual {v5, v9}, Landroid/widget/FrameLayout;->setClipChildren(Z)V

    invoke-virtual {v5, v9}, Landroid/widget/FrameLayout;->setClipToPadding(Z)V

    .line 768
    const/4 v13, 0x0

    iput-boolean v13, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FirstPhotoPending:Z

    .line 769
    iput-object v14, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r596WarnedPhotoId:Ljava/lang/String;

    .line 770
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v16

    const-wide/16 v19, 0x3b6

    add-long v6, v16, v19

    iput-wide v6, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FirstPhotoDeadline:J

    .line 771
    iput-boolean v13, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572NativeMountAck:Z

    const/4 v6, 0x1

    iput-boolean v6, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastRestorePending:Z

    iput-boolean v13, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastRestoreDone:Z

    .line 772
    iput-boolean v13, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastSeen:Z

    const/4 v7, 0x0

    iput-object v7, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572LastVideoRail:Ljava/lang/Boolean;

    .line 773
    invoke-direct/range {p0 .. p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->installInlineBack(Landroid/app/Activity;Landroid/webkit/WebView;)V

    .line 774
    invoke-direct {v0, v1, v2, v3, v5}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->monitorNativeHost(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Landroid/widget/FrameLayout;)V

    .line 781
    :cond_143
    iget v7, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastW:I

    if-ltz v7, :cond_16c

    iget v7, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastH:I

    if-ltz v7, :cond_16c

    iget v7, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastW:I

    sub-int v7, v12, v7

    invoke-static {v7}, Ljava/lang/Math;->abs(I)I

    move-result v7

    const/high16 v9, 0x41100000    # 9.0f

    invoke-static {v1, v9}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v13

    if-gt v7, v13, :cond_16c

    iget v7, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastH:I

    sub-int v7, v8, v7

    invoke-static {v7}, Ljava/lang/Math;->abs(I)I

    move-result v7

    invoke-static {v1, v9}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v9

    if-le v7, v9, :cond_16a

    goto :goto_16c

    :cond_16a
    const/4 v7, 0x0

    goto :goto_16d

    :cond_16c
    :goto_16c
    const/4 v7, 0x1

    .line 782
    :goto_16d
    if-eqz v7, :cond_190

    .line 784
    new-instance v7, Landroid/widget/FrameLayout$LayoutParams;

    const/16 v9, 0x33

    invoke-direct {v7, v12, v8, v9}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    .line 785
    iput v11, v7, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    iput v10, v7, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 786
    invoke-virtual {v5}, Landroid/widget/FrameLayout;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v9

    invoke-virtual {v9}, Landroid/view/ViewPropertyAnimator;->cancel()V

    const/4 v9, 0x0

    invoke-virtual {v5, v9}, Landroid/widget/FrameLayout;->setTranslationX(F)V

    invoke-virtual {v5, v9}, Landroid/widget/FrameLayout;->setTranslationY(F)V

    .line 787
    invoke-virtual {v5, v7}, Landroid/widget/FrameLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    iput v11, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->baseX:I

    iput v10, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->baseY:I

    .line 788
    :cond_18f
    goto :goto_1b0

    :cond_190
    iget v7, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastX:I

    if-ne v11, v7, :cond_198

    iget v7, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastY:I

    if-eq v10, v7, :cond_18f

    .line 793
    :cond_198
    iget v7, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->baseX:I

    sub-int v7, v11, v7

    int-to-float v7, v7

    invoke-virtual {v5, v7}, Landroid/widget/FrameLayout;->setTranslationX(F)V

    iget v7, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->baseY:I

    sub-int v7, v10, v7

    int-to-float v7, v7

    invoke-virtual {v5, v7}, Landroid/widget/FrameLayout;->setTranslationY(F)V

    .line 794
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v6

    iput-wide v6, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastGeometrySnapshotAt:J

    .line 795
    iput v10, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastGeometrySnapshotY:I

    .line 797
    :goto_1b0
    iput v11, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastX:I

    iput v10, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastY:I

    iput v12, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastW:I

    iput v8, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastH:I

    .line 798
    add-int/2addr v8, v10

    if-ltz v8, :cond_1c7

    invoke-virtual {v15}, Landroid/widget/FrameLayout;->getHeight()I

    move-result v6

    if-le v10, v6, :cond_1c2

    goto :goto_1c7

    .line 799
    :cond_1c2
    const/4 v6, 0x0

    invoke-virtual {v5, v6}, Landroid/widget/FrameLayout;->setVisibility(I)V

    goto :goto_1cb

    .line 798
    :cond_1c7
    :goto_1c7
    const/4 v6, 0x4

    invoke-virtual {v5, v6}, Landroid/widget/FrameLayout;->setVisibility(I)V

    .line 800
    :goto_1cb
    invoke-direct {v0, v1, v2, v5, v3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->compactNativeCard(Landroid/app/Activity;Landroid/webkit/WebView;Landroid/widget/FrameLayout;Ljava/lang/Object;)V

    .line 801
    invoke-direct {v0, v3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->syncAdvancedButton(Ljava/lang/Object;)V

    .line 802
    invoke-static/range {p3 .. p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    .line 803
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v6

    .line 806
    iget-object v8, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastFillId:Ljava/lang/String;

    invoke-virtual {v5, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_1ea

    .line 808
    iput-object v5, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastFillId:Ljava/lang/String;

    const/4 v5, 0x0

    iput v5, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fillPrepareAttempts:I

    const-wide/16 v8, 0x0

    iput-wide v8, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastFillAt:J

    .line 814
    :cond_1ea
    iget v5, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fillPrepareAttempts:I

    const/4 v8, 0x3

    if-ge v5, v8, :cond_204

    iget-wide v8, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastFillAt:J

    sub-long v8, v6, v8

    const-wide/16 v10, 0x2bc

    cmp-long v5, v8, v10

    if-lez v5, :cond_204

    .line 815
    invoke-direct {v0, v1, v3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fillNativeMediaCard(Landroid/app/Activity;Ljava/lang/Object;)V

    iput-wide v6, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastFillAt:J

    iget v5, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fillPrepareAttempts:I

    const/4 v6, 0x1

    add-int/2addr v5, v6

    iput v5, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fillPrepareAttempts:I

    .line 817
    :cond_204
    const-string v5, "cover"

    invoke-virtual {v4, v5, v14}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v0, v2, v3, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->syncIndex(Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;)V

    .line 818
    invoke-direct/range {p0 .. p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FinishEntry(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;)V

    .line 819
    invoke-direct/range {p0 .. p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572SyncFastSetting(Landroid/app/Activity;)V

    .line 820
    return-void

    .line 758
    :cond_214
    :goto_214
    const-string v1, "ATTACH_REJECTED_STAGE_SIZE"

    invoke-direct {v0, v2, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602Signal(Landroid/webkit/WebView;Ljava/lang/String;)V

    return-void

    .line 756
    :cond_21a
    :goto_21a
    return-void

    .line 749
    :cond_21b
    :goto_21b
    return-void

    .line 747
    :cond_21c
    :goto_21c
    return-void

    .line 744
    :cond_21d
    :goto_21d
    const-string v1, "ATTACH_REJECTED_HOST_HIERARCHY"

    invoke-direct {v0, v2, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602Signal(Landroid/webkit/WebView;Ljava/lang/String;)V

    return-void

    .line 740
    :cond_223
    :goto_223
    return-void
.end method

.method private clearCardMark()V
    .locals 7

    .line 689
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->stopMonitoringNativeHost()V

    .line 690
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->disarm()V

    .line 691
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->advancedButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    if-eqz v0, :cond_21

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->advancedButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_21

    .line 692
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->advancedButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->advancedButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 693
    :cond_21
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    if-eqz v0, :cond_43

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    invoke-virtual {v0}, Landroid/widget/ImageView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_43

    .line 694
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setVisibility(I)V

    .line 695
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    invoke-virtual {v0}, Landroid/widget/ImageView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 697
    :cond_43
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-eqz v0, :cond_5b

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    const-string v1, "texture"

    invoke-static {v0, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    instance-of v1, v0, Landroid/view/TextureView;

    if-eqz v1, :cond_5b

    :try_start_53
    check-cast v0, Landroid/view/TextureView;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/view/TextureView;->setOpaque(Z)V
    :try_end_59
    .catchall {:try_start_53 .. :try_end_59} :catchall_5a

    goto :goto_5b

    :catchall_5a
    move-exception v0

    .line 698
    :cond_5b
    :goto_5b
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railToggle:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    if-eqz v0, :cond_76

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railToggle:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_76

    .line 699
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railToggle:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railToggle:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 700
    :cond_76
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->coverStar:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    if-eqz v0, :cond_91

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->coverStar:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_91

    .line 701
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->coverStar:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->coverStar:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 707
    :cond_91
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    if-eqz v0, :cond_b2

    :try_start_95
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/FrameLayout;->setTranslationX(F)V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    invoke-virtual {v0, v1}, Landroid/widget/FrameLayout;->setTranslationY(F)V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    const/high16 v1, 0x3f800000    # 1.0f

    invoke-virtual {v0, v1}, Landroid/widget/FrameLayout;->setAlpha(F)V
    :try_end_b0
    .catchall {:try_start_95 .. :try_end_b0} :catchall_b1

    goto :goto_b2

    :catchall_b1
    move-exception v0

    .line 708
    :cond_b2
    :goto_b2
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570SaveDialog:Landroid/app/AlertDialog;

    if-eqz v0, :cond_c3

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570SaveDialog:Landroid/app/AlertDialog;

    invoke-virtual {v0}, Landroid/app/AlertDialog;->isShowing()Z

    move-result v0

    if-eqz v0, :cond_c3

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570SaveDialog:Landroid/app/AlertDialog;

    invoke-virtual {v0}, Landroid/app/AlertDialog;->dismiss()V

    .line 709
    :cond_c3
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570OrderDialog:Landroid/app/AlertDialog;

    if-eqz v0, :cond_d4

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570OrderDialog:Landroid/app/AlertDialog;

    invoke-virtual {v0}, Landroid/app/AlertDialog;->isShowing()Z

    move-result v0

    if-eqz v0, :cond_d4

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570OrderDialog:Landroid/app/AlertDialog;

    invoke-virtual {v0}, Landroid/app/AlertDialog;->dismiss()V

    .line 710
    :cond_d4
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570SaveDialog:Landroid/app/AlertDialog;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570OrderDialog:Landroid/app/AlertDialog;

    .line 711
    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    .line 712
    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->coverStar:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railToggle:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->advancedButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->favoriteButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    invoke-virtual {v1}, Ljava/util/LinkedHashMap;->clear()V

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railView:Landroid/view/View;

    const/4 v1, 0x0

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railToggleInstalled:Z

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeLower:Landroid/widget/LinearLayout;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->actionCapsule:Landroid/widget/LinearLayout;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->actionDeck:Landroid/widget/FrameLayout;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientParent:Landroid/view/ViewGroup;

    const-string v2, ""

    iput-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientMediaId:Ljava/lang/String;

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->initialCardChromeHidden:Z

    .line 713
    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FirstPhotoPending:Z

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572NativeMountAck:Z

    const-wide/16 v3, 0x0

    iput-wide v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FirstPhotoDeadline:J

    iput-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r596WarnedPhotoId:Ljava/lang/String;

    .line 714
    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602PlaylistPolling:Z

    iput-wide v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602LastPlaylistPollAt:J

    iput-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602LastAppliedSignature:Ljava/lang/String;

    .line 715
    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastRestorePending:Z

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastRestoreDone:Z

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastSeen:Z

    .line 716
    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572LastVideoRail:Ljava/lang/Boolean;

    .line 717
    iget-object v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594InfoDotOwner:Landroid/view/View;

    if-eqz v5, :cond_12c

    iget-object v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594InfoDot:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$R594InfoDot;

    if-eqz v5, :cond_12c

    iget-object v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594InfoDotOwner:Landroid/view/View;

    invoke-virtual {v5}, Landroid/view/View;->getOverlay()Landroid/view/ViewOverlay;

    move-result-object v5

    iget-object v6, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594InfoDot:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$R594InfoDot;

    invoke-virtual {v5, v6}, Landroid/view/ViewOverlay;->remove(Landroid/graphics/drawable/Drawable;)V

    .line 718
    :cond_12c
    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594InfoDotOwner:Landroid/view/View;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594InfoDot:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$R594InfoDot;

    .line 719
    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->compactDone:Z

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r592InfoRestoreDone:Z

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    const/4 v0, -0x1

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastIndex:I

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastH:I

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastW:I

    iput-wide v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inactiveAt:J

    iput-wide v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastFillAt:J

    iput-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastFillId:Ljava/lang/String;

    .line 720
    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->exitInFlight:Z

    iput v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownedDayToken:I

    iput-wide v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeCloseDetectedAt:J

    iput-wide v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastGeometrySnapshotAt:J

    iput-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastVideoGeometryId:Ljava/lang/String;

    iput v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fillPrepareAttempts:I

    .line 721
    const/high16 v0, -0x80000000

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastY:I

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastX:I

    .line 722
    return-void
.end method

.method private closePositionPort()V
    .locals 2

    .line 375
    :try_start_0
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionPort:Landroid/webkit/WebMessagePort;

    if-eqz v0, :cond_b

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionPort:Landroid/webkit/WebMessagePort;

    invoke-virtual {v0}, Landroid/webkit/WebMessagePort;->close()V
    :try_end_9
    .catchall {:try_start_0 .. :try_end_9} :catchall_a

    goto :goto_b

    :catchall_a
    move-exception v0

    .line 376
    :cond_b
    :goto_b
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionPort:Landroid/webkit/WebMessagePort;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionWeb:Landroid/webkit/WebView;

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionPortSettingUp:Z

    const-wide/16 v0, 0x0

    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastPositionMessageAt:J

    .line 377
    return-void
.end method

.method private compactNativeCard(Landroid/app/Activity;Landroid/webkit/WebView;Landroid/widget/FrameLayout;Ljava/lang/Object;)V
    .locals 16

    .line 965
    move-object/from16 v8, p0

    move-object/from16 v2, p1

    move-object/from16 v1, p2

    move-object/from16 v3, p4

    const-string v0, "moa.gallery.action.deck.r443"

    move-object/from16 v4, p3

    invoke-virtual {v4, v0}, Landroid/widget/FrameLayout;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v0

    .line 966
    instance-of v5, v0, Landroid/widget/FrameLayout;

    if-nez v5, :cond_15

    return-void

    .line 967
    :cond_15
    move-object v5, v0

    check-cast v5, Landroid/widget/FrameLayout;

    .line 968
    invoke-virtual {v5}, Landroid/widget/FrameLayout;->getChildCount()I

    move-result v0

    const/4 v9, 0x1

    if-ne v0, v9, :cond_34a

    const/4 v6, 0x0

    invoke-virtual {v5, v6}, Landroid/widget/FrameLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v0

    instance-of v0, v0, Landroid/widget/LinearLayout;

    if-nez v0, :cond_2a

    goto/16 :goto_34a

    .line 969
    :cond_2a
    invoke-virtual {v5, v6}, Landroid/widget/FrameLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v0

    move-object v7, v0

    check-cast v7, Landroid/widget/LinearLayout;

    .line 970
    invoke-virtual {v7}, Landroid/widget/LinearLayout;->getChildCount()I

    move-result v0

    const/4 v10, 0x4

    if-ge v0, v10, :cond_39

    return-void

    .line 971
    :cond_39
    iget-boolean v0, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->compactDone:Z

    if-eqz v0, :cond_42

    iget-object v0, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->actionDeck:Landroid/widget/FrameLayout;

    if-ne v5, v0, :cond_42

    .line 974
    return-void

    .line 977
    :cond_42
    invoke-virtual {v7, v6}, Landroid/widget/LinearLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v10

    invoke-virtual {v7, v9}, Landroid/widget/LinearLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v11

    .line 978
    const/4 v12, 0x2

    invoke-virtual {v7, v12}, Landroid/widget/LinearLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v13

    const/4 v14, 0x3

    invoke-virtual {v7, v14}, Landroid/widget/LinearLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v15

    .line 979
    iput-object v5, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->actionDeck:Landroid/widget/FrameLayout;

    iput-object v7, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->actionCapsule:Landroid/widget/LinearLayout;

    .line 980
    invoke-virtual {v5}, Landroid/widget/FrameLayout;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    instance-of v0, v0, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz v0, :cond_71

    .line 981
    invoke-virtual {v5}, Landroid/widget/FrameLayout;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/widget/FrameLayout$LayoutParams;

    .line 982
    const/high16 v12, 0x42200000    # 40.0f

    invoke-static {v2, v12}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v12

    iput v12, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    invoke-virtual {v5, v0}, Landroid/widget/FrameLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 984
    :cond_71
    invoke-virtual {v7}, Landroid/widget/LinearLayout;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    instance-of v0, v0, Landroid/widget/FrameLayout$LayoutParams;

    const/high16 v12, 0x3f800000    # 1.0f

    const/high16 v14, 0x42080000    # 34.0f

    if-eqz v0, :cond_b3

    .line 985
    invoke-virtual {v7}, Landroid/widget/LinearLayout;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/widget/FrameLayout$LayoutParams;

    .line 986
    invoke-static {v2, v14}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v9

    iput v9, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    const/high16 v9, 0x43820000    # 260.0f

    invoke-static {v2, v9}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v9

    invoke-virtual/range {p3 .. p3}, Landroid/widget/FrameLayout;->getWidth()I

    move-result v4

    const/high16 v14, 0x41900000    # 18.0f

    invoke-static {v2, v14}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v14

    sub-int/2addr v4, v14

    invoke-static {v9, v4}, Ljava/lang/Math;->max(II)I

    move-result v4

    const/high16 v9, 0x43990000    # 306.0f

    invoke-static {v2, v9}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v9

    invoke-static {v4, v9}, Ljava/lang/Math;->min(II)I

    move-result v4

    iput v4, v0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    .line 987
    invoke-static {v2, v12}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v4

    iput v4, v0, Landroid/widget/FrameLayout$LayoutParams;->bottomMargin:I

    invoke-virtual {v7, v0}, Landroid/widget/LinearLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 990
    :cond_b3
    invoke-virtual {v5, v6}, Landroid/widget/FrameLayout;->setBackgroundColor(I)V

    .line 991
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v0}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const v4, -0x6fdeddd7

    invoke-virtual {v0, v4}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/high16 v4, 0x41980000    # 19.0f

    invoke-static {v2, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v4

    int-to-float v4, v4

    invoke-virtual {v0, v4}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    .line 992
    const/high16 v4, 0x3f000000    # 0.5f

    invoke-static {v2, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v4

    const v9, 0x447d828c

    invoke-virtual {v0, v4, v9}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    invoke-virtual {v7, v0}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 993
    move v0, v6

    :goto_db
    invoke-virtual {v7}, Landroid/widget/LinearLayout;->getChildCount()I

    move-result v4

    if-ge v0, v4, :cond_127

    .line 994
    invoke-virtual {v7, v0}, Landroid/widget/LinearLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v4

    const/high16 v9, 0x42080000    # 34.0f

    invoke-static {v2, v9}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v14

    invoke-virtual {v4, v14}, Landroid/view/View;->setMinimumHeight(I)V

    .line 995
    invoke-virtual {v4}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v14

    instance-of v14, v14, Landroid/widget/LinearLayout$LayoutParams;

    if-eqz v14, :cond_105

    .line 996
    invoke-virtual {v4}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v14

    check-cast v14, Landroid/widget/LinearLayout$LayoutParams;

    .line 997
    invoke-static {v2, v9}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v12

    iput v12, v14, Landroid/widget/LinearLayout$LayoutParams;->height:I

    invoke-virtual {v4, v14}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 999
    :cond_105
    instance-of v9, v4, Landroid/view/ViewGroup;

    if-eqz v9, :cond_122

    check-cast v4, Landroid/view/ViewGroup;

    .line 1003
    move v9, v6

    :goto_10c
    invoke-virtual {v4}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v12

    if-ge v9, v12, :cond_122

    .line 1004
    invoke-virtual {v4, v9}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v12

    const v14, 0x3f47ae14    # 0.78f

    invoke-virtual {v12, v14}, Landroid/view/View;->setScaleX(F)V

    invoke-virtual {v12, v14}, Landroid/view/View;->setScaleY(F)V

    .line 1003
    add-int/lit8 v9, v9, 0x1

    goto :goto_10c

    .line 993
    :cond_122
    add-int/lit8 v0, v0, 0x1

    const/high16 v12, 0x3f800000    # 1.0f

    goto :goto_db

    .line 1008
    :cond_127
    new-instance v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-direct {v0, v2, v6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;-><init>(Landroid/app/Activity;I)V

    .line 1009
    const-string v4, "\ud604\uc7ac \uc0ac\uc9c4\uc744 \ub2ec\ub825 \ub300\ud45c\uc0ac\uc9c4\uc73c\ub85c \uc9c0\uc815"

    invoke-virtual {v0, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 1010
    const-string v4, "moa.gallery.inline.cover.r511"

    invoke-virtual {v0, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setTag(Ljava/lang/Object;)V

    const/4 v4, 0x1

    invoke-virtual {v0, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setClickable(Z)V

    invoke-virtual {v0, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setFocusable(Z)V

    .line 1011
    new-instance v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda12;

    invoke-direct {v4, v3, v1, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda12;-><init>(Ljava/lang/Object;Landroid/webkit/WebView;Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;)V

    invoke-virtual {v0, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 1016
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v9, 0x42080000    # 34.0f

    invoke-static {v2, v9}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v12

    const/high16 v9, 0x3f800000    # 1.0f

    invoke-direct {v4, v6, v12, v9}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v7, v0, v6, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)V

    .line 1017
    iput-object v0, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->coverStar:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    .line 1020
    const-string v0, "lowerControls"

    invoke-static {v3, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .line 1021
    instance-of v4, v0, Landroid/widget/LinearLayout;

    if-eqz v4, :cond_278

    .line 1022
    check-cast v0, Landroid/widget/LinearLayout;

    iput-object v0, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeLower:Landroid/widget/LinearLayout;

    .line 1023
    invoke-virtual {v0}, Landroid/widget/LinearLayout;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    instance-of v4, v4, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz v4, :cond_18d

    .line 1024
    invoke-virtual {v0}, Landroid/widget/LinearLayout;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    check-cast v4, Landroid/widget/FrameLayout$LayoutParams;

    .line 1025
    invoke-static/range {p4 .. p4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v9

    const-string v12, "v"

    invoke-virtual {v9, v12}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v9

    if-eqz v9, :cond_182

    const/high16 v9, 0x43090000    # 137.0f

    goto :goto_184

    :cond_182
    const/high16 v9, 0x42e00000    # 112.0f

    :goto_184
    invoke-static {v2, v9}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v9

    iput v9, v4, Landroid/widget/FrameLayout$LayoutParams;->height:I

    invoke-virtual {v0, v4}, Landroid/widget/LinearLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 1027
    :cond_18d
    const-string v0, "rail"

    invoke-static {v3, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .line 1028
    instance-of v4, v0, Landroid/view/View;

    if-eqz v4, :cond_1c4

    check-cast v0, Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    instance-of v4, v4, Landroid/widget/LinearLayout$LayoutParams;

    if-eqz v4, :cond_1c4

    .line 1029
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    check-cast v4, Landroid/widget/LinearLayout$LayoutParams;

    .line 1033
    const/high16 v9, 0x42800000    # 64.0f

    invoke-static {v2, v9}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v9

    iput v9, v4, Landroid/widget/LinearLayout$LayoutParams;->height:I

    invoke-virtual {v0, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 1034
    const/high16 v4, 0x42000000    # 32.0f

    invoke-static {v2, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v4

    int-to-float v4, v4

    invoke-virtual {v0, v4}, Landroid/view/View;->setPivotY(F)V

    const v4, 0x3f4a3d71    # 0.79f

    invoke-virtual {v0, v4}, Landroid/view/View;->setScaleY(F)V

    .line 1035
    iput-object v0, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railView:Landroid/view/View;

    .line 1037
    :cond_1c4
    const-string v0, "videoControls"

    invoke-static {v3, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .line 1038
    instance-of v4, v0, Landroid/widget/LinearLayout;

    if-eqz v4, :cond_253

    move-object v4, v0

    check-cast v4, Landroid/view/View;

    invoke-virtual {v4}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v9

    instance-of v9, v9, Landroid/widget/LinearLayout$LayoutParams;

    if-eqz v9, :cond_253

    .line 1039
    invoke-virtual {v4}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v9

    check-cast v9, Landroid/widget/LinearLayout$LayoutParams;

    .line 1040
    const/high16 v12, 0x42080000    # 34.0f

    invoke-static {v2, v12}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v14

    iput v14, v9, Landroid/widget/LinearLayout$LayoutParams;->height:I

    invoke-virtual {v4, v9}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 1043
    check-cast v0, Landroid/widget/LinearLayout;

    .line 1044
    move v4, v6

    :goto_1ed
    invoke-virtual {v0}, Landroid/widget/LinearLayout;->getChildCount()I

    move-result v9

    if-ge v4, v9, :cond_253

    .line 1045
    invoke-virtual {v0, v4}, Landroid/widget/LinearLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v9

    .line 1046
    invoke-virtual {v9}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v12

    instance-of v12, v12, Landroid/widget/LinearLayout$LayoutParams;

    if-eqz v12, :cond_216

    .line 1047
    invoke-virtual {v9}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v12

    check-cast v12, Landroid/widget/LinearLayout$LayoutParams;

    .line 1048
    const/4 v14, 0x1

    if-ne v4, v14, :cond_20b

    const/high16 v14, 0x41f80000    # 31.0f

    goto :goto_20d

    :cond_20b
    const/high16 v14, 0x42040000    # 33.0f

    :goto_20d
    invoke-static {v2, v14}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v14

    iput v14, v12, Landroid/widget/LinearLayout$LayoutParams;->height:I

    invoke-virtual {v9, v12}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 1050
    :cond_216
    instance-of v12, v9, Landroid/view/ViewGroup;

    if-eqz v12, :cond_24f

    .line 1051
    check-cast v9, Landroid/view/ViewGroup;

    .line 1052
    move v12, v6

    :goto_21d
    invoke-virtual {v9}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v14

    if-ge v12, v14, :cond_24f

    .line 1053
    invoke-virtual {v9, v12}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v14

    .line 1056
    const/4 v6, 0x1

    if-eq v4, v6, :cond_234

    const v6, 0x3f23d70a    # 0.64f

    invoke-virtual {v14, v6}, Landroid/view/View;->setScaleX(F)V

    invoke-virtual {v14, v6}, Landroid/view/View;->setScaleY(F)V

    goto :goto_24b

    .line 1057
    :cond_234
    if-nez v12, :cond_240

    const v6, 0x3f2e147b    # 0.68f

    invoke-virtual {v14, v6}, Landroid/view/View;->setScaleX(F)V

    invoke-virtual {v14, v6}, Landroid/view/View;->setScaleY(F)V

    goto :goto_24b

    .line 1058
    :cond_240
    instance-of v6, v14, Landroid/widget/TextView;

    if-eqz v6, :cond_24b

    check-cast v14, Landroid/widget/TextView;

    const/high16 v6, 0x41180000    # 9.5f

    invoke-virtual {v14, v6}, Landroid/widget/TextView;->setTextSize(F)V

    .line 1052
    :cond_24b
    :goto_24b
    add-int/lit8 v12, v12, 0x1

    const/4 v6, 0x0

    goto :goto_21d

    .line 1044
    :cond_24f
    add-int/lit8 v4, v4, 0x1

    const/4 v6, 0x0

    goto :goto_1ed

    .line 1063
    :cond_253
    const-string v0, "seekRow"

    invoke-static {v3, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .line 1064
    instance-of v4, v0, Landroid/view/View;

    if-eqz v4, :cond_278

    check-cast v0, Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    instance-of v4, v4, Landroid/widget/LinearLayout$LayoutParams;

    if-eqz v4, :cond_278

    .line 1065
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    check-cast v4, Landroid/widget/LinearLayout$LayoutParams;

    .line 1066
    const/high16 v6, 0x41d80000    # 27.0f

    invoke-static {v2, v6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v6

    iput v6, v4, Landroid/widget/LinearLayout$LayoutParams;->height:I

    invoke-virtual {v0, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 1069
    :cond_278
    iget-object v0, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railView:Landroid/view/View;

    const-string v4, "rail_expanded"

    const-string v6, "moa.r515.card_ui"

    if-eqz v0, :cond_298

    iget-boolean v0, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railToggleInstalled:Z

    if-nez v0, :cond_298

    .line 1070
    const/4 v9, 0x0

    invoke-virtual {v2, v6, v9}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const/4 v9, 0x1

    invoke-interface {v0, v4, v9}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railExpanded:Z

    .line 1071
    invoke-direct {v8, v2, v7}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->installRailToggle(Landroid/app/Activity;Landroid/widget/LinearLayout;)V

    .line 1072
    iget-boolean v0, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railExpanded:Z

    invoke-direct {v8, v2, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->setRailExpanded(Landroid/app/Activity;Z)V

    .line 1077
    :cond_298
    iget-boolean v0, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->initialCardChromeHidden:Z

    if-nez v0, :cond_2ce

    .line 1078
    const/4 v9, 0x1

    iput-boolean v9, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->initialCardChromeHidden:Z

    .line 1083
    const/4 v12, 0x0

    invoke-virtual {v2, v6, v12}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0, v4, v9}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v4

    .line 1084
    iput-boolean v4, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railExpanded:Z

    .line 1085
    :try_start_2aa
    invoke-virtual/range {p4 .. p4}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-string v6, "chromeVisible"

    invoke-static {v0, v6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->field(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    if-eqz v0, :cond_2bc

    const/4 v6, 0x1

    invoke-virtual {v0, v3, v6}, Ljava/lang/reflect/Field;->setBoolean(Ljava/lang/Object;Z)V
    :try_end_2ba
    .catchall {:try_start_2aa .. :try_end_2ba} :catchall_2bb

    goto :goto_2bc

    :catchall_2bb
    move-exception v0

    .line 1086
    :cond_2bc
    :goto_2bc
    iget-object v0, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeLower:Landroid/widget/LinearLayout;

    if-eqz v0, :cond_2c7

    iget-object v0, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeLower:Landroid/widget/LinearLayout;

    const/4 v6, 0x0

    invoke-virtual {v0, v6}, Landroid/widget/LinearLayout;->setVisibility(I)V

    goto :goto_2c8

    :cond_2c7
    const/4 v6, 0x0

    .line 1087
    :goto_2c8
    invoke-virtual {v5, v6}, Landroid/widget/FrameLayout;->setVisibility(I)V

    .line 1088
    invoke-direct {v8, v2, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->setRailExpanded(Landroid/app/Activity;Z)V

    .line 1090
    :cond_2ce
    iget-object v0, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->favoriteButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    if-nez v0, :cond_304

    .line 1092
    new-instance v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    const/4 v4, 0x3

    invoke-direct {v0, v2, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;-><init>(Landroid/app/Activity;I)V

    .line 1093
    const-string v4, "\ud604\uc7ac \uc0ac\uc9c4 \ub124\uc774\ubc84 \uc990\uaca8\ucc3e\uae30 \uc800\uc7a5"

    invoke-virtual {v0, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 1094
    const-string v4, "moa.gallery.inline.favorite.r570"

    invoke-virtual {v0, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setTag(Ljava/lang/Object;)V

    const/4 v4, 0x1

    invoke-virtual {v0, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setClickable(Z)V

    invoke-virtual {v0, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setFocusable(Z)V

    .line 1095
    new-instance v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda13;

    invoke-direct {v4, v8, v2, v1, v3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda13;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;)V

    invoke-virtual {v0, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 1096
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v5, 0x42080000    # 34.0f

    invoke-static {v2, v5}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v6

    const/high16 v5, 0x3f800000    # 1.0f

    const/4 v9, 0x0

    invoke-direct {v4, v9, v6, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v7, v0, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iput-object v0, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->favoriteButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    .line 1098
    :cond_304
    iget-object v0, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->advancedButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    if-nez v0, :cond_33a

    .line 1101
    new-instance v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    const/4 v4, 0x2

    invoke-direct {v0, v2, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;-><init>(Landroid/app/Activity;I)V

    .line 1102
    const-string v4, "\uc6d0\ub798 \uace0\uae09 \uac24\ub7ec\ub9ac \uc804\uccb4 \ud654\uba74\uc73c\ub85c \uc5f4\uae30"

    invoke-virtual {v0, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 1103
    const-string v4, "moa.gallery.card.advanced.r535"

    invoke-virtual {v0, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setTag(Ljava/lang/Object;)V

    const/4 v4, 0x1

    invoke-virtual {v0, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setClickable(Z)V

    invoke-virtual {v0, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setFocusable(Z)V

    .line 1104
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v5, 0x42080000    # 34.0f

    invoke-static {v2, v5}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v5

    const/high16 v6, 0x3f800000    # 1.0f

    const/4 v9, 0x0

    invoke-direct {v4, v9, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v7, v0, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1105
    new-instance v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda14;

    invoke-direct {v4, v8, v1, v3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda14;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/webkit/WebView;Ljava/lang/Object;)V

    invoke-virtual {v0, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 1106
    iput-object v0, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->advancedButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    .line 1109
    :cond_33a
    move-object/from16 v1, p0

    move-object/from16 v2, p1

    move-object v3, v7

    move-object v4, v10

    move-object v5, v11

    move-object v6, v13

    move-object v7, v15

    invoke-direct/range {v1 .. v7}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570InitActionOrder(Landroid/app/Activity;Landroid/widget/LinearLayout;Landroid/view/View;Landroid/view/View;Landroid/view/View;Landroid/view/View;)V

    .line 1110
    const/4 v1, 0x1

    iput-boolean v1, v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->compactDone:Z

    .line 1111
    return-void

    .line 968
    :cond_34a
    :goto_34a
    return-void
.end method

.method private static currentId(Ljava/lang/Object;)Ljava/lang/String;
    .locals 3

    .line 1395
    const-string v0, ""

    :try_start_2
    const-string v1, "ids"

    invoke-static {p0, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    const-string v2, "index"

    invoke-static {p0, v2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    .line 1396
    instance-of v2, v1, Ljava/util/List;

    if-eqz v2, :cond_30

    instance-of v2, p0, Ljava/lang/Integer;

    if-nez v2, :cond_17

    goto :goto_30

    .line 1397
    :cond_17
    check-cast v1, Ljava/util/List;

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    .line 1398
    if-ltz p0, :cond_2f

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v2

    if-ge p0, v2, :cond_2f

    invoke-interface {v1, p0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0
    :try_end_2f
    .catchall {:try_start_2 .. :try_end_2f} :catchall_31

    :cond_2f
    return-object v0

    .line 1396
    :cond_30
    :goto_30
    return-object v0

    .line 1399
    :catchall_31
    move-exception p0

    return-object v0
.end method

.method private disarm()V
    .locals 2

    .line 601
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->armRoot:Landroid/widget/FrameLayout;

    if-eqz v0, :cond_1c

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->armGuard:Landroid/view/ViewTreeObserver$OnPreDrawListener;

    if-eqz v0, :cond_1c

    .line 602
    :try_start_8
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->armRoot:Landroid/widget/FrameLayout;

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    .line 603
    invoke-virtual {v0}, Landroid/view/ViewTreeObserver;->isAlive()Z

    move-result v1

    if-eqz v1, :cond_1b

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->armGuard:Landroid/view/ViewTreeObserver$OnPreDrawListener;

    invoke-virtual {v0, v1}, Landroid/view/ViewTreeObserver;->removeOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V
    :try_end_19
    .catchall {:try_start_8 .. :try_end_19} :catchall_1a

    goto :goto_1b

    .line 604
    :catchall_1a
    move-exception v0

    :cond_1b
    :goto_1b
    nop

    .line 605
    :cond_1c
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->armRoot:Landroid/widget/FrameLayout;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->armGuard:Landroid/view/ViewTreeObserver$OnPreDrawListener;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->armedState:Lorg/json/JSONObject;

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inlineArmed:Z

    .line 606
    return-void
.end method

.method private static dp(Landroid/app/Activity;F)I
    .locals 0

    .line 1480
    invoke-virtual {p0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    mul-float/2addr p1, p0

    const/high16 p0, 0x3f000000    # 0.5f

    add-float/2addr p1, p0

    float-to-int p0, p1

    return p0
.end method

.method private dropDayBack()V
    .locals 2

    .line 724
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inlineBack:Landroid/window/OnBackInvokedCallback;

    if-eqz v0, :cond_1c

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->backOwner:Landroid/app/Activity;

    if-eqz v0, :cond_1c

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x21

    if-lt v0, v1, :cond_1c

    .line 725
    :try_start_e
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->backOwner:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->getOnBackInvokedDispatcher()Landroid/window/OnBackInvokedDispatcher;

    move-result-object v0

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inlineBack:Landroid/window/OnBackInvokedCallback;

    invoke-interface {v0, v1}, Landroid/window/OnBackInvokedDispatcher;->unregisterOnBackInvokedCallback(Landroid/window/OnBackInvokedCallback;)V
    :try_end_19
    .catchall {:try_start_e .. :try_end_19} :catchall_1a

    goto :goto_1b

    .line 726
    :catchall_1a
    move-exception v0

    :goto_1b
    nop

    .line 727
    :cond_1c
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inlineBack:Landroid/window/OnBackInvokedCallback;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->backOwner:Landroid/app/Activity;

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->exitInFlight:Z

    .line 728
    return-void
.end method

.method private ensurePositionChannel(Landroid/webkit/WebView;)V
    .locals 6

    .line 379
    invoke-static {p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->isTrustedWeb(Landroid/webkit/WebView;)Z

    move-result v0

    if-nez v0, :cond_7

    return-void

    .line 380
    :cond_7
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionWeb:Landroid/webkit/WebView;

    if-eqz v0, :cond_12

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionWeb:Landroid/webkit/WebView;

    if-eq v0, p1, :cond_12

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->closePositionPort()V

    .line 381
    :cond_12
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionPort:Landroid/webkit/WebMessagePort;

    if-nez v0, :cond_3f

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionPortSettingUp:Z

    if-eqz v0, :cond_1b

    goto :goto_3f

    .line 382
    :cond_1b
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 383
    iget-wide v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastPortInitAttempt:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x4b0

    cmp-long v2, v2, v4

    if-gez v2, :cond_2a

    return-void

    .line 384
    :cond_2a
    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastPortInitAttempt:J

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionPortSettingUp:Z

    .line 385
    :try_start_2f
    const-string v0, "window.__moaR527BridgeListenReady===true"

    new-instance v1, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda28;

    invoke-direct {v1, p0, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda28;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/webkit/WebView;)V

    invoke-virtual {p1, v0, v1}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V
    :try_end_39
    .catchall {:try_start_2f .. :try_end_39} :catchall_3a

    .line 404
    goto :goto_3e

    :catchall_3a
    move-exception p1

    const/4 p1, 0x0

    iput-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionPortSettingUp:Z

    .line 405
    :goto_3e
    return-void

    .line 381
    :cond_3f
    :goto_3f
    return-void
.end method

.method private enterOriginalFullscreen(Landroid/webkit/WebView;Ljava/lang/Object;)V
    .locals 2

    .line 1242
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz v0, :cond_3d

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeOpen:Z

    if-nez v0, :cond_3d

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-ne p2, v0, :cond_3d

    invoke-static {p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->isTrustedWeb(Landroid/webkit/WebView;)Z

    move-result v0

    if-nez v0, :cond_13

    goto :goto_3d

    .line 1243
    :cond_13
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeOpen:Z

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeSeenOpen:Z

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullscreenOwnerActivity:Landroid/app/Activity;

    .line 1244
    iget v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastIndex:I

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeLastIndex:I

    invoke-static {p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeLastId:Ljava/lang/String;

    .line 1245
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeStartedAt:J

    .line 1247
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dropDayBack()V

    .line 1248
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->clearCardMark()V

    invoke-static {p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->invokeClose(Ljava/lang/Object;)V

    .line 1249
    const-string p2, "window.__moaR531ShowAdvanced&&window.__moaR531ShowAdvanced();"

    const/4 v0, 0x0

    invoke-virtual {p1, p2, v0}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 1250
    return-void

    .line 1242
    :cond_3d
    :goto_3d
    return-void
.end method

.method private exitForegroundClosedGallery(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;)V
    .locals 2

    .line 670
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->resumed:Z

    if-eqz v0, :cond_50

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    if-ne p1, v0, :cond_50

    invoke-virtual {p1}, Landroid/app/Activity;->hasWindowFocus()Z

    move-result v0

    if-eqz v0, :cond_50

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lifecyclePauseInProgress:Z

    if-nez v0, :cond_50

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->controlledRebuildInProgress:Z

    if-nez v0, :cond_50

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeOpen:Z

    if-nez v0, :cond_50

    .line 671
    invoke-static {p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_50

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-ne v0, p3, :cond_50

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    if-eq v0, p1, :cond_29

    goto :goto_50

    .line 674
    :cond_29
    nop

    .line 675
    invoke-static {p4}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p4

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "window.__moaR563ForegroundNativeClosed&&window.__moaR563ForegroundNativeClosed("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p4

    const-string v0, ");"

    invoke-virtual {p4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p4

    invoke-virtual {p4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p4

    new-instance v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda21;

    invoke-direct {v0, p0, p3, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda21;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Ljava/lang/Object;Landroid/app/Activity;)V

    .line 674
    invoke-virtual {p2, p4, v0}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 687
    return-void

    .line 672
    :cond_50
    :goto_50
    return-void
.end method

.method private static field(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;",
            "Ljava/lang/String;",
            ")",
            "Ljava/lang/reflect/Field;"
        }
    .end annotation

    .line 339
    nop

    :goto_1
    const/4 v0, 0x0

    if-eqz p0, :cond_15

    .line 340
    :try_start_4
    invoke-virtual {p0, p1}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Ljava/lang/reflect/Field;->setAccessible(Z)V
    :try_end_c
    .catch Ljava/lang/NoSuchFieldException; {:try_start_4 .. :try_end_c} :catch_f
    .catchall {:try_start_4 .. :try_end_c} :catchall_d

    return-object v1

    .line 341
    :catchall_d
    move-exception p0

    return-object v0

    :catch_f
    move-exception v0

    .line 339
    invoke-virtual {p0}, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;

    move-result-object p0

    goto :goto_1

    .line 342
    :cond_15
    return-object v0
.end method

.method private fillNativeMediaCard(Landroid/app/Activity;Ljava/lang/Object;)V
    .locals 6

    .line 1352
    const-string v0, "images"

    invoke-static {p2, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .line 1353
    instance-of v1, v0, [Landroid/widget/ImageView;

    if-eqz v1, :cond_24

    .line 1354
    check-cast v0, [Landroid/widget/ImageView;

    array-length v1, v0

    const/4 v2, 0x0

    :goto_e
    if-ge v2, v1, :cond_24

    aget-object v3, v0, v2

    if-eqz v3, :cond_21

    invoke-virtual {v3}, Landroid/widget/ImageView;->getScaleType()Landroid/widget/ImageView$ScaleType;

    move-result-object v4

    sget-object v5, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;

    if-eq v4, v5, :cond_21

    .line 1355
    sget-object v4, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {v3, v4}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    .line 1354
    :cond_21
    add-int/lit8 v2, v2, 0x1

    goto :goto_e

    .line 1360
    :cond_24
    const-string v0, "texture"

    invoke-static {p2, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .line 1361
    instance-of v1, v0, Landroid/view/TextureView;

    if-eqz v1, :cond_37

    .line 1362
    check-cast v0, Landroid/view/TextureView;

    .line 1363
    invoke-static {p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p2

    .line 1364
    invoke-direct {p0, p1, v0, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->updateVideoAmbient(Landroid/app/Activity;Landroid/view/TextureView;Ljava/lang/String;)V

    .line 1366
    :cond_37
    return-void
.end method

.method private findWeb(Landroid/app/Activity;)Landroid/webkit/WebView;
    .locals 2

    .line 355
    const-string v0, "web"

    invoke-static {p1, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .line 356
    instance-of v1, v0, Landroid/webkit/WebView;

    if-eqz v1, :cond_d

    check-cast v0, Landroid/webkit/WebView;

    return-object v0

    .line 357
    :cond_d
    const v0, 0x1020002

    invoke-virtual {p1, v0}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    invoke-static {p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->findWebRecursive(Landroid/view/View;)Landroid/webkit/WebView;

    move-result-object p1

    return-object p1
.end method

.method private static findWebRecursive(Landroid/view/View;)Landroid/webkit/WebView;
    .locals 2

    .line 360
    instance-of v0, p0, Landroid/webkit/WebView;

    if-eqz v0, :cond_7

    check-cast p0, Landroid/webkit/WebView;

    return-object p0

    .line 361
    :cond_7
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_22

    check-cast p0, Landroid/view/ViewGroup;

    .line 362
    const/4 v0, 0x0

    :goto_e
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    if-ge v0, v1, :cond_22

    .line 363
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    invoke-static {v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->findWebRecursive(Landroid/view/View;)Landroid/webkit/WebView;

    move-result-object v1

    if-eqz v1, :cond_1f

    return-object v1

    .line 362
    :cond_1f
    add-int/lit8 v0, v0, 0x1

    goto :goto_e

    .line 366
    :cond_22
    const/4 p0, 0x0

    return-object p0
.end method

.method private static galleryOpen(Ljava/lang/Object;)Z
    .locals 5

    .line 350
    const/4 v0, 0x0

    if-nez p0, :cond_4

    return v0

    .line 351
    :cond_4
    :try_start_4
    sget-object v1, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    const-string v3, "isOpen"

    new-array v4, v0, [Ljava/lang/Class;

    invoke-virtual {v2, v3, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    new-array v3, v0, [Ljava/lang/Object;

    invoke-virtual {v2, p0, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result p0
    :try_end_1c
    .catchall {:try_start_4 .. :try_end_1c} :catchall_1d

    return p0

    .line 352
    :catchall_1d
    move-exception p0

    return v0
.end method

.method private installInlineBack(Landroid/app/Activity;Landroid/webkit/WebView;)V
    .locals 2

    .line 923
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x21

    if-ge v0, v1, :cond_7

    return-void

    .line 924
    :cond_7
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inlineBack:Landroid/window/OnBackInvokedCallback;

    if-eqz v0, :cond_10

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->backOwner:Landroid/app/Activity;

    if-ne v0, p1, :cond_10

    return-void

    .line 925
    :cond_10
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inlineBack:Landroid/window/OnBackInvokedCallback;

    if-eqz v0, :cond_17

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dropDayBack()V

    .line 929
    :cond_17
    :try_start_17
    new-instance v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda11;

    invoke-direct {v0, p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda11;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/webkit/WebView;)V

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inlineBack:Landroid/window/OnBackInvokedCallback;

    .line 960
    invoke-virtual {p1}, Landroid/app/Activity;->getOnBackInvokedDispatcher()Landroid/window/OnBackInvokedDispatcher;

    move-result-object p2

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inlineBack:Landroid/window/OnBackInvokedCallback;

    const v1, 0xf4272

    invoke-interface {p2, v1, v0}, Landroid/window/OnBackInvokedDispatcher;->registerOnBackInvokedCallback(ILandroid/window/OnBackInvokedCallback;)V

    .line 961
    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->backOwner:Landroid/app/Activity;
    :try_end_2c
    .catchall {:try_start_17 .. :try_end_2c} :catchall_2d

    .line 962
    goto :goto_33

    :catchall_2d
    move-exception p1

    const/4 p1, 0x0

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inlineBack:Landroid/window/OnBackInvokedCallback;

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->backOwner:Landroid/app/Activity;

    .line 963
    :goto_33
    return-void
.end method

.method private installPreDrawGuard(Landroid/app/Activity;Landroid/webkit/WebView;Landroid/widget/FrameLayout;)V
    .locals 1

    .line 608
    new-instance v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$4;

    invoke-direct {v0, p0, p3, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$4;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/widget/FrameLayout;Landroid/app/Activity;Landroid/webkit/WebView;)V

    .line 633
    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->armGuard:Landroid/view/ViewTreeObserver$OnPreDrawListener;

    .line 634
    invoke-virtual {p3}, Landroid/widget/FrameLayout;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object p1

    invoke-virtual {p1, v0}, Landroid/view/ViewTreeObserver;->addOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 635
    return-void
.end method

.method private installRailToggle(Landroid/app/Activity;Landroid/widget/LinearLayout;)V
    .locals 6

    .line 1309
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railToggleInstalled:Z

    if-nez v0, :cond_40

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railView:Landroid/view/View;

    if-nez v0, :cond_9

    goto :goto_40

    .line 1312
    :cond_9
    new-instance v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    const/4 v1, 0x1

    invoke-direct {v0, p1, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;-><init>(Landroid/app/Activity;I)V

    .line 1313
    invoke-virtual {v0, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setClickable(Z)V

    invoke-virtual {v0, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setFocusable(Z)V

    .line 1314
    const-string v2, "\uc0ac\uc9c4 \ubaa9\ub85d \uc811\uae30"

    invoke-virtual {v0, v2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 1315
    const-string v2, "moa.gallery.inline.rail.toggle.r519"

    invoke-virtual {v0, v2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setTag(Ljava/lang/Object;)V

    .line 1316
    const/4 v2, 0x0

    invoke-virtual {v0, v2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setBackgroundColor(I)V

    .line 1317
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v4, 0x42080000    # 34.0f

    invoke-static {p1, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v4

    const/high16 v5, 0x3f800000    # 1.0f

    invoke-direct {v3, v2, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {p2, v0, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1318
    new-instance p2, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda25;

    invoke-direct {p2, p0, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda25;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;)V

    invoke-virtual {v0, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 1322
    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railToggle:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railToggleInstalled:Z

    .line 1323
    return-void

    .line 1309
    :cond_40
    :goto_40
    return-void
.end method

.method private static invokeClose(Ljava/lang/Object;)V
    .locals 4

    .line 637
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-string v1, "close"

    const/4 v2, 0x0

    new-array v3, v2, [Ljava/lang/Class;

    invoke-virtual {v0, v1, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    new-array v1, v2, [Ljava/lang/Object;

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_12
    .catchall {:try_start_0 .. :try_end_12} :catchall_13

    goto :goto_14

    :catchall_13
    move-exception p0

    .line 638
    :goto_14
    return-void
.end method

.method private static isTrustedWeb(Landroid/webkit/WebView;)Z
    .locals 2

    .line 369
    const/4 v0, 0x0

    if-nez p0, :cond_4

    return v0

    .line 370
    :cond_4
    invoke-virtual {p0}, Landroid/webkit/WebView;->getUrl()Ljava/lang/String;

    move-result-object p0

    .line 371
    if-eqz p0, :cond_1c

    const-string v1, "https://familyjourney.local/web/"

    invoke-virtual {p0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_1a

    .line 372
    const-string v1, "https://familyjourney.local/"

    invoke-virtual {p0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_1c

    :cond_1a
    const/4 v0, 0x1

    goto :goto_1d

    :cond_1c
    nop

    .line 371
    :goto_1d
    return v0
.end method

.method private synthetic lambda$compactNativeCard$10(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Landroid/view/View;)V
    .locals 0

    .line 1095
    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570OpenFavorite(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;)V

    return-void
.end method

.method private synthetic lambda$compactNativeCard$11(Landroid/webkit/WebView;Ljava/lang/Object;Landroid/view/View;)V
    .locals 0

    .line 1105
    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->enterOriginalFullscreen(Landroid/webkit/WebView;Ljava/lang/Object;)V

    return-void
.end method

.method static synthetic lambda$compactNativeCard$9(Ljava/lang/Object;Landroid/webkit/WebView;Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;Landroid/view/View;)V
    .locals 1

    .line 1012
    invoke-static {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p3

    if-nez p3, :cond_b

    return-void

    .line 1013
    :cond_b
    invoke-static {p0}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "window.MoaR469SimpleDiary&&window.MoaR469SimpleDiary.setCoverNative&&window.MoaR469SimpleDiary.setCoverNative("

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p3, ");"

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const/4 p3, 0x0

    invoke-virtual {p1, p0, p3}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 1014
    const/4 p0, 0x1

    invoke-virtual {p2, p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setSelected(Z)V

    invoke-virtual {p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->invalidate()V

    .line 1015
    return-void
.end method

.method private synthetic lambda$ensurePositionChannel$1(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 3

    .line 386
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionPortSettingUp:Z

    .line 387
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    if-eqz v1, :cond_55

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    invoke-direct {p0, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->findWeb(Landroid/app/Activity;)Landroid/webkit/WebView;

    move-result-object v1

    if-ne p1, v1, :cond_55

    invoke-static {p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->isTrustedWeb(Landroid/webkit/WebView;)Z

    move-result v1

    if-eqz v1, :cond_55

    const-string v1, "true"

    invoke-virtual {v1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_1e

    goto :goto_55

    .line 389
    :cond_1e
    :try_start_1e
    invoke-virtual {p1}, Landroid/webkit/WebView;->createWebMessageChannel()[Landroid/webkit/WebMessagePort;

    move-result-object p2

    .line 390
    if-eqz p2, :cond_4f

    array-length v1, p2

    const/4 v2, 0x2

    if-eq v1, v2, :cond_29

    goto :goto_4f

    .line 391
    :cond_29
    aget-object v0, p2, v0

    .line 392
    new-instance v1, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$3;

    invoke-direct {v1, p0, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$3;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/webkit/WebView;)V

    invoke-virtual {v0, v1}, Landroid/webkit/WebMessagePort;->setWebMessageCallback(Landroid/webkit/WebMessagePort$WebMessageCallback;)V

    .line 400
    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionPort:Landroid/webkit/WebMessagePort;

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionWeb:Landroid/webkit/WebView;

    .line 401
    new-instance v0, Landroid/webkit/WebMessage;

    const-string v1, "MOA_R527_POSITION_CHANNEL"

    const/4 v2, 0x1

    aget-object p2, p2, v2

    filled-new-array {p2}, [Landroid/webkit/WebMessagePort;

    move-result-object p2

    invoke-direct {v0, v1, p2}, Landroid/webkit/WebMessage;-><init>(Ljava/lang/String;[Landroid/webkit/WebMessagePort;)V

    const-string p2, "https://familyjourney.local"

    .line 402
    invoke-static {p2}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p2

    .line 401
    invoke-virtual {p1, v0, p2}, Landroid/webkit/WebView;->postWebMessage(Landroid/webkit/WebMessage;Landroid/net/Uri;)V
    :try_end_4e
    .catchall {:try_start_1e .. :try_end_4e} :catchall_50

    .line 403
    goto :goto_54

    .line 390
    :cond_4f
    :goto_4f
    return-void

    .line 403
    :catchall_50
    move-exception p1

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->closePositionPort()V

    .line 404
    :goto_54
    return-void

    .line 387
    :cond_55
    :goto_55
    return-void
.end method

.method private synthetic lambda$exitForegroundClosedGallery$5(Ljava/lang/Object;Landroid/app/Activity;Ljava/lang/String;)V
    .locals 2

    .line 676
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-ne v0, p1, :cond_4b

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    if-eq p1, p2, :cond_9

    goto :goto_4b

    .line 677
    :cond_9
    const-string p1, "\"exit\""

    invoke-static {p3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    const/4 p2, 0x0

    if-nez p1, :cond_25

    .line 678
    invoke-static {p3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    const-string p3, "\"not-open\""

    invoke-virtual {p3, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_23

    goto :goto_25

    :cond_23
    move p1, p2

    goto :goto_26

    :cond_25
    :goto_25
    const/4 p1, 0x1

    .line 681
    :goto_26
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->closePositionPort()V

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->clearCardMark()V

    .line 682
    if-eqz p1, :cond_3a

    iput-boolean p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnFromBackground:Z

    iput-boolean p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->hadMountedOnPause:Z

    .line 683
    const-wide/16 p1, 0x0

    iput-wide p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnCloseGuardUntil:J

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dropDayBack()V

    goto :goto_41

    .line 684
    :cond_3a
    const-string p1, "MOA_R567"

    const-string p2, "NATIVE_CLOSE_INTENTIONAL_OR_NEW_DATE"

    invoke-static {p1, p2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 685
    :goto_41
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide p1

    const-wide/16 v0, 0xbe

    add-long/2addr p1, v0

    iput-wide p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->suppressArmUntil:J

    .line 686
    return-void

    .line 676
    :cond_4b
    :goto_4b
    return-void
.end method

.method private synthetic lambda$installInlineBack$7(Ljava/lang/String;)V
    .locals 1

    .line 955
    const-string v0, "\"exit\""

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_15

    const-string v0, "\"not-open\""

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_11

    goto :goto_15

    .line 957
    :cond_11
    const/4 p1, 0x0

    iput-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->exitInFlight:Z

    goto :goto_18

    .line 956
    :cond_15
    :goto_15
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dropDayBack()V

    .line 958
    :goto_18
    return-void
.end method

.method private synthetic lambda$installInlineBack$8(Landroid/app/Activity;Landroid/webkit/WebView;)V
    .locals 6

    .line 933
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 934
    iget-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->exitInFlight:Z

    if-eqz v2, :cond_13

    iget-wide v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastNativeBackAt:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x708

    cmp-long v2, v2, v4

    if-gez v2, :cond_13

    return-void

    .line 938
    :cond_13
    :try_start_13
    invoke-virtual {p1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object p1

    invoke-virtual {p1}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p1

    .line 939
    invoke-virtual {p1}, Landroid/view/View;->getRootWindowInsets()Landroid/view/WindowInsets;

    move-result-object v2

    .line 940
    if-eqz v2, :cond_3e

    invoke-static {}, Landroid/view/WindowInsets$Type;->ime()I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/view/WindowInsets;->isVisible(I)Z

    move-result v2

    if-eqz v2, :cond_3e

    .line 941
    invoke-virtual {p1}, Landroid/view/View;->getWindowInsetsController()Landroid/view/WindowInsetsController;

    move-result-object v2

    if-eqz v2, :cond_3c

    .line 942
    invoke-virtual {p1}, Landroid/view/View;->getWindowInsetsController()Landroid/view/WindowInsetsController;

    move-result-object p1

    invoke-static {}, Landroid/view/WindowInsets$Type;->ime()I

    move-result v2

    invoke-interface {p1, v2}, Landroid/view/WindowInsetsController;->hide(I)V
    :try_end_3c
    .catchall {:try_start_13 .. :try_end_3c} :catchall_3d

    .line 943
    :cond_3c
    return-void

    .line 945
    :catchall_3d
    move-exception p1

    :cond_3e
    nop

    .line 946
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570SaveDialog:Landroid/app/AlertDialog;

    if-eqz p1, :cond_51

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570SaveDialog:Landroid/app/AlertDialog;

    invoke-virtual {p1}, Landroid/app/AlertDialog;->isShowing()Z

    move-result p1

    if-eqz p1, :cond_51

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570SaveDialog:Landroid/app/AlertDialog;

    invoke-virtual {p1}, Landroid/app/AlertDialog;->dismiss()V

    return-void

    .line 947
    :cond_51
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570OrderDialog:Landroid/app/AlertDialog;

    if-eqz p1, :cond_63

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570OrderDialog:Landroid/app/AlertDialog;

    invoke-virtual {p1}, Landroid/app/AlertDialog;->isShowing()Z

    move-result p1

    if-eqz p1, :cond_63

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570OrderDialog:Landroid/app/AlertDialog;

    invoke-virtual {p1}, Landroid/app/AlertDialog;->dismiss()V

    return-void

    .line 950
    :cond_63
    const/4 p1, 0x1

    iput-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->exitInFlight:Z

    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastNativeBackAt:J

    .line 954
    new-instance p1, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda20;

    invoke-direct {p1, p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda20;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;)V

    const-string v0, "window.__moaR559ForegroundDayBack?window.__moaR559ForegroundDayBack():\"not-open\""

    invoke-virtual {p2, v0, p1}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 959
    return-void
.end method

.method private synthetic lambda$installRailToggle$21(Landroid/app/Activity;Landroid/view/View;)V
    .locals 1

    .line 1319
    iget-boolean p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railExpanded:Z

    xor-int/lit8 p2, p2, 0x1

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->setRailExpanded(Landroid/app/Activity;Z)V

    .line 1320
    const-string p2, "moa.r515.card_ui"

    const/4 v0, 0x0

    invoke-virtual {p1, p2, v0}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    const-string p2, "rail_expanded"

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railExpanded:Z

    invoke-interface {p1, p2, v0}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1321
    return-void
.end method

.method private synthetic lambda$maybeArm$4(ILandroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 4

    .line 577
    const-string v0, "ARM_SNAPSHOT"

    invoke-direct {p0, p1, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EndEval(ILjava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_9

    return-void

    .line 578
    :cond_9
    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->resumed:Z

    if-eqz p1, :cond_8e

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    if-ne p2, p1, :cond_8e

    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inlineArmed:Z

    if-eqz p1, :cond_17

    goto/16 :goto_8e

    .line 580
    :cond_17
    :try_start_17
    new-instance p1, Lorg/json/JSONTokener;

    invoke-direct {p1, p4}, Lorg/json/JSONTokener;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Lorg/json/JSONTokener;->nextValue()Ljava/lang/Object;

    move-result-object p1

    .line 581
    instance-of p4, p1, Ljava/lang/String;

    if-nez p4, :cond_25

    return-void

    .line 582
    :cond_25
    new-instance p4, Lorg/json/JSONObject;

    check-cast p1, Ljava/lang/String;

    invoke-direct {p4, p1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 583
    const-string p1, "active"

    invoke-virtual {p4, p1}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_8a

    const-string p1, "w"

    invoke-virtual {p4, p1}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;)D

    move-result-wide v0

    const-wide v2, 0x4062c00000000000L    # 150.0

    cmpg-double p1, v0, v2

    if-ltz p1, :cond_8a

    const-string p1, "h"

    invoke-virtual {p4, p1}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;)D

    move-result-wide v0

    const-wide v2, 0x4066800000000000L    # 180.0

    cmpg-double p1, v0, v2

    if-gez p1, :cond_53

    goto :goto_8a

    .line 584
    :cond_53
    const p1, 0x1020002

    invoke-virtual {p2, p1}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/FrameLayout;

    .line 585
    if-nez p1, :cond_5f

    return-void

    .line 586
    :cond_5f
    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->armRoot:Landroid/widget/FrameLayout;

    iput-object p4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->armedState:Lorg/json/JSONObject;

    const-string v0, "token"

    const/4 v1, 0x0

    invoke-virtual {p4, v0, v1}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p4

    iput p4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownedDayToken:I

    const/4 p4, 0x1

    iput-boolean p4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inlineArmed:Z

    .line 587
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    const-wide/16 v2, 0x1388

    add-long/2addr v0, v2

    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->armDeadline:J

    .line 588
    const-string p4, "NATIVE_PREDRAW_ARMED"

    invoke-direct {p0, p3, p4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602Signal(Landroid/webkit/WebView;Ljava/lang/String;)V

    .line 591
    invoke-direct {p0, p2, p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->installInlineBack(Landroid/app/Activity;Landroid/webkit/WebView;)V

    .line 592
    invoke-direct {p0, p2, p3, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->installPreDrawGuard(Landroid/app/Activity;Landroid/webkit/WebView;Landroid/widget/FrameLayout;)V

    .line 593
    const-string p1, "window.__moaR511NativeArmed=true;"

    const/4 p2, 0x0

    invoke-virtual {p3, p1, p2}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V
    :try_end_89
    .catchall {:try_start_17 .. :try_end_89} :catchall_8b

    goto :goto_8c

    .line 583
    :cond_8a
    :goto_8a
    return-void

    .line 594
    :catchall_8b
    move-exception p1

    :goto_8c
    nop

    .line 595
    return-void

    .line 578
    :cond_8e
    :goto_8e
    return-void
.end method

.method private synthetic lambda$onActivityResumed$27(Landroid/app/Activity;I)V
    .locals 0

    .line 1733
    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611RecheckAfterNaverAccess(Landroid/app/Activity;I)V

    return-void
.end method

.method private synthetic lambda$onActivityResumed$28(Landroid/app/Activity;I)V
    .locals 0

    .line 1745
    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->rebindAfterReturn(Landroid/app/Activity;I)V

    return-void
.end method

.method static synthetic lambda$r570DispatchSave$20(Landroid/app/Activity;Ljava/lang/String;)V
    .locals 1

    .line 1237
    const-string v0, "true"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    const/4 v0, 0x1

    if-nez p1, :cond_13

    const-string p1, "\uc800\uc7a5 \uc5d4\uc9c4 \ud655\uc778 \uc2e4\ud328 \u00b7 \ub2e4\uc2dc \uc2dc\ub3c4\ud574 \uc8fc\uc138\uc694"

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    goto :goto_1c

    .line 1238
    :cond_13
    const-string p1, "\uc800\uc7a5 \uc694\uccad\uc744 \uc804\ub2ec\ud588\uc2b5\ub2c8\ub2e4 \u00b7 \ub124\uc774\ubc84 \uc800\uc7a5 \uacb0\uacfc \ud655\uc778 \ud544\uc694"

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    .line 1239
    :goto_1c
    return-void
.end method

.method private synthetic lambda$r570InitActionOrder$12(Landroid/app/Activity;Landroid/widget/LinearLayout;Landroid/view/View;)Z
    .locals 0

    .line 1130
    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570OpenOrder(Landroid/app/Activity;Landroid/widget/LinearLayout;)V

    const/4 p1, 0x1

    return p1
.end method

.method private synthetic lambda$r570OpenFavorite$17(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/content/DialogInterface;I)V
    .locals 9

    .line 1215
    const-string v8, "web"

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move-object v3, p3

    move-object v4, p4

    move-object v5, p5

    move-object v6, p6

    move-object/from16 v7, p7

    invoke-direct/range {v0 .. v8}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570DispatchSave(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Ljava/lang/String;)V

    return-void
.end method

.method private synthetic lambda$r570OpenFavorite$18(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/content/DialogInterface;I)V
    .locals 9

    .line 1216
    const-string v8, "native"

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move-object v3, p3

    move-object v4, p4

    move-object v5, p5

    move-object v6, p6

    move-object/from16 v7, p7

    invoke-direct/range {v0 .. v8}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570DispatchSave(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Ljava/lang/String;)V

    return-void
.end method

.method static synthetic lambda$r570OpenFavorite$19(Landroid/content/DialogInterface;I)V
    .locals 0

    .line 1217
    return-void
.end method

.method static synthetic lambda$r570OpenOrder$13([ILandroid/content/DialogInterface;I)V
    .locals 0

    .line 1181
    const/4 p1, 0x0

    aput p2, p0, p1

    return-void
.end method

.method private synthetic lambda$r570OpenOrder$14(Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/util/ArrayList;[ILandroid/content/DialogInterface;I)V
    .locals 6

    .line 1182
    const/4 p5, 0x0

    aget v4, p4, p5

    const/4 v5, -0x1

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move-object v3, p3

    invoke-direct/range {v0 .. v5}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570MoveOrder(Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/util/ArrayList;II)V

    return-void
.end method

.method private synthetic lambda$r570OpenOrder$15(Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/util/ArrayList;[ILandroid/content/DialogInterface;I)V
    .locals 6

    .line 1183
    const/4 p5, 0x0

    aget v4, p4, p5

    const/4 v5, 0x1

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move-object v3, p3

    invoke-direct/range {v0 .. v5}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570MoveOrder(Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/util/ArrayList;II)V

    return-void
.end method

.method static synthetic lambda$r570OpenOrder$16(Landroid/content/DialogInterface;I)V
    .locals 0

    .line 1184
    return-void
.end method

.method private synthetic lambda$r602PollPlaylist$22(Ljava/lang/Object;Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 16

    .line 1413
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object/from16 v2, p3

    const-string v3, "ids"

    const-string v4, ""

    const-string v5, "MOA_R602"

    const/4 v6, 0x0

    iput-boolean v6, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602PlaylistPolling:Z

    .line 1414
    iget-object v7, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-ne v1, v7, :cond_1c4

    invoke-static/range {p1 .. p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_1c4

    iget-boolean v7, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz v7, :cond_1c4

    iget-object v7, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    move-object/from16 v8, p2

    if-eq v8, v7, :cond_25

    goto/16 :goto_1c4

    .line 1416
    :cond_25
    :try_start_25
    new-instance v7, Lorg/json/JSONTokener;

    move-object/from16 v8, p4

    invoke-direct {v7, v8}, Lorg/json/JSONTokener;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7}, Lorg/json/JSONTokener;->nextValue()Ljava/lang/Object;

    move-result-object v7

    instance-of v8, v7, Ljava/lang/String;

    if-nez v8, :cond_35

    return-void

    .line 1417
    :cond_35
    check-cast v7, Ljava/lang/String;

    invoke-virtual {v7}, Ljava/lang/String;->isEmpty()Z

    move-result v8

    if-eqz v8, :cond_3e

    return-void

    .line 1418
    :cond_3e
    new-instance v8, Lorg/json/JSONObject;

    invoke-direct {v8, v7}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 1419
    const-string v7, "currentDay"

    invoke-static {v1, v7}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v7

    invoke-static {v7}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v7

    .line 1420
    const-string v9, "day"

    invoke-virtual {v8, v9, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v9, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_5a

    return-void

    .line 1421
    :cond_5a
    const-string v9, "token"

    const/4 v10, -0x1

    invoke-virtual {v8, v9, v10}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v9

    .line 1424
    iget v10, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownedDayToken:I

    if-lt v9, v10, :cond_1a3

    if-gtz v9, :cond_69

    goto/16 :goto_1a3

    .line 1425
    :cond_69
    invoke-virtual {v8, v3}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v10

    .line 1426
    if-eqz v10, :cond_1a2

    invoke-virtual {v10}, Lorg/json/JSONArray;->length()I

    move-result v11

    if-eqz v11, :cond_1a2

    invoke-virtual {v10}, Lorg/json/JSONArray;->length()I

    move-result v11

    const/16 v12, 0x2710

    if-le v11, v12, :cond_7f

    goto/16 :goto_1a2

    .line 1427
    :cond_7f
    new-instance v11, Ljava/util/ArrayList;

    invoke-direct {v11}, Ljava/util/ArrayList;-><init>()V

    .line 1428
    move v12, v6

    :goto_85
    invoke-virtual {v10}, Lorg/json/JSONArray;->length()I

    move-result v13

    if-ge v12, v13, :cond_9e

    .line 1429
    invoke-virtual {v10, v12, v4}, Lorg/json/JSONArray;->optString(ILjava/lang/String;)Ljava/lang/String;

    move-result-object v13

    .line 1430
    const-string v14, "(?:v)?[0-9]{1,18}"

    invoke-virtual {v13, v14}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v14

    if-nez v14, :cond_98

    return-void

    .line 1431
    :cond_98
    invoke-virtual {v11, v13}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 1428
    add-int/lit8 v12, v12, 0x1

    goto :goto_85

    .line 1433
    :cond_9e
    invoke-static {v1, v3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    .line 1434
    instance-of v4, v3, Ljava/util/List;

    if-nez v4, :cond_a7

    return-void

    .line 1435
    :cond_a7
    move-object v4, v3

    check-cast v4, Ljava/util/List;

    .line 1436
    invoke-virtual {v11, v4}, Ljava/util/ArrayList;->equals(Ljava/lang/Object;)Z

    move-result v4
    :try_end_ae
    .catchall {:try_start_25 .. :try_end_ae} :catchall_1a4

    const-string v10, "window.__moaR602PlaylistUpdate=null;"

    const-string v12, ":"

    const-wide/16 v13, 0x0

    const-string v15, "changedAt"

    const/4 v6, 0x0

    if-eqz v4, :cond_d8

    .line 1437
    :try_start_b9
    invoke-virtual {v8, v15, v13, v14}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide v3

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602LastAppliedSignature:Ljava/lang/String;

    .line 1438
    invoke-virtual {v2, v10, v6}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 1439
    return-void

    .line 1441
    :cond_d8
    invoke-static/range {p1 .. p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    .line 1444
    check-cast v3, Ljava/util/List;

    .line 1445
    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v13

    .line 1446
    invoke-interface {v3}, Ljava/util/List;->clear()V

    invoke-interface {v3, v11}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 1447
    invoke-virtual {v11, v4}, Ljava/util/ArrayList;->indexOf(Ljava/lang/Object;)I

    move-result v3
    :try_end_ec
    .catchall {:try_start_b9 .. :try_end_ec} :catchall_1a4

    .line 1448
    const-string v4, "index"

    const/4 v14, 0x1

    if-gez v3, :cond_103

    :try_start_f1
    invoke-virtual {v11}, Ljava/util/ArrayList;->size()I

    move-result v3

    sub-int/2addr v3, v14

    const/4 v6, 0x0

    invoke-virtual {v8, v4, v6}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v14

    invoke-static {v3, v14}, Ljava/lang/Math;->min(II)I

    move-result v3

    invoke-static {v6, v3}, Ljava/lang/Math;->max(II)I

    move-result v3

    .line 1449
    :cond_103
    invoke-virtual/range {p1 .. p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v6

    invoke-static {v6, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->field(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v4

    .line 1450
    if-eqz v4, :cond_110

    invoke-virtual {v4, v1, v3}, Ljava/lang/reflect/Field;->setInt(Ljava/lang/Object;I)V

    .line 1451
    :cond_110
    invoke-virtual/range {p1 .. p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    const-string v4, "loadToken"

    invoke-static {v3, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->field(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v3

    .line 1452
    if-eqz v3, :cond_125

    invoke-virtual {v3, v1}, Ljava/lang/reflect/Field;->getInt(Ljava/lang/Object;)I

    move-result v4

    const/4 v6, 0x1

    add-int/2addr v4, v6

    invoke-virtual {v3, v1, v4}, Ljava/lang/reflect/Field;->setInt(Ljava/lang/Object;I)V

    .line 1453
    :cond_125
    const-string v3, "loadedPageIds"

    invoke-static {v1, v3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    .line 1454
    instance-of v4, v3, [Ljava/lang/String;

    if-eqz v4, :cond_135

    check-cast v3, [Ljava/lang/String;

    const/4 v4, 0x0

    invoke-static {v3, v4}, Ljava/util/Arrays;->fill([Ljava/lang/Object;Ljava/lang/Object;)V

    .line 1455
    :cond_135
    invoke-virtual/range {p1 .. p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    const-string v4, "refreshPages"

    const/4 v6, 0x0

    new-array v14, v6, [Ljava/lang/Class;

    invoke-virtual {v3, v4, v14}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    .line 1456
    const/4 v4, 0x1

    invoke-virtual {v3, v4}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    new-array v4, v6, [Ljava/lang/Object;

    invoke-virtual {v3, v1, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1457
    const-string v3, "rail"

    invoke-static {v1, v3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    .line 1458
    instance-of v3, v1, Landroid/view/View;

    if-eqz v3, :cond_15a

    check-cast v1, Landroid/view/View;

    invoke-virtual {v1}, Landroid/view/View;->invalidate()V

    .line 1459
    :cond_15a
    iput v9, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownedDayToken:I

    .line 1460
    const-wide/16 v3, 0x0

    invoke-virtual {v8, v15, v3, v4}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide v3

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602LastAppliedSignature:Ljava/lang/String;

    .line 1461
    invoke-virtual {v11}, Ljava/util/ArrayList;->size()I

    move-result v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "NATIVE_PLAYLIST_UPDATED_FROM_CANONICAL old="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, " new="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v5, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1462
    const/4 v0, 0x0

    invoke-virtual {v2, v10, v0}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V
    :try_end_1a1
    .catchall {:try_start_f1 .. :try_end_1a1} :catchall_1a4

    .line 1465
    goto :goto_1c3

    .line 1426
    :cond_1a2
    :goto_1a2
    return-void

    .line 1424
    :cond_1a3
    :goto_1a3
    return-void

    .line 1463
    :catchall_1a4
    move-exception v0

    .line 1464
    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "NATIVE_PLAYLIST_UPDATE_FAILED_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v5, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 1466
    :goto_1c3
    return-void

    .line 1414
    :cond_1c4
    :goto_1c4
    return-void
.end method

.method private synthetic lambda$r611MarkNaverAccessChange$0(ILandroid/app/Activity;)V
    .locals 1

    .line 276
    iget v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611NaverToggleSeq:I

    if-ne p1, v0, :cond_23

    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->resumed:Z

    if-eqz p1, :cond_23

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    if-ne p1, p2, :cond_23

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    if-ne p1, p2, :cond_23

    .line 277
    invoke-virtual {p2}, Landroid/app/Activity;->isDestroyed()Z

    move-result p1

    if-nez p1, :cond_23

    invoke-virtual {p2}, Landroid/app/Activity;->isFinishing()Z

    move-result p1

    if-eqz p1, :cond_1d

    goto :goto_23

    .line 278
    :cond_1d
    iget p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foregroundEpoch:I

    invoke-direct {p0, p2, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611RecheckAfterNaverAccess(Landroid/app/Activity;I)V

    .line 279
    return-void

    .line 277
    :cond_23
    :goto_23
    return-void
.end method

.method private synthetic lambda$rebindAfterReturn$24(Landroid/app/Activity;ILjava/lang/Object;Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 5

    .line 1579
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->resumed:Z

    if-eqz v0, :cond_98

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    if-ne v0, p1, :cond_98

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foregroundEpoch:I

    if-ne p2, v0, :cond_98

    iget-boolean p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnFromBackground:Z

    if-eqz p2, :cond_98

    iget-object p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-ne p2, p3, :cond_98

    iget-object p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    if-eqz p2, :cond_98

    .line 1580
    invoke-static {p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_20

    goto/16 :goto_98

    .line 1581
    :cond_20
    nop

    .line 1582
    const/4 p2, 0x0

    :try_start_22
    invoke-static {p5}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p5

    const-string v0, "\""

    const-string v1, ""

    invoke-virtual {p5, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p5

    invoke-static {p5}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p5
    :try_end_32
    .catchall {:try_start_22 .. :try_end_32} :catchall_33

    goto :goto_35

    :catchall_33
    move-exception p5

    move p5, p2

    .line 1583
    :goto_35
    const-string v0, "MOA_R567"

    if-gtz p5, :cond_3f

    const-string p1, "RETURN_JS_NOT_READY_RETRY"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 1584
    :cond_3f
    iput p5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownedDayToken:I

    .line 1585
    iput-boolean p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnFromBackground:Z

    iput-boolean p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->hadMountedOnPause:Z

    const-wide/16 v1, 0x0

    iput-wide v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeCloseDetectedAt:J

    .line 1586
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v1

    const-wide/16 v3, 0x140

    add-long/2addr v1, v3

    iput-wide v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnCloseGuardUntil:J

    .line 1587
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    const/high16 v2, 0x3f800000    # 1.0f

    invoke-virtual {v1, v2}, Landroid/widget/FrameLayout;->setAlpha(F)V

    .line 1588
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    invoke-virtual {v1, p2}, Landroid/widget/FrameLayout;->setVisibility(I)V

    .line 1589
    iget-object p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    invoke-virtual {p2}, Landroid/widget/FrameLayout;->bringToFront()V

    .line 1590
    iget-object p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    invoke-virtual {p2}, Landroid/widget/FrameLayout;->requestLayout()V

    iget-object p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    invoke-virtual {p2}, Landroid/widget/FrameLayout;->invalidate()V

    .line 1591
    invoke-direct {p0, p1, p4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->installInlineBack(Landroid/app/Activity;Landroid/webkit/WebView;)V

    iget-object p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    invoke-direct {p0, p1, p4, p3, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->monitorNativeHost(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Landroid/widget/FrameLayout;)V

    .line 1592
    invoke-direct {p0, p4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ensurePositionChannel(Landroid/webkit/WebView;)V

    .line 1593
    invoke-direct {p0, p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->refreshOriginalMediaIfBlank(Ljava/lang/Object;)V

    .line 1594
    const-string p1, "window.__moaR559RepositionNative&&window.__moaR559RepositionNative();"

    const/4 p2, 0x0

    invoke-virtual {p4, p1, p2}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 1596
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "RETURN_ORIGINAL_NATIVE_RETAINED_VISIBLE token="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1597
    return-void

    .line 1580
    :cond_98
    :goto_98
    return-void
.end method

.method private synthetic lambda$rebindAfterReturn$25(Landroid/app/Activity;ILjava/lang/Object;Ljava/lang/String;)V
    .locals 6

    .line 1638
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->resumed:Z

    const/4 v1, 0x0

    if-eqz v0, :cond_59

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    if-ne v0, p1, :cond_59

    iget p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foregroundEpoch:I

    if-ne p2, p1, :cond_59

    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnFromBackground:Z

    if-nez p1, :cond_12

    goto :goto_59

    .line 1640
    :cond_12
    const-string p1, "true"

    invoke-static {p4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    const-string p2, "MOA_R567"

    if-nez p1, :cond_28

    .line 1641
    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->controlledRebuildInProgress:Z

    .line 1642
    const-string p1, "RETURN_REOPEN_JS_NOT_READY_RETRY"

    invoke-static {p2, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 1644
    :cond_28
    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnFromBackground:Z

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->hadMountedOnPause:Z

    .line 1645
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v2

    iput-wide v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastRebindAt:J

    .line 1646
    iget-wide v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastRebindAt:J

    const-wide/16 v4, 0x140

    add-long/2addr v2, v4

    iput-wide v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnCloseGuardUntil:J

    .line 1647
    iget-wide v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastRebindAt:J

    const-wide/16 v4, 0xbe

    add-long/2addr v2, v4

    iput-wide v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->suppressArmUntil:J

    .line 1648
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->closePositionPort()V

    .line 1651
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->clearCardMark()V

    .line 1652
    if-eqz p3, :cond_51

    invoke-static {p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_51

    invoke-static {p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->invokeClose(Ljava/lang/Object;)V

    .line 1653
    :cond_51
    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->controlledRebuildInProgress:Z

    .line 1654
    const-string p1, "RETURN_LOST_NATIVE_REOPEN_SAME_DAY"

    invoke-static {p2, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1655
    return-void

    .line 1639
    :cond_59
    :goto_59
    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->controlledRebuildInProgress:Z

    return-void
.end method

.method private synthetic lambda$rebindAfterReturn$26(Landroid/app/Activity;ILandroid/webkit/WebView;Ljava/lang/String;)V
    .locals 4

    .line 1611
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->resumed:Z

    if-eqz v0, :cond_d9

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    if-ne v0, p1, :cond_d9

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foregroundEpoch:I

    if-ne p2, v0, :cond_d9

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeOpen:Z

    if-nez v0, :cond_d9

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    if-eq v0, p1, :cond_16

    goto/16 :goto_d9

    .line 1613
    :cond_16
    :try_start_16
    new-instance v0, Lorg/json/JSONTokener;

    invoke-direct {v0, p4}, Lorg/json/JSONTokener;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Lorg/json/JSONTokener;->nextValue()Ljava/lang/Object;

    move-result-object p4

    .line 1614
    instance-of v0, p4, Ljava/lang/String;

    if-nez v0, :cond_24

    return-void

    .line 1615
    :cond_24
    new-instance v0, Lorg/json/JSONObject;

    check-cast p4, Ljava/lang/String;

    invoke-direct {v0, p4}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 1616
    const-string p4, "day"

    invoke-virtual {v0, p4}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;)Z

    move-result p4

    if-eqz p4, :cond_d5

    const-string p4, "full"

    invoke-virtual {v0, p4}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;)Z

    move-result p4

    if-eqz p4, :cond_3d

    goto/16 :goto_d5

    .line 1617
    :cond_3d
    const-string p4, "token"

    const/4 v1, 0x0

    invoke-virtual {v0, p4, v1}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p4

    .line 1620
    const-string v1, "date"

    const-string v2, ""

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 1621
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    const-string v2, "currentDay"

    invoke-static {v1, v2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    invoke-static {v1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    .line 1622
    const-string v2, "null"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_66

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_68

    :cond_66
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownerDayAtPause:Ljava/lang/String;

    .line 1623
    :cond_68
    if-lez p4, :cond_d4

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result p4

    if-nez p4, :cond_d4

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p4

    if-nez p4, :cond_77

    goto :goto_d4

    .line 1625
    :cond_77
    const-string p4, "unifiedGallery"

    invoke-static {p1, p4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p4

    .line 1626
    const v1, 0x1020002

    invoke-virtual {p1, v1}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/FrameLayout;

    .line 1627
    invoke-static {p4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_aa

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-ne p4, v2, :cond_aa

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    if-eqz v2, :cond_aa

    const-string v2, "host"

    .line 1628
    invoke-static {p4, v2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    if-ne v2, v3, :cond_aa

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    invoke-virtual {v2}, Landroid/widget/FrameLayout;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    if-ne v2, v1, :cond_aa

    .line 1631
    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->rebindAfterReturn(Landroid/app/Activity;I)V

    return-void

    .line 1635
    :cond_aa
    const/4 v1, 0x1

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->controlledRebuildInProgress:Z

    .line 1636
    nop

    .line 1637
    invoke-static {v0}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "window.__moaR567ReopenLostCard&&window.__moaR567ReopenLostCard("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ");"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    new-instance v1, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda6;

    invoke-direct {v1, p0, p1, p2, p4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda6;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;ILjava/lang/Object;)V

    .line 1636
    invoke-virtual {p3, v0, v1}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V
    :try_end_d3
    .catchall {:try_start_16 .. :try_end_d3} :catchall_d6

    goto :goto_d7

    .line 1623
    :cond_d4
    :goto_d4
    return-void

    .line 1616
    :cond_d5
    :goto_d5
    return-void

    .line 1656
    :catchall_d6
    move-exception p1

    :goto_d7
    nop

    .line 1657
    return-void

    .line 1611
    :cond_d9
    :goto_d9
    return-void
.end method

.method private synthetic lambda$refreshOriginalMediaIfBlank$23(Ljava/lang/Object;Landroid/widget/FrameLayout;ILjava/lang/String;)V
    .locals 5

    .line 1523
    const-string v0, "MOA_R563"

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->resumed:Z

    if-eqz v1, :cond_d7

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    if-ne v1, v2, :cond_d7

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeOpen:Z

    if-nez v1, :cond_d7

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz v1, :cond_d7

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-ne v1, p1, :cond_d7

    if-eqz p2, :cond_d7

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    if-ne p2, v1, :cond_d7

    .line 1525
    const-string v1, "host"

    invoke-static {p1, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    if-ne v1, p2, :cond_d7

    iget p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownedDayToken:I

    if-ne p2, p3, :cond_d7

    .line 1526
    invoke-static {p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_d7

    .line 1527
    invoke-static {p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p4, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_d7

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->actualMediaReady(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_42

    goto/16 :goto_d7

    .line 1529
    :cond_42
    :try_start_42
    const-string p2, "texture"

    invoke-static {p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p2

    .line 1530
    const-string p3, "media"

    invoke-static {p1, p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p3

    .line 1531
    instance-of p4, p2, Landroid/view/TextureView;

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eqz p4, :cond_5e

    check-cast p2, Landroid/view/TextureView;

    .line 1532
    invoke-virtual {p2}, Landroid/view/TextureView;->isAvailable()Z

    move-result p2

    if-eqz p2, :cond_5e

    move p2, v1

    goto :goto_5f

    :cond_5e
    move p2, v2

    .line 1533
    :goto_5f
    if-eqz p2, :cond_74

    instance-of p2, p3, Landroid/media/MediaPlayer;

    if-eqz p2, :cond_74

    sget-object p2, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    const-string p3, "prepared"

    .line 1534
    invoke-static {p1, p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_74

    return-void

    .line 1535
    :cond_74
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p2

    const-string p3, "teardownPlayer"

    new-array p4, v2, [Ljava/lang/Class;

    invoke-virtual {p2, p3, p4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p2

    .line 1536
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p3

    const-string p4, "refreshPages"

    new-array v3, v2, [Ljava/lang/Class;

    invoke-virtual {p3, p4, v3}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p3

    .line 1537
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p4

    const-string v3, "prepareCurrentVideo"

    new-array v4, v2, [Ljava/lang/Class;

    invoke-virtual {p4, v3, v4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p4

    .line 1538
    invoke-virtual {p2, v1}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    invoke-virtual {p3, v1}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    invoke-virtual {p4, v1}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 1540
    new-array v1, v2, [Ljava/lang/Object;

    invoke-virtual {p2, p1, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    new-array p2, v2, [Ljava/lang/Object;

    invoke-virtual {p3, p1, p2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    new-array p2, v2, [Ljava/lang/Object;

    invoke-virtual {p4, p1, p2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1541
    const-string p1, "ORIGINAL_VIDEO_SURFACE_REPAIR id_preserved"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_b5
    .catchall {:try_start_42 .. :try_end_b5} :catchall_b6

    .line 1545
    goto :goto_d6

    .line 1542
    :catchall_b6
    move-exception p1

    .line 1543
    nop

    .line 1544
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p1

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "ORIGINAL_VIDEO_SURFACE_REPAIR_FAILED_"

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 1543
    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 1546
    :goto_d6
    return-void

    .line 1527
    :cond_d7
    :goto_d7
    return-void
.end method

.method private synthetic lambda$retireDayBackIfInactive$6(Landroid/app/Activity;Ljava/lang/String;)V
    .locals 1

    .line 733
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->backOwner:Landroid/app/Activity;

    if-ne v0, p1, :cond_13

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inlineBack:Landroid/window/OnBackInvokedCallback;

    if-eqz p1, :cond_13

    const-string p1, "true"

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_13

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dropDayBack()V

    .line 734
    :cond_13
    return-void
.end method

.method private synthetic lambda$tick$2(Ljava/lang/Object;Ljava/lang/String;)V
    .locals 1

    .line 549
    :try_start_0
    new-instance v0, Lorg/json/JSONTokener;

    invoke-direct {v0, p2}, Lorg/json/JSONTokener;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Lorg/json/JSONTokener;->nextValue()Ljava/lang/Object;

    move-result-object p2

    instance-of v0, p2, Ljava/lang/String;

    if-nez v0, :cond_e

    return-void

    :cond_e
    new-instance v0, Lorg/json/JSONObject;

    check-cast p2, Ljava/lang/String;

    invoke-direct {v0, p2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 550
    const-string p2, "day"

    invoke-virtual {v0, p2}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;)Z

    move-result p2

    if-nez p2, :cond_28

    invoke-static {p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_28

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->clearCardMark()V
    :try_end_26
    .catchall {:try_start_0 .. :try_end_26} :catchall_27

    goto :goto_28

    .line 551
    :catchall_27
    move-exception p1

    :cond_28
    :goto_28
    nop

    .line 552
    return-void
.end method

.method private synthetic lambda$tick$3(ILandroid/app/Activity;Ljava/lang/Object;Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 7

    .line 531
    const-string v0, "SNAPSHOT"

    invoke-direct {p0, p1, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EndEval(ILjava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_9

    return-void

    .line 532
    :cond_9
    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->resumed:Z

    if-eqz p1, :cond_9f

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    if-ne p1, p2, :cond_9f

    invoke-static {p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_19

    goto/16 :goto_9f

    .line 534
    :cond_19
    const/4 p1, 0x0

    :try_start_1a
    new-instance v0, Lorg/json/JSONTokener;

    invoke-direct {v0, p5}, Lorg/json/JSONTokener;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Lorg/json/JSONTokener;->nextValue()Ljava/lang/Object;

    move-result-object p5

    .line 535
    instance-of v0, p5, Ljava/lang/String;

    if-nez v0, :cond_28

    return-void

    .line 536
    :cond_28
    new-instance v0, Lorg/json/JSONObject;

    check-cast p5, Ljava/lang/String;

    invoke-direct {v0, p5}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 537
    const-string p5, "active"

    invoke-virtual {v0, p5}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;)Z

    move-result p5

    const-wide/16 v1, 0x0

    if-nez p5, :cond_63

    .line 540
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v3

    .line 541
    iget-wide v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inactiveAt:J

    cmp-long p2, v5, v1

    if-nez p2, :cond_45

    iput-wide v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inactiveAt:J

    .line 547
    :cond_45
    iget-boolean p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz p2, :cond_62

    iget-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inactiveAt:J

    sub-long v0, v3, v0

    const-wide/16 v5, 0x2710

    cmp-long p2, v0, v5

    if-lez p2, :cond_62

    .line 548
    const-string p2, "(function(){var d=window.MoaR469SimpleDiary,s=d&&d.readOnlyStatus&&d.readOnlyStatus();return JSON.stringify({day:!!(s&&s.active&&s.page===\'day\'),pending:!!window.__moaR507NativePending});})()"

    new-instance p5, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda24;

    invoke-direct {p5, p0, p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda24;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Ljava/lang/Object;)V

    invoke-virtual {p4, p2, p5}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 553
    const-wide/16 p2, 0x1f40

    sub-long/2addr v3, p2

    iput-wide v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inactiveAt:J

    .line 555
    :cond_62
    return-void

    .line 557
    :cond_63
    iput-wide v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inactiveAt:J

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v1

    iput-wide v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastValidSnapshot:J

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->snapshotFailures:I

    .line 558
    const-string p5, "w"

    invoke-virtual {v0, p5}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;)D

    move-result-wide v1

    const-wide/high16 v3, 0x4049000000000000L    # 50.0

    cmpg-double p5, v1, v3

    if-ltz p5, :cond_8a

    const-string p5, "h"

    invoke-virtual {v0, p5}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;)D

    move-result-wide v1

    const-wide/high16 v3, 0x4059000000000000L    # 100.0

    cmpg-double p5, v1, v3

    if-gez p5, :cond_86

    goto :goto_8a

    .line 559
    :cond_86
    invoke-direct {p0, p2, p4, p3, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->attachCard(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Lorg/json/JSONObject;)V
    :try_end_89
    .catchall {:try_start_1a .. :try_end_89} :catchall_8b

    .line 568
    goto :goto_9e

    .line 558
    :cond_8a
    :goto_8a
    return-void

    .line 560
    :catchall_8b
    move-exception p2

    .line 562
    iget p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->snapshotFailures:I

    add-int/lit8 p2, p2, 0x1

    iput p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->snapshotFailures:I

    .line 563
    iget p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->snapshotFailures:I

    const/16 p3, 0xf

    if-le p2, p3, :cond_9e

    iget-boolean p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz p2, :cond_9e

    .line 566
    iput p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->snapshotFailures:I

    .line 569
    :cond_9e
    :goto_9e
    return-void

    .line 532
    :cond_9f
    :goto_9f
    return-void
.end method

.method private maybeArm(Landroid/app/Activity;Landroid/webkit/WebView;)V
    .locals 4

    .line 572
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-nez v0, :cond_4c

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inlineArmed:Z

    if-nez v0, :cond_4c

    .line 573
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    iget-wide v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->suppressArmUntil:J

    cmp-long v0, v0, v2

    if-gez v0, :cond_13

    goto :goto_4c

    .line 574
    :cond_13
    const-string v0, "ARM_SNAPSHOT"

    invoke-direct {p0, p2, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657BeginEval(Landroid/webkit/WebView;Ljava/lang/String;)I

    move-result v1

    .line 575
    if-gez v1, :cond_1c

    return-void

    .line 576
    :cond_1c
    :try_start_1c
    const-string v2, "(function(){try{var d=window.MoaR469SimpleDiary,s=d&&d.readOnlyStatus&&d.readOnlyStatus();var e=document.querySelector(\'#moa-r469-root .moa-r469-stage\');if(!window.__moaR511InlineArm||!s||!s.active||s.page!==\'day\'||!e)return JSON.stringify({active:false});var r=e.getBoundingClientRect();return JSON.stringify({active:true,x:r.left,y:r.top,w:r.width,h:r.height,vw:innerWidth,vh:innerHeight,cover:(window.__moaR507CoverId||\'\'),token:(window.__moaR527DayToken||0)});}catch(e){return JSON.stringify({active:false});}})()"

    new-instance v3, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda23;

    invoke-direct {v3, p0, v1, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda23;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;ILandroid/app/Activity;Landroid/webkit/WebView;)V

    invoke-virtual {p2, v2, v3}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V
    :try_end_26
    .catchall {:try_start_1c .. :try_end_26} :catchall_27

    .line 598
    goto :goto_4b

    .line 595
    :catchall_27
    move-exception p1

    .line 596
    invoke-direct {p0, v1, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EndEval(ILjava/lang/String;)Z

    .line 597
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p1

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "ARM_SNAPSHOT_EVALUATION_THROW "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string p2, "MOA_R657"

    invoke-static {p2, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 599
    :goto_4b
    return-void

    .line 573
    :cond_4c
    :goto_4c
    return-void
.end method

.method private monitorNativeHost(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Landroid/widget/FrameLayout;)V
    .locals 7

    .line 650
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->monitoredHost:Landroid/widget/FrameLayout;

    if-ne v0, p4, :cond_9

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->monitoredHostListener:Landroid/view/View$OnAttachStateChangeListener;

    if-eqz v0, :cond_9

    return-void

    .line 651
    :cond_9
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->stopMonitoringNativeHost()V

    .line 652
    iput-object p4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->monitoredHost:Landroid/widget/FrameLayout;

    .line 653
    const-string v0, "currentDay"

    invoke-static {p3, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    .line 654
    new-instance v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$5;

    move-object v1, v0

    move-object v2, p0

    move-object v3, p3

    move-object v4, p1

    move-object v5, p2

    invoke-direct/range {v1 .. v6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$5;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Ljava/lang/Object;Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/String;)V

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->monitoredHostListener:Landroid/view/View$OnAttachStateChangeListener;

    .line 667
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->monitoredHostListener:Landroid/view/View$OnAttachStateChangeListener;

    invoke-virtual {p4, p1}, Landroid/widget/FrameLayout;->addOnAttachStateChangeListener(Landroid/view/View$OnAttachStateChangeListener;)V

    .line 668
    return-void
.end method

.method private onPositionMessage(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 23

    .line 407
    move-object/from16 v0, p0

    move-object/from16 v1, p2

    if-eqz v1, :cond_16f

    invoke-virtual/range {p2 .. p2}, Ljava/lang/String;->length()I

    move-result v2

    const/16 v3, 0xb4

    if-le v2, v3, :cond_10

    goto/16 :goto_16f

    .line 409
    :cond_10
    :try_start_10
    const-string v2, ","

    const/4 v3, -0x1

    invoke-virtual {v1, v2, v3}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v1

    array-length v2, v1

    const/4 v3, 0x7

    if-eq v2, v3, :cond_1c

    return-void

    .line 410
    :cond_1c
    const/4 v2, 0x0

    aget-object v3, v1, v2

    invoke-static {v3}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v3

    double-to-int v3, v3

    .line 411
    iget v4, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownedDayToken:I

    if-ne v3, v4, :cond_16b

    if-gtz v3, :cond_2c

    goto/16 :goto_16b

    .line 412
    :cond_2c
    const/4 v3, 0x1

    aget-object v4, v1, v3

    invoke-static {v4}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v4

    const/4 v6, 0x2

    aget-object v7, v1, v6

    invoke-static {v7}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v7

    .line 413
    const/4 v9, 0x3

    aget-object v9, v1, v9

    invoke-static {v9}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v9

    const/4 v11, 0x4

    aget-object v12, v1, v11

    invoke-static {v12}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v12

    .line 414
    const/4 v14, 0x5

    aget-object v14, v1, v14

    invoke-static {v14}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v14

    const/16 v16, 0x6

    aget-object v1, v1, v16

    invoke-static {v1}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v16

    .line 415
    invoke-static {v4, v5}, Ljava/lang/Double;->isFinite(D)Z

    move-result v1

    if-eqz v1, :cond_16a

    invoke-static {v7, v8}, Ljava/lang/Double;->isFinite(D)Z

    move-result v1

    if-eqz v1, :cond_16a

    invoke-static {v9, v10}, Ljava/lang/Double;->isFinite(D)Z

    move-result v1

    if-eqz v1, :cond_16a

    .line 416
    invoke-static {v12, v13}, Ljava/lang/Double;->isFinite(D)Z

    move-result v1

    if-eqz v1, :cond_16a

    invoke-static {v14, v15}, Ljava/lang/Double;->isFinite(D)Z

    move-result v1

    if-eqz v1, :cond_16a

    invoke-static/range {v16 .. v17}, Ljava/lang/Double;->isFinite(D)Z

    move-result v1

    if-eqz v1, :cond_16a

    const-wide/high16 v18, 0x4059000000000000L    # 100.0

    cmpg-double v1, v14, v18

    if-ltz v1, :cond_16a

    cmpg-double v1, v16, v18

    if-ltz v1, :cond_16a

    cmpg-double v1, v9, v18

    if-ltz v1, :cond_16a

    cmpg-double v1, v12, v18

    if-ltz v1, :cond_16a

    .line 417
    invoke-static {v7, v8}, Ljava/lang/Math;->abs(D)D

    move-result-wide v18

    const-wide v20, 0x40d3880000000000L    # 20000.0

    cmpl-double v1, v18, v20

    if-lez v1, :cond_9c

    goto/16 :goto_16a

    .line 418
    :cond_9c
    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    const v11, 0x1020002

    invoke-virtual {v1, v11}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/FrameLayout;

    .line 419
    if-eqz v1, :cond_169

    iget-object v11, v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    invoke-virtual {v11}, Landroid/widget/FrameLayout;->getParent()Landroid/view/ViewParent;

    move-result-object v11

    if-eq v11, v1, :cond_b3

    goto/16 :goto_169

    .line 420
    :cond_b3
    new-array v11, v6, [I

    new-array v6, v6, [I

    .line 421
    move-object/from16 v3, p1

    invoke-virtual {v3, v11}, Landroid/webkit/WebView;->getLocationInWindow([I)V

    invoke-virtual {v1, v6}, Landroid/widget/FrameLayout;->getLocationInWindow([I)V

    .line 422
    invoke-virtual/range {p1 .. p1}, Landroid/webkit/WebView;->getWidth()I

    move-result v2

    int-to-double v2, v2

    div-double/2addr v2, v14

    invoke-virtual/range {p1 .. p1}, Landroid/webkit/WebView;->getHeight()I

    move-result v14

    int-to-double v14, v14

    div-double v14, v14, v16

    .line 423
    const-wide v16, 0x3fc999999999999aL    # 0.2

    cmpg-double v20, v2, v16

    if-ltz v20, :cond_168

    const-wide/high16 v20, 0x4024000000000000L    # 10.0

    cmpl-double v22, v2, v20

    if-gtz v22, :cond_168

    cmpg-double v16, v14, v16

    if-ltz v16, :cond_168

    cmpl-double v16, v14, v20

    if-lez v16, :cond_e5

    goto/16 :goto_168

    .line 426
    :cond_e5
    const/16 v16, 0x0

    aget v17, v11, v16

    aget v19, v6, v16

    move-object/from16 v20, v1

    sub-int v1, v17, v19

    int-to-double v0, v1

    mul-double/2addr v4, v2

    add-double/2addr v0, v4

    invoke-static {v0, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->rounded(D)I

    move-result v0

    const/4 v1, 0x1

    aget v4, v11, v1

    aget v1, v6, v1

    sub-int/2addr v4, v1

    int-to-double v4, v4

    mul-double/2addr v7, v14

    add-double/2addr v4, v7

    invoke-static {v4, v5}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->rounded(D)I

    move-result v1

    .line 427
    mul-double/2addr v9, v2

    invoke-static {v9, v10}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->rounded(D)I

    move-result v2

    mul-double/2addr v12, v14

    invoke-static {v12, v13}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->rounded(D)I

    move-result v3

    .line 429
    move-object/from16 v4, p0

    iget v5, v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastW:I

    if-ltz v5, :cond_167

    iget v5, v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastW:I

    sub-int/2addr v2, v5

    invoke-static {v2}, Ljava/lang/Math;->abs(I)I

    move-result v2

    iget-object v5, v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    const/high16 v6, 0x41000000    # 8.0f

    invoke-static {v5, v6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v5

    if-gt v2, v5, :cond_167

    iget v2, v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastH:I

    sub-int v2, v3, v2

    .line 430
    invoke-static {v2}, Ljava/lang/Math;->abs(I)I

    move-result v2

    iget-object v5, v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    invoke-static {v5, v6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v5

    if-le v2, v5, :cond_135

    goto :goto_167

    .line 432
    :cond_135
    iget-object v2, v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    iget v5, v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->baseX:I

    sub-int v5, v0, v5

    int-to-float v5, v5

    invoke-virtual {v2, v5}, Landroid/widget/FrameLayout;->setTranslationX(F)V

    .line 433
    iget-object v2, v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    iget v5, v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->baseY:I

    sub-int v5, v1, v5

    int-to-float v5, v5

    invoke-virtual {v2, v5}, Landroid/widget/FrameLayout;->setTranslationY(F)V

    .line 434
    iget-object v2, v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    add-int/2addr v3, v1

    if-ltz v3, :cond_158

    invoke-virtual/range {v20 .. v20}, Landroid/widget/FrameLayout;->getHeight()I

    move-result v3

    if-le v1, v3, :cond_155

    goto :goto_158

    :cond_155
    move/from16 v3, v16

    goto :goto_159

    :cond_158
    :goto_158
    const/4 v3, 0x4

    :goto_159
    invoke-virtual {v2, v3}, Landroid/widget/FrameLayout;->setVisibility(I)V

    .line 435
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v2

    iput-wide v2, v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastPositionMessageAt:J

    .line 436
    iput v0, v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastX:I

    iput v1, v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastY:I
    :try_end_166
    .catchall {:try_start_10 .. :try_end_166} :catchall_16c

    goto :goto_16d

    .line 430
    :cond_167
    :goto_167
    return-void

    .line 423
    :cond_168
    :goto_168
    return-void

    .line 419
    :cond_169
    :goto_169
    return-void

    .line 417
    :cond_16a
    :goto_16a
    return-void

    .line 411
    :cond_16b
    :goto_16b
    return-void

    .line 437
    :catchall_16c
    move-exception v0

    :goto_16d
    nop

    .line 438
    return-void

    .line 407
    :cond_16f
    :goto_16f
    return-void
.end method

.method private r570ApplyOrder(Landroid/app/Activity;Landroid/widget/LinearLayout;)V
    .locals 6

    .line 1153
    if-eqz p2, :cond_7a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    invoke-virtual {v0}, Ljava/util/LinkedHashMap;->size()I

    move-result v0

    const/16 v1, 0x8

    if-eq v0, v1, :cond_d

    goto :goto_7a

    .line 1154
    :cond_d
    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570SavedRoles(Landroid/app/Activity;)Ljava/util/ArrayList;

    move-result-object v0

    .line 1155
    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_15
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2d

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    invoke-virtual {v3, v2}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/View;

    .line 1156
    if-nez v2, :cond_2c

    return-void

    .line 1157
    :cond_2c
    goto :goto_15

    .line 1159
    :cond_2d
    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_31
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_4f

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    invoke-virtual {v3, v2}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/View;

    .line 1160
    invoke-virtual {v2}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    if-ne v3, p2, :cond_4e

    invoke-virtual {p2, v2}, Landroid/widget/LinearLayout;->removeView(Landroid/view/View;)V

    .line 1161
    :cond_4e
    goto :goto_31

    .line 1162
    :cond_4f
    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_53
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_79

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    invoke-virtual {v2, v1}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/View;

    .line 1163
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v3, 0x42080000    # 34.0f

    invoke-static {p1, v3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v3

    const/high16 v4, 0x3f800000    # 1.0f

    const/4 v5, 0x0

    invoke-direct {v2, v5, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {p2, v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1164
    goto :goto_53

    .line 1165
    :cond_79
    return-void

    .line 1153
    :cond_7a
    :goto_7a
    return-void
.end method

.method private r570DispatchSave(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Ljava/lang/String;)V
    .locals 2

    .line 1222
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    const/4 v1, 0x0

    if-eqz v0, :cond_ab

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-ne p3, v0, :cond_ab

    invoke-static {p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p4, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p3

    if-eqz p3, :cond_ab

    invoke-static {p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->isTrustedWeb(Landroid/webkit/WebView;)Z

    move-result p3

    if-nez p3, :cond_1b

    goto/16 :goto_ab

    .line 1229
    :cond_1b
    const-string p3, "moa.r570.photo.actions"

    invoke-virtual {p1, p3, v1}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p3

    invoke-interface {p3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    .line 1230
    invoke-virtual {p7}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    const-string v1, "last_save_list"

    invoke-interface {p3, v1, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    invoke-interface {p3}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1231
    nop

    .line 1232
    invoke-static {p4}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    .line 1233
    invoke-virtual {p5}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p4

    invoke-virtual {p4}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p4

    invoke-static {p4}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p4

    .line 1234
    invoke-virtual {p6}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p5

    invoke-virtual {p5}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p5

    invoke-static {p5}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p5

    .line 1235
    invoke-virtual {p7}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p6

    invoke-virtual {p6}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p6

    invoke-static {p6}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p6

    invoke-static {p8}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p7

    new-instance p8, Ljava/lang/StringBuilder;

    invoke-direct {p8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "(function(){return window.MoaR570PhotoFavorites&&window.MoaR570PhotoFavorites.save("

    invoke-virtual {p8, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p8

    invoke-virtual {p8, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    const-string p8, ","

    invoke-virtual {p3, p8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, p8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, p8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, p6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, p8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, p7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    const-string p4, ");})()"

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    .line 1236
    new-instance p4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda26;

    invoke-direct {p4, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda26;-><init>(Landroid/app/Activity;)V

    invoke-virtual {p2, p3, p4}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 1240
    return-void

    .line 1223
    :cond_ab
    :goto_ab
    const-string p2, "\uc0ac\uc9c4\uc774 \ubcc0\uacbd\ub418\uc5b4 \uc800\uc7a5 \uc694\uccad\uc744 \ucde8\uc18c\ud588\uc2b5\ub2c8\ub2e4"

    invoke-static {p1, p2, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method private r570InitActionOrder(Landroid/app/Activity;Landroid/widget/LinearLayout;Landroid/view/View;Landroid/view/View;Landroid/view/View;Landroid/view/View;)V
    .locals 3

    .line 1121
    if-eqz p2, :cond_c7

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->coverStar:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    if-eqz v0, :cond_c7

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->favoriteButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    if-eqz v0, :cond_c7

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railToggle:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    if-eqz v0, :cond_c7

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->advancedButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    if-nez v0, :cond_14

    goto/16 :goto_c7

    .line 1122
    :cond_14
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    invoke-virtual {v0}, Ljava/util/LinkedHashMap;->clear()V

    .line 1123
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    const-string v1, "cover"

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->coverStar:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    const-string v1, "share"

    invoke-virtual {v0, v1, p3}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 1124
    iget-object p3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    const-string v0, "naver"

    invoke-virtual {p3, v0, p4}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object p3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    const-string p4, "info"

    invoke-virtual {p3, p4, p5}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 1125
    iget-object p3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    const-string p4, "fast"

    invoke-virtual {p3, p4, p6}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object p3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    const-string p4, "favorite"

    iget-object p5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->favoriteButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {p3, p4, p5}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 1126
    iget-object p3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    const-string p4, "rail"

    iget-object p5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railToggle:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {p3, p4, p5}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object p3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    const-string p4, "expand"

    iget-object p5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->advancedButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {p3, p4, p5}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 1127
    iget-object p3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    invoke-virtual {p3}, Ljava/util/LinkedHashMap;->size()I

    move-result p3

    const/16 p4, 0x8

    if-eq p3, p4, :cond_64

    return-void

    .line 1128
    :cond_64
    iget-object p3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    invoke-virtual {p3}, Ljava/util/LinkedHashMap;->values()Ljava/util/Collection;

    move-result-object p3

    invoke-interface {p3}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p3

    :goto_6e
    invoke-interface {p3}, Ljava/util/Iterator;->hasNext()Z

    move-result p5

    if-eqz p5, :cond_83

    invoke-interface {p3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p5

    check-cast p5, Landroid/view/View;

    .line 1130
    new-instance p6, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda19;

    invoke-direct {p6, p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda19;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/widget/LinearLayout;)V

    invoke-virtual {p5, p6}, Landroid/view/View;->setOnLongClickListener(Landroid/view/View$OnLongClickListener;)V

    .line 1131
    goto :goto_6e

    .line 1134
    :cond_83
    new-array p3, p4, [F

    fill-array-data p3, :array_c8

    .line 1135
    const/4 p4, 0x0

    move p5, p4

    :goto_8a
    sget-object p6, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->R570_ROLES:[Ljava/lang/String;

    array-length p6, p6

    if-ge p5, p6, :cond_c3

    .line 1136
    iget-object p6, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    sget-object v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->R570_ROLES:[Ljava/lang/String;

    aget-object v0, v0, p5

    invoke-virtual {p6, v0}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p6

    check-cast p6, Landroid/view/View;

    if-nez p6, :cond_9e

    goto :goto_c0

    .line 1137
    :cond_9e
    instance-of v0, p6, Landroid/view/ViewGroup;

    if-eqz v0, :cond_b0

    move-object v0, p6

    check-cast v0, Landroid/view/ViewGroup;

    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    if-lez v1, :cond_b0

    .line 1138
    invoke-virtual {v0, p4}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object p6

    goto :goto_b1

    :cond_b0
    nop

    .line 1139
    :goto_b1
    instance-of v0, p6, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    if-eqz v0, :cond_b6

    goto :goto_c0

    .line 1140
    :cond_b6
    aget v0, p3, p5

    invoke-virtual {p6, v0}, Landroid/view/View;->setScaleX(F)V

    aget v0, p3, p5

    invoke-virtual {p6, v0}, Landroid/view/View;->setScaleY(F)V

    .line 1135
    :goto_c0
    add-int/lit8 p5, p5, 0x1

    goto :goto_8a

    .line 1142
    :cond_c3
    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570ApplyOrder(Landroid/app/Activity;Landroid/widget/LinearLayout;)V

    .line 1143
    return-void

    .line 1121
    :cond_c7
    :goto_c7
    return-void

    :array_c8
    .array-data 4
        0x3f800000    # 1.0f
        0x3f47ae14    # 0.78f
        0x3f47ae14    # 0.78f
        0x3f47ae14    # 0.78f
        0x3f47ae14    # 0.78f
        0x3f800000    # 1.0f
        0x3f800000    # 1.0f
        0x3f800000    # 1.0f
    .end array-data
.end method

.method private r570MoveOrder(Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/util/ArrayList;II)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/app/Activity;",
            "Landroid/widget/LinearLayout;",
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;II)V"
        }
    .end annotation

    .line 1189
    if-ltz p4, :cond_3c

    invoke-virtual {p3}, Ljava/util/ArrayList;->size()I

    move-result v0

    if-ge p4, v0, :cond_3c

    add-int/2addr p5, p4

    if-ltz p5, :cond_3c

    invoke-virtual {p3}, Ljava/util/ArrayList;->size()I

    move-result v0

    if-lt p5, v0, :cond_12

    goto :goto_3c

    .line 1190
    :cond_12
    invoke-static {p3, p4, p5}, Ljava/util/Collections;->swap(Ljava/util/List;II)V

    .line 1191
    const-string p4, "moa.r570.photo.actions"

    const/4 p5, 0x0

    invoke-virtual {p1, p4, p5}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p4

    invoke-interface {p4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p4

    .line 1192
    const-string v0, ","

    invoke-static {v0, p3}, Landroid/text/TextUtils;->join(Ljava/lang/CharSequence;Ljava/lang/Iterable;)Ljava/lang/String;

    move-result-object p3

    const-string v0, "order"

    invoke-interface {p4, v0, p3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    invoke-interface {p3}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1193
    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570ApplyOrder(Landroid/app/Activity;Landroid/widget/LinearLayout;)V

    .line 1194
    const-string p2, "\uc544\uc774\ucf58 \uc21c\uc11c\uac00 \uc800\uc7a5\ub410\uc2b5\ub2c8\ub2e4"

    invoke-static {p1, p2, p5}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 1195
    return-void

    .line 1189
    :cond_3c
    :goto_3c
    return-void
.end method

.method private r570OpenFavorite(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;)V
    .locals 16

    .line 1199
    move-object/from16 v9, p0

    move-object/from16 v10, p1

    move-object/from16 v11, p3

    if-eqz v10, :cond_107

    if-eqz p2, :cond_107

    if-eqz v11, :cond_107

    iget-boolean v0, v9, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz v0, :cond_107

    iget-object v0, v9, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-ne v11, v0, :cond_107

    iget-boolean v0, v9, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeOpen:Z

    if-nez v0, :cond_107

    invoke-static/range {p2 .. p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->isTrustedWeb(Landroid/webkit/WebView;)Z

    move-result v0

    if-nez v0, :cond_20

    goto/16 :goto_107

    .line 1200
    :cond_20
    invoke-static/range {p3 .. p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v12

    .line 1201
    const-string v0, "(?:v)?[0-9]{1,18}"

    invoke-virtual {v12, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_37

    .line 1202
    const-string v0, "\ud604\uc7ac \uc0ac\uc9c4\uc758 \uc704\uce58\ub97c \ud655\uc778\ud560 \uc218 \uc5c6\uc2b5\ub2c8\ub2e4"

    invoke-static {v10, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void

    .line 1204
    :cond_37
    iget-object v0, v9, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570SaveDialog:Landroid/app/AlertDialog;

    if-eqz v0, :cond_44

    iget-object v0, v9, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570SaveDialog:Landroid/app/AlertDialog;

    invoke-virtual {v0}, Landroid/app/AlertDialog;->isShowing()Z

    move-result v0

    if-eqz v0, :cond_44

    return-void

    .line 1205
    :cond_44
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, v10}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x1

    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 1206
    const/high16 v3, 0x41900000    # 18.0f

    invoke-static {v10, v3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v3

    const/high16 v4, 0x40a00000    # 5.0f

    invoke-static {v10, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result v4

    invoke-virtual {v0, v3, v4, v3, v1}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 1207
    new-instance v3, Landroid/widget/TextView;

    invoke-direct {v3, v10}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v4, "\ud604\uc7ac \uc0ac\uc9c4\uc758 \uc6d0\ubcf8 \ucd2c\uc601 GPS \uc0ac\uc6a9 \u00b7 \uc815\ud655\ud55c \uc8fc\uc18c \ud655\uc778 \ud6c4 \uc800\uc7a5"

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1208
    const/high16 v4, 0x41400000    # 12.0f

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextSize(F)V

    const v4, -0x968e86

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-virtual {v0, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 1209
    new-instance v13, Landroid/widget/EditText;

    invoke-direct {v13, v10}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    invoke-virtual {v13, v2}, Landroid/widget/EditText;->setSingleLine(Z)V

    const-string v3, "\uc7a5\uc18c \ubcc4\uba85 (\uc120\ud0dd)"

    invoke-virtual {v13, v3}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V

    invoke-virtual {v13, v2}, Landroid/widget/EditText;->setMaxLines(I)V

    .line 1210
    new-instance v14, Landroid/widget/EditText;

    invoke-direct {v14, v10}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    const-string v3, "\ub124\uc774\ubc84 \uc990\uaca8\ucc3e\uae30 \uba54\ubaa8 (\uc120\ud0dd)"

    invoke-virtual {v14, v3}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V

    const/4 v3, 0x2

    invoke-virtual {v14, v3}, Landroid/widget/EditText;->setMinLines(I)V

    const/4 v3, 0x3

    invoke-virtual {v14, v3}, Landroid/widget/EditText;->setMaxLines(I)V

    .line 1211
    new-instance v15, Landroid/widget/EditText;

    invoke-direct {v15, v10}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    invoke-virtual {v15, v2}, Landroid/widget/EditText;->setSingleLine(Z)V

    const-string v2, "\uc800\uc7a5\ud560 \ub9ac\uc2a4\ud2b8 \uc774\ub984"

    invoke-virtual {v15, v2}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V

    .line 1212
    const-string v2, "moa.r570.photo.actions"

    invoke-virtual {v10, v2, v1}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    const-string v2, "last_save_list"

    const-string v3, "\ub0b4 \uc7a5\uc18c"

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v15, v1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 1213
    invoke-virtual {v0, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    invoke-virtual {v0, v14}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    invoke-virtual {v0, v15}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 1214
    new-instance v1, Landroid/app/AlertDialog$Builder;

    invoke-direct {v1, v10}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v2, "\ub124\uc774\ubc84 \uc990\uaca8\ucc3e\uae30 \uc800\uc7a5"

    invoke-virtual {v1, v2}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    .line 1215
    invoke-virtual {v1, v0}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;

    move-result-object v8

    new-instance v7, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda8;

    move-object v0, v7

    move-object/from16 v1, p0

    move-object/from16 v2, p1

    move-object/from16 v3, p2

    move-object/from16 v4, p3

    move-object v5, v12

    move-object v6, v13

    move-object v10, v7

    move-object v7, v14

    move-object v11, v8

    move-object v8, v15

    invoke-direct/range {v0 .. v8}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda8;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;)V

    const-string v0, "\ube44\uc810\uc720 \uc800\uc7a5"

    invoke-virtual {v11, v0, v10}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v10

    new-instance v11, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda9;

    move-object v0, v11

    invoke-direct/range {v0 .. v8}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda9;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;)V

    .line 1216
    const-string v0, "\uae30\uc874 \uc800\uc7a5"

    invoke-virtual {v10, v0, v11}, Landroid/app/AlertDialog$Builder;->setNeutralButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda10;

    invoke-direct {v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda10;-><init>()V

    .line 1217
    const-string v2, "\ucde8\uc18c"

    invoke-virtual {v0, v2, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object v0

    iput-object v0, v9, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570SaveDialog:Landroid/app/AlertDialog;

    .line 1218
    invoke-virtual {v0}, Landroid/app/AlertDialog;->show()V

    .line 1219
    return-void

    .line 1199
    :cond_107
    :goto_107
    return-void
.end method

.method private r570OpenOrder(Landroid/app/Activity;Landroid/widget/LinearLayout;)V
    .locals 10

    .line 1173
    if-eqz p1, :cond_a8

    invoke-virtual {p1}, Landroid/app/Activity;->isFinishing()Z

    move-result v0

    if-nez v0, :cond_a8

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->actionCapsule:Landroid/widget/LinearLayout;

    if-ne p2, v0, :cond_a8

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    invoke-virtual {v0}, Ljava/util/LinkedHashMap;->size()I

    move-result v0

    const/16 v1, 0x8

    if-eq v0, v1, :cond_18

    goto/16 :goto_a8

    .line 1174
    :cond_18
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570OrderDialog:Landroid/app/AlertDialog;

    if-eqz v0, :cond_25

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570OrderDialog:Landroid/app/AlertDialog;

    invoke-virtual {v0}, Landroid/app/AlertDialog;->isShowing()Z

    move-result v0

    if-eqz v0, :cond_25

    return-void

    .line 1175
    :cond_25
    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570SavedRoles(Landroid/app/Activity;)Ljava/util/ArrayList;

    move-result-object v0

    .line 1176
    const/4 v1, 0x0

    filled-new-array {v1}, [I

    move-result-object v7

    .line 1177
    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v2

    new-array v2, v2, [Ljava/lang/String;

    .line 1178
    move v3, v1

    :goto_35
    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v4

    if-ge v3, v4, :cond_62

    add-int/lit8 v4, v3, 0x1

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/String;

    invoke-static {v5}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570RoleLabel(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v8, ". "

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    aput-object v5, v2, v3

    move v3, v4

    goto :goto_35

    .line 1179
    :cond_62
    new-instance v3, Landroid/app/AlertDialog$Builder;

    invoke-direct {v3, p1}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 1180
    const-string v4, "\uc0ac\uc9c4\ud615 \uc544\uc774\ucf58 \uc21c\uc11c"

    invoke-virtual {v3, v4}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v3

    new-instance v4, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda0;

    invoke-direct {v4, v7}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda0;-><init>([I)V

    .line 1181
    invoke-virtual {v3, v2, v1, v4}, Landroid/app/AlertDialog$Builder;->setSingleChoiceItems([Ljava/lang/CharSequence;ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v8

    new-instance v9, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda1;

    move-object v1, v9

    move-object v2, p0

    move-object v3, p1

    move-object v4, p2

    move-object v5, v0

    move-object v6, v7

    invoke-direct/range {v1 .. v6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda1;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/util/ArrayList;[I)V

    .line 1182
    const-string v1, "\uc67c\ucabd\uc73c\ub85c"

    invoke-virtual {v8, v1, v9}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v8

    new-instance v9, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda2;

    move-object v1, v9

    invoke-direct/range {v1 .. v6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda2;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/util/ArrayList;[I)V

    .line 1183
    const-string p1, "\uc624\ub978\ucabd\uc73c\ub85c"

    invoke-virtual {v8, p1, v9}, Landroid/app/AlertDialog$Builder;->setNeutralButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    new-instance p2, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda3;

    invoke-direct {p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda3;-><init>()V

    .line 1184
    const-string v0, "\ub2eb\uae30"

    invoke-virtual {p1, v0, p2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 1185
    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object p1

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570OrderDialog:Landroid/app/AlertDialog;

    .line 1186
    invoke-virtual {p1}, Landroid/app/AlertDialog;->show()V

    .line 1187
    return-void

    .line 1173
    :cond_a8
    :goto_a8
    return-void
.end method

.method private static r570RoleLabel(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 1167
    invoke-virtual {p0}, Ljava/lang/String;->hashCode()I

    move-result v0

    sparse-switch v0, :sswitch_data_76

    :cond_7
    goto :goto_58

    :sswitch_8
    const-string v0, "favorite"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_7

    const/4 v0, 0x5

    goto :goto_59

    :sswitch_12
    const-string v0, "share"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_7

    const/4 v0, 0x1

    goto :goto_59

    :sswitch_1c
    const-string v0, "naver"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_7

    const/4 v0, 0x2

    goto :goto_59

    :sswitch_26
    const-string v0, "cover"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_7

    const/4 v0, 0x0

    goto :goto_59

    :sswitch_30
    const-string v0, "rail"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_7

    const/4 v0, 0x6

    goto :goto_59

    :sswitch_3a
    const-string v0, "info"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_7

    const/4 v0, 0x3

    goto :goto_59

    :sswitch_44
    const-string v0, "fast"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_7

    const/4 v0, 0x4

    goto :goto_59

    :sswitch_4e
    const-string v0, "expand"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_7

    const/4 v0, 0x7

    goto :goto_59

    :goto_58
    const/4 v0, -0x1

    :goto_59
    packed-switch v0, :pswitch_data_98

    .line 1170
    return-object p0

    :pswitch_5d
    const-string p0, "\uc804\uccb4 \ud654\uba74"

    return-object p0

    :pswitch_60
    const-string p0, "\uc0ac\uc9c4 \ubaa9\ub85d"

    return-object p0

    .line 1169
    :pswitch_63
    const-string p0, "\ub124\uc774\ubc84 \uc800\uc7a5"

    return-object p0

    :pswitch_66
    const-string p0, "\uc5f0\uc18d \ub118\uae30\uae30"

    return-object p0

    .line 1168
    :pswitch_69
    const-string p0, "\ucd2c\uc601 \uc815\ubcf4"

    return-object p0

    :pswitch_6c
    const-string p0, "\ub124\uc774\ubc84 \uc9c0\ub3c4"

    return-object p0

    .line 1167
    :pswitch_6f
    const-string p0, "\uacf5\uc720"

    return-object p0

    :pswitch_72
    const-string p0, "\ub300\ud45c \uc0ac\uc9c4"

    return-object p0

    nop

    :sswitch_data_76
    .sparse-switch
        -0x4cd72166 -> :sswitch_4e
        0x2fd85c -> :sswitch_44
        0x3164ae -> :sswitch_3a
        0x354b92 -> :sswitch_30
        0x5a753b7 -> :sswitch_26
        0x63bf910 -> :sswitch_1c
        0x6854fdf -> :sswitch_12
        0x3ea1c99c -> :sswitch_8
    .end sparse-switch

    :pswitch_data_98
    .packed-switch 0x0
        :pswitch_72
        :pswitch_6f
        :pswitch_6c
        :pswitch_69
        :pswitch_66
        :pswitch_63
        :pswitch_60
        :pswitch_5d
    .end packed-switch
.end method

.method private r570SavedRoles(Landroid/app/Activity;)Ljava/util/ArrayList;
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/app/Activity;",
            ")",
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 1145
    const-string v0, "moa.r570.photo.actions"

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p1

    const-string v0, "order"

    const-string v2, ""

    invoke-interface {p1, v0, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 1146
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 1147
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v2

    if-lez v2, :cond_39

    const-string v2, ","

    invoke-virtual {p1, v2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p1

    array-length v2, p1

    :goto_21
    if-ge v1, v2, :cond_39

    aget-object v3, p1, v1

    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    invoke-virtual {v4, v3}, Ljava/util/LinkedHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_36

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_36

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_36
    add-int/lit8 v1, v1, 0x1

    goto :goto_21

    .line 1149
    :cond_39
    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result p1

    sget-object v1, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->R570_ROLES:[Ljava/lang/String;

    array-length v1, v1

    if-eq p1, v1, :cond_4e

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    sget-object p1, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->R570_ROLES:[Ljava/lang/String;

    invoke-static {p1}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    .line 1150
    :cond_4e
    return-object v0
.end method

.method private r572FinishEntry(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;)V
    .locals 6

    .line 825
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz v0, :cond_cc

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-ne p3, v0, :cond_cc

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    if-eqz v0, :cond_cc

    invoke-static {p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_14

    goto/16 :goto_cc

    .line 831
    :cond_14
    const v0, 0x1020002

    invoke-virtual {p1, v0}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/FrameLayout;

    .line 832
    const-string v1, "stage"

    invoke-static {p3, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    .line 836
    if-eqz v0, :cond_c6

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    invoke-virtual {v2}, Landroid/widget/FrameLayout;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    if-ne v2, v0, :cond_c6

    instance-of v2, v1, Landroid/widget/FrameLayout;

    if-eqz v2, :cond_c6

    check-cast v1, Landroid/widget/FrameLayout;

    .line 838
    invoke-virtual {v1}, Landroid/widget/FrameLayout;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    if-eq v1, v2, :cond_3d

    goto/16 :goto_c6

    .line 841
    :cond_3d
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->actionDeck:Landroid/widget/FrameLayout;

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz v1, :cond_4d

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->actionDeck:Landroid/widget/FrameLayout;

    invoke-virtual {v1}, Landroid/widget/FrameLayout;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eqz v1, :cond_4d

    move v1, v2

    goto :goto_4e

    :cond_4d
    move v1, v3

    .line 842
    :goto_4e
    if-nez v1, :cond_55

    const-string v4, "NATIVE_ACTION_DECK_PENDING"

    invoke-direct {p0, p2, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602Signal(Landroid/webkit/WebView;Ljava/lang/String;)V

    .line 843
    :cond_55
    iget v4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastY:I

    const/high16 v5, -0x80000000

    if-eq v4, v5, :cond_a0

    iget v4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastY:I

    iget v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastH:I

    add-int/2addr v4, v5

    if-lez v4, :cond_a0

    iget v4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastY:I

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->getHeight()I

    move-result v0

    if-ge v4, v0, :cond_a0

    .line 844
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    invoke-virtual {v0, v3}, Landroid/widget/FrameLayout;->setVisibility(I)V

    .line 845
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572NativeMountAck:Z

    if-nez v0, :cond_99

    .line 846
    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572NativeMountAck:Z

    .line 847
    const-string v0, "NATIVE_HOST_MOUNTED_ORIGINAL_STAGE"

    invoke-direct {p0, p2, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602Signal(Landroid/webkit/WebView;Ljava/lang/String;)V

    .line 848
    iget v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownedDayToken:I

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "window.__moaR507NativeMounted&&window.__moaR507NativeMounted(true,"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, ");"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const/4 v2, 0x0

    invoke-virtual {p2, v0, v2}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 850
    :cond_99
    if-eqz v1, :cond_a0

    const-string v0, "NATIVE_8_ACTION_DECK_READY"

    invoke-direct {p0, p2, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602Signal(Landroid/webkit/WebView;Ljava/lang/String;)V

    .line 855
    :cond_a0
    invoke-static {p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p2

    const-string v0, "v"

    invoke-virtual {p2, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p2

    if-nez p2, :cond_bf

    invoke-direct {p0, p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->actualMediaReady(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_bf

    .line 856
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    iget-wide v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FirstPhotoDeadline:J

    cmp-long p2, v0, v2

    if-ltz p2, :cond_bf

    .line 857
    invoke-direct {p0, p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->refreshOriginalMediaIfBlank(Ljava/lang/Object;)V

    .line 858
    :cond_bf
    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r592RestoreOriginalInfoPreference(Landroid/app/Activity;)V

    .line 859
    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594SyncIndicators(Landroid/app/Activity;)V

    .line 860
    return-void

    .line 839
    :cond_c6
    :goto_c6
    const-string p1, "NATIVE_HOST_STAGE_NOT_ATTACHED"

    invoke-direct {p0, p2, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602Signal(Landroid/webkit/WebView;Ljava/lang/String;)V

    return-void

    .line 825
    :cond_cc
    :goto_cc
    return-void
.end method

.method private r572SyncFastSetting(Landroid/app/Activity;)V
    .locals 5

    .line 896
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz v0, :cond_66

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->actionCapsule:Landroid/widget/LinearLayout;

    if-eqz v0, :cond_66

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572NativeMountAck:Z

    if-nez v0, :cond_d

    goto :goto_66

    .line 897
    :cond_d
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    const-string v1, "fast"

    invoke-virtual {v0, v1}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    if-nez v0, :cond_1a

    return-void

    .line 898
    :cond_1a
    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastRestoreDone:Z

    const-string v2, "fast_enabled"

    const-string v3, "moa.r572.photo.fast"

    const/4 v4, 0x0

    if-nez v1, :cond_48

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastRestorePending:Z

    if-eqz v1, :cond_48

    .line 899
    const/4 v1, 0x1

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastRestoreDone:Z

    iput-boolean v4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastRestorePending:Z

    .line 900
    invoke-virtual {p1, v3, v4}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p1

    invoke-interface {p1, v2, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p1

    .line 901
    if-eqz p1, :cond_3f

    invoke-virtual {v0}, Landroid/view/View;->isSelected()Z

    move-result p1

    if-nez p1, :cond_3f

    .line 903
    invoke-virtual {v0}, Landroid/view/View;->performClick()Z

    .line 905
    :cond_3f
    invoke-virtual {v0}, Landroid/view/View;->isSelected()Z

    move-result p1

    iput-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastState:Z

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastSeen:Z

    .line 906
    return-void

    .line 908
    :cond_48
    invoke-virtual {v0}, Landroid/view/View;->isSelected()Z

    move-result v0

    .line 909
    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastSeen:Z

    if-eqz v1, :cond_65

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastState:Z

    if-eq v0, v1, :cond_65

    .line 910
    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FastState:Z

    .line 911
    invoke-virtual {p1, v3, v4}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1, v2, v0}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 913
    :cond_65
    return-void

    .line 896
    :cond_66
    :goto_66
    return-void
.end method

.method private r572SyncRailHeight(Landroid/app/Activity;Ljava/lang/Object;)V
    .locals 1

    .line 915
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz v0, :cond_31

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railView:Landroid/view/View;

    if-eqz v0, :cond_31

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeLower:Landroid/widget/LinearLayout;

    if-eqz v0, :cond_31

    if-nez p2, :cond_f

    goto :goto_31

    .line 916
    :cond_f
    invoke-static {p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p2

    const-string v0, "v"

    invoke-virtual {p2, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p2

    .line 917
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572LastVideoRail:Ljava/lang/Boolean;

    if-eqz v0, :cond_25

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572LastVideoRail:Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-eq v0, p2, :cond_30

    .line 918
    :cond_25
    invoke-static {p2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p2

    iput-object p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572LastVideoRail:Ljava/lang/Boolean;

    .line 919
    iget-boolean p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railExpanded:Z

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->setRailExpanded(Landroid/app/Activity;Z)V

    .line 921
    :cond_30
    return-void

    .line 915
    :cond_31
    :goto_31
    return-void
.end method

.method private r592RestoreOriginalInfoPreference(Landroid/app/Activity;)V
    .locals 3

    .line 865
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r592InfoRestoreDone:Z

    if-nez v0, :cond_30

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-nez v0, :cond_9

    goto :goto_30

    .line 866
    :cond_9
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    const-string v1, "info"

    invoke-virtual {v0, v1}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    if-nez v0, :cond_16

    return-void

    .line 867
    :cond_16
    const-string v1, "moa_r443_gallery_top_info_v1"

    const/4 v2, 0x0

    invoke-virtual {p1, v1, v2}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p1

    .line 868
    const-string v1, "show_on_open"

    invoke-interface {p1, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p1

    .line 869
    invoke-virtual {v0}, Landroid/view/View;->isSelected()Z

    move-result v1

    if-eq v1, p1, :cond_2c

    invoke-virtual {v0}, Landroid/view/View;->performClick()Z

    .line 870
    :cond_2c
    const/4 p1, 0x1

    iput-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r592InfoRestoreDone:Z

    .line 871
    return-void

    .line 865
    :cond_30
    :goto_30
    return-void
.end method

.method private r594SyncIndicators(Landroid/app/Activity;)V
    .locals 5

    .line 886
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r570Actions:Ljava/util/LinkedHashMap;

    const-string v1, "info"

    invoke-virtual {v0, v1}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    if-eqz v0, :cond_5d

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-nez v1, :cond_11

    goto :goto_5d

    .line 887
    :cond_11
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594InfoDotOwner:Landroid/view/View;

    if-eq v1, v0, :cond_3a

    .line 888
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594InfoDotOwner:Landroid/view/View;

    if-eqz v1, :cond_28

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594InfoDot:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$R594InfoDot;

    if-eqz v1, :cond_28

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594InfoDotOwner:Landroid/view/View;

    invoke-virtual {v1}, Landroid/view/View;->getOverlay()Landroid/view/ViewOverlay;

    move-result-object v1

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594InfoDot:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$R594InfoDot;

    invoke-virtual {v1, v2}, Landroid/view/ViewOverlay;->remove(Landroid/graphics/drawable/Drawable;)V

    .line 889
    :cond_28
    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594InfoDotOwner:Landroid/view/View;

    new-instance v1, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$R594InfoDot;

    invoke-direct {v1, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$R594InfoDot;-><init>(Landroid/app/Activity;)V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594InfoDot:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$R594InfoDot;

    invoke-virtual {v0}, Landroid/view/View;->getOverlay()Landroid/view/ViewOverlay;

    move-result-object v1

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594InfoDot:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$R594InfoDot;

    invoke-virtual {v1, v2}, Landroid/view/ViewOverlay;->add(Landroid/graphics/drawable/Drawable;)V

    .line 891
    :cond_3a
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594InfoDot:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$R594InfoDot;

    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v2

    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    move-result v3

    const/4 v4, 0x0

    invoke-virtual {v1, v4, v4, v2, v3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$R594InfoDot;->setBounds(IIII)V

    .line 892
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r594InfoDot:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$R594InfoDot;

    const-string v2, "moa_r443_gallery_top_info_v1"

    invoke-virtual {p1, v2, v4}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p1

    const-string v2, "show_on_open"

    invoke-interface {p1, v2, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p1

    invoke-virtual {v1, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$R594InfoDot;->show(Z)V

    .line 893
    invoke-virtual {v0}, Landroid/view/View;->invalidate()V

    .line 894
    return-void

    .line 886
    :cond_5d
    :goto_5d
    return-void
.end method

.method private r602PollPlaylist(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;)V
    .locals 6

    .line 1406
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz v0, :cond_37

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-ne p3, v0, :cond_37

    invoke-static {p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_37

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602PlaylistPolling:Z

    if-eqz v0, :cond_13

    goto :goto_37

    .line 1407
    :cond_13
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 1408
    iget-wide v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602LastPlaylistPollAt:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x1b8

    cmp-long v2, v2, v4

    if-gez v2, :cond_22

    return-void

    .line 1409
    :cond_22
    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602LastPlaylistPollAt:J

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602PlaylistPolling:Z

    .line 1412
    :try_start_27
    const-string v0, "(function(){var u=window.__moaR602PlaylistUpdate;if(!u||!Array.isArray(u.ids))return \'\';return JSON.stringify(u);})()"

    new-instance v1, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda17;

    invoke-direct {v1, p0, p3, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda17;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Ljava/lang/Object;Landroid/app/Activity;Landroid/webkit/WebView;)V

    invoke-virtual {p2, v0, v1}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V
    :try_end_31
    .catchall {:try_start_27 .. :try_end_31} :catchall_32

    .line 1466
    goto :goto_36

    :catchall_32
    move-exception p1

    const/4 p1, 0x0

    iput-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602PlaylistPolling:Z

    .line 1467
    :goto_36
    return-void

    .line 1406
    :cond_37
    :goto_37
    return-void
.end method

.method private r602Signal(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 6

    .line 209
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 210
    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602LastJavaSignal:Ljava/lang/String;

    invoke-virtual {p2, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_17

    iget-wide v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602LastJavaSignalAt:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x708

    cmp-long v2, v2, v4

    if-gez v2, :cond_17

    return-void

    .line 211
    :cond_17
    iput-object p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602LastJavaSignal:Ljava/lang/String;

    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602LastJavaSignalAt:J

    .line 212
    if-eqz p1, :cond_4f

    :try_start_1d
    invoke-static {p2}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 213
    invoke-static {p2}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "window.__moaR602JavaState="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ";window.__moaR602JavaReport&&window.__moaR602JavaReport("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v0, ");"

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 212
    const/4 v0, 0x0

    invoke-virtual {p1, p2, v0}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V
    :try_end_4c
    .catchall {:try_start_1d .. :try_end_4c} :catchall_4d

    goto :goto_4e

    .line 214
    :catchall_4d
    move-exception p1

    :goto_4e
    nop

    .line 215
    :cond_4f
    return-void
.end method

.method private r611InstallNaverAccessWatcher()V
    .locals 5

    .line 240
    const-string v0, "lastEnabled"

    :try_start_2
    invoke-virtual {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "moa.r611.naver_toggle"

    const/4 v3, 0x0

    invoke-virtual {v1, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 241
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611ReadNaverEnabled()I

    move-result v2

    const/4 v4, -0x1

    invoke-interface {v1, v0, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v4

    .line 242
    iput v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611NaverEnabled:I

    .line 243
    if-ltz v2, :cond_25

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1, v0, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 244
    :cond_25
    if-ltz v2, :cond_2e

    if-ltz v4, :cond_2e

    if-eq v2, v4, :cond_2e

    invoke-direct {p0, v2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611MarkNaverAccessChange(I)V

    .line 245
    :cond_2e
    new-instance v0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$1;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->main:Landroid/os/Handler;

    invoke-direct {v0, p0, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$1;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/os/Handler;)V

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611AccessibilityObserver:Landroid/database/ContentObserver;

    .line 249
    invoke-virtual {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v1, "enabled_accessibility_services"

    .line 250
    invoke-static {v1}, Landroid/provider/Settings$Secure;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611AccessibilityObserver:Landroid/database/ContentObserver;

    .line 249
    invoke-virtual {v0, v1, v3, v2}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;)V
    :try_end_4a
    .catchall {:try_start_2 .. :try_end_4a} :catchall_4b

    .line 254
    goto :goto_6c

    .line 252
    :catchall_4b
    move-exception v0

    .line 253
    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "NAVER_ACCESS_OBSERVER_FAILED_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "MOA_R611"

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 255
    :goto_6c
    return-void
.end method

.method private r611MarkNaverAccessChange(I)V
    .locals 8

    .line 265
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611LastNaverToggleAt:J

    .line 266
    iget v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611NaverToggleSeq:I

    const/4 v1, 0x1

    add-int/2addr v0, v1

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611NaverToggleSeq:I

    const/4 v0, 0x0

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611HealthyCheckSeq:I

    .line 267
    if-ne p1, v1, :cond_14

    const-string p1, "NAVER_ACCESS_ENABLED"

    goto :goto_16

    :cond_14
    const-string p1, "NAVER_ACCESS_DISABLED"

    :goto_16
    const-string v2, "MOA_R611"

    invoke-static {v2, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 268
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    .line 269
    if-eqz p1, :cond_4d

    iget-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz v2, :cond_4d

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-nez v2, :cond_28

    goto :goto_4d

    .line 271
    :cond_28
    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnFromBackground:Z

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->hadMountedOnPause:Z

    .line 272
    iget-wide v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611LastNaverToggleAt:J

    const-wide/16 v3, 0x2cec

    add-long/2addr v1, v3

    iput-wide v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnCloseGuardUntil:J

    .line 273
    iget v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611NaverToggleSeq:I

    .line 274
    const/4 v2, 0x5

    new-array v3, v2, [J

    fill-array-data v3, :array_4e

    :goto_3b
    if-ge v0, v2, :cond_4c

    aget-wide v4, v3, v0

    .line 275
    iget-object v6, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->main:Landroid/os/Handler;

    new-instance v7, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda7;

    invoke-direct {v7, p0, v1, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda7;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;ILandroid/app/Activity;)V

    invoke-virtual {v6, v7, v4, v5}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 274
    add-int/lit8 v0, v0, 0x1

    goto :goto_3b

    .line 281
    :cond_4c
    return-void

    .line 269
    :cond_4d
    :goto_4d
    return-void

    :array_4e
    .array-data 8
        0xc8
        0x28a
        0x5aa
        0xb54
        0x12f2
    .end array-data
.end method

.method private r611OnNaverAccessChange()V
    .locals 4

    .line 257
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611ReadNaverEnabled()I

    move-result v0

    .line 258
    if-ltz v0, :cond_2b

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611NaverEnabled:I

    if-ne v0, v1, :cond_b

    goto :goto_2b

    .line 259
    :cond_b
    iput v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611NaverEnabled:I

    .line 260
    :try_start_d
    invoke-virtual {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "moa.r611.naver_toggle"

    const/4 v3, 0x0

    invoke-virtual {v1, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 261
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "lastEnabled"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_25
    .catchall {:try_start_d .. :try_end_25} :catchall_26

    goto :goto_27

    :catchall_26
    move-exception v1

    .line 262
    :goto_27
    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611MarkNaverAccessChange(I)V

    .line 263
    return-void

    .line 258
    :cond_2b
    :goto_2b
    return-void
.end method

.method private r611ReadNaverEnabled()I
    .locals 6

    .line 229
    :try_start_0
    invoke-virtual {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v1, "enabled_accessibility_services"

    invoke-static {v0, v1}, Landroid/provider/Settings$Secure;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 231
    const/4 v1, 0x0

    if-eqz v0, :cond_3a

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_1c

    goto :goto_3a

    .line 232
    :cond_1c
    const-string v2, ":"

    invoke-virtual {v0, v2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    array-length v2, v0

    move v3, v1

    :goto_24
    if-ge v3, v2, :cond_39

    aget-object v4, v0, v3

    .line 233
    invoke-virtual {v4}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    const-string v5, "/com.juhyeon.familyjourney.NaverSaveService"

    invoke-virtual {v4, v5}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v4
    :try_end_32
    .catchall {:try_start_0 .. :try_end_32} :catchall_3b

    if-eqz v4, :cond_36

    const/4 v0, 0x1

    return v0

    .line 232
    :cond_36
    add-int/lit8 v3, v3, 0x1

    goto :goto_24

    .line 235
    :cond_39
    return v1

    .line 231
    :cond_3a
    :goto_3a
    return v1

    .line 236
    :catchall_3b
    move-exception v0

    const/4 v0, -0x1

    return v0
.end method

.method private r611RecheckAfterNaverAccess(Landroid/app/Activity;I)V
    .locals 5

    .line 283
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->resumed:Z

    if-eqz v0, :cond_7a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    if-ne v0, p1, :cond_7a

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foregroundEpoch:I

    if-ne p2, v0, :cond_7a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    if-ne v0, p1, :cond_7a

    .line 284
    invoke-virtual {p1}, Landroid/app/Activity;->hasWindowFocus()Z

    move-result v0

    if-eqz v0, :cond_7a

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeOpen:Z

    if-eqz v0, :cond_1b

    goto :goto_7a

    .line 285
    :cond_1b
    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->findWeb(Landroid/app/Activity;)Landroid/webkit/WebView;

    move-result-object v0

    invoke-static {v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->isTrustedWeb(Landroid/webkit/WebView;)Z

    move-result v1

    if-nez v1, :cond_26

    return-void

    .line 286
    :cond_26
    const-string v1, "unifiedGallery"

    invoke-static {p1, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    .line 287
    const v2, 0x1020002

    invoke-virtual {p1, v2}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/FrameLayout;

    .line 288
    invoke-static {v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result v3

    const/4 v4, 0x1

    if-eqz v3, :cond_58

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-ne v1, v3, :cond_58

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    if-eqz v3, :cond_58

    .line 289
    const-string v3, "host"

    invoke-static {v1, v3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    if-ne v1, v3, :cond_58

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    invoke-virtual {v1}, Landroid/widget/FrameLayout;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-ne v1, v2, :cond_58

    move v1, v4

    goto :goto_59

    :cond_58
    const/4 v1, 0x0

    .line 292
    :goto_59
    if-eqz v1, :cond_62

    iget v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611HealthyCheckSeq:I

    iget v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611NaverToggleSeq:I

    if-ne v2, v3, :cond_62

    return-void

    .line 293
    :cond_62
    if-eqz v1, :cond_68

    iget v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611NaverToggleSeq:I

    iput v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611HealthyCheckSeq:I

    .line 294
    :cond_68
    if-eqz v1, :cond_6d

    const-string v1, "NAVER_ACCESS_ORIGINAL_HOST_LIVE"

    goto :goto_6f

    :cond_6d
    const-string v1, "NAVER_ACCESS_ORIGINAL_HOST_LOST"

    :goto_6f
    invoke-direct {p0, v0, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602Signal(Landroid/webkit/WebView;Ljava/lang/String;)V

    .line 295
    iput-boolean v4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnFromBackground:Z

    iput-boolean v4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->hadMountedOnPause:Z

    .line 296
    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->rebindAfterReturn(Landroid/app/Activity;I)V

    .line 297
    return-void

    .line 284
    :cond_7a
    :goto_7a
    return-void
.end method

.method private r657BeginEval(Landroid/webkit/WebView;Ljava/lang/String;)I
    .locals 11

    .line 85
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 86
    iget-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->processing:Z

    const-string v3, "MOA_R657"

    const/4 v4, 0x1

    if-eqz v2, :cond_57

    .line 87
    iget-wide v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalStartedAt:J

    const-wide/16 v7, 0x0

    cmp-long v2, v5, v7

    if-lez v2, :cond_55

    iget-wide v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalStartedAt:J

    sub-long v5, v0, v5

    const-wide/16 v9, 0xdac

    cmp-long v2, v5, v9

    if-ltz v2, :cond_55

    .line 90
    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalKind:Ljava/lang/String;

    iget-wide v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalStartedAt:J

    sub-long v5, v0, v5

    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    const-string v10, "EVAL_STALE_UNLOCK kind="

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v9, " age="

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v3, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 92
    const/4 v2, 0x0

    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->processing:Z

    .line 93
    iget v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalGeneration:I

    add-int/2addr v2, v4

    iput v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalGeneration:I

    .line 94
    iput-wide v7, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalStartedAt:J

    const-string v2, "idle"

    iput-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalKind:Ljava/lang/String;

    const/4 v2, 0x0

    iput-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalWeb:Landroid/webkit/WebView;

    goto :goto_57

    .line 95
    :cond_55
    const/4 p1, -0x1

    return p1

    .line 97
    :cond_57
    :goto_57
    iput-boolean v4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->processing:Z

    .line 98
    iget v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalGeneration:I

    add-int/2addr v2, v4

    iput v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalGeneration:I

    .line 99
    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalStartedAt:J

    iput-object p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalKind:Ljava/lang/String;

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalWeb:Landroid/webkit/WebView;

    .line 100
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "EVAL_SET kind="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, " token="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v3, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 101
    return v2
.end method

.method private r657EndEval(ILjava/lang/String;)Z
    .locals 5

    .line 104
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->processing:Z

    const/4 v1, 0x0

    const-string v2, " token="

    const-string v3, "MOA_R657"

    if-eqz v0, :cond_3b

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalGeneration:I

    if-eq p1, v0, :cond_e

    goto :goto_3b

    .line 108
    :cond_e
    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->processing:Z

    .line 109
    const-wide/16 v0, 0x0

    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalStartedAt:J

    const-string v0, "idle"

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalKind:Ljava/lang/String;

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EvalWeb:Landroid/webkit/WebView;

    .line 110
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "EVAL_CLEAR kind="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v3, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 111
    const/4 p1, 0x1

    return p1

    .line 105
    :cond_3b
    :goto_3b
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "EVAL_LATE_IGNORED kind="

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v3, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 106
    return v1
.end method

.method private static readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    .locals 2

    .line 345
    const/4 v0, 0x0

    if-nez p0, :cond_4

    return-object v0

    .line 346
    :cond_4
    :try_start_4
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-static {v1, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->field(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object p1

    if-nez p1, :cond_f

    goto :goto_13

    :cond_f
    invoke-virtual {p1, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0
    :try_end_13
    .catchall {:try_start_4 .. :try_end_13} :catchall_14

    :goto_13
    return-object v0

    .line 347
    :catchall_14
    move-exception p0

    return-object v0
.end method

.method private rebindAfterReturn(Landroid/app/Activity;I)V
    .locals 9

    .line 1558
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->resumed:Z

    if-eqz v0, :cond_bd

    if-eqz p1, :cond_bd

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    if-ne v0, p1, :cond_bd

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foregroundEpoch:I

    if-ne p2, v0, :cond_bd

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnFromBackground:Z

    if-eqz v0, :cond_bd

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeOpen:Z

    if-nez v0, :cond_bd

    .line 1559
    invoke-virtual {p1}, Landroid/app/Activity;->isFinishing()Z

    move-result v0

    if-nez v0, :cond_bd

    invoke-virtual {p1}, Landroid/app/Activity;->isDestroyed()Z

    move-result v0

    if-nez v0, :cond_bd

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    if-eq v0, p1, :cond_28

    goto/16 :goto_bd

    .line 1561
    :cond_28
    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->findWeb(Landroid/app/Activity;)Landroid/webkit/WebView;

    move-result-object v0

    if-eqz v0, :cond_bc

    invoke-static {v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->isTrustedWeb(Landroid/webkit/WebView;)Z

    move-result v1

    if-nez v1, :cond_36

    goto/16 :goto_bc

    .line 1562
    :cond_36
    const-string v1, "unifiedGallery"

    invoke-static {p1, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v5

    .line 1563
    const v1, 0x1020002

    invoke-virtual {p1, v1}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/FrameLayout;

    .line 1564
    const-string v2, "host"

    invoke-static {v5, v2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    .line 1565
    invoke-static {v5}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_67

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-ne v5, v3, :cond_67

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    if-ne v2, v3, :cond_67

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    if-eqz v2, :cond_67

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    .line 1566
    invoke-virtual {v2}, Landroid/widget/FrameLayout;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    if-ne v2, v1, :cond_67

    const/4 v1, 0x1

    goto :goto_68

    :cond_67
    const/4 v1, 0x0

    .line 1567
    :goto_68
    if-eqz v1, :cond_a0

    .line 1575
    const-string v1, "currentDay"

    invoke-static {v5, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    invoke-static {v1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    .line 1576
    nop

    .line 1577
    invoke-static {v1}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "(function(){try{var ok=window.__moaR567RestoreLiveCard&&window.__moaR567RestoreLiveCard("

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ");return ok?(window.__moaR527DayToken||0):0}catch(e){return 0}})()"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    new-instance v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda15;

    move-object v1, v8

    move-object v2, p0

    move-object v3, p1

    move v4, p2

    move-object v6, v0

    invoke-direct/range {v1 .. v6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda15;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;ILjava/lang/Object;Landroid/webkit/WebView;)V

    .line 1576
    invoke-virtual {v0, v7, v8}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 1598
    return-void

    .line 1600
    :cond_a0
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v1

    .line 1601
    iget-wide v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastRebindAt:J

    sub-long/2addr v1, v3

    const-wide/16 v3, 0xa28

    cmp-long v1, v1, v3

    if-gez v1, :cond_ae

    return-void

    .line 1610
    :cond_ae
    :try_start_ae
    const-string v1, "(function(){try{var d=window.MoaR469SimpleDiary,s=d&&d.readOnlyStatus&&d.readOnlyStatus();return JSON.stringify({day:!!(s&&s.active&&s.page===\'day\'),date:String(s&&s.date||\'\'),token:window.__moaR527DayToken||0,full:!!(window.__moaR539AdvancedActive&&window.__moaR539AdvancedActive())});}catch(e){return \'{}\'}})()"

    new-instance v2, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda16;

    invoke-direct {v2, p0, p1, p2, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda16;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;ILandroid/webkit/WebView;)V

    invoke-virtual {v0, v1, v2}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V
    :try_end_b8
    .catchall {:try_start_ae .. :try_end_b8} :catchall_b9

    goto :goto_ba

    .line 1657
    :catchall_b9
    move-exception p1

    :goto_ba
    nop

    .line 1658
    return-void

    .line 1561
    :cond_bc
    :goto_bc
    return-void

    .line 1560
    :cond_bd
    :goto_bd
    return-void
.end method

.method private refreshOriginalMediaIfBlank(Ljava/lang/Object;)V
    .locals 10

    .line 1508
    const-string v0, "MOA_R563"

    invoke-static {p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_98

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->actualMediaReady(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_10

    goto/16 :goto_98

    .line 1509
    :cond_10
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v1

    .line 1510
    iget-wide v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastMediaRefreshAt:J

    sub-long v3, v1, v3

    const-wide/16 v5, 0x708

    cmp-long v3, v3, v5

    if-gez v3, :cond_1f

    return-void

    .line 1511
    :cond_1f
    iput-wide v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastMediaRefreshAt:J

    .line 1512
    invoke-static {p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v9

    .line 1513
    const-string v1, "v"

    invoke-virtual {v9, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_41

    .line 1519
    iget v8, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownedDayToken:I

    .line 1520
    iget-object v7, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    .line 1521
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->main:Landroid/os/Handler;

    new-instance v1, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda18;

    move-object v4, v1

    move-object v5, p0

    move-object v6, p1

    invoke-direct/range {v4 .. v9}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda18;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Ljava/lang/Object;Landroid/widget/FrameLayout;ILjava/lang/String;)V

    const-wide/16 v2, 0x334

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 1547
    return-void

    .line 1550
    :cond_41
    :try_start_41
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    const-string v2, "refreshPages"

    const/4 v3, 0x0

    new-array v4, v3, [Ljava/lang/Class;

    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    .line 1551
    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    new-array v2, v3, [Ljava/lang/Object;

    invoke-virtual {v1, p1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1552
    const-string v1, "index"

    invoke-static {p1, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "ORIGINAL_PHOTO_PAGE_REFRESH index="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_77
    .catchall {:try_start_41 .. :try_end_77} :catchall_78

    .line 1555
    goto :goto_97

    .line 1553
    :catchall_78
    move-exception p1

    .line 1554
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p1

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "ORIGINAL_PHOTO_PAGE_REFRESH_FAILED_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 1556
    :goto_97
    return-void

    .line 1508
    :cond_98
    :goto_98
    return-void
.end method

.method private retireDayBackIfInactive(Landroid/app/Activity;Landroid/webkit/WebView;)V
    .locals 2

    .line 730
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inlineBack:Landroid/window/OnBackInvokedCallback;

    if-eqz v0, :cond_19

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->backOwner:Landroid/app/Activity;

    if-ne v0, p1, :cond_19

    if-nez p2, :cond_b

    goto :goto_19

    .line 731
    :cond_b
    :try_start_b
    const-string v0, "(function(){var d=window.MoaR469SimpleDiary,s=d&&d.readOnlyStatus&&d.readOnlyStatus();return !!(s&&s.active&&s.page===\'day\'&&!window.__moaR539AdvancedActive?.());})()"

    new-instance v1, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda27;

    invoke-direct {v1, p0, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda27;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;)V

    invoke-virtual {p2, v0, v1}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V
    :try_end_15
    .catchall {:try_start_b .. :try_end_15} :catchall_16

    goto :goto_17

    .line 734
    :catchall_16
    move-exception p1

    :goto_17
    nop

    .line 735
    return-void

    .line 730
    :cond_19
    :goto_19
    return-void
.end method

.method private static rounded(D)I
    .locals 0

    .line 736
    invoke-static {p0, p1}, Ljava/lang/Math;->round(D)J

    move-result-wide p0

    long-to-int p0, p0

    return p0
.end method

.method private setRailExpanded(Landroid/app/Activity;Z)V
    .locals 4

    .line 1325
    iput-boolean p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railExpanded:Z

    .line 1326
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railView:Landroid/view/View;

    const/4 v1, 0x0

    if-eqz v0, :cond_12

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railView:Landroid/view/View;

    if-eqz p2, :cond_d

    move v2, v1

    goto :goto_f

    :cond_d
    const/16 v2, 0x8

    :goto_f
    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    .line 1327
    :cond_12
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeLower:Landroid/widget/LinearLayout;

    if-eqz v0, :cond_57

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeLower:Landroid/widget/LinearLayout;

    invoke-virtual {v0}, Landroid/widget/LinearLayout;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    instance-of v0, v0, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz v0, :cond_57

    .line 1328
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeLower:Landroid/widget/LinearLayout;

    invoke-virtual {v0}, Landroid/widget/LinearLayout;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/widget/FrameLayout$LayoutParams;

    .line 1332
    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-eqz v2, :cond_3b

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    invoke-static {v2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    const-string v3, "v"

    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_3b

    const/4 v1, 0x1

    .line 1333
    :cond_3b
    if-eqz p2, :cond_45

    if-eqz v1, :cond_42

    const/16 v1, 0x89

    goto :goto_47

    :cond_42
    const/16 v1, 0x70

    goto :goto_47

    :cond_45
    const/16 v1, 0x52

    :goto_47
    int-to-float v1, v1

    invoke-static {p1, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dp(Landroid/app/Activity;F)I

    move-result p1

    .line 1334
    iget v1, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    if-eq v1, p1, :cond_57

    iput p1, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeLower:Landroid/widget/LinearLayout;

    invoke-virtual {p1, v0}, Landroid/widget/LinearLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 1336
    :cond_57
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railToggle:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    if-eqz p1, :cond_71

    .line 1337
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railToggle:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->invalidate()V

    .line 1338
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railToggle:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    if-eqz p2, :cond_67

    const-string v0, "\uc0ac\uc9c4 \ubaa9\ub85d \uc811\uae30"

    goto :goto_69

    :cond_67
    const-string v0, "\uc0ac\uc9c4 \ubaa9\ub85d \ud3bc\uce58\uae30"

    :goto_69
    invoke-virtual {p1, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 1340
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->railToggle:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {p1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setSelected(Z)V

    .line 1342
    :cond_71
    return-void
.end method

.method private stopMonitoringNativeHost()V
    .locals 2

    .line 644
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->monitoredHost:Landroid/widget/FrameLayout;

    if-eqz v0, :cond_12

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->monitoredHostListener:Landroid/view/View$OnAttachStateChangeListener;

    if-eqz v0, :cond_12

    .line 645
    :try_start_8
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->monitoredHost:Landroid/widget/FrameLayout;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->monitoredHostListener:Landroid/view/View$OnAttachStateChangeListener;

    invoke-virtual {v0, v1}, Landroid/widget/FrameLayout;->removeOnAttachStateChangeListener(Landroid/view/View$OnAttachStateChangeListener;)V
    :try_end_f
    .catchall {:try_start_8 .. :try_end_f} :catchall_10

    goto :goto_11

    .line 646
    :catchall_10
    move-exception v0

    :goto_11
    nop

    .line 647
    :cond_12
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->monitoredHost:Landroid/widget/FrameLayout;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->monitoredHostListener:Landroid/view/View$OnAttachStateChangeListener;

    .line 648
    return-void
.end method

.method private syncAdvancedButton(Ljava/lang/Object;)V
    .locals 1

    .line 1114
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->advancedButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    if-eqz p1, :cond_12

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->advancedButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->getVisibility()I

    move-result p1

    if-eqz p1, :cond_12

    .line 1115
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->advancedButton:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setVisibility(I)V

    .line 1116
    :cond_12
    return-void
.end method

.method private syncIndex(Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;)V
    .locals 2

    .line 1470
    const-string v0, "index"

    invoke-static {p2, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .line 1471
    instance-of v1, v0, Ljava/lang/Integer;

    if-nez v1, :cond_b

    return-void

    .line 1472
    :cond_b
    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 1473
    invoke-static {p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p2

    .line 1474
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->coverStar:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    if-eqz v1, :cond_27

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->coverStar:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {p2, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    invoke-virtual {v1, p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->setSelected(Z)V

    iget-object p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->coverStar:Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;

    invoke-virtual {p2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$UnifiedGlyph;->invalidate()V

    .line 1475
    :cond_27
    iget p2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastIndex:I

    if-eq v0, p2, :cond_4a

    .line 1476
    iput v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastIndex:I

    .line 1477
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "window.__moaR507NativeSelected&&window.__moaR507NativeSelected("

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string p3, ");"

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    const/4 p3, 0x0

    invoke-virtual {p1, p2, p3}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 1479
    :cond_4a
    return-void
.end method

.method private tick()V
    .locals 13

    .line 440
    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    .line 441
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->resumed:Z

    if-eqz v0, :cond_1c7

    if-eqz v3, :cond_1c7

    invoke-virtual {v3}, Landroid/app/Activity;->isFinishing()Z

    move-result v0

    if-nez v0, :cond_1c7

    invoke-virtual {v3}, Landroid/app/Activity;->isDestroyed()Z

    move-result v0

    if-eqz v0, :cond_16

    goto/16 :goto_1c7

    .line 445
    :cond_16
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz v0, :cond_23

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    if-eqz v0, :cond_23

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    if-eq v3, v0, :cond_23

    return-void

    .line 446
    :cond_23
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeOpen:Z

    if-eqz v0, :cond_30

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullscreenOwnerActivity:Landroid/app/Activity;

    if-eqz v0, :cond_30

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullscreenOwnerActivity:Landroid/app/Activity;

    if-eq v3, v0, :cond_30

    return-void

    .line 447
    :cond_30
    invoke-direct {p0, v3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->findWeb(Landroid/app/Activity;)Landroid/webkit/WebView;

    move-result-object v6

    if-nez v6, :cond_37

    return-void

    .line 448
    :cond_37
    const-string v0, "unifiedGallery"

    invoke-static {v3, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v4

    .line 451
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeOpen:Z

    const-string v1, ""

    const/4 v2, 0x0

    const/4 v5, 0x0

    if-eqz v0, :cond_ba

    .line 452
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v7

    .line 453
    invoke-static {v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_71

    .line 454
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeSeenOpen:Z

    .line 455
    const-string v0, "index"

    invoke-static {v4, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .line 456
    instance-of v1, v0, Ljava/lang/Integer;

    if-eqz v1, :cond_64

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeLastIndex:I

    .line 457
    :cond_64
    invoke-static {v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_7f

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeLastId:Ljava/lang/String;

    goto :goto_7f

    .line 458
    :cond_71
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeSeenOpen:Z

    if-nez v0, :cond_80

    iget-wide v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeStartedAt:J

    sub-long/2addr v7, v3

    const-wide/16 v3, 0xb54

    cmp-long v0, v7, v3

    if-lez v0, :cond_7f

    goto :goto_80

    :cond_7f
    :goto_7f
    goto :goto_b9

    .line 459
    :cond_80
    :goto_80
    iget v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeLastIndex:I

    .line 460
    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeLastId:Ljava/lang/String;

    invoke-static {v3}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 461
    iput-boolean v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeOpen:Z

    iput-boolean v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeSeenOpen:Z

    iput-object v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullscreenOwnerActivity:Landroid/app/Activity;

    .line 462
    const/4 v4, -0x1

    iput v4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeLastIndex:I

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeLastId:Ljava/lang/String;

    .line 464
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "window.__moaR539AdvancedSelection&&window.__moaR539AdvancedSelection("

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ","

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ");window.__moaR531AdvancedClosed&&window.__moaR531AdvancedClosed();"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v6, v0, v2}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 467
    :goto_b9
    return-void

    .line 469
    :cond_ba
    invoke-static {v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result v0

    const-wide/16 v7, 0x0

    if-nez v0, :cond_14d

    .line 474
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v9

    .line 475
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz v0, :cond_e3

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeOpen:Z

    if-nez v0, :cond_e3

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnFromBackground:Z

    if-nez v0, :cond_e2

    iget-wide v11, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnCloseGuardUntil:J

    cmp-long v0, v9, v11

    if-ltz v0, :cond_e2

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    if-ne v0, v3, :cond_e2

    .line 477
    invoke-virtual {v3}, Landroid/app/Activity;->hasWindowFocus()Z

    move-result v0

    if-nez v0, :cond_e3

    :cond_e2
    return-void

    .line 478
    :cond_e3
    invoke-direct {p0, v6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ensurePositionChannel(Landroid/webkit/WebView;)V

    .line 479
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-nez v0, :cond_ed

    invoke-direct {p0, v3, v6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->retireDayBackIfInactive(Landroid/app/Activity;Landroid/webkit/WebView;)V

    .line 480
    :cond_ed
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz v0, :cond_138

    .line 481
    iget-wide v11, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeCloseDetectedAt:J

    cmp-long v0, v11, v7

    if-nez v0, :cond_fa

    iput-wide v9, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeCloseDetectedAt:J

    return-void

    .line 482
    :cond_fa
    iget-wide v7, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeCloseDetectedAt:J

    sub-long/2addr v9, v7

    const-wide/16 v7, 0xb4

    cmp-long v0, v9, v7

    if-gez v0, :cond_104

    return-void

    .line 483
    :cond_104
    nop

    .line 484
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    .line 485
    const-string v2, "currentDay"

    invoke-static {v4, v2}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    .line 488
    iget-boolean v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->resumed:Z

    if-eqz v5, :cond_137

    iget-object v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    if-ne v5, v3, :cond_137

    invoke-virtual {v3}, Landroid/app/Activity;->hasWindowFocus()Z

    move-result v5

    if-eqz v5, :cond_137

    iget-object v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-ne v5, v0, :cond_137

    .line 489
    invoke-static {v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_137

    .line 490
    nop

    .line 491
    const-string v4, "null"

    invoke-virtual {v4, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_133

    goto :goto_134

    :cond_133
    move-object v1, v2

    .line 490
    :goto_134
    invoke-direct {p0, v3, v6, v0, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->exitForegroundClosedGallery(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;Ljava/lang/String;)V

    .line 493
    :cond_137
    return-void

    .line 495
    :cond_138
    iget-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastHello:J

    sub-long v0, v9, v0

    const-wide/16 v4, 0x3e8

    cmp-long v0, v0, v4

    if-lez v0, :cond_149

    .line 496
    iput-wide v9, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastHello:J

    .line 497
    const-string v0, "window.__moaR507BridgeReady=true;"

    invoke-virtual {v6, v0, v2}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 499
    :cond_149
    invoke-direct {p0, v3, v6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->maybeArm(Landroid/app/Activity;Landroid/webkit/WebView;)V

    .line 500
    return-void

    .line 502
    :cond_14d
    iput-wide v7, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeCloseDetectedAt:J

    .line 503
    const-string v0, "NATIVE_GALLERY_OPEN_OBSERVED"

    invoke-direct {p0, v6, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602Signal(Landroid/webkit/WebView;Ljava/lang/String;)V

    .line 504
    invoke-direct {p0, v6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ensurePositionChannel(Landroid/webkit/WebView;)V

    .line 508
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-nez v0, :cond_166

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->inlineArmed:Z

    if-nez v0, :cond_166

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->processing:Z

    if-nez v0, :cond_166

    invoke-direct {p0, v3, v6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->maybeArm(Landroid/app/Activity;Landroid/webkit/WebView;)V

    .line 512
    :cond_166
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz v0, :cond_18f

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-ne v4, v0, :cond_18f

    .line 513
    invoke-direct {p0, v3, v6, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r602PollPlaylist(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;)V

    .line 514
    invoke-direct {p0, v3, v6, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572FinishEntry(Landroid/app/Activity;Landroid/webkit/WebView;Ljava/lang/Object;)V

    .line 515
    invoke-direct {p0, v3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572SyncFastSetting(Landroid/app/Activity;)V

    .line 516
    invoke-direct {p0, v3, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r572SyncRailHeight(Landroid/app/Activity;Ljava/lang/Object;)V

    .line 517
    invoke-static {v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->currentId(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    .line 518
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastFillId:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_18f

    .line 519
    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastFillId:Ljava/lang/String;

    iput v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fillPrepareAttempts:I

    iput-wide v7, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastFillAt:J

    .line 520
    invoke-direct {p0, v3, v4, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->updateAmbientForSelection(Landroid/app/Activity;Ljava/lang/Object;Ljava/lang/String;)V

    .line 525
    :cond_18f
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionWeb:Landroid/webkit/WebView;

    if-ne v0, v6, :cond_1a9

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->positionPort:Landroid/webkit/WebMessagePort;

    if-eqz v0, :cond_1a9

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz v0, :cond_1a9

    .line 526
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    iget-wide v7, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastPositionMessageAt:J

    sub-long/2addr v0, v7

    const-wide/16 v7, 0x226

    cmp-long v0, v0, v7

    if-gez v0, :cond_1a9

    return-void

    .line 527
    :cond_1a9
    const-string v7, "SNAPSHOT"

    invoke-direct {p0, v6, v7}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657BeginEval(Landroid/webkit/WebView;Ljava/lang/String;)I

    move-result v8

    .line 528
    if-gez v8, :cond_1b2

    return-void

    .line 529
    :cond_1b2
    nop

    .line 530
    :try_start_1b3
    const-string v9, "(function(){try{var d=window.MoaR469SimpleDiary,s=d&&d.readOnlyStatus&&d.readOnlyStatus();var e=document.querySelector(\'#moa-r469-root .moa-r469-stage\');if(!s||!s.active||s.page!==\'day\'||!(window.__moaR507NativePending===true||window.__moaR511InlineArm===true)||!e) return JSON.stringify({active:false});var r=e.getBoundingClientRect();return JSON.stringify({active:true,x:r.left,y:r.top,w:r.width,h:r.height,vw:innerWidth,vh:innerHeight,cover:(window.__moaR507CoverId||\'\'),token:(window.__moaR527DayToken||0)});}catch(e){return JSON.stringify({active:false});}})()"

    new-instance v10, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda22;

    move-object v0, v10

    move-object v1, p0

    move v2, v8

    move-object v5, v6

    invoke-direct/range {v0 .. v5}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda22;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;ILandroid/app/Activity;Ljava/lang/Object;Landroid/webkit/WebView;)V

    invoke-virtual {v6, v9, v10}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V
    :try_end_1c1
    .catchall {:try_start_1b3 .. :try_end_1c1} :catchall_1c2

    .line 569
    goto :goto_1c6

    :catchall_1c2
    move-exception v0

    invoke-direct {p0, v8, v7}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r657EndEval(ILjava/lang/String;)Z

    .line 570
    :goto_1c6
    return-void

    .line 441
    :cond_1c7
    :goto_1c7
    return-void
.end method

.method private updateAmbientForSelection(Landroid/app/Activity;Ljava/lang/Object;Ljava/lang/String;)V
    .locals 1

    .line 1347
    const-string v0, "texture"

    invoke-static {p2, v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p2

    .line 1348
    instance-of v0, p2, Landroid/view/TextureView;

    if-eqz v0, :cond_10

    check-cast p2, Landroid/view/TextureView;

    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->updateVideoAmbient(Landroid/app/Activity;Landroid/view/TextureView;Ljava/lang/String;)V

    goto :goto_1b

    .line 1349
    :cond_10
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    if-eqz p1, :cond_1b

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    const/16 p2, 0x8

    invoke-virtual {p1, p2}, Landroid/widget/ImageView;->setVisibility(I)V

    .line 1350
    :cond_1b
    :goto_1b
    return-void
.end method

.method private updateVideoAmbient(Landroid/app/Activity;Landroid/view/TextureView;Ljava/lang/String;)V
    .locals 6

    .line 1368
    const-string v0, "v"

    invoke-virtual {p3, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_94

    invoke-virtual {p3, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v0

    const-string v2, "[0-9]{1,18}"

    invoke-virtual {v0, v2}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_17

    goto/16 :goto_94

    .line 1372
    :cond_17
    invoke-virtual {p2}, Landroid/view/TextureView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    const/4 v2, 0x0

    if-eqz v0, :cond_27

    invoke-virtual {p2}, Landroid/view/TextureView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    goto :goto_28

    :cond_27
    move-object v0, v2

    .line 1373
    :goto_28
    instance-of v3, v0, Landroid/widget/FrameLayout;

    if-nez v3, :cond_2d

    return-void

    .line 1374
    :cond_2d
    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    const/4 v4, 0x0

    if-eqz v3, :cond_36

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientParent:Landroid/view/ViewGroup;

    if-eq v3, v0, :cond_76

    .line 1375
    :cond_36
    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    if-eqz v3, :cond_51

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    invoke-virtual {v3}, Landroid/widget/ImageView;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    instance-of v3, v3, Landroid/view/ViewGroup;

    if-eqz v3, :cond_51

    .line 1376
    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    invoke-virtual {v3}, Landroid/widget/ImageView;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    check-cast v3, Landroid/view/ViewGroup;

    iget-object v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    invoke-virtual {v3, v5}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 1377
    :cond_51
    new-instance v3, Landroid/widget/ImageView;

    invoke-direct {v3, p1}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    sget-object p1, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {v3, p1}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    .line 1378
    const/high16 p1, -0x1000000

    invoke-virtual {v3, p1}, Landroid/widget/ImageView;->setBackgroundColor(I)V

    const/high16 p1, 0x3f800000    # 1.0f

    invoke-virtual {v3, p1}, Landroid/widget/ImageView;->setAlpha(F)V

    .line 1381
    new-instance p1, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v5, -0x1

    invoke-direct {p1, v5, v5}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v3, v4, p1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)V

    .line 1382
    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientParent:Landroid/view/ViewGroup;

    const-string p1, ""

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientMediaId:Ljava/lang/String;

    .line 1384
    :cond_76
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    invoke-virtual {p1, v4}, Landroid/widget/ImageView;->setVisibility(I)V

    invoke-virtual {p2, v1}, Landroid/view/TextureView;->setOpaque(Z)V

    .line 1385
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientMediaId:Ljava/lang/String;

    invoke-virtual {p3, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_87

    return-void

    .line 1386
    :cond_87
    iput-object p3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientMediaId:Ljava/lang/String;

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    invoke-virtual {p1, v2}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 1387
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    .line 1391
    invoke-virtual {p1, v2}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 1392
    return-void

    .line 1369
    :cond_94
    :goto_94
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    if-eqz p1, :cond_9f

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ambientPoster:Landroid/widget/ImageView;

    const/16 p3, 0x8

    invoke-virtual {p1, p3}, Landroid/widget/ImageView;->setVisibility(I)V

    .line 1370
    :cond_9f
    invoke-virtual {p2, v1}, Landroid/view/TextureView;->setOpaque(Z)V

    return-void
.end method


# virtual methods
.method public delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 0

    .line 1776
    const/4 p1, 0x0

    return p1
.end method

.method public getType(Landroid/net/Uri;)Ljava/lang/String;
    .locals 0

    .line 1774
    const/4 p1, 0x0

    return-object p1
.end method

.method public insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;
    .locals 0

    .line 1775
    const/4 p1, 0x0

    return-object p1
.end method

.method public onActivityCreated(Landroid/app/Activity;Landroid/os/Bundle;)V
    .locals 0

    .line 1769
    return-void
.end method

.method public onActivityDestroyed(Landroid/app/Activity;)V
    .locals 3

    .line 1759
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    const/4 v1, 0x0

    const/4 v2, 0x0

    if-ne v0, p1, :cond_a

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->resumed:Z

    .line 1760
    :cond_a
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    if-eq v0, p1, :cond_1a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullscreenOwnerActivity:Landroid/app/Activity;

    if-eq v0, p1, :cond_1a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->prePausedOwnerActivity:Landroid/app/Activity;

    if-eq v0, p1, :cond_1a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->backOwner:Landroid/app/Activity;

    if-ne v0, p1, :cond_35

    .line 1761
    :cond_1a
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->dropDayBack()V

    .line 1762
    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->prePausedRetainedGallery:Ljava/lang/Object;

    .line 1763
    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->prePausedOwnerActivity:Landroid/app/Activity;

    .line 1764
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->closePositionPort()V

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->clearCardMark()V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullscreenOwnerActivity:Landroid/app/Activity;

    .line 1765
    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnFromBackground:Z

    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->hadMountedOnPause:Z

    .line 1766
    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lifecyclePauseInProgress:Z

    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->controlledRebuildInProgress:Z

    const-string p1, ""

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownerDayAtPause:Ljava/lang/String;

    .line 1768
    :cond_35
    return-void
.end method

.method public onActivityPaused(Landroid/app/Activity;)V
    .locals 3

    .line 1751
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-ne v0, p1, :cond_d

    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->resumed:Z

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foregroundEpoch:I

    add-int/2addr v0, v1

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foregroundEpoch:I

    .line 1752
    :cond_d
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    if-ne p1, v0, :cond_2f

    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz p1, :cond_2f

    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->fullNativeOpen:Z

    if-nez p1, :cond_2f

    .line 1753
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    if-eqz p1, :cond_22

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-eqz p1, :cond_22

    goto :goto_23

    :cond_22
    move v1, v2

    :goto_23
    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->hadMountedOnPause:Z

    .line 1754
    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->hadMountedOnPause:Z

    iput-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnFromBackground:Z

    .line 1755
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->backgroundStartedAt:J

    .line 1757
    :cond_2f
    return-void
.end method

.method public onActivityPostResumed(Landroid/app/Activity;)V
    .locals 4

    .line 1713
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->prePausedOwnerActivity:Landroid/app/Activity;

    if-ne p1, v0, :cond_63

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->prePausedRetainedGallery:Ljava/lang/Object;

    if-nez v0, :cond_9

    goto :goto_63

    .line 1714
    :cond_9
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->prePausedRetainedGallery:Ljava/lang/Object;

    .line 1715
    const/4 v1, 0x0

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->prePausedRetainedGallery:Ljava/lang/Object;

    .line 1716
    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->prePausedOwnerActivity:Landroid/app/Activity;

    .line 1717
    const-string v1, "unifiedGallery"

    invoke-static {p1, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    if-ne v0, p1, :cond_62

    invoke-static {v0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_1f

    goto :goto_62

    .line 1719
    :cond_1f
    :try_start_1f
    sget-object p1, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    const-string v1, "r227ExternalMapPending"

    invoke-static {v0, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_3f

    .line 1720
    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    const-string v1, "r227ResumeFromExternalMap"

    const/4 v2, 0x0

    new-array v3, v2, [Ljava/lang/Class;

    invoke-virtual {p1, v1, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    new-array v1, v2, [Ljava/lang/Object;

    invoke-virtual {p1, v0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_3f
    .catchall {:try_start_1f .. :try_end_3f} :catchall_40

    .line 1724
    :cond_3f
    goto :goto_61

    .line 1722
    :catchall_40
    move-exception p1

    .line 1723
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p1

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "POST_RESUME_RETAIN_FAILED_"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "MOA_R555"

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 1725
    :goto_61
    return-void

    .line 1717
    :cond_62
    :goto_62
    return-void

    .line 1713
    :cond_63
    :goto_63
    return-void
.end method

.method public onActivityPrePaused(Landroid/app/Activity;)V
    .locals 10

    .line 1664
    const-string v0, "MOA_R555"

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-ne p1, v1, :cond_3d

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownsGallery:Z

    if-eqz v1, :cond_3d

    .line 1665
    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lifecyclePauseInProgress:Z

    .line 1666
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeHost:Landroid/widget/FrameLayout;

    if-eqz v1, :cond_18

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    if-eqz v1, :cond_18

    move v1, v2

    goto :goto_19

    :cond_18
    move v1, v3

    :goto_19
    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->hadMountedOnPause:Z

    .line 1667
    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->hadMountedOnPause:Z

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnFromBackground:Z

    .line 1668
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryRef:Ljava/lang/Object;

    const-string v4, "currentDay"

    invoke-static {v1, v4}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    invoke-static {v1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    .line 1669
    const-string v4, "null"

    invoke-virtual {v4, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_35

    const-string v1, ""

    :cond_35
    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ownerDayAtPause:Ljava/lang/String;

    .line 1670
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v4

    iput-wide v4, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->backgroundStartedAt:J

    .line 1674
    :cond_3d
    if-eqz p1, :cond_129

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    if-ne p1, v1, :cond_129

    invoke-virtual {p1}, Landroid/app/Activity;->isFinishing()Z

    move-result v1

    if-nez v1, :cond_129

    invoke-virtual {p1}, Landroid/app/Activity;->isDestroyed()Z

    move-result v1

    if-nez v1, :cond_129

    .line 1675
    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->findWeb(Landroid/app/Activity;)Landroid/webkit/WebView;

    move-result-object v1

    invoke-static {v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->isTrustedWeb(Landroid/webkit/WebView;)Z

    move-result v1

    if-nez v1, :cond_5b

    goto/16 :goto_129

    .line 1676
    :cond_5b
    const-string v1, "unifiedGallery"

    invoke-static {p1, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    .line 1677
    if-eqz v1, :cond_128

    invoke-static {v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->galleryOpen(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_128

    .line 1678
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v4

    const-string v5, "com.juhyeon.familyjourney.MoaNativeGallery"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_7b

    goto/16 :goto_128

    .line 1680
    :cond_7b
    :try_start_7b
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    const-string v5, "r227ExternalMapPending"

    invoke-static {v4, v5}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->field(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v4

    .line 1681
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    const-string v6, "r227VideoWasPlaying"

    invoke-static {v5, v6}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->field(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v5

    .line 1682
    if-eqz v4, :cond_107

    if-nez v5, :cond_95

    goto/16 :goto_107

    .line 1683
    :cond_95
    invoke-virtual {v4, v1}, Ljava/lang/reflect/Field;->getBoolean(Ljava/lang/Object;)Z

    move-result v6

    .line 1684
    if-nez v6, :cond_cf

    .line 1685
    nop

    .line 1686
    const-string v7, "media"

    invoke-static {v1, v7}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v7

    .line 1687
    sget-object v8, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    const-string v9, "prepared"

    invoke-static {v1, v9}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->readField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_c8

    instance-of v8, v7, Landroid/media/MediaPlayer;
    :try_end_b2
    .catchall {:try_start_7b .. :try_end_b2} :catchall_108

    if-eqz v8, :cond_c8

    .line 1688
    :try_start_b4
    move-object v8, v7

    check-cast v8, Landroid/media/MediaPlayer;

    invoke-virtual {v8}, Landroid/media/MediaPlayer;->isPlaying()Z

    move-result v8
    :try_end_bb
    .catchall {:try_start_b4 .. :try_end_bb} :catchall_c5

    .line 1689
    if-eqz v8, :cond_c9

    :try_start_bd
    check-cast v7, Landroid/media/MediaPlayer;

    invoke-virtual {v7}, Landroid/media/MediaPlayer;->pause()V
    :try_end_c2
    .catchall {:try_start_bd .. :try_end_c2} :catchall_c3

    goto :goto_c9

    :catchall_c3
    move-exception v7

    goto :goto_c9

    :catchall_c5
    move-exception v7

    move v8, v3

    goto :goto_c9

    .line 1691
    :cond_c8
    move v8, v3

    :cond_c9
    :goto_c9
    :try_start_c9
    invoke-virtual {v5, v1, v8}, Ljava/lang/reflect/Field;->setBoolean(Ljava/lang/Object;Z)V

    .line 1692
    invoke-virtual {v4, v1, v2}, Ljava/lang/reflect/Field;->setBoolean(Ljava/lang/Object;Z)V

    .line 1694
    :cond_cf
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    const-string v7, "r227RetainForExternalMap"

    new-array v8, v3, [Ljava/lang/Class;

    invoke-virtual {v2, v7, v8}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    .line 1695
    sget-object v7, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    new-array v8, v3, [Ljava/lang/Object;

    invoke-virtual {v2, v1, v8}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {v7, v2}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result v2

    .line 1696
    if-eqz v2, :cond_f9

    .line 1697
    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->prePausedRetainedGallery:Ljava/lang/Object;

    .line 1698
    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->prePausedOwnerActivity:Landroid/app/Activity;

    .line 1699
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v1

    iput-wide v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->prePauseRetainAt:J

    .line 1700
    const-string p1, "PRE_PAUSE_RETAIN_PASS"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_106

    .line 1701
    :cond_f9
    if-nez v6, :cond_106

    .line 1702
    invoke-virtual {v4, v1, v3}, Ljava/lang/reflect/Field;->setBoolean(Ljava/lang/Object;Z)V

    .line 1703
    invoke-virtual {v5, v1, v3}, Ljava/lang/reflect/Field;->setBoolean(Ljava/lang/Object;Z)V

    .line 1704
    const-string p1, "PRE_PAUSE_RETAIN_UNAVAILABLE"

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_106
    .catchall {:try_start_c9 .. :try_end_106} :catchall_108

    .line 1708
    :cond_106
    :goto_106
    goto :goto_127

    .line 1682
    :cond_107
    :goto_107
    return-void

    .line 1706
    :catchall_108
    move-exception p1

    .line 1707
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p1

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "PRE_PAUSE_RETAIN_FAILED_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 1709
    :goto_127
    return-void

    .line 1678
    :cond_128
    :goto_128
    return-void

    .line 1675
    :cond_129
    :goto_129
    return-void
.end method

.method public onActivityResumed(Landroid/app/Activity;)V
    .locals 9

    .line 1727
    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foreground:Landroid/app/Activity;

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->resumed:Z

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foregroundEpoch:I

    add-int/2addr v1, v0

    iput v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->foregroundEpoch:I

    .line 1730
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    const/4 v2, 0x0

    if-ne p1, v0, :cond_3c

    iget-wide v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611LastNaverToggleAt:J

    const-wide/16 v5, 0x0

    cmp-long v0, v3, v5

    if-lez v0, :cond_3c

    .line 1731
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v3

    iget-wide v5, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611LastNaverToggleAt:J

    sub-long/2addr v3, v5

    const-wide/16 v5, 0x4650

    cmp-long v0, v3, v5

    if-gez v0, :cond_3c

    .line 1732
    const/4 v0, 0x4

    new-array v3, v0, [J

    fill-array-data v3, :array_7a

    move v4, v2

    :goto_2b
    if-ge v4, v0, :cond_3c

    aget-wide v5, v3, v4

    .line 1733
    iget-object v7, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->main:Landroid/os/Handler;

    new-instance v8, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda4;

    invoke-direct {v8, p0, p1, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda4;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;I)V

    invoke-virtual {v7, v8, v5, v6}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 1732
    add-int/lit8 v4, v4, 0x1

    goto :goto_2b

    .line 1737
    :cond_3c
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    if-ne p1, v0, :cond_42

    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lifecyclePauseInProgress:Z

    .line 1738
    :cond_42
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnFromBackground:Z

    if-eqz v0, :cond_79

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->hadMountedOnPause:Z

    if-eqz v0, :cond_79

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->nativeOwnerActivity:Landroid/app/Activity;

    if-ne p1, v0, :cond_79

    .line 1739
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v3

    iput-wide v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastResumeAt:J

    .line 1740
    iget-wide v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->lastResumeAt:J

    const-wide/16 v5, 0x4e2

    add-long/2addr v3, v5

    iput-wide v3, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->returnCloseGuardUntil:J

    .line 1744
    const/4 v0, 0x6

    new-array v3, v0, [J

    fill-array-data v3, :array_8e

    :goto_61
    if-ge v2, v0, :cond_72

    aget-wide v4, v3, v2

    .line 1745
    iget-object v6, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->main:Landroid/os/Handler;

    new-instance v7, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda5;

    invoke-direct {v7, p0, p1, v1}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider$$ExternalSyntheticLambda5;-><init>(Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;Landroid/app/Activity;I)V

    invoke-virtual {v6, v7, v4, v5}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 1744
    add-int/lit8 v2, v2, 0x1

    goto :goto_61

    .line 1747
    :cond_72
    const-string p1, "MOA_R567"

    const-string v0, "RETURN_RECHECK_SCHEDULED"

    invoke-static {p1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1749
    :cond_79
    return-void

    :array_7a
    .array-data 8
        0xf0
        0x35c
        0x744
        0xe10
    .end array-data

    :array_8e
    .array-data 8
        0x96
        0x1e0
        0x3b6
        0x6a4
        0xabe
        0xf6e
    .end array-data
.end method

.method public onActivitySaveInstanceState(Landroid/app/Activity;Landroid/os/Bundle;)V
    .locals 0

    .line 1772
    return-void
.end method

.method public onActivityStarted(Landroid/app/Activity;)V
    .locals 0

    .line 1770
    return-void
.end method

.method public onActivityStopped(Landroid/app/Activity;)V
    .locals 0

    .line 1771
    return-void
.end method

.method public onCreate()Z
    .locals 2

    .line 322
    :try_start_0
    invoke-virtual {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    check-cast v0, Landroid/app/Application;

    .line 323
    invoke-virtual {v0, p0}, Landroid/app/Application;->registerActivityLifecycleCallbacks(Landroid/app/Application$ActivityLifecycleCallbacks;)V

    .line 324
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->r611InstallNaverAccessWatcher()V

    .line 325
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->main:Landroid/os/Handler;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaR507InlineGalleryProvider;->ticker:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_17
    .catchall {:try_start_0 .. :try_end_17} :catchall_19

    .line 326
    const/4 v0, 0x1

    return v0

    .line 327
    :catchall_19
    move-exception v0

    const/4 v0, 0x0

    return v0
.end method

.method public query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    .locals 0

    .line 1773
    const/4 p1, 0x0

    return-object p1
.end method

.method public update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 0

    .line 1777
    const/4 p1, 0x0

    return p1
.end method
