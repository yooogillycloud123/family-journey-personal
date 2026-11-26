.class public final Lcom/juhyeon/familyjourney/MoaNativeGallery;
.super Ljava/lang/Object;
.source "MoaNativeGallery.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/juhyeon/familyjourney/MoaNativeGallery$SwipeHandler;,
        Lcom/juhyeon/familyjourney/MoaNativeGallery$R227NaverPin;,
        Lcom/juhyeon/familyjourney/MoaNativeGallery$R201VideoIconButton;,
        Lcom/juhyeon/familyjourney/MoaNativeGallery$VerticalMediaVolume;,
        Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;
    }
.end annotation


# static fields
.field private static final R209_MUTE_ICON_PNG:Ljava/lang/String; = "iVBORw0KGgoAAAANSUhEUgAAAEgAAABJCAYAAACesWDiAAAFJ0lEQVR42u2cf2iVVRjHP3dpdddSik2zgkE/7JelZZIRUoKrJCMK3f4oGTFMLFLJkrLSImdmYhFW0BIS/9BVKyTE1tAVFSTBAhErpdgfYyAFidoomfv2x3tu3tZ9z/tu933P+967+4XDuPc87znPvjvneZ/zPM9ZRhIV+KOqhHXPJEFQA7Da/Ewr6oGtQA/QBTwR62yScm25/otuSZPy+tPQFks6of/j+bjmzP/QW2DiA5KmpYScVfLH8bjmzeQZ6ePAxAKL7GdgGdCd0JYaD+wAmgLkaoA/47RBnT4y1wD7gXsSIOdSY2uaQsgOxG2km4B3LbKfA8sdkvMg0AdMC2tO4zbSudYqOzY6sDdPauSI3UgPV3DQosz2GMnZqtHBKUFIapH0u0WhjoiVqZW0V6OHc4KQ9ICkwxalPpGUjUCRuT5uRuoJQtIsSd9aFOuWdFURSqyU1KfikRhBueX/lUW5ryVdPwoFNksaUDRIlKAcSR0WBQ9JmhNyrKykdxQtEicISVWStlmU7Je0KMQ4CxQ9YiFopOGOIaAFeNWnf4pxNh8PGOcH4PuSCKoUwe5bAX/RlQHPVxvbVVZbbHjbImnIovSGEGPsLmeCkLQ6QPE2SecGjPFpOROEpLUByn8oqSZgjB2lStCagHNZWPRImhBirlQRlLFkNeYCe4BshO+E34A7gKMWmWbgg7QE8f1e83cC70dMDkCdecU/bJHZDtw7iujgOJcELQauiMmzuADYZLInfugEZgesNDdpoAL7bo6kY3KDpwNswE2SukKONd6VJ30jMMmRn/o60GrpPwgsAT5LU2a11rEOa4A3Lf29QKOxic5j0lWujF0AVgDtlv6/zEp6I+Cc6ISgpPL1jSaVPNUi8xSwMektlmRBwzxgCzDDIvMc8GySBJ1OOMBwn3EUb7PIvAa8UCCzOmbKX6YD24D7LTKtwELgb/P51FgiCOAGQ9KjFpkO4BHgp7iM9DjSjTrgbeASSxTzY+CwSxuUNmSBDcBmi8yYJiiHVcBHafCk04yFwKEKQcHGuzdJgoZKgKR6YBA4v7KC/HGOWUnXVQjyx2Rgn/G+KwT5YIpxGFvKOdxRLM4D2vBiSxUj7YOMOZ9tipuggRLfcs9gD74VTdAJ4EyJk9Ro7FJ1HATtB/rLwHg/BOw2B91ICTpiTsjlgHnATuN9j86w+aSeJwO7gLtKiIyTwIU+fUfxkqEHovKDjgFLge+I4YJITFgHfOnTdzWw1xx2I1lB+ZiPF/+dbt5wp/DivxPy3ng5onPx7Gq8FLNL1Bh92oFFPjJnzEraGXrUmO9crI+odGak5S9B5YEvuS6gsrVmRwQNr2JbFyDfnhaCctX6/Q5XUK4tDXimu5gCqqhxEfAFcGuMB+9Cv0wDXqh2os9zPcDMNJzm/wBmmUOlS3ThXc7zqzW6xbz+65Iw0n5tRQxbLBMw52WSDlqe/0XStUnZoELt7ggvsoQhCEkXS+oMIGlBWghC0u3mEowrgsLcNxmQNCMtBCHpckl7HBKUa21hblOmIeTah1ek8J7jeZcAL/r01eYyJmmJSQ+Zs9/LnK3WcIH1ePVGJ4d9vw+vqo00/V+OfM+7PyJHMWxrMMb7R3MtPpuEozgSzDfx5ZtHGJOOPtCd4n+wNBWv6n52SPnsv9si5qB9WnAE70pE2OjmYFznlzTjtIntvFIhyI61JgjvF938Jq6J02yDCmGmSefUD/v+SuDXCkFn0Qw8hld6tyyu7VXKBDlDVYUCO/4Bt8Q6slJaMUIAAAAASUVORK5CYII="


# instance fields
.field private final activity:Landroid/app/Activity;

.field private backButton:Landroid/widget/Button;

.field private backCallback:Landroid/window/OnBackInvokedCallback;

.field private backRegistered:Z

.field private final background:Ljava/util/concurrent/ExecutorService;

.field private browsingRail:Z

.field private chromeVisible:Z

.field private currentDay:Ljava/lang/String;

.field private fingerOffset:F

.field private final frameWorker:Ljava/util/concurrent/ExecutorService;

.field private final full:Landroid/util/LruCache;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/LruCache<",
            "Ljava/lang/String;",
            "Landroid/graphics/Bitmap;",
            ">;"
        }
    .end annotation
.end field

.field private header:Landroid/widget/TextView;

.field private host:Landroid/widget/FrameLayout;

.field private final ids:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private images:[Landroid/widget/ImageView;

.field private index:I

.field private lastLiveSeek:J

.field private final legacyDetails:Ljava/util/function/Consumer;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/function/Consumer<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private loadToken:I

.field private final loadedPageIds:[Ljava/lang/String;

.field private lowerControls:Landroid/widget/LinearLayout;

.field private final main:Landroid/os/Handler;

.field private media:Landroid/media/MediaPlayer;

.field private mediaSurface:Landroid/view/Surface;

.field private menuButton:Landroid/widget/Button;

.field private motion:Landroid/animation/ValueAnimator;

.field private mute:Landroid/widget/Button;

.field private muted:Z

.field private open:Z

.field private pages:[Landroid/widget/FrameLayout;

.field private pause:Landroid/widget/Button;

.field private final pendingPosters:Ljava/util/HashSet;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashSet<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private photoPanX:F

.field private photoPanY:F

.field private photoZoom:F

.field private final posters:Landroid/util/LruCache;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/LruCache<",
            "Ljava/lang/String;",
            "Landroid/graphics/Bitmap;",
            ">;"
        }
    .end annotation
.end field

.field private prepared:Z

.field private r187LastSeekTime:J

.field private r187PendingDispatch:Ljava/lang/Runnable;

.field private r187SeekInFlight:Z

.field private r187SeekIssued:I

.field private r187SeekReleased:Z

.field private r187SeekWanted:I

.field private r197CenterDownX:F

.field private r197CenterTapPending:Z

.field private r197ScrubAnim:Landroid/animation/ValueAnimator;

.field private r197ScrubExpansion:F

.field private r199SideGesture:Z

.field private r199SideStartX:F

.field private r203FlingFrame:Ljava/lang/Runnable;

.field private r203FloatIndex:F

.field private r203Scroller:Landroid/widget/OverScroller;

.field private r203Snap:Landroid/animation/ValueAnimator;

.field private r203StageVelocity:Landroid/view/VelocityTracker;

.field private r205CapturePreview:Landroid/widget/ImageView;

.field private r205PreviewDismiss:Ljava/lang/Runnable;

.field private r207ResumeVideoAfterPhoto:Z

.field private r207SavedPhotoImage:Landroid/widget/ImageView;

.field private r207SavedPhotoLoadGeneration:I

.field private r207SavedPhotoViewer:Landroid/widget/FrameLayout;

.field private r225Address:Landroid/widget/TextView;

.field private r225CaptureTime:Landroid/widget/TextView;

.field private r225HasTime:Z

.field private r225Info:Landroid/widget/LinearLayout;

.field private r225Lat:D

.field private r225Lon:D

.field private r225MetaId:Ljava/lang/String;

.field private r225MetaSeq:I

.field private final r225MetadataWorker:Ljava/util/concurrent/ExecutorService;

.field private r225Naver:Landroid/view/View;

.field private r225PendingMeta:Ljava/lang/Runnable;

.field private r225ResolvedAddress:Ljava/lang/String;

.field private r227ExternalMapPending:Z

.field private r227ScrubDownX:F

.field private r227ScrubDownY:F

.field private r227ScrubDragged:Z

.field private r227VideoWasPlaying:Z

.field private rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

.field private savedSystemUi:I

.field private scrubDownMs:F

.field private scrubDownX:F

.field private scrubFrameClip:Ljava/lang/String;

.field private scrubFrameCount:I

.field private scrubFrameToken:I

.field private final scrubFrames:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/Integer;",
            "Landroid/graphics/Bitmap;",
            ">;"
        }
    .end annotation
.end field

.field private scrubMs:I

.field private scrubPreview:Landroid/widget/ImageView;

.field private scrubWasPlaying:Z

.field private scrubbingVideo:Z

.field private seek:Landroid/widget/SeekBar;

.field private seekInProgress:Z

.field private seekRow:Landroid/widget/LinearLayout;

.field private stage:Landroid/widget/FrameLayout;

.field private still:Landroid/widget/Button;

.field private texture:Landroid/view/TextureView;

.field private ticker:Ljava/lang/Runnable;

.field private videoControls:Landroid/widget/LinearLayout;

.field private videoModeButton:Landroid/widget/Button;

.field private videoModeHint:Landroid/widget/TextView;

.field private videoScrubMode:Z

.field private videoStatus:Landroid/widget/TextView;

.field private videoTime:Landroid/widget/TextView;

.field private videoToken:I

.field private volumeBubble:Landroid/view/View;

.field private volumeRail:Lcom/juhyeon/familyjourney/MoaNativeGallery$VerticalMediaVolume;

.field private volumeRow:Landroid/widget/LinearLayout;


# direct methods
.method public static synthetic $r8$lambda$-X9hbsmzUirHbEjGnpIG2leaSj8(Lcom/juhyeon/familyjourney/MoaNativeGallery;Ljava/lang/String;IIII)V
    .locals 0

    invoke-direct/range {p0 .. p5}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$requestScrubFrames$32(Ljava/lang/String;IIII)V

    return-void
.end method

.method public static synthetic $r8$lambda$0TOoz4HcoaP4dlFI40kKj9WthDY(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$open$11(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$4lKSmXyj7O06XKAdO8fJ9W62qgk(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$videoFailure$26(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$69QRu3X2rqoMnUw2yslgfzw_FBs(Lcom/juhyeon/familyjourney/MoaNativeGallery;Ljava/lang/Exception;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$capture$43(Ljava/lang/Exception;)V

    return-void
.end method

.method public static synthetic $r8$lambda$8rAvt2_ZU5cwwWeiTiiVlGCTg6w(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$open$12()V

    return-void
.end method

.method public static synthetic $r8$lambda$A5XusNdQkeF5lb8bwmRCnvKnc7c(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/animation/ValueAnimator;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$setVideoScrubMode$29(Landroid/animation/ValueAnimator;)V

    return-void
.end method

.method public static synthetic $r8$lambda$AIFcOCJhdcVfKpQv1EZZDp6JiyM(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/MenuItem;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$open$1(Landroid/view/MenuItem;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$ANnYBkZUutO0thqtQTqZOG8Gt2U(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/net/Uri;ILandroid/widget/FrameLayout;Landroid/widget/ImageView;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$r207OpenSavedPhoto$38(Landroid/net/Uri;ILandroid/widget/FrameLayout;Landroid/widget/ImageView;)V

    return-void
.end method

.method public static synthetic $r8$lambda$BlMyox2UtVdEpsBywdhz7tupFBQ(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/animation/ValueAnimator;Landroid/animation/ValueAnimator;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$r203SnapNearest$24(Landroid/animation/ValueAnimator;Landroid/animation/ValueAnimator;)V

    return-void
.end method

.method public static synthetic $r8$lambda$Cx6FJhgEIi5PUrJ9lqpZfonceA0(Lcom/juhyeon/familyjourney/MoaNativeGallery;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$r187ScheduleSeek$34(I)V

    return-void
.end method

.method public static synthetic $r8$lambda$EbVo5GW-pAl1T9vZMSpVz9NfFQo(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/widget/ImageView;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$r205ShowCapturePreview$41(Landroid/widget/ImageView;)V

    return-void
.end method

.method public static synthetic $r8$lambda$EgTOUqDgxuAPiwY4OSrb-d9TQvg(Lcom/juhyeon/familyjourney/MoaNativeGallery;ILandroid/widget/FrameLayout;Landroid/graphics/Bitmap;Landroid/widget/ImageView;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$r207OpenSavedPhoto$37(ILandroid/widget/FrameLayout;Landroid/graphics/Bitmap;Landroid/widget/ImageView;)V

    return-void
.end method

.method public static synthetic $r8$lambda$F3rw44DYEAYZGpnKhay1Lf365vo(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$registerBack$20()V

    return-void
.end method

.method public static synthetic $r8$lambda$I4VnEaVk9mNT2N6iqHGz8CcuoU4(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$open$9(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$NNmWrEnnxThkD_7hR4G49unHn7Q(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/net/Uri;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$r205ShowCapturePreview$39(Landroid/net/Uri;Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$NlSvCvu3xCVZE61UwXdH22CHDcA(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/MenuItem;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$open$4(Landroid/view/MenuItem;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$V54LHnekztQFQnlfmvmAUcYyoAo(Lcom/juhyeon/familyjourney/MoaNativeGallery;ILandroid/media/MediaPlayer;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$r187DispatchSeek$33(ILandroid/media/MediaPlayer;)V

    return-void
.end method

.method public static synthetic $r8$lambda$XJOg5yw1R2Rlzd3zE7CrowKukfE(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/widget/ImageView;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$r205ShowCapturePreview$40(Landroid/widget/ImageView;)V

    return-void
.end method

.method public static synthetic $r8$lambda$XwQLdUORlNHr8T_XHXVDf8TVJBU(Lcom/juhyeon/familyjourney/MoaNativeGallery;ILjava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$r225LoadWebIndex$18(ILjava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$ZokGJEGzf-TM_ZKv5yNRbuaVxkY(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$open$7(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$aHnnRqYDM7MRKa-4SboWPuEQGwI(Lcom/juhyeon/familyjourney/MoaNativeGallery;ILjava/lang/String;JZDD)V
    .locals 0

    invoke-direct/range {p0 .. p9}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$r225LoadMediaMetadata$19(ILjava/lang/String;JZDD)V

    return-void
.end method

.method public static synthetic $r8$lambda$b7Q4ZAV42w9x9kJLXQ_o20YfC_M(Lcom/juhyeon/familyjourney/MoaNativeGallery;IIILandroid/widget/ImageView;Landroid/graphics/Bitmap;)V
    .locals 0

    invoke-direct/range {p0 .. p5}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$refreshPages$21(IIILandroid/widget/ImageView;Landroid/graphics/Bitmap;)V

    return-void
.end method

.method public static synthetic $r8$lambda$bHq_j5INPSHcUYLYsMapBaDLvdw(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$open$8(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$b_quxpNr9I_iT0eU4hpO9EvJZXc(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/animation/ValueAnimator;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$settle$25(Landroid/animation/ValueAnimator;)V

    return-void
.end method

.method public static synthetic $r8$lambda$bt_2yI_e2gXoRv2R3FW4t0Auckc(Lcom/juhyeon/familyjourney/MoaNativeGallery;ILjava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$r225ScheduleMeta$14(ILjava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$c7uNGZLmpJMbMfQqwJN8-fYXAC0(Lcom/juhyeon/familyjourney/MoaNativeGallery;DDILjava/lang/String;)V
    .locals 0

    invoke-direct/range {p0 .. p6}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$r225SetGps$17(DDILjava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$fwvPmIbCqcUWU2_awqBJJIqmX9o(Lcom/juhyeon/familyjourney/MoaNativeGallery;ILjava/lang/String;DDLjava/lang/String;)V
    .locals 0

    invoke-direct/range {p0 .. p7}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$r225SetGps$16(ILjava/lang/String;DDLjava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$i6okMOv8VXJgFPp5jbLghBzhppU(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$updateMediaVolume$28()V

    return-void
.end method

.method public static synthetic $r8$lambda$jRboA1qsfsShXcWLqjGyvp7ffes(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$anchorVolumeBubble$27()V

    return-void
.end method

.method public static synthetic $r8$lambda$j_Bh5tvLoCnqZzgC2x_99O1Yjfs(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/graphics/Bitmap;Landroid/net/Uri;I)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$capture$44(Landroid/graphics/Bitmap;Landroid/net/Uri;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$jkEmWNoNW_BJuwsShydVTt4_f7M(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$r207OpenSavedPhoto$35(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$k20CQddcpIdeOT5Rt4tE3htz-9E(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$open$0(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$no2DO-7F2babZb4MQhfbwoo2v9k(Lcom/juhyeon/familyjourney/MoaNativeGallery;ILjava/lang/String;Ljava/util/HashMap;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$requestScrubFrames$31(ILjava/lang/String;Ljava/util/HashMap;)V

    return-void
.end method

.method public static synthetic $r8$lambda$ou8A-QdPF0oFLcbldX7SqxGxrf0(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$open$3(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$qt7OKD4iWk_6LcWa63HqCtpr4_U(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/graphics/Bitmap;Landroid/net/Uri;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$capture$42(Landroid/graphics/Bitmap;Landroid/net/Uri;)V

    return-void
.end method

.method public static synthetic $r8$lambda$srWtNuwaWwwJEHK4CMu4a-Qk3DY(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/widget/Button;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$open$2(Landroid/widget/Button;Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$tFjDE559rFVQQl7npEwv3ycc_pU(Lcom/juhyeon/familyjourney/MoaNativeGallery;Ljava/lang/String;IIILandroid/widget/ImageView;)V
    .locals 0

    invoke-direct/range {p0 .. p5}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$refreshPages$22(Ljava/lang/String;IIILandroid/widget/ImageView;)V

    return-void
.end method

.method public static synthetic $r8$lambda$viMy55hHnfFMyGIrb0XXevcv6Og(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/View;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$open$5(Landroid/view/View;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$wWFgKIbSML1ZAI1OIvhMTz8Ki5g(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$open$10(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$xeEAddgj3MrQCWFMjdFzKMpKTb0(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/View;ILandroid/view/KeyEvent;)Z
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$r207OpenSavedPhoto$36(Landroid/view/View;ILandroid/view/KeyEvent;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$y62VxIlisoOTCsrblH6Bke2Q08w(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$open$6(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$yQwpsouTSzVsrBV4rLVSJ1BsUz0(Lcom/juhyeon/familyjourney/MoaNativeGallery;ILjava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lambda$r225ScheduleMeta$15(ILjava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$fgetactivity(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Landroid/app/Activity;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetbackground(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Ljava/util/concurrent/ExecutorService;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->background:Ljava/util/concurrent/ExecutorService;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetfingerOffset(Lcom/juhyeon/familyjourney/MoaNativeGallery;)F
    .locals 0

    iget p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->fingerOffset:F

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetids(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Ljava/util/ArrayList;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetimages(Lcom/juhyeon/familyjourney/MoaNativeGallery;)[Landroid/widget/ImageView;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->images:[Landroid/widget/ImageView;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetindex(Lcom/juhyeon/familyjourney/MoaNativeGallery;)I
    .locals 0

    iget p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetloadToken(Lcom/juhyeon/familyjourney/MoaNativeGallery;)I
    .locals 0

    iget p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadToken:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmain(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Landroid/os/Handler;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmedia(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Landroid/media/MediaPlayer;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmotion(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Landroid/animation/ValueAnimator;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->motion:Landroid/animation/ValueAnimator;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmute(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Landroid/widget/Button;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mute:Landroid/widget/Button;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmuted(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->muted:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetopen(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetpause(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Landroid/widget/Button;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetpendingPosters(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Ljava/util/HashSet;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pendingPosters:Ljava/util/HashSet;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetphotoPanX(Lcom/juhyeon/familyjourney/MoaNativeGallery;)F
    .locals 0

    iget p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoPanX:F

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetphotoPanY(Lcom/juhyeon/familyjourney/MoaNativeGallery;)F
    .locals 0

    iget p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoPanY:F

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetphotoZoom(Lcom/juhyeon/familyjourney/MoaNativeGallery;)F
    .locals 0

    iget p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoZoom:F

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetposters(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Landroid/util/LruCache;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->posters:Landroid/util/LruCache;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetprepared(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetr197ScrubAnim(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Landroid/animation/ValueAnimator;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubAnim:Landroid/animation/ValueAnimator;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetr197ScrubExpansion(Lcom/juhyeon/familyjourney/MoaNativeGallery;)F
    .locals 0

    iget p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubExpansion:F

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetr203FlingFrame(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Ljava/lang/Runnable;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203FlingFrame:Ljava/lang/Runnable;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetr203FloatIndex(Lcom/juhyeon/familyjourney/MoaNativeGallery;)F
    .locals 0

    iget p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203FloatIndex:F

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetr203Scroller(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Landroid/widget/OverScroller;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Scroller:Landroid/widget/OverScroller;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetr203Snap(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Landroid/animation/ValueAnimator;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Snap:Landroid/animation/ValueAnimator;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetr203StageVelocity(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Landroid/view/VelocityTracker;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203StageVelocity:Landroid/view/VelocityTracker;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetr227ScrubDownX(Lcom/juhyeon/familyjourney/MoaNativeGallery;)F
    .locals 0

    iget p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227ScrubDownX:F

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetr227ScrubDownY(Lcom/juhyeon/familyjourney/MoaNativeGallery;)F
    .locals 0

    iget p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227ScrubDownY:F

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetr227ScrubDragged(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227ScrubDragged:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetrail(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetscrubbingVideo(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubbingVideo:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetseek(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Landroid/widget/SeekBar;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seek:Landroid/widget/SeekBar;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetseekInProgress(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seekInProgress:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetstage(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Landroid/widget/FrameLayout;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgettexture(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Landroid/view/TextureView;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetvideoScrubMode(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoScrubMode:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetvideoTime(Lcom/juhyeon/familyjourney/MoaNativeGallery;)Landroid/widget/TextView;
    .locals 0

    iget-object p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetvideoToken(Lcom/juhyeon/familyjourney/MoaNativeGallery;)I
    .locals 0

    iget p0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoToken:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fputbrowsingRail(Lcom/juhyeon/familyjourney/MoaNativeGallery;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->browsingRail:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputindex(Lcom/juhyeon/familyjourney/MoaNativeGallery;I)V
    .locals 0

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputloadToken(Lcom/juhyeon/familyjourney/MoaNativeGallery;I)V
    .locals 0

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadToken:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmedia(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/media/MediaPlayer;)V
    .locals 0

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmediaSurface(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/Surface;)V
    .locals 0

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mediaSurface:Landroid/view/Surface;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmotion(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/animation/ValueAnimator;)V
    .locals 0

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->motion:Landroid/animation/ValueAnimator;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputphotoPanX(Lcom/juhyeon/familyjourney/MoaNativeGallery;F)V
    .locals 0

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoPanX:F

    return-void
.end method

.method static bridge synthetic -$$Nest$fputphotoPanY(Lcom/juhyeon/familyjourney/MoaNativeGallery;F)V
    .locals 0

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoPanY:F

    return-void
.end method

.method static bridge synthetic -$$Nest$fputphotoZoom(Lcom/juhyeon/familyjourney/MoaNativeGallery;F)V
    .locals 0

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoZoom:F

    return-void
.end method

.method static bridge synthetic -$$Nest$fputprepared(Lcom/juhyeon/familyjourney/MoaNativeGallery;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputr197ScrubAnim(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/animation/ValueAnimator;)V
    .locals 0

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubAnim:Landroid/animation/ValueAnimator;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputr203FlingFrame(Lcom/juhyeon/familyjourney/MoaNativeGallery;Ljava/lang/Runnable;)V
    .locals 0

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203FlingFrame:Ljava/lang/Runnable;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputr203Scroller(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/widget/OverScroller;)V
    .locals 0

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Scroller:Landroid/widget/OverScroller;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputr203Snap(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/animation/ValueAnimator;)V
    .locals 0

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Snap:Landroid/animation/ValueAnimator;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputr203StageVelocity(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/VelocityTracker;)V
    .locals 0

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203StageVelocity:Landroid/view/VelocityTracker;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputr227ScrubDownX(Lcom/juhyeon/familyjourney/MoaNativeGallery;F)V
    .locals 0

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227ScrubDownX:F

    return-void
.end method

.method static bridge synthetic -$$Nest$fputr227ScrubDownY(Lcom/juhyeon/familyjourney/MoaNativeGallery;F)V
    .locals 0

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227ScrubDownY:F

    return-void
.end method

.method static bridge synthetic -$$Nest$fputr227ScrubDragged(Lcom/juhyeon/familyjourney/MoaNativeGallery;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227ScrubDragged:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputseekInProgress(Lcom/juhyeon/familyjourney/MoaNativeGallery;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seekInProgress:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$mapplyPhotoZoom(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->applyPhotoZoom()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mclock(Lcom/juhyeon/familyjourney/MoaNativeGallery;J)Ljava/lang/String;
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->clock(J)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mdp(Lcom/juhyeon/familyjourney/MoaNativeGallery;F)I
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mgetBitmap(Lcom/juhyeon/familyjourney/MoaNativeGallery;Ljava/lang/String;Z)Landroid/graphics/Bitmap;
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->getBitmap(Ljava/lang/String;Z)Landroid/graphics/Bitmap;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mnavigate(Lcom/juhyeon/familyjourney/MoaNativeGallery;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->navigate(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mprepareCurrentVideo(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepareCurrentVideo()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mr201DrawSceneFrames(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/graphics/Canvas;Landroid/graphics/Paint;Landroid/graphics/RectF;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r201DrawSceneFrames(Landroid/graphics/Canvas;Landroid/graphics/Paint;Landroid/graphics/RectF;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mr203CancelFling(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203CancelFling()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mr203Clamp(Lcom/juhyeon/familyjourney/MoaNativeGallery;F)F
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Clamp(F)F

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mr203CompleteFling(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203CompleteFling()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mr203Present(Lcom/juhyeon/familyjourney/MoaNativeGallery;F)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Present(F)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mr203ReleaseWithVelocity(Lcom/juhyeon/familyjourney/MoaNativeGallery;FFF)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203ReleaseWithVelocity(FFF)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mr203SnapNearest(Lcom/juhyeon/familyjourney/MoaNativeGallery;F)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203SnapNearest(F)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mrefreshPages(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->refreshPages()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mrequestScrubFrames(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->requestScrubFrames()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mresetPhotoZoom(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->resetPhotoZoom()V

    return-void
.end method

.method static bridge synthetic -$$Nest$msetVideoScrubMode(Lcom/juhyeon/familyjourney/MoaNativeGallery;Z)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->setVideoScrubMode(Z)V

    return-void
.end method

.method static bridge synthetic -$$Nest$msettle(Lcom/juhyeon/familyjourney/MoaNativeGallery;IF)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->settle(IF)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mstartTicker(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->startTicker()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mteardownPlayer(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->teardownPlayer()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mtoggleChrome(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->toggleChrome()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mtouchVideoFrames(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/view/MotionEvent;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->touchVideoFrames(Landroid/view/MotionEvent;)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mupdatePosition(Lcom/juhyeon/familyjourney/MoaNativeGallery;F)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->updatePosition(F)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateVideoGeometry(Lcom/juhyeon/familyjourney/MoaNativeGallery;II)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->updateVideoGeometry(II)V

    return-void
.end method

.method static bridge synthetic -$$Nest$muri(Lcom/juhyeon/familyjourney/MoaNativeGallery;Ljava/lang/String;)Landroid/net/Uri;
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->uri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mvideo(Lcom/juhyeon/familyjourney/MoaNativeGallery;Ljava/lang/String;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->video(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mvideoFailure(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoFailure()V

    return-void
.end method

.method public constructor <init>(Landroid/app/Activity;Ljava/util/function/Consumer;)V
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/app/Activity;",
            "Ljava/util/function/Consumer<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    const/4 v0, 0x2

    invoke-static {v0}, Ljava/util/concurrent/Executors;->newFixedThreadPool(I)Ljava/util/concurrent/ExecutorService;

    move-result-object v1

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->background:Ljava/util/concurrent/ExecutorService;

    invoke-static {v0}, Ljava/util/concurrent/Executors;->newFixedThreadPool(I)Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetadataWorker:Ljava/util/concurrent/ExecutorService;

    new-instance v0, Lcom/juhyeon/familyjourney/MoaNativeGallery$1;

    const/high16 v1, 0x1400000

    invoke-direct {v0, p0, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$1;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;I)V

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->posters:Landroid/util/LruCache;

    new-instance v0, Lcom/juhyeon/familyjourney/MoaNativeGallery$2;

    const/high16 v1, 0x2a00000

    invoke-direct {v0, p0, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$2;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;I)V

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->full:Landroid/util/LruCache;

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->chromeVisible:Z

    const/4 v1, 0x0

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoScrubMode:Z

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubbingVideo:Z

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubWasPlaying:Z

    const/4 v2, 0x0

    iput v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubExpansion:F

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197CenterTapPending:Z

    iput v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197CenterDownX:F

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r199SideGesture:Z

    iput v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r199SideStartX:F

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekInFlight:Z

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekReleased:Z

    iput v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekWanted:I

    iput v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekIssued:I

    const-wide/16 v3, 0x0

    iput-wide v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187LastSeekTime:J

    iput v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubMs:I

    iput-wide v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lastLiveSeek:J

    const-string v3, ""

    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameClip:Ljava/lang/String;

    const/16 v4, 0x18

    iput v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameCount:I

    iput v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameToken:I

    new-instance v4, Ljava/util/HashMap;

    invoke-direct {v4}, Ljava/util/HashMap;-><init>()V

    iput-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrames:Ljava/util/HashMap;

    const/4 v4, 0x3

    new-array v5, v4, [Ljava/lang/String;

    iput-object v5, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadedPageIds:[Ljava/lang/String;

    new-instance v5, Ljava/util/HashSet;

    invoke-direct {v5}, Ljava/util/HashSet;-><init>()V

    iput-object v5, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pendingPosters:Ljava/util/HashSet;

    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v5

    iput-object v5, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->frameWorker:Ljava/util/concurrent/ExecutorService;

    new-array v5, v4, [Landroid/widget/FrameLayout;

    iput-object v5, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pages:[Landroid/widget/FrameLayout;

    new-array v4, v4, [Landroid/widget/ImageView;

    iput-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->images:[Landroid/widget/ImageView;

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227ExternalMapPending:Z

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227VideoWasPlaying:Z

    iput v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227ScrubDownX:F

    iput v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227ScrubDownY:F

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227ScrubDragged:Z

    iput v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetaSeq:I

    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetaId:Ljava/lang/String;

    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225ResolvedAddress:Ljava/lang/String;

    const-wide/high16 v4, 0x7ff8000000000000L    # Double.NaN

    iput-wide v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lat:D

    iput-wide v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lon:D

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225HasTime:Z

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207ResumeVideoAfterPhoto:Z

    iput v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoLoadGeneration:I

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->muted:Z

    const/high16 v0, 0x3f800000    # 1.0f

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoZoom:F

    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->currentDay:Ljava/lang/String;

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    iput-object p2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->legacyDetails:Ljava/util/function/Consumer;

    return-void
.end method

.method private anchorVolumeBubble()V
    .locals 10

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    if-eqz v0, :cond_af

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mute:Landroid/widget/Button;

    if-eqz v0, :cond_af

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeBubble:Landroid/view/View;

    if-eqz v0, :cond_af

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeBubble:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    if-eq v0, v1, :cond_18

    goto/16 :goto_af

    :cond_18
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->getWidth()I

    move-result v0

    if-eqz v0, :cond_a4

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mute:Landroid/widget/Button;

    invoke-virtual {v0}, Landroid/widget/Button;->getWidth()I

    move-result v0

    if-nez v0, :cond_29

    goto :goto_a4

    :cond_29
    const/4 v0, 0x2

    new-array v1, v0, [I

    new-array v2, v0, [I

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mute:Landroid/widget/Button;

    invoke-virtual {v3, v1}, Landroid/widget/Button;->getLocationInWindow([I)V

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    invoke-virtual {v3, v2}, Landroid/widget/FrameLayout;->getLocationInWindow([I)V

    const/high16 v3, 0x42680000    # 58.0f

    invoke-direct {p0, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v3

    const/high16 v4, 0x433b0000    # 187.0f

    invoke-direct {p0, v4}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v4

    iget-object v5, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeBubble:Landroid/view/View;

    invoke-virtual {v5}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v5

    check-cast v5, Landroid/widget/FrameLayout$LayoutParams;

    const/16 v6, 0x33

    iput v6, v5, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    const/high16 v6, 0x40a00000    # 5.0f

    invoke-direct {p0, v6}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v7

    invoke-direct {p0, v6}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v8

    iget-object v9, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    invoke-virtual {v9}, Landroid/widget/FrameLayout;->getWidth()I

    move-result v9

    sub-int/2addr v9, v3

    invoke-direct {p0, v6}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v6

    sub-int/2addr v9, v6

    invoke-static {v8, v9}, Ljava/lang/Math;->max(II)I

    move-result v6

    const/4 v8, 0x0

    aget v9, v1, v8

    aget v8, v2, v8

    sub-int/2addr v9, v8

    iget-object v8, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mute:Landroid/widget/Button;

    invoke-virtual {v8}, Landroid/widget/Button;->getWidth()I

    move-result v8

    div-int/2addr v8, v0

    add-int/2addr v9, v8

    div-int/2addr v3, v0

    sub-int/2addr v9, v3

    invoke-static {v6, v9}, Ljava/lang/Math;->min(II)I

    move-result v0

    invoke-static {v7, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    iput v0, v5, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    const/high16 v0, 0x41100000    # 9.0f

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v0

    const/4 v3, 0x1

    aget v1, v1, v3

    aget v2, v2, v3

    sub-int/2addr v1, v2

    sub-int/2addr v1, v4

    const/high16 v2, 0x41300000    # 11.0f

    invoke-direct {p0, v2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v2

    sub-int/2addr v1, v2

    invoke-static {v0, v1}, Ljava/lang/Math;->max(II)I

    move-result v0

    iput v0, v5, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeBubble:Landroid/view/View;

    invoke-virtual {v0, v5}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    return-void

    :cond_a4
    :goto_a4
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeBubble:Landroid/view/View;

    new-instance v1, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda0;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    return-void

    :cond_af
    :goto_af
    return-void
.end method

.method private applyPhotoZoom()V
    .locals 6

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->images:[Landroid/widget/ImageView;

    const/4 v1, 0x1

    aget-object v0, v0, v1

    if-nez v0, :cond_8

    return-void

    :cond_8
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->images:[Landroid/widget/ImageView;

    aget-object v0, v0, v1

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoZoom:F

    const/high16 v2, 0x3f800000    # 1.0f

    sub-float/2addr v1, v2

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    invoke-virtual {v3}, Landroid/widget/FrameLayout;->getWidth()I

    move-result v3

    int-to-float v3, v3

    mul-float/2addr v1, v3

    const/high16 v3, 0x3f000000    # 0.5f

    mul-float/2addr v1, v3

    const/4 v4, 0x0

    invoke-static {v4, v1}, Ljava/lang/Math;->max(FF)F

    move-result v1

    iget v5, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoZoom:F

    sub-float/2addr v5, v2

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    invoke-virtual {v2}, Landroid/widget/FrameLayout;->getHeight()I

    move-result v2

    int-to-float v2, v2

    mul-float/2addr v5, v2

    mul-float/2addr v5, v3

    invoke-static {v4, v5}, Ljava/lang/Math;->max(FF)F

    move-result v2

    neg-float v3, v1

    iget v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoPanX:F

    invoke-static {v1, v4}, Ljava/lang/Math;->min(FF)F

    move-result v1

    invoke-static {v3, v1}, Ljava/lang/Math;->max(FF)F

    move-result v1

    iput v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoPanX:F

    neg-float v1, v2

    iget v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoPanY:F

    invoke-static {v2, v3}, Ljava/lang/Math;->min(FF)F

    move-result v2

    invoke-static {v1, v2}, Ljava/lang/Math;->max(FF)F

    move-result v1

    iput v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoPanY:F

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoZoom:F

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setScaleX(F)V

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoZoom:F

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setScaleY(F)V

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoPanX:F

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setTranslationX(F)V

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoPanY:F

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setTranslationY(F)V

    return-void
.end method

.method private button(Ljava/lang/String;I)Landroid/widget/Button;
    .locals 2

    new-instance v0, Landroid/widget/Button;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v0, v1}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setAllCaps(Z)V

    invoke-virtual {v0, p1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    int-to-float p1, p2

    invoke-virtual {v0, p1}, Landroid/widget/Button;->setTextSize(F)V

    const/4 p1, -0x1

    invoke-virtual {v0, p1}, Landroid/widget/Button;->setTextColor(I)V

    const p1, -0xdddbd5

    invoke-static {p1}, Landroid/content/res/ColorStateList;->valueOf(I)Landroid/content/res/ColorStateList;

    move-result-object p1

    invoke-virtual {v0, p1}, Landroid/widget/Button;->setBackgroundTintList(Landroid/content/res/ColorStateList;)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setMinHeight(I)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setMinimumHeight(I)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setMinWidth(I)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setMinimumWidth(I)V

    return-object v0
.end method

.method private capture()V
    .locals 5

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_5a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->video(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_15

    goto :goto_5a

    :cond_15
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->uri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    if-eqz v1, :cond_32

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    if-eqz v1, :cond_32

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {v1}, Landroid/media/MediaPlayer;->getCurrentPosition()I

    move-result v1

    goto :goto_33

    :cond_32
    const/4 v1, 0x0

    :goto_33
    nop

    const/4 v2, 0x0

    :try_start_35
    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    if-eqz v3, :cond_4d

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    invoke-virtual {v3}, Landroid/view/TextureView;->isAvailable()Z

    move-result v3

    if-eqz v3, :cond_4d

    iget-boolean v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    if-eqz v3, :cond_4d

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    invoke-virtual {v3}, Landroid/view/TextureView;->getBitmap()Landroid/graphics/Bitmap;

    move-result-object v2
    :try_end_4b
    .catch Ljava/lang/RuntimeException; {:try_start_35 .. :try_end_4b} :catch_4c

    goto :goto_4d

    :catch_4c
    move-exception v3

    :cond_4d
    :goto_4d
    nop

    nop

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->background:Ljava/util/concurrent/ExecutorService;

    new-instance v4, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda19;

    invoke-direct {v4, p0, v2, v0, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda19;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/graphics/Bitmap;Landroid/net/Uri;I)V

    invoke-interface {v3, v4}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    return-void

    :cond_5a
    :goto_5a
    return-void
.end method

.method private clock(J)Ljava/lang/String;
    .locals 5

    const-wide/16 v0, 0x0

    invoke-static {v0, v1, p1, p2}, Ljava/lang/Math;->max(JJ)J

    move-result-wide p1

    const-wide/16 v0, 0x3e8

    div-long/2addr p1, v0

    sget-object v0, Ljava/util/Locale;->US:Ljava/util/Locale;

    const-wide/16 v1, 0x3c

    div-long v3, p1, v1

    invoke-static {v3, v4}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v3

    rem-long/2addr p1, v1

    invoke-static {p1, p2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p1

    filled-new-array {v3, p1}, [Ljava/lang/Object;

    move-result-object p1

    const-string p2, "%02d:%02d"

    invoke-static {v0, p2, p1}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method private dp(F)I
    .locals 1

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    mul-float/2addr p1, v0

    const/high16 v0, 0x3f000000    # 0.5f

    add-float/2addr p1, v0

    float-to-int p1, p1

    return p1
.end method

.method private getBitmap(Ljava/lang/String;Z)Landroid/graphics/Bitmap;
    .locals 7

    if-eqz p2, :cond_5

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->full:Landroid/util/LruCache;

    goto :goto_7

    :cond_5
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->posters:Landroid/util/LruCache;

    :goto_7
    invoke-virtual {v0, p1}, Landroid/util/LruCache;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/graphics/Bitmap;

    if-eqz v0, :cond_10

    return-object v0

    :cond_10
    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->uri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_18

    return-object v1

    :cond_18
    if-nez p2, :cond_38

    :try_start_1a
    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v2}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    new-instance v3, Landroid/util/Size;

    const/high16 v4, 0x43200000    # 160.0f

    invoke-direct {p0, v4}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v5

    invoke-direct {p0, v4}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v4

    invoke-direct {v3, v5, v4}, Landroid/util/Size;-><init>(II)V

    invoke-virtual {v2, v0, v3, v1}, Landroid/content/ContentResolver;->loadThumbnail(Landroid/net/Uri;Landroid/util/Size;Landroid/os/CancellationSignal;)Landroid/graphics/Bitmap;

    move-result-object v0
    :try_end_33
    .catch Ljava/lang/Exception; {:try_start_1a .. :try_end_33} :catch_35

    goto/16 :goto_af

    :catch_35
    move-exception p1

    goto/16 :goto_db

    :cond_38
    nop

    :try_start_39
    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v2}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    invoke-static {v2, v0}, Landroid/graphics/ImageDecoder;->createSource(Landroid/content/ContentResolver;Landroid/net/Uri;)Landroid/graphics/ImageDecoder$Source;

    move-result-object v2

    new-instance v3, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda17;

    invoke-direct {v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda17;-><init>()V

    invoke-static {v2, v3}, Landroid/graphics/ImageDecoder;->decodeBitmap(Landroid/graphics/ImageDecoder$Source;Landroid/graphics/ImageDecoder$OnHeaderDecodedListener;)Landroid/graphics/Bitmap;

    move-result-object v2

    if-eqz v2, :cond_55

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->full:Landroid/util/LruCache;

    invoke-virtual {v3, p1, v2}, Landroid/util/LruCache;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_53
    .catch Ljava/lang/Exception; {:try_start_39 .. :try_end_53} :catch_54

    return-object v2

    :catch_54
    move-exception v2

    :cond_55
    nop

    :try_start_56
    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v2}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    invoke-virtual {v2, v0}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v2

    if-nez v2, :cond_68

    if-eqz v2, :cond_67

    invoke-virtual {v2}, Ljava/io/InputStream;->close()V
    :try_end_67
    .catch Ljava/lang/Exception; {:try_start_56 .. :try_end_67} :catch_35

    :cond_67
    return-object v1

    :cond_68
    :try_start_68
    new-instance v3, Landroid/graphics/BitmapFactory$Options;

    invoke-direct {v3}, Landroid/graphics/BitmapFactory$Options;-><init>()V

    const/4 v4, 0x1

    iput-boolean v4, v3, Landroid/graphics/BitmapFactory$Options;->inJustDecodeBounds:Z

    invoke-static {v2, v1, v3}, Landroid/graphics/BitmapFactory;->decodeStream(Ljava/io/InputStream;Landroid/graphics/Rect;Landroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;

    iput v4, v3, Landroid/graphics/BitmapFactory$Options;->inSampleSize:I

    :goto_75
    iget v4, v3, Landroid/graphics/BitmapFactory$Options;->outWidth:I

    iget v5, v3, Landroid/graphics/BitmapFactory$Options;->inSampleSize:I

    div-int/2addr v4, v5

    const/16 v5, 0x8fc

    if-gt v4, v5, :cond_c8

    iget v4, v3, Landroid/graphics/BitmapFactory$Options;->outHeight:I

    iget v6, v3, Landroid/graphics/BitmapFactory$Options;->inSampleSize:I

    div-int/2addr v4, v6

    if-le v4, v5, :cond_86

    goto :goto_c8

    :cond_86
    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v4}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v4

    invoke-virtual {v4, v0}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v0

    if-nez v0, :cond_9d

    if-eqz v0, :cond_97

    invoke-virtual {v0}, Ljava/io/InputStream;->close()V
    :try_end_97
    .catchall {:try_start_68 .. :try_end_97} :catchall_cf

    :cond_97
    if-eqz v2, :cond_9c

    :try_start_99
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V
    :try_end_9c
    .catch Ljava/lang/Exception; {:try_start_99 .. :try_end_9c} :catch_35

    :cond_9c
    return-object v1

    :cond_9d
    const/4 v4, 0x0

    :try_start_9e
    iput-boolean v4, v3, Landroid/graphics/BitmapFactory$Options;->inJustDecodeBounds:Z

    invoke-static {v0, v1, v3}, Landroid/graphics/BitmapFactory;->decodeStream(Ljava/io/InputStream;Landroid/graphics/Rect;Landroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;

    move-result-object v3
    :try_end_a4
    .catchall {:try_start_9e .. :try_end_a4} :catchall_bc

    if-eqz v0, :cond_a9

    :try_start_a6
    invoke-virtual {v0}, Ljava/io/InputStream;->close()V
    :try_end_a9
    .catchall {:try_start_a6 .. :try_end_a9} :catchall_cf

    :cond_a9
    if-eqz v2, :cond_ae

    :try_start_ab
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V

    :cond_ae
    move-object v0, v3

    :goto_af
    if-eqz v0, :cond_bb

    if-eqz p2, :cond_b6

    iget-object p2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->full:Landroid/util/LruCache;

    goto :goto_b8

    :cond_b6
    iget-object p2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->posters:Landroid/util/LruCache;

    :goto_b8
    invoke-virtual {p2, p1, v0}, Landroid/util/LruCache;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_bb
    .catch Ljava/lang/Exception; {:try_start_ab .. :try_end_bb} :catch_35

    :cond_bb
    return-object v0

    :catchall_bc
    move-exception p1

    if-eqz v0, :cond_c7

    :try_start_bf
    invoke-virtual {v0}, Ljava/io/InputStream;->close()V
    :try_end_c2
    .catchall {:try_start_bf .. :try_end_c2} :catchall_c3

    goto :goto_c7

    :catchall_c3
    move-exception p2

    :try_start_c4
    invoke-virtual {p1, p2}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_c7
    :goto_c7
    throw p1

    :cond_c8
    :goto_c8
    iget v4, v3, Landroid/graphics/BitmapFactory$Options;->inSampleSize:I

    mul-int/lit8 v4, v4, 0x2

    iput v4, v3, Landroid/graphics/BitmapFactory$Options;->inSampleSize:I
    :try_end_ce
    .catchall {:try_start_c4 .. :try_end_ce} :catchall_cf

    goto :goto_75

    :catchall_cf
    move-exception p1

    if-eqz v2, :cond_da

    :try_start_d2
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V
    :try_end_d5
    .catchall {:try_start_d2 .. :try_end_d5} :catchall_d6

    goto :goto_da

    :catchall_d6
    move-exception p2

    :try_start_d7
    invoke-virtual {p1, p2}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_da
    :goto_da
    throw p1
    :try_end_db
    .catch Ljava/lang/Exception; {:try_start_d7 .. :try_end_db} :catch_35

    :goto_db
    return-object v1
.end method

.method private getWidthSafe(Landroid/view/View;)I
    .locals 1

    if-nez p1, :cond_9

    const/high16 p1, 0x43960000    # 300.0f

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result p1

    goto :goto_12

    :cond_9
    const/4 v0, 0x1

    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result p1

    invoke-static {v0, p1}, Ljava/lang/Math;->max(II)I

    move-result p1

    :goto_12
    return p1
.end method

.method private hideScrubPreview()V
    .locals 2

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubPreview:Landroid/widget/ImageView;

    if-eqz v0, :cond_11

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubPreview:Landroid/widget/ImageView;

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setVisibility(I)V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubPreview:Landroid/widget/ImageView;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    :cond_11
    return-void
.end method

.method private synthetic lambda$anchorVolumeBubble$27()V
    .locals 1

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_7

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->anchorVolumeBubble()V

    :cond_7
    return-void
.end method

.method private synthetic lambda$capture$42(Landroid/graphics/Bitmap;Landroid/net/Uri;)V
    .locals 1

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_9

    if-eqz p1, :cond_9

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205ShowCapturePreview(Landroid/graphics/Bitmap;Landroid/net/Uri;)V

    :cond_9
    return-void
.end method

.method private synthetic lambda$capture$43(Ljava/lang/Exception;)V
    .locals 3

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {p1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p1

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\uc7a5\uba74 \uc800\uc7a5 \uc2e4\ud328: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const/4 v1, 0x0

    invoke-static {v0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method private synthetic lambda$capture$44(Landroid/graphics/Bitmap;Landroid/net/Uri;I)V
    .locals 7

    const-string v0, "is_pending"

    nop

    const/4 v1, 0x0

    const/4 v2, 0x0

    if-nez p1, :cond_41

    :try_start_7
    new-instance p1, Landroid/media/MediaMetadataRetriever;

    invoke-direct {p1}, Landroid/media/MediaMetadataRetriever;-><init>()V
    :try_end_c
    .catch Ljava/lang/Exception; {:try_start_7 .. :try_end_c} :catch_3d
    .catchall {:try_start_7 .. :try_end_c} :catchall_39

    :try_start_c
    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {p1, v3, p2}, Landroid/media/MediaMetadataRetriever;->setDataSource(Landroid/content/Context;Landroid/net/Uri;)V

    int-to-long p2, p3

    const-wide/16 v3, 0x3e8

    mul-long/2addr p2, v3

    const/4 v3, 0x3

    invoke-virtual {p1, p2, p3, v3}, Landroid/media/MediaMetadataRetriever;->getFrameAtTime(JI)Landroid/graphics/Bitmap;

    move-result-object v3

    if-nez v3, :cond_21

    const/4 v3, 0x2

    invoke-virtual {p1, p2, p3, v3}, Landroid/media/MediaMetadataRetriever;->getFrameAtTime(JI)Landroid/graphics/Bitmap;

    move-result-object v3

    :cond_21
    if-nez v3, :cond_2a

    const-wide/16 p2, -0x1

    invoke-virtual {p1, p2, p3}, Landroid/media/MediaMetadataRetriever;->getFrameAtTime(J)Landroid/graphics/Bitmap;

    move-result-object p2
    :try_end_29
    .catchall {:try_start_c .. :try_end_29} :catchall_32

    goto :goto_2b

    :cond_2a
    move-object p2, v3

    :goto_2b
    :try_start_2b
    invoke-virtual {p1}, Landroid/media/MediaMetadataRetriever;->release()V
    :try_end_2e
    .catch Ljava/lang/Exception; {:try_start_2b .. :try_end_2e} :catch_2f
    .catchall {:try_start_2b .. :try_end_2e} :catchall_39

    goto :goto_30

    :catch_2f
    move-exception p1

    :goto_30
    move-object p1, p2

    goto :goto_41

    :catchall_32
    move-exception p2

    :try_start_33
    invoke-virtual {p1}, Landroid/media/MediaMetadataRetriever;->release()V
    :try_end_36
    .catch Ljava/lang/Exception; {:try_start_33 .. :try_end_36} :catch_37
    .catchall {:try_start_33 .. :try_end_36} :catchall_39

    goto :goto_38

    :catch_37
    move-exception p1

    :goto_38
    :try_start_38
    throw p2

    :catchall_39
    move-exception p1

    move-object p2, v1

    goto/16 :goto_158

    :catch_3d
    move-exception p1

    move-object p2, v1

    goto/16 :goto_13d

    :cond_41
    :goto_41
    if-eqz p1, :cond_135

    new-instance p2, Landroid/content/ContentValues;

    invoke-direct {p2}, Landroid/content/ContentValues;-><init>()V

    const-string p3, "_display_name"

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "MOA_"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, ".jpg"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p2, p3, v3}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    const-string p3, "mime_type"

    const-string v3, "image/jpeg"

    invoke-virtual {p2, p3, v3}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    const-string p3, "relative_path"

    sget-object v3, Landroid/os/Environment;->DIRECTORY_PICTURES:Ljava/lang/String;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "/MOA-Video-Captures/"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p2, p3, v3}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    const/4 p3, 0x1

    invoke-static {p3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {p2, v0, v3}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v3}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    sget-object v4, Landroid/provider/MediaStore$Images$Media;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;

    invoke-virtual {v3, v4, p2}, Landroid/content/ContentResolver;->insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;

    move-result-object p2
    :try_end_9f
    .catch Ljava/lang/Exception; {:try_start_38 .. :try_end_9f} :catch_3d
    .catchall {:try_start_38 .. :try_end_9f} :catchall_39

    if-eqz p2, :cond_12d

    :try_start_a1
    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v3}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    const-string v4, "w"

    invoke-virtual {v3, p2, v4}, Landroid/content/ContentResolver;->openOutputStream(Landroid/net/Uri;Ljava/lang/String;)Ljava/io/OutputStream;

    move-result-object v3
    :try_end_ad
    .catch Ljava/lang/Exception; {:try_start_a1 .. :try_end_ad} :catch_12b
    .catchall {:try_start_a1 .. :try_end_ad} :catchall_157

    if-eqz v3, :cond_117

    :try_start_af
    sget-object v4, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;

    const/16 v5, 0x5e

    invoke-virtual {p1, v4, v5, v3}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    move-result v4
    :try_end_b7
    .catchall {:try_start_af .. :try_end_b7} :catchall_11f

    if-eqz v4, :cond_117

    if-eqz v3, :cond_be

    :try_start_bb
    invoke-virtual {v3}, Ljava/io/OutputStream;->close()V

    :cond_be
    new-instance v3, Landroid/content/ContentValues;

    invoke-direct {v3}, Landroid/content/ContentValues;-><init>()V

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-virtual {v3, v0, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    invoke-virtual {v0, p2, v3, v1, v1}, Landroid/content/ContentResolver;->update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    :try_end_d3
    .catch Ljava/lang/Exception; {:try_start_bb .. :try_end_d3} :catch_12b
    .catchall {:try_start_bb .. :try_end_d3} :catchall_157

    nop

    const/high16 v0, 0x429c0000    # 78.0f

    :try_start_d6
    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v0

    int-to-float v2, v0

    invoke-virtual {p1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v3

    int-to-float v3, v3

    mul-float/2addr v2, v3

    invoke-virtual {p1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v3

    invoke-static {p3, v3}, Ljava/lang/Math;->max(II)I

    move-result v3

    int-to-float v3, v3

    div-float/2addr v2, v3

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    invoke-static {p3, v2}, Ljava/lang/Math;->max(II)I

    move-result v2

    const/high16 v3, 0x42c40000    # 98.0f

    invoke-direct {p0, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v3

    invoke-static {v3, v2}, Ljava/lang/Math;->min(II)I

    move-result v2

    invoke-static {p1, v2, v0, p3}, Landroid/graphics/Bitmap;->createScaledBitmap(Landroid/graphics/Bitmap;IIZ)Landroid/graphics/Bitmap;

    move-result-object p1
    :try_end_101
    .catchall {:try_start_d6 .. :try_end_101} :catchall_102

    goto :goto_104

    :catchall_102
    move-exception p1

    move-object p1, v1

    :goto_104
    nop

    nop

    :try_start_106
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    new-instance v2, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda33;

    invoke-direct {v2, p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda33;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/graphics/Bitmap;Landroid/net/Uri;)V

    invoke-virtual {v0, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_110
    .catch Ljava/lang/Exception; {:try_start_106 .. :try_end_110} :catch_114
    .catchall {:try_start_106 .. :try_end_110} :catchall_111

    goto :goto_156

    :catchall_111
    move-exception p1

    move v2, p3

    goto :goto_158

    :catch_114
    move-exception p1

    move v2, p3

    goto :goto_13d

    :cond_117
    :try_start_117
    new-instance p1, Ljava/io/IOException;

    const-string p3, "write failed"

    invoke-direct {p1, p3}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_11f
    .catchall {:try_start_117 .. :try_end_11f} :catchall_11f

    :catchall_11f
    move-exception p1

    if-eqz v3, :cond_12a

    :try_start_122
    invoke-virtual {v3}, Ljava/io/OutputStream;->close()V
    :try_end_125
    .catchall {:try_start_122 .. :try_end_125} :catchall_126

    goto :goto_12a

    :catchall_126
    move-exception p3

    :try_start_127
    invoke-virtual {p1, p3}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_12a
    :goto_12a
    throw p1

    :catch_12b
    move-exception p1

    goto :goto_13d

    :cond_12d
    new-instance p1, Ljava/io/IOException;

    const-string p3, "create failed"

    invoke-direct {p1, p3}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_135
    .catch Ljava/lang/Exception; {:try_start_127 .. :try_end_135} :catch_12b
    .catchall {:try_start_127 .. :try_end_135} :catchall_157

    :cond_135
    :try_start_135
    new-instance p1, Ljava/io/IOException;

    const-string p2, "\ud654\uba74 \uc601\uc0c1 \ud504\ub808\uc784\uc744 \uc77d\uc744 \uc218 \uc5c6\uc2b5\ub2c8\ub2e4"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_13d
    .catch Ljava/lang/Exception; {:try_start_135 .. :try_end_13d} :catch_3d
    .catchall {:try_start_135 .. :try_end_13d} :catchall_39

    :goto_13d
    :try_start_13d
    iget-object p3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    new-instance v0, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda34;

    invoke-direct {v0, p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda34;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Ljava/lang/Exception;)V

    invoke-virtual {p3, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_147
    .catchall {:try_start_13d .. :try_end_147} :catchall_157

    if-nez v2, :cond_156

    if-eqz p2, :cond_156

    :try_start_14b
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {p1}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p1

    invoke-virtual {p1, p2, v1, v1}, Landroid/content/ContentResolver;->delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I
    :try_end_154
    .catch Ljava/lang/Exception; {:try_start_14b .. :try_end_154} :catch_155

    goto :goto_156

    :catch_155
    move-exception p1

    :cond_156
    :goto_156
    return-void

    :catchall_157
    move-exception p1

    :goto_158
    if-nez v2, :cond_167

    if-eqz p2, :cond_167

    :try_start_15c
    iget-object p3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {p3}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p3

    invoke-virtual {p3, p2, v1, v1}, Landroid/content/ContentResolver;->delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I
    :try_end_165
    .catch Ljava/lang/Exception; {:try_start_15c .. :try_end_165} :catch_166

    goto :goto_167

    :catch_166
    move-exception p2

    :cond_167
    :goto_167
    throw p1
.end method

.method static synthetic lambda$getBitmap$23(Landroid/graphics/ImageDecoder;Landroid/graphics/ImageDecoder$ImageInfo;Landroid/graphics/ImageDecoder$Source;)V
    .locals 4

    invoke-virtual {p1}, Landroid/graphics/ImageDecoder$ImageInfo;->getSize()Landroid/util/Size;

    move-result-object p2

    invoke-virtual {p2}, Landroid/util/Size;->getWidth()I

    move-result p2

    const/4 v0, 0x1

    invoke-static {v0, p2}, Ljava/lang/Math;->max(II)I

    move-result p2

    invoke-virtual {p1}, Landroid/graphics/ImageDecoder$ImageInfo;->getSize()Landroid/util/Size;

    move-result-object p1

    invoke-virtual {p1}, Landroid/util/Size;->getHeight()I

    move-result p1

    invoke-static {v0, p1}, Ljava/lang/Math;->max(II)I

    move-result p1

    move v1, v0

    :goto_1a
    div-int v2, p2, v1

    const/16 v3, 0x8fc

    if-gt v2, v3, :cond_2c

    div-int v2, p1, v1

    if-le v2, v3, :cond_25

    goto :goto_2c

    :cond_25
    invoke-virtual {p0, v1}, Landroid/graphics/ImageDecoder;->setTargetSampleSize(I)V

    invoke-virtual {p0, v0}, Landroid/graphics/ImageDecoder;->setAllocator(I)V

    return-void

    :cond_2c
    :goto_2c
    mul-int/lit8 v1, v1, 0x2

    goto :goto_1a
.end method

.method private synthetic lambda$open$0(Landroid/view/View;)V
    .locals 0

    invoke-virtual {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->close()V

    return-void
.end method

.method private synthetic lambda$open$1(Landroid/view/MenuItem;)Z
    .locals 3

    invoke-interface {p1}, Landroid/view/MenuItem;->getItemId()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_b

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->openOriginal()V

    return v1

    :cond_b
    invoke-interface {p1}, Landroid/view/MenuItem;->getItemId()I

    move-result v0

    const/4 v2, 0x2

    if-ne v0, v2, :cond_16

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->shareOriginal()V

    return v1

    :cond_16
    invoke-interface {p1}, Landroid/view/MenuItem;->getItemId()I

    move-result p1

    const/4 v0, 0x3

    if-ne p1, v0, :cond_21

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->openLegacyDetails()V

    return v1

    :cond_21
    const/4 p1, 0x0

    return p1
.end method

.method private synthetic lambda$open$10(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->toggle()V

    return-void
.end method

.method private synthetic lambda$open$11(Landroid/view/View;)V
    .locals 0

    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoScrubMode:Z

    xor-int/lit8 p1, p1, 0x1

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->setVideoScrubMode(Z)V

    return-void
.end method

.method private synthetic lambda$open$12()V
    .locals 1

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_8

    const/4 v0, 0x0

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->updatePosition(F)V

    :cond_8
    return-void
.end method

.method private synthetic lambda$open$2(Landroid/widget/Button;Landroid/view/View;)V
    .locals 4

    new-instance p2, Landroid/widget/PopupMenu;

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {p2, v0, p1}, Landroid/widget/PopupMenu;-><init>(Landroid/content/Context;Landroid/view/View;)V

    invoke-virtual {p2}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    const-string v0, "\uc6d0\ubcf8 \uac24\ub7ec\ub9ac\uc5d0\uc11c \uc5f4\uae30"

    const/4 v1, 0x0

    const/4 v2, 0x1

    invoke-interface {p1, v1, v2, v1, v0}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    invoke-virtual {p2}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    const-string v0, "\uc0ac\uc9c4\u00b7\uc601\uc0c1 \uacf5\uc720"

    const/4 v3, 0x2

    invoke-interface {p1, v1, v3, v2, v0}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    invoke-virtual {p2}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    const/4 v0, 0x3

    const-string v2, "\ubaa8\uc544 \uae30\uc874 \uc0c1\uc138\u00b7GPS \ubcf4\uae30"

    invoke-interface {p1, v1, v0, v3, v2}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    new-instance p1, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda23;

    invoke-direct {p1, p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda23;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {p2, p1}, Landroid/widget/PopupMenu;->setOnMenuItemClickListener(Landroid/widget/PopupMenu$OnMenuItemClickListener;)V

    invoke-virtual {p2}, Landroid/widget/PopupMenu;->show()V

    return-void
.end method

.method private synthetic lambda$open$3(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225OpenNaver()V

    return-void
.end method

.method private synthetic lambda$open$4(Landroid/view/MenuItem;)Z
    .locals 3

    invoke-interface {p1}, Landroid/view/MenuItem;->getItemId()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_b

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->openOriginal()V

    return v1

    :cond_b
    invoke-interface {p1}, Landroid/view/MenuItem;->getItemId()I

    move-result v0

    const/4 v2, 0x2

    if-ne v0, v2, :cond_16

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->shareOriginal()V

    return v1

    :cond_16
    invoke-interface {p1}, Landroid/view/MenuItem;->getItemId()I

    move-result p1

    const/4 v0, 0x3

    if-ne p1, v0, :cond_21

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->openLegacyDetails()V

    return v1

    :cond_21
    const/4 p1, 0x0

    return p1
.end method

.method private synthetic lambda$open$5(Landroid/view/View;)Z
    .locals 6

    new-instance p1, Landroid/widget/PopupMenu;

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Info:Landroid/widget/LinearLayout;

    invoke-direct {p1, v0, v1}, Landroid/widget/PopupMenu;-><init>(Landroid/content/Context;Landroid/view/View;)V

    invoke-virtual {p1}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object v0

    const-string v1, "\uc6d0\ubcf8 \uac24\ub7ec\ub9ac\uc5d0\uc11c \uc5f4\uae30"

    const/4 v2, 0x0

    const/4 v3, 0x1

    invoke-interface {v0, v2, v3, v2, v1}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    invoke-virtual {p1}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object v0

    const-string v1, "\uc0ac\uc9c4\u00b7\uc601\uc0c1 \uacf5\uc720"

    const/4 v4, 0x2

    invoke-interface {v0, v2, v4, v3, v1}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    invoke-virtual {p1}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object v0

    const/4 v1, 0x3

    const-string v5, "\ubaa8\uc544 \uae30\uc874 \uc0c1\uc138\u00b7GPS \ubcf4\uae30"

    invoke-interface {v0, v2, v1, v4, v5}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    new-instance v0, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda36;

    invoke-direct {v0, p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda36;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {p1, v0}, Landroid/widget/PopupMenu;->setOnMenuItemClickListener(Landroid/widget/PopupMenu$OnMenuItemClickListener;)V

    invoke-virtual {p1}, Landroid/widget/PopupMenu;->show()V

    return v3
.end method

.method private synthetic lambda$open$6(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->capture()V

    return-void
.end method

.method private synthetic lambda$open$7(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->toggle()V

    return-void
.end method

.method private synthetic lambda$open$8(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->toggleMute()V

    return-void
.end method

.method private synthetic lambda$open$9(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->toggle()V

    return-void
.end method

.method private synthetic lambda$r187DispatchSeek$33(ILandroid/media/MediaPlayer;)V
    .locals 2

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    if-ne p2, v0, :cond_7a

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoToken:I

    if-ne p1, v0, :cond_7a

    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-nez p1, :cond_d

    goto :goto_7a

    :cond_d
    const/4 p1, 0x0

    iput-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekInFlight:Z

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubbingVideo:Z

    if-nez v0, :cond_18

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekReleased:Z

    if-eqz v0, :cond_29

    :cond_18
    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekWanted:I

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekIssued:I

    sub-int/2addr v0, v1

    invoke-static {v0}, Ljava/lang/Math;->abs(I)I

    move-result v0

    const/16 v1, 0x2d

    if-le v0, v1, :cond_29

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187ScheduleSeek()V

    return-void

    :cond_29
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekReleased:Z

    if-eqz v0, :cond_38

    iput-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekReleased:Z

    :try_start_2f
    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubWasPlaying:Z

    if-eqz p1, :cond_38

    invoke-virtual {p2}, Landroid/media/MediaPlayer;->start()V
    :try_end_36
    .catch Ljava/lang/Exception; {:try_start_2f .. :try_end_36} :catch_37

    goto :goto_38

    :catch_37
    move-exception p1

    :cond_38
    :goto_38
    :try_start_38
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    if-eqz p1, :cond_70

    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubbingVideo:Z

    if-nez p1, :cond_70

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    invoke-virtual {p2}, Landroid/media/MediaPlayer;->getCurrentPosition()I

    move-result p2

    int-to-long v0, p2

    invoke-direct {p0, v0, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->clock(J)Ljava/lang/String;

    move-result-object p2

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoLengthMs()I

    move-result v0

    int-to-long v0, v0

    invoke-direct {p0, v0, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->clock(J)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v1, " / "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    :try_end_6e
    .catch Ljava/lang/Exception; {:try_start_38 .. :try_end_6e} :catch_6f

    goto :goto_70

    :catch_6f
    move-exception p1

    :cond_70
    :goto_70
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    if-eqz p1, :cond_79

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    invoke-virtual {p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;->invalidate()V

    :cond_79
    return-void

    :cond_7a
    :goto_7a
    return-void
.end method

.method private synthetic lambda$r187ScheduleSeek$34(I)V
    .locals 1

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187PendingDispatch:Ljava/lang/Runnable;

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_e

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoToken:I

    if-ne p1, v0, :cond_e

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187DispatchSeek()V

    :cond_e
    return-void
.end method

.method private synthetic lambda$r203SnapNearest$24(Landroid/animation/ValueAnimator;Landroid/animation/ValueAnimator;)V
    .locals 1

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Snap:Landroid/animation/ValueAnimator;

    if-ne v0, p1, :cond_15

    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz p1, :cond_15

    invoke-virtual {p2}, Landroid/animation/ValueAnimator;->getAnimatedValue()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Float;

    invoke-virtual {p1}, Ljava/lang/Float;->floatValue()F

    move-result p1

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Present(F)V

    :cond_15
    return-void
.end method

.method static synthetic lambda$r205PressFeedback$13(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 2

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result p1

    if-nez p1, :cond_26

    invoke-virtual {p0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object p1

    invoke-virtual {p1}, Landroid/view/ViewPropertyAnimator;->cancel()V

    invoke-virtual {p0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    const p1, 0x3f68f5c3    # 0.91f

    invoke-virtual {p0, p1}, Landroid/view/ViewPropertyAnimator;->scaleX(F)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/view/ViewPropertyAnimator;->scaleY(F)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    const-wide/16 v0, 0x4b

    invoke-virtual {p0, v0, v1}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewPropertyAnimator;->start()V

    goto :goto_56

    :cond_26
    const/4 v0, 0x1

    if-eq p1, v0, :cond_2c

    const/4 v0, 0x3

    if-ne p1, v0, :cond_56

    :cond_2c
    invoke-virtual {p0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object p1

    invoke-virtual {p1}, Landroid/view/ViewPropertyAnimator;->cancel()V

    invoke-virtual {p0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    const/high16 p1, 0x3f800000    # 1.0f

    invoke-virtual {p0, p1}, Landroid/view/ViewPropertyAnimator;->scaleX(F)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/view/ViewPropertyAnimator;->scaleY(F)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    const-wide/16 v0, 0x91

    invoke-virtual {p0, v0, v1}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    new-instance p1, Landroid/view/animation/OvershootInterpolator;

    const v0, 0x3f59999a    # 0.85f

    invoke-direct {p1, v0}, Landroid/view/animation/OvershootInterpolator;-><init>(F)V

    invoke-virtual {p0, p1}, Landroid/view/ViewPropertyAnimator;->setInterpolator(Landroid/animation/TimeInterpolator;)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewPropertyAnimator;->start()V

    :cond_56
    :goto_56
    const/4 p0, 0x0

    return p0
.end method

.method private synthetic lambda$r205ShowCapturePreview$39(Landroid/net/Uri;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207OpenSavedPhoto(Landroid/net/Uri;)V

    return-void
.end method

.method private synthetic lambda$r205ShowCapturePreview$40(Landroid/widget/ImageView;)V
    .locals 1

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    if-ne v0, p1, :cond_1b

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    invoke-virtual {p1, v0}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    invoke-virtual {p1}, Landroid/widget/ImageView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_1b

    invoke-virtual {p1}, Landroid/widget/ImageView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    invoke-virtual {v0, p1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :cond_1b
    return-void
.end method

.method private synthetic lambda$r205ShowCapturePreview$41(Landroid/widget/ImageView;)V
    .locals 3

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    if-eq v0, p1, :cond_5

    return-void

    :cond_5
    invoke-virtual {p1}, Landroid/widget/ImageView;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/ViewPropertyAnimator;->alpha(F)Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    const/high16 v1, 0x41000000    # 8.0f

    invoke-direct {p0, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v1

    neg-int v1, v1

    int-to-float v1, v1

    invoke-virtual {v0, v1}, Landroid/view/ViewPropertyAnimator;->translationY(F)Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    const-wide/16 v1, 0xb4

    invoke-virtual {v0, v1, v2}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    new-instance v1, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda40;

    invoke-direct {v1, p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda40;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/widget/ImageView;)V

    invoke-virtual {v0, v1}, Landroid/view/ViewPropertyAnimator;->withEndAction(Ljava/lang/Runnable;)Landroid/view/ViewPropertyAnimator;

    move-result-object p1

    invoke-virtual {p1}, Landroid/view/ViewPropertyAnimator;->start()V

    return-void
.end method

.method private synthetic lambda$r207OpenSavedPhoto$35(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207CloseSavedPhoto()V

    return-void
.end method

.method private synthetic lambda$r207OpenSavedPhoto$36(Landroid/view/View;ILandroid/view/KeyEvent;)Z
    .locals 0

    const/4 p1, 0x4

    if-ne p2, p1, :cond_e

    invoke-virtual {p3}, Landroid/view/KeyEvent;->getAction()I

    move-result p1

    const/4 p2, 0x1

    if-ne p1, p2, :cond_e

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207CloseSavedPhoto()V

    return p2

    :cond_e
    const/4 p1, 0x0

    return p1
.end method

.method private synthetic lambda$r207OpenSavedPhoto$37(ILandroid/widget/FrameLayout;Landroid/graphics/Bitmap;Landroid/widget/ImageView;)V
    .locals 1

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoLoadGeneration:I

    if-ne p1, v0, :cond_20

    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz p1, :cond_20

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoViewer:Landroid/widget/FrameLayout;

    if-eq p1, p2, :cond_d

    goto :goto_20

    :cond_d
    if-eqz p3, :cond_13

    invoke-virtual {p4, p3}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    goto :goto_1f

    :cond_13
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    const-string p2, "\uc800\uc7a5\ud55c \uc0ac\uc9c4\uc744 \uc5f4 \uc218 \uc5c6\uc5b4\uc694"

    const/4 p3, 0x0

    invoke-static {p1, p2, p3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    :goto_1f
    return-void

    :cond_20
    :goto_20
    return-void
.end method

.method private synthetic lambda$r207OpenSavedPhoto$38(Landroid/net/Uri;ILandroid/widget/FrameLayout;Landroid/widget/ImageView;)V
    .locals 7

    nop

    const/4 v0, 0x0

    :try_start_2
    new-instance v1, Landroid/graphics/BitmapFactory$Options;

    invoke-direct {v1}, Landroid/graphics/BitmapFactory$Options;-><init>()V

    const/4 v2, 0x1

    iput-boolean v2, v1, Landroid/graphics/BitmapFactory$Options;->inJustDecodeBounds:Z

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v3}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    invoke-virtual {v3, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v3
    :try_end_14
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_14} :catch_66

    if-eqz v3, :cond_26

    :try_start_16
    invoke-static {v3, v0, v1}, Landroid/graphics/BitmapFactory;->decodeStream(Ljava/io/InputStream;Landroid/graphics/Rect;Landroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;
    :try_end_19
    .catchall {:try_start_16 .. :try_end_19} :catchall_1a

    goto :goto_26

    :catchall_1a
    move-exception p1

    if-eqz v3, :cond_25

    :try_start_1d
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    :try_end_20
    .catchall {:try_start_1d .. :try_end_20} :catchall_21

    goto :goto_25

    :catchall_21
    move-exception v1

    :try_start_22
    invoke-virtual {p1, v1}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_25
    :goto_25
    throw p1

    :cond_26
    :goto_26
    if-eqz v3, :cond_2b

    invoke-virtual {v3}, Ljava/io/InputStream;->close()V

    :cond_2b
    iget v3, v1, Landroid/graphics/BitmapFactory$Options;->outWidth:I

    iget v1, v1, Landroid/graphics/BitmapFactory$Options;->outHeight:I

    invoke-static {v3, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    :goto_33
    div-int v3, v1, v2

    const/16 v4, 0x1000

    if-le v3, v4, :cond_3c

    mul-int/lit8 v2, v2, 0x2

    goto :goto_33

    :cond_3c
    new-instance v1, Landroid/graphics/BitmapFactory$Options;

    invoke-direct {v1}, Landroid/graphics/BitmapFactory$Options;-><init>()V

    iput v2, v1, Landroid/graphics/BitmapFactory$Options;->inSampleSize:I

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v2}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    invoke-virtual {v2, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object p1
    :try_end_4d
    .catch Ljava/lang/Exception; {:try_start_22 .. :try_end_4d} :catch_66

    if-eqz p1, :cond_60

    :try_start_4f
    invoke-static {p1, v0, v1}, Landroid/graphics/BitmapFactory;->decodeStream(Ljava/io/InputStream;Landroid/graphics/Rect;Landroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;

    move-result-object v0
    :try_end_53
    .catchall {:try_start_4f .. :try_end_53} :catchall_54

    goto :goto_60

    :catchall_54
    move-exception v1

    if-eqz p1, :cond_5f

    :try_start_57
    invoke-virtual {p1}, Ljava/io/InputStream;->close()V
    :try_end_5a
    .catchall {:try_start_57 .. :try_end_5a} :catchall_5b

    goto :goto_5f

    :catchall_5b
    move-exception p1

    :try_start_5c
    invoke-virtual {v1, p1}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_5f
    :goto_5f
    throw v1

    :cond_60
    :goto_60
    if-eqz p1, :cond_67

    invoke-virtual {p1}, Ljava/io/InputStream;->close()V
    :try_end_65
    .catch Ljava/lang/Exception; {:try_start_5c .. :try_end_65} :catch_66

    goto :goto_67

    :catch_66
    move-exception p1

    :cond_67
    :goto_67
    move-object v5, v0

    nop

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    new-instance v0, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda31;

    move-object v1, v0

    move-object v2, p0

    move v3, p2

    move-object v4, p3

    move-object v6, p4

    invoke-direct/range {v1 .. v6}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda31;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;ILandroid/widget/FrameLayout;Landroid/graphics/Bitmap;Landroid/widget/ImageView;)V

    invoke-virtual {p1, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private synthetic lambda$r225LoadMediaMetadata$19(ILjava/lang/String;JZDD)V
    .locals 8

    move-object v0, p0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetadataCurrent(ILjava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_8

    return-void

    :cond_8
    const-wide/16 v1, 0x0

    cmp-long v1, p3, v1

    if-lez v1, :cond_12

    invoke-direct/range {p0 .. p5}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225SetTime(ILjava/lang/String;JZ)V

    goto :goto_1d

    :cond_12
    iget-boolean v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225HasTime:Z

    if-nez v1, :cond_1d

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225CaptureTime:Landroid/widget/TextView;

    const-string v2, "\ucd2c\uc601 \uc2dc\uac04 \uc815\ubcf4 \uc5c6\uc74c"

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_1d
    :goto_1d
    invoke-static/range {p6 .. p9}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225GoodGps(DD)Z

    move-result v1

    if-eqz v1, :cond_2f

    const-string v7, ""

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-wide v3, p6

    move-wide/from16 v5, p8

    invoke-direct/range {v0 .. v7}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225SetGps(ILjava/lang/String;DDLjava/lang/String;)V

    goto :goto_52

    :cond_2f
    iget-wide v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lat:D

    iget-wide v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lon:D

    invoke-static {v1, v2, v3, v4}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225GoodGps(DD)Z

    move-result v1

    if-nez v1, :cond_52

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    const-string v2, "android.permission.ACCESS_MEDIA_LOCATION"

    invoke-virtual {v1, v2}, Landroid/app/Activity;->checkSelfPermission(Ljava/lang/String;)I

    move-result v1

    if-eqz v1, :cond_45

    const/4 v1, 0x1

    goto :goto_46

    :cond_45
    const/4 v1, 0x0

    :goto_46
    iget-object v0, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Address:Landroid/widget/TextView;

    if-eqz v1, :cond_4d

    const-string v1, "\uc6d0\ubcf8 \uc704\uce58\uc815\ubcf4 \uc811\uadfc \uad8c\ud55c \ud544\uc694 \u00b7 \uc9c0\ub3c4 \uc0c9\uc778 \ud655\uc778 \uc911"

    goto :goto_4f

    :cond_4d
    const-string v1, "\uc6d0\ubcf8 GPS \uc815\ubcf4\uac00 \uc5c6\ub294 \uc0ac\uc9c4 \u00b7 \uc9c0\ub3c4 \uc0c9\uc778 \ud655\uc778 \uc911"

    :goto_4f
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_52
    :goto_52
    return-void
.end method

.method private synthetic lambda$r225LoadWebIndex$18(ILjava/lang/String;Ljava/lang/String;)V
    .locals 14

    move-object/from16 v0, p3

    const-string v1, "lon"

    const-string v2, "lat"

    invoke-direct/range {p0 .. p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetadataCurrent(ILjava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_58

    if-nez v0, :cond_f

    goto :goto_58

    :cond_f
    :try_start_f
    new-instance v3, Lorg/json/JSONTokener;

    invoke-direct {v3, v0}, Lorg/json/JSONTokener;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3}, Lorg/json/JSONTokener;->nextValue()Ljava/lang/Object;

    move-result-object v0

    new-instance v3, Lorg/json/JSONObject;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v3, v0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v0, "t"

    const-wide/16 v4, 0x0

    invoke-virtual {v3, v0, v4, v5}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide v9

    cmp-long v0, v9, v4

    if-lez v0, :cond_35

    const/4 v11, 0x1

    move-object v6, p0

    move v7, p1

    move-object/from16 v8, p2

    invoke-direct/range {v6 .. v11}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225SetTime(ILjava/lang/String;JZ)V

    :cond_35
    invoke-virtual {v3, v2}, Lorg/json/JSONObject;->isNull(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_56

    invoke-virtual {v3, v1}, Lorg/json/JSONObject;->isNull(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_56

    const-wide/high16 v4, 0x7ff8000000000000L    # Double.NaN

    invoke-virtual {v3, v2, v4, v5}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;D)D

    move-result-wide v9

    invoke-virtual {v3, v1, v4, v5}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;D)D

    move-result-wide v11

    const-string v13, ""

    move-object v6, p0

    move v7, p1

    move-object/from16 v8, p2

    invoke-direct/range {v6 .. v13}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225SetGps(ILjava/lang/String;DDLjava/lang/String;)V
    :try_end_54
    .catch Ljava/lang/Exception; {:try_start_f .. :try_end_54} :catch_55

    goto :goto_56

    :catch_55
    move-exception v0

    :cond_56
    :goto_56
    nop

    return-void

    :cond_58
    :goto_58
    return-void
.end method

.method private synthetic lambda$r225ScheduleMeta$14(ILjava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225LoadMediaMetadata(ILjava/lang/String;)V

    return-void
.end method

.method private synthetic lambda$r225ScheduleMeta$15(ILjava/lang/String;)V
    .locals 2

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225PendingMeta:Ljava/lang/Runnable;

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetadataCurrent(ILjava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_a

    return-void

    :cond_a
    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225LoadWebIndex(ILjava/lang/String;)V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetadataWorker:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda16;

    invoke-direct {v1, p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda16;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;ILjava/lang/String;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method private synthetic lambda$r225SetGps$16(ILjava/lang/String;DDLjava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetadataCurrent(ILjava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_3b

    iget-wide p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lat:D

    cmpl-double p1, p1, p3

    if-nez p1, :cond_3b

    iget-wide p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lon:D

    cmpl-double p1, p1, p5

    if-eqz p1, :cond_13

    goto :goto_3b

    :cond_13
    invoke-virtual {p7}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-nez p1, :cond_21

    iput-object p7, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225ResolvedAddress:Ljava/lang/String;

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Address:Landroid/widget/TextView;

    invoke-virtual {p1, p7}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_3a

    :cond_21
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Address:Landroid/widget/TextView;

    sget-object p2, Ljava/util/Locale;->KOREA:Ljava/util/Locale;

    invoke-static {p3, p4}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object p3

    invoke-static {p5, p6}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object p4

    filled-new-array {p3, p4}, [Ljava/lang/Object;

    move-result-object p3

    const-string p4, "GPS %.6f, %.6f \u00b7 \uc0c1\uc138\uc8fc\uc18c \ubbf8\ud655\uc778"

    invoke-static {p2, p4, p3}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :goto_3a
    return-void

    :cond_3b
    :goto_3b
    return-void
.end method

.method private synthetic lambda$r225SetGps$17(DDILjava/lang/String;)V
    .locals 11

    move-object v2, p0

    const-string v1, ""

    :try_start_3
    new-instance v3, Landroid/location/Geocoder;

    iget-object v0, v2, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    sget-object v4, Ljava/util/Locale;->KOREAN:Ljava/util/Locale;

    invoke-direct {v3, v0, v4}, Landroid/location/Geocoder;-><init>(Landroid/content/Context;Ljava/util/Locale;)V

    const/4 v8, 0x1

    move-wide v4, p1

    move-wide v6, p3

    invoke-virtual/range {v3 .. v8}, Landroid/location/Geocoder;->getFromLocation(DDI)Ljava/util/List;

    move-result-object v0

    if-eqz v0, :cond_34

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_34

    const/4 v3, 0x0

    invoke-interface {v0, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    if-eqz v4, :cond_34

    invoke-interface {v0, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/location/Address;

    invoke-virtual {v0, v3}, Landroid/location/Address;->getAddressLine(I)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_34

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1
    :try_end_32
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_32} :catch_33

    goto :goto_34

    :catch_33
    move-exception v0

    :cond_34
    :goto_34
    move-object v9, v1

    nop

    iget-object v0, v2, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    new-instance v10, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda22;

    move-object v1, v10

    move-object v2, p0

    move/from16 v3, p5

    move-object/from16 v4, p6

    move-wide v5, p1

    move-wide v7, p3

    invoke-direct/range {v1 .. v9}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda22;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;ILjava/lang/String;DDLjava/lang/String;)V

    invoke-virtual {v0, v10}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private synthetic lambda$refreshPages$21(IIILandroid/widget/ImageView;Landroid/graphics/Bitmap;)V
    .locals 1

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_23

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadToken:I

    if-ne p1, v0, :cond_23

    iget p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    add-int/2addr p1, p3

    add-int/lit8 p1, p1, -0x1

    if-ne p2, p1, :cond_23

    invoke-virtual {p4}, Landroid/widget/ImageView;->isAttachedToWindow()Z

    move-result p1

    if-eqz p1, :cond_23

    if-eqz p5, :cond_23

    invoke-virtual {p4, p5}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    if-eqz p1, :cond_23

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    invoke-virtual {p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;->invalidate()V

    :cond_23
    return-void
.end method

.method private synthetic lambda$refreshPages$22(Ljava/lang/String;IIILandroid/widget/ImageView;)V
    .locals 8

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->video(Ljava/lang/String;)Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    invoke-direct {p0, p1, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->getBitmap(Ljava/lang/String;Z)Landroid/graphics/Bitmap;

    move-result-object v7

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    new-instance v0, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda44;

    move-object v1, v0

    move-object v2, p0

    move v3, p2

    move v4, p3

    move v5, p4

    move-object v6, p5

    invoke-direct/range {v1 .. v7}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda44;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;IIILandroid/widget/ImageView;Landroid/graphics/Bitmap;)V

    invoke-virtual {p1, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private synthetic lambda$registerBack$20()V
    .locals 1

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoViewer:Landroid/widget/FrameLayout;

    if-eqz v0, :cond_8

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207CloseSavedPhoto()V

    goto :goto_b

    :cond_8
    invoke-virtual {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->close()V

    :goto_b
    return-void
.end method

.method static synthetic lambda$requestScrubFrames$30(ILjava/lang/Integer;Ljava/lang/Integer;)I
    .locals 0

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    sub-int/2addr p1, p0

    invoke-static {p1}, Ljava/lang/Math;->abs(I)I

    move-result p1

    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result p2

    sub-int/2addr p2, p0

    invoke-static {p2}, Ljava/lang/Math;->abs(I)I

    move-result p0

    invoke-static {p1, p0}, Ljava/lang/Integer;->compare(II)I

    move-result p0

    return p0
.end method

.method private synthetic lambda$requestScrubFrames$31(ILjava/lang/String;Ljava/util/HashMap;)V
    .locals 1

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_29

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameToken:I

    if-ne p1, v0, :cond_29

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    invoke-virtual {p1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_29

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrames:Ljava/util/HashMap;

    invoke-virtual {p1, p3}, Ljava/util/HashMap;->putAll(Ljava/util/Map;)V

    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoScrubMode:Z

    if-eqz p1, :cond_43

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    if-eqz p1, :cond_43

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    invoke-virtual {p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;->invalidate()V

    goto :goto_43

    :cond_29
    invoke-virtual {p3}, Ljava/util/HashMap;->values()Ljava/util/Collection;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_31
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result p2

    if-eqz p2, :cond_43

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/graphics/Bitmap;

    :try_start_3d
    invoke-virtual {p2}, Landroid/graphics/Bitmap;->recycle()V
    :try_end_40
    .catch Ljava/lang/Exception; {:try_start_3d .. :try_end_40} :catch_41

    goto :goto_31

    :catch_41
    move-exception p2

    goto :goto_31

    :cond_43
    :goto_43
    return-void
.end method

.method private synthetic lambda$requestScrubFrames$32(Ljava/lang/String;IIII)V
    .locals 9

    new-instance v6, Landroid/media/MediaMetadataRetriever;

    invoke-direct {v6}, Landroid/media/MediaMetadataRetriever;-><init>()V

    :try_start_5
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->uri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    invoke-virtual {v6, v0, v1}, Landroid/media/MediaMetadataRetriever;->setDataSource(Landroid/content/Context;Landroid/net/Uri;)V

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    const/4 v1, 0x0

    :goto_14
    if-ge v1, p2, :cond_20

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_14

    :cond_20
    new-instance v1, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda29;

    invoke-direct {v1, p3}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda29;-><init>(I)V

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->sort(Ljava/util/Comparator;)V

    new-instance p3, Ljava/util/HashMap;

    invoke-direct {p3}, Ljava/util/HashMap;-><init>()V

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v7

    :goto_31
    invoke-interface {v7}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_78

    invoke-interface {v7}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v8

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameToken:I

    if-ne p4, v0, :cond_78

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-nez v0, :cond_4a

    goto :goto_78

    :cond_4a
    int-to-long v0, p5

    const-wide/16 v2, 0x3e8

    mul-long/2addr v0, v2

    int-to-long v2, v8

    mul-long/2addr v0, v2

    const/4 v2, 0x1

    add-int/lit8 v3, p2, -0x1

    invoke-static {v2, v3}, Ljava/lang/Math;->max(II)I

    move-result v2

    int-to-long v2, v2

    div-long v1, v0, v2
    :try_end_5a
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5a} :catch_8f
    .catchall {:try_start_5 .. :try_end_5a} :catchall_88

    nop

    const/high16 v0, 0x42900000    # 72.0f

    :try_start_5d
    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v4

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v5

    const/4 v3, 0x2

    move-object v0, v6

    invoke-virtual/range {v0 .. v5}, Landroid/media/MediaMetadataRetriever;->getScaledFrameAtTime(JIII)Landroid/graphics/Bitmap;

    move-result-object v0
    :try_end_6b
    .catch Ljava/lang/Exception; {:try_start_5d .. :try_end_6b} :catch_6c
    .catchall {:try_start_5d .. :try_end_6b} :catchall_88

    goto :goto_6e

    :catch_6c
    move-exception v0

    const/4 v0, 0x0

    :goto_6e
    if-eqz v0, :cond_77

    :try_start_70
    invoke-static {v8}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {p3, v1, v0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_77
    goto :goto_31

    :cond_78
    :goto_78
    iget-object p2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    new-instance p5, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda30;

    invoke-direct {p5, p0, p4, p1, p3}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda30;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;ILjava/lang/String;Ljava/util/HashMap;)V

    invoke-virtual {p2, p5}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_82
    .catch Ljava/lang/Exception; {:try_start_70 .. :try_end_82} :catch_8f
    .catchall {:try_start_70 .. :try_end_82} :catchall_88

    :try_start_82
    invoke-virtual {v6}, Landroid/media/MediaMetadataRetriever;->release()V
    :try_end_85
    .catch Ljava/lang/Exception; {:try_start_82 .. :try_end_85} :catch_86

    goto :goto_93

    :catch_86
    move-exception p1

    goto :goto_93

    :catchall_88
    move-exception p1

    :try_start_89
    invoke-virtual {v6}, Landroid/media/MediaMetadataRetriever;->release()V
    :try_end_8c
    .catch Ljava/lang/Exception; {:try_start_89 .. :try_end_8c} :catch_8d

    goto :goto_8e

    :catch_8d
    move-exception p2

    :goto_8e
    throw p1

    :catch_8f
    move-exception p1

    :try_start_90
    invoke-virtual {v6}, Landroid/media/MediaMetadataRetriever;->release()V
    :try_end_93
    .catch Ljava/lang/Exception; {:try_start_90 .. :try_end_93} :catch_86

    :goto_93
    return-void
.end method

.method private synthetic lambda$setVideoScrubMode$29(Landroid/animation/ValueAnimator;)V
    .locals 0

    invoke-virtual {p1}, Landroid/animation/ValueAnimator;->getAnimatedValue()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Float;

    invoke-virtual {p1}, Ljava/lang/Float;->floatValue()F

    move-result p1

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubExpansion:F

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    if-eqz p1, :cond_15

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    invoke-virtual {p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;->invalidate()V

    :cond_15
    return-void
.end method

.method private synthetic lambda$settle$25(Landroid/animation/ValueAnimator;)V
    .locals 0

    invoke-virtual {p1}, Landroid/animation/ValueAnimator;->getAnimatedValue()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Float;

    invoke-virtual {p1}, Ljava/lang/Float;->floatValue()F

    move-result p1

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->updatePosition(F)V

    return-void
.end method

.method private synthetic lambda$updateMediaVolume$28()V
    .locals 1

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_b

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeBubble:Landroid/view/View;

    if-eqz v0, :cond_b

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->anchorVolumeBubble()V

    :cond_b
    return-void
.end method

.method private synthetic lambda$videoFailure$26(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->openOriginal()V

    return-void
.end method

.method private navigate(I)V
    .locals 1

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_3b

    if-ltz p1, :cond_3b

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    if-ge p1, v0, :cond_3b

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    if-ne p1, v0, :cond_13

    goto :goto_3b

    :cond_13
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203CancelFling()V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->motion:Landroid/animation/ValueAnimator;

    if-eqz v0, :cond_22

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->motion:Landroid/animation/ValueAnimator;

    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->cancel()V

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->motion:Landroid/animation/ValueAnimator;

    :cond_22
    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    iget p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadToken:I

    add-int/lit8 p1, p1, 0x1

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadToken:I

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->resetPhotoZoom()V

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->teardownPlayer()V

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->refreshPages()V

    const/4 p1, 0x0

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->updatePosition(F)V

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepareCurrentVideo()V

    return-void

    :cond_3b
    :goto_3b
    return-void
.end method

.method private openLegacyDetails()V
    .locals 4

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_4a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_4a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->legacyDetails:Ljava/util/function/Consumer;

    if-nez v0, :cond_11

    goto :goto_4a

    :cond_11
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->currentDay:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v1

    const/16 v2, 0xa

    if-lt v1, v2, :cond_28

    const-string v1, "day"

    goto :goto_2a

    :cond_28
    const-string v1, "month"

    :goto_2a
    invoke-virtual {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->close()V

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->legacyDetails:Ljava/util/function/Consumer;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, "|"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-interface {v2, v0}, Ljava/util/function/Consumer;->accept(Ljava/lang/Object;)V

    return-void

    :cond_4a
    :goto_4a
    return-void
.end method

.method private openOriginal()V
    .locals 4

    :try_start_0
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_3d

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_d

    goto :goto_3d

    :cond_d
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->uri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    if-nez v1, :cond_1e

    return-void

    :cond_1e
    new-instance v2, Landroid/content/Intent;

    const-string v3, "android.intent.action.VIEW"

    invoke-direct {v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->video(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_2e

    const-string v0, "video/*"

    goto :goto_30

    :cond_2e
    const-string v0, "image/*"

    :goto_30
    invoke-virtual {v2, v1, v0}, Landroid/content/Intent;->setDataAndType(Landroid/net/Uri;Ljava/lang/String;)Landroid/content/Intent;

    const/4 v0, 0x1

    invoke-virtual {v2, v0}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v0, v2}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :try_end_3c
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_3c} :catch_3e

    goto :goto_3f

    :cond_3d
    :goto_3d
    return-void

    :catch_3e
    move-exception v0

    :goto_3f
    return-void
.end method

.method private prepareCurrentVideo()V
    .locals 6

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->muted:Z

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->updateMediaVolume()V

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v1, :cond_61

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    iget v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-direct {p0, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->video(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_1b

    goto :goto_61

    :cond_1b
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    iget v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    iget v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoToken:I

    add-int/2addr v2, v0

    iput v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoToken:I

    :try_start_2a
    new-instance v3, Landroid/view/TextureView;

    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v3, v4}, Landroid/view/TextureView;-><init>(Landroid/content/Context;)V

    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/view/TextureView;->setOpaque(Z)V

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/view/TextureView;->setAlpha(F)V

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pages:[Landroid/widget/FrameLayout;

    aget-object v0, v3, v0

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v5, -0x1

    invoke-direct {v4, v5, v5}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v3, v4}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubPreview:Landroid/widget/ImageView;

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    new-instance v3, Lcom/juhyeon/familyjourney/MoaNativeGallery$7;

    invoke-direct {v3, p0, v2, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$7;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;ILjava/lang/String;)V

    invoke-virtual {v0, v3}, Landroid/view/TextureView;->setSurfaceTextureListener(Landroid/view/TextureView$SurfaceTextureListener;)V
    :try_end_5b
    .catch Ljava/lang/Exception; {:try_start_2a .. :try_end_5b} :catch_5c

    goto :goto_60

    :catch_5c
    move-exception v0

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoFailure()V

    :goto_60
    return-void

    :cond_61
    :goto_61
    return-void
.end method

.method private r187DispatchSeek()V
    .locals 6

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    if-eqz v0, :cond_50

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    if-eqz v0, :cond_50

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_50

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekInFlight:Z

    if-eqz v0, :cond_11

    goto :goto_50

    :cond_11
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoToken:I

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoLengthMs()I

    move-result v2

    iget v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekWanted:I

    invoke-static {v2, v3}, Ljava/lang/Math;->min(II)I

    move-result v2

    const/4 v3, 0x0

    invoke-static {v3, v2}, Ljava/lang/Math;->max(II)I

    move-result v2

    iput v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekIssued:I

    const/4 v4, 0x1

    iput-boolean v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekInFlight:Z

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v4

    iput-wide v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187LastSeekTime:J

    :try_start_2f
    new-instance v4, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda28;

    invoke-direct {v4, p0, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda28;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;I)V

    invoke-virtual {v0, v4}, Landroid/media/MediaPlayer;->setOnSeekCompleteListener(Landroid/media/MediaPlayer$OnSeekCompleteListener;)V

    int-to-long v1, v2

    const/4 v4, 0x3

    invoke-virtual {v0, v1, v2, v4}, Landroid/media/MediaPlayer;->seekTo(JI)V
    :try_end_3c
    .catch Ljava/lang/Exception; {:try_start_2f .. :try_end_3c} :catch_3d

    goto :goto_4f

    :catch_3d
    move-exception v1

    iput-boolean v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekInFlight:Z

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekReleased:Z

    if-eqz v1, :cond_4f

    iput-boolean v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekReleased:Z

    :try_start_46
    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubWasPlaying:Z

    if-eqz v1, :cond_4f

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->start()V
    :try_end_4d
    .catch Ljava/lang/Exception; {:try_start_46 .. :try_end_4d} :catch_4e

    goto :goto_4f

    :catch_4e
    move-exception v0

    :cond_4f
    :goto_4f
    return-void

    :cond_50
    :goto_50
    return-void
.end method

.method private r187ScheduleSeek()V
    .locals 7

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    if-eqz v0, :cond_42

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    if-eqz v0, :cond_42

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_42

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekInFlight:Z

    if-eqz v0, :cond_11

    goto :goto_42

    :cond_11
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187PendingDispatch:Ljava/lang/Runnable;

    if-eqz v0, :cond_1c

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187PendingDispatch:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    :cond_1c
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    iget-wide v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187LastSeekTime:J

    sub-long/2addr v0, v2

    iget-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekReleased:Z

    const-wide/16 v3, 0x0

    if-eqz v2, :cond_2a

    goto :goto_31

    :cond_2a
    const-wide/16 v5, 0x55

    sub-long/2addr v5, v0

    invoke-static {v3, v4, v5, v6}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v3

    :goto_31
    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoToken:I

    new-instance v1, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda24;

    invoke-direct {v1, p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda24;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;I)V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187PendingDispatch:Ljava/lang/Runnable;

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187PendingDispatch:Ljava/lang/Runnable;

    invoke-virtual {v0, v1, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void

    :cond_42
    :goto_42
    return-void
.end method

.method private r201DrawSceneFrames(Landroid/graphics/Canvas;Landroid/graphics/Paint;Landroid/graphics/RectF;)V
    .locals 21

    move-object/from16 v0, p0

    move-object/from16 v7, p1

    move-object/from16 v8, p2

    move-object/from16 v9, p3

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_1d1

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    iget v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-direct {v0, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->video(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_22

    goto/16 :goto_1d1

    :cond_22
    iget v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameCount:I

    const/4 v10, 0x2

    invoke-static {v10, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    invoke-direct/range {p0 .. p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoLengthMs()I

    move-result v2

    const/high16 v3, 0x42180000    # 38.0f

    invoke-direct {v0, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v3

    int-to-float v11, v3

    invoke-virtual/range {p3 .. p3}, Landroid/graphics/RectF;->width()F

    move-result v3

    const/high16 v12, 0x3f800000    # 1.0f

    invoke-static {v12, v11}, Ljava/lang/Math;->max(FF)F

    move-result v4

    div-float/2addr v3, v4

    int-to-float v4, v1

    sub-float v5, v4, v12

    invoke-direct/range {p0 .. p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoPositionMs()I

    move-result v6

    int-to-float v6, v6

    const/4 v13, 0x1

    invoke-static {v13, v2}, Ljava/lang/Math;->max(II)I

    move-result v2

    int-to-float v2, v2

    div-float/2addr v6, v2

    sub-int/2addr v1, v13

    int-to-float v2, v1

    mul-float/2addr v6, v2

    invoke-static {v5, v6}, Ljava/lang/Math;->min(FF)F

    move-result v2

    const/4 v5, 0x0

    invoke-static {v5, v2}, Ljava/lang/Math;->max(FF)F

    move-result v14

    sub-float/2addr v4, v3

    invoke-static {v5, v4}, Ljava/lang/Math;->max(FF)F

    move-result v2

    const/high16 v15, 0x3f000000    # 0.5f

    mul-float v4, v3, v15

    sub-float v4, v14, v4

    invoke-static {v2, v4}, Ljava/lang/Math;->min(FF)F

    move-result v2

    invoke-static {v5, v2}, Ljava/lang/Math;->max(FF)F

    move-result v6

    float-to-double v4, v6

    invoke-static {v4, v5}, Ljava/lang/Math;->floor(D)D

    move-result-wide v4

    double-to-int v2, v4

    const/4 v4, 0x0

    invoke-static {v4, v2}, Ljava/lang/Math;->max(II)I

    move-result v2

    add-float/2addr v3, v6

    float-to-double v3, v3

    invoke-static {v3, v4}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v3

    double-to-int v3, v3

    invoke-static {v1, v3}, Ljava/lang/Math;->min(II)I

    move-result v5

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->posters:Landroid/util/LruCache;

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    iget v4, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    invoke-virtual {v3, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    invoke-virtual {v1, v3}, Landroid/util/LruCache;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    move-object/from16 v16, v1

    check-cast v16, Landroid/graphics/Bitmap;

    move v4, v2

    :goto_98
    if-gt v4, v5, :cond_186

    iget v1, v9, Landroid/graphics/RectF;->left:F

    int-to-float v2, v4

    sub-float/2addr v2, v6

    mul-float/2addr v2, v11

    add-float/2addr v1, v2

    new-instance v2, Landroid/graphics/RectF;

    iget v3, v9, Landroid/graphics/RectF;->top:F

    add-float v17, v1, v11

    invoke-direct {v0, v12}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v15

    int-to-float v15, v15

    add-float v15, v17, v15

    iget v12, v9, Landroid/graphics/RectF;->bottom:F

    invoke-direct {v2, v1, v3, v15, v12}, Landroid/graphics/RectF;-><init>(FFFF)V

    const v1, -0xe4e1dc

    invoke-virtual {v8, v1}, Landroid/graphics/Paint;->setColor(I)V

    invoke-virtual {v7, v2, v8}, Landroid/graphics/Canvas;->drawRect(Landroid/graphics/RectF;Landroid/graphics/Paint;)V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrames:Ljava/util/HashMap;

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/graphics/Bitmap;

    if-eqz v1, :cond_cf

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v3

    if-eqz v3, :cond_d1

    :cond_cf
    move-object/from16 v1, v16

    :cond_d1
    if-eqz v1, :cond_153

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v3

    if-nez v3, :cond_153

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v3

    if-lez v3, :cond_153

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v3

    if-lez v3, :cond_153

    invoke-virtual {v2}, Landroid/graphics/RectF;->width()F

    move-result v3

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v12

    int-to-float v12, v12

    div-float/2addr v3, v12

    invoke-virtual {v2}, Landroid/graphics/RectF;->height()F

    move-result v12

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v15

    int-to-float v15, v15

    div-float/2addr v12, v15

    invoke-static {v3, v12}, Ljava/lang/Math;->max(FF)F

    move-result v3

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v12

    invoke-virtual {v2}, Landroid/graphics/RectF;->width()F

    move-result v15

    div-float/2addr v15, v3

    invoke-static {v15}, Ljava/lang/Math;->round(F)I

    move-result v15

    invoke-static {v12, v15}, Ljava/lang/Math;->min(II)I

    move-result v12

    invoke-static {v13, v12}, Ljava/lang/Math;->max(II)I

    move-result v12

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v15

    invoke-virtual {v2}, Landroid/graphics/RectF;->height()F

    move-result v19

    div-float v19, v19, v3

    invoke-static/range {v19 .. v19}, Ljava/lang/Math;->round(F)I

    move-result v3

    invoke-static {v15, v3}, Ljava/lang/Math;->min(II)I

    move-result v3

    invoke-static {v13, v3}, Ljava/lang/Math;->max(II)I

    move-result v3

    new-instance v15, Landroid/graphics/Rect;

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v19

    sub-int v19, v19, v12

    div-int/lit8 v13, v19, 0x2

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v19

    sub-int v19, v19, v3

    move/from16 v20, v4

    div-int/lit8 v4, v19, 0x2

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v19

    add-int v19, v19, v12

    div-int/lit8 v12, v19, 0x2

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v19

    add-int v19, v19, v3

    div-int/lit8 v3, v19, 0x2

    invoke-direct {v15, v13, v4, v12, v3}, Landroid/graphics/Rect;-><init>(IIII)V

    invoke-virtual {v7, v1, v15, v2, v8}, Landroid/graphics/Canvas;->drawBitmap(Landroid/graphics/Bitmap;Landroid/graphics/Rect;Landroid/graphics/RectF;Landroid/graphics/Paint;)V

    goto :goto_155

    :cond_153
    move/from16 v20, v4

    :goto_155
    const v1, 0x55ffffff    # 3.518437E13f

    invoke-virtual {v8, v1}, Landroid/graphics/Paint;->setColor(I)V

    const/high16 v12, 0x3f000000    # 0.5f

    invoke-direct {v0, v12}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v1

    int-to-float v1, v1

    invoke-virtual {v8, v1}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    iget v3, v2, Landroid/graphics/RectF;->right:F

    iget v4, v2, Landroid/graphics/RectF;->top:F

    iget v13, v2, Landroid/graphics/RectF;->right:F

    iget v15, v2, Landroid/graphics/RectF;->bottom:F

    move-object/from16 v1, p1

    move v2, v3

    move v3, v4

    move/from16 v18, v20

    move v4, v13

    move v13, v5

    move v5, v15

    move v15, v6

    move-object/from16 v6, p2

    invoke-virtual/range {v1 .. v6}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    add-int/lit8 v4, v18, 0x1

    move v5, v13

    move v6, v15

    const/4 v13, 0x1

    move v15, v12

    const/high16 v12, 0x3f800000    # 1.0f

    goto/16 :goto_98

    :cond_186
    move v15, v6

    iget v1, v9, Landroid/graphics/RectF;->left:F

    const/high16 v2, 0x3f800000    # 1.0f

    invoke-direct {v0, v2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v3

    int-to-float v3, v3

    add-float/2addr v1, v3

    iget v3, v9, Landroid/graphics/RectF;->right:F

    invoke-direct {v0, v2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v2

    int-to-float v2, v2

    sub-float/2addr v3, v2

    iget v2, v9, Landroid/graphics/RectF;->left:F

    sub-float/2addr v14, v15

    mul-float/2addr v14, v11

    add-float/2addr v2, v14

    invoke-static {v3, v2}, Ljava/lang/Math;->min(FF)F

    move-result v2

    invoke-static {v1, v2}, Ljava/lang/Math;->max(FF)F

    move-result v1

    const/4 v2, -0x1

    invoke-virtual {v8, v2}, Landroid/graphics/Paint;->setColor(I)V

    new-instance v2, Landroid/graphics/RectF;

    const v3, 0x3fb33333    # 1.4f

    invoke-direct {v0, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v4

    int-to-float v4, v4

    sub-float v4, v1, v4

    iget v5, v9, Landroid/graphics/RectF;->top:F

    invoke-direct {v0, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v6

    int-to-float v6, v6

    add-float/2addr v1, v6

    iget v6, v9, Landroid/graphics/RectF;->bottom:F

    invoke-direct {v2, v4, v5, v1, v6}, Landroid/graphics/RectF;-><init>(FFFF)V

    invoke-direct {v0, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v1

    int-to-float v1, v1

    invoke-direct {v0, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v0

    int-to-float v0, v0

    invoke-virtual {v7, v2, v1, v0, v8}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V

    return-void

    :cond_1d1
    :goto_1d1
    return-void
.end method

.method private r203CancelFling()V
    .locals 3

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203FlingFrame:Ljava/lang/Runnable;

    const/4 v1, 0x0

    if-eqz v0, :cond_e

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203FlingFrame:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203FlingFrame:Ljava/lang/Runnable;

    :cond_e
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Scroller:Landroid/widget/OverScroller;

    if-eqz v0, :cond_1a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Scroller:Landroid/widget/OverScroller;

    const/4 v2, 0x1

    invoke-virtual {v0, v2}, Landroid/widget/OverScroller;->forceFinished(Z)V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Scroller:Landroid/widget/OverScroller;

    :cond_1a
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Snap:Landroid/animation/ValueAnimator;

    if-eqz v0, :cond_25

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Snap:Landroid/animation/ValueAnimator;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Snap:Landroid/animation/ValueAnimator;

    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->cancel()V

    :cond_25
    return-void
.end method

.method private r203Clamp(F)F
    .locals 3

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_a

    return v1

    :cond_a
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    int-to-float v0, v0

    const/high16 v2, 0x3f800000    # 1.0f

    sub-float/2addr v0, v2

    invoke-static {v0, p1}, Ljava/lang/Math;->min(FF)F

    move-result p1

    invoke-static {v1, p1}, Ljava/lang/Math;->max(FF)F

    move-result p1

    return p1
.end method

.method private r203CompleteFling()V
    .locals 3

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_40

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_d

    goto :goto_40

    :cond_d
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->browsingRail:Z

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    add-int/lit8 v1, v1, -0x1

    iget v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203FloatIndex:F

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    invoke-static {v1, v2}, Ljava/lang/Math;->min(II)I

    move-result v1

    invoke-static {v0, v1}, Ljava/lang/Math;->max(II)I

    move-result v0

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    if-eq v1, v0, :cond_35

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadToken:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadToken:I

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->resetPhotoZoom()V

    :cond_35
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->refreshPages()V

    const/4 v0, 0x0

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->updatePosition(F)V

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepareCurrentVideo()V

    return-void

    :cond_40
    :goto_40
    return-void
.end method

.method private r203Present(F)V
    .locals 3

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_5a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_5a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    if-nez v0, :cond_11

    goto :goto_5a

    :cond_11
    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Clamp(F)F

    move-result p1

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203FloatIndex:F

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    const/4 v1, 0x1

    sub-int/2addr v0, v1

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result v2

    invoke-static {v0, v2}, Ljava/lang/Math;->min(II)I

    move-result v0

    const/4 v2, 0x0

    invoke-static {v2, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    iget v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    if-eq v0, v2, :cond_46

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadToken:I

    add-int/2addr v0, v1

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadToken:I

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->resetPhotoZoom()V

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->refreshPages()V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    if-eqz v0, :cond_46

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    invoke-virtual {v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;->prefetch()V

    :cond_46
    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    int-to-float v0, v0

    sub-float/2addr v0, p1

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    invoke-virtual {p1}, Landroid/widget/FrameLayout;->getWidth()I

    move-result p1

    invoke-static {v1, p1}, Ljava/lang/Math;->max(II)I

    move-result p1

    int-to-float p1, p1

    mul-float/2addr v0, p1

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->updatePosition(F)V

    return-void

    :cond_5a
    :goto_5a
    return-void
.end method

.method private r203ReleaseWithVelocity(FFF)V
    .locals 15

    move-object v0, p0

    iget-boolean v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v1, :cond_c9

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_f

    goto/16 :goto_c9

    :cond_f
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203CancelFling()V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->motion:Landroid/animation/ValueAnimator;

    const/4 v2, 0x0

    if-eqz v1, :cond_1e

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->motion:Landroid/animation/ValueAnimator;

    iput-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->motion:Landroid/animation/ValueAnimator;

    invoke-virtual {v1}, Landroid/animation/ValueAnimator;->cancel()V

    :cond_1e
    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubAnim:Landroid/animation/ValueAnimator;

    if-eqz v1, :cond_29

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubAnim:Landroid/animation/ValueAnimator;

    invoke-virtual {v1}, Landroid/animation/ValueAnimator;->cancel()V

    iput-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubAnim:Landroid/animation/ValueAnimator;

    :cond_29
    const/4 v1, 0x0

    iput-boolean v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoScrubMode:Z

    const/4 v2, 0x0

    iput v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubExpansion:F

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    if-nez v2, :cond_37

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    if-eqz v2, :cond_3a

    :cond_37
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->teardownPlayer()V

    :cond_3a
    const/4 v2, 0x1

    iput-boolean v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->browsingRail:Z

    invoke-direct/range {p0 .. p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Clamp(F)F

    move-result v3

    invoke-direct {p0, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Present(F)V

    invoke-static/range {p2 .. p2}, Ljava/lang/Math;->abs(F)F

    move-result v4

    const/high16 v5, 0x43be0000    # 380.0f

    cmpg-float v4, v4, v5

    if-ltz v4, :cond_c5

    iget-object v4, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v4

    const/4 v5, 0x2

    if-ge v4, v5, :cond_58

    goto :goto_c5

    :cond_58
    const/high16 v4, 0x42300000    # 44.0f

    invoke-direct {p0, v4}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v4

    invoke-static {v2, v4}, Ljava/lang/Math;->max(II)I

    move-result v2

    int-to-float v4, v2

    mul-float v5, v3, v4

    invoke-static {v5}, Ljava/lang/Math;->round(F)I

    move-result v7

    const/high16 v5, 0x42340000    # 45.0f

    sub-float v6, v3, v5

    mul-float/2addr v6, v4

    invoke-static {v6}, Ljava/lang/Math;->round(F)I

    move-result v6

    invoke-static {v1, v6}, Ljava/lang/Math;->max(II)I

    move-result v11

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    int-to-float v1, v1

    const/high16 v6, 0x3f800000    # 1.0f

    sub-float/2addr v1, v6

    mul-float/2addr v1, v4

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result v1

    add-float/2addr v3, v5

    mul-float/2addr v3, v4

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    invoke-static {v1, v3}, Ljava/lang/Math;->min(II)I

    move-result v12

    move/from16 v1, p2

    neg-float v1, v1

    mul-float v1, v1, p3

    const v3, 0x465ac000    # 14000.0f

    invoke-static {v3, v1}, Ljava/lang/Math;->min(FF)F

    move-result v1

    const v3, -0x39a54000    # -14000.0f

    invoke-static {v3, v1}, Ljava/lang/Math;->max(FF)F

    move-result v1

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result v9

    new-instance v1, Landroid/widget/OverScroller;

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v1, v3}, Landroid/widget/OverScroller;-><init>(Landroid/content/Context;)V

    iput-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Scroller:Landroid/widget/OverScroller;

    iget-object v6, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Scroller:Landroid/widget/OverScroller;

    const/4 v13, 0x0

    const/4 v14, 0x0

    const/4 v8, 0x0

    const/4 v10, 0x0

    invoke-virtual/range {v6 .. v14}, Landroid/widget/OverScroller;->fling(IIIIIIII)V

    new-instance v1, Lcom/juhyeon/familyjourney/MoaNativeGallery$5;

    invoke-direct {v1, p0, v2}, Lcom/juhyeon/familyjourney/MoaNativeGallery$5;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;I)V

    iput-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203FlingFrame:Ljava/lang/Runnable;

    iget-object v0, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    invoke-virtual {v0, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;->postOnAnimation(Ljava/lang/Runnable;)V

    return-void

    :cond_c5
    :goto_c5
    invoke-direct {p0, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203SnapNearest(F)V

    return-void

    :cond_c9
    :goto_c9
    return-void
.end method

.method private r203SnapNearest(F)V
    .locals 3

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_5d

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_d

    goto :goto_5d

    :cond_d
    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Clamp(F)F

    move-result p1

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result v0

    int-to-float v0, v0

    sub-float v1, p1, v0

    invoke-static {v1}, Ljava/lang/Math;->abs(F)F

    move-result v1

    const v2, 0x3a83126f    # 0.001f

    cmpg-float v1, v1, v2

    if-gez v1, :cond_2a

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Present(F)V

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203CompleteFling()V

    return-void

    :cond_2a
    const/4 v1, 0x2

    new-array v1, v1, [F

    const/4 v2, 0x0

    aput p1, v1, v2

    const/4 p1, 0x1

    aput v0, v1, p1

    invoke-static {v1}, Landroid/animation/ValueAnimator;->ofFloat([F)Landroid/animation/ValueAnimator;

    move-result-object p1

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203Snap:Landroid/animation/ValueAnimator;

    const-wide/16 v1, 0x96

    invoke-virtual {p1, v1, v2}, Landroid/animation/ValueAnimator;->setDuration(J)Landroid/animation/ValueAnimator;

    new-instance v1, Landroid/view/animation/DecelerateInterpolator;

    const v2, 0x3fcccccd    # 1.6f

    invoke-direct {v1, v2}, Landroid/view/animation/DecelerateInterpolator;-><init>(F)V

    invoke-virtual {p1, v1}, Landroid/animation/ValueAnimator;->setInterpolator(Landroid/animation/TimeInterpolator;)V

    new-instance v1, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda25;

    invoke-direct {v1, p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda25;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/animation/ValueAnimator;)V

    invoke-virtual {p1, v1}, Landroid/animation/ValueAnimator;->addUpdateListener(Landroid/animation/ValueAnimator$AnimatorUpdateListener;)V

    new-instance v1, Lcom/juhyeon/familyjourney/MoaNativeGallery$4;

    invoke-direct {v1, p0, p1, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$4;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/animation/ValueAnimator;F)V

    invoke-virtual {p1, v1}, Landroid/animation/ValueAnimator;->addListener(Landroid/animation/Animator$AnimatorListener;)V

    invoke-virtual {p1}, Landroid/animation/ValueAnimator;->start()V

    return-void

    :cond_5d
    :goto_5d
    return-void
.end method

.method private r205PressFeedback(Landroid/view/View;)V
    .locals 1

    new-instance v0, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda20;

    invoke-direct {v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda20;-><init>()V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    return-void
.end method

.method private r205ShowCapturePreview(Landroid/graphics/Bitmap;Landroid/net/Uri;)V
    .locals 6

    if-eqz p1, :cond_10d

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    if-eqz v0, :cond_10d

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-nez v0, :cond_c

    goto/16 :goto_10d

    :cond_c
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205PreviewDismiss:Ljava/lang/Runnable;

    const/4 v1, 0x0

    if-eqz v0, :cond_1a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205PreviewDismiss:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205PreviewDismiss:Ljava/lang/Runnable;

    :cond_1a
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    if-eqz v0, :cond_3a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    invoke-virtual {v0}, Landroid/widget/ImageView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_35

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    invoke-virtual {v0}, Landroid/widget/ImageView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :cond_35
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    :cond_3a
    new-instance v0, Landroid/widget/ImageView;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v0, v1}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    invoke-virtual {v0, p1}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    sget-object p1, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {v0, p1}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    const/high16 p1, 0x40000000    # 2.0f

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v1

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v2

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v3

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result p1

    invoke-virtual {v0, v1, v2, v3, p1}, Landroid/widget/ImageView;->setPadding(IIII)V

    new-instance p1, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {p1}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const v1, -0x1ae4e3e0

    invoke-virtual {p1, v1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/high16 v1, 0x40e00000    # 7.0f

    invoke-direct {p0, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v1

    int-to-float v1, v1

    invoke-virtual {p1, v1}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    const/high16 v1, 0x3f800000    # 1.0f

    invoke-direct {p0, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v2

    const v3, -0x421c1a18

    invoke-virtual {p1, v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    invoke-virtual {v0, p1}, Landroid/widget/ImageView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    const/4 p1, 0x1

    invoke-virtual {v0, p1}, Landroid/widget/ImageView;->setClipToOutline(Z)V

    const/high16 v2, 0x40c00000    # 6.0f

    invoke-direct {p0, v2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v2

    int-to-float v2, v2

    invoke-virtual {v0, v2}, Landroid/widget/ImageView;->setElevation(F)V

    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;

    const/high16 v3, 0x42600000    # 56.0f

    invoke-direct {p0, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v3

    const/high16 v4, 0x42880000    # 68.0f

    invoke-direct {p0, v4}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v4

    const/16 v5, 0x55

    invoke-direct {v2, v3, v4, v5}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    const/high16 v3, 0x41700000    # 15.0f

    invoke-direct {p0, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v3

    iput v3, v2, Landroid/widget/FrameLayout$LayoutParams;->rightMargin:I

    const/high16 v3, 0x43000000    # 128.0f

    invoke-direct {p0, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v3

    iput v3, v2, Landroid/widget/FrameLayout$LayoutParams;->bottomMargin:I

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    invoke-virtual {v3, v0, v2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    const-string v2, "\uc800\uc7a5\ub41c \ucea1\ucc98 \uc0ac\uc9c4 \ud06c\uac8c \ubcf4\uae30"

    invoke-virtual {v0, v2}, Landroid/widget/ImageView;->setContentDescription(Ljava/lang/CharSequence;)V

    invoke-virtual {v0, p1}, Landroid/widget/ImageView;->setClickable(Z)V

    new-instance p1, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda41;

    invoke-direct {p1, p0, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda41;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/net/Uri;)V

    invoke-virtual {v0, p1}, Landroid/widget/ImageView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const/4 p1, 0x0

    invoke-virtual {v0, p1}, Landroid/widget/ImageView;->setAlpha(F)V

    const p2, 0x3f47ae14    # 0.78f

    invoke-virtual {v0, p2}, Landroid/widget/ImageView;->setScaleX(F)V

    invoke-virtual {v0, p2}, Landroid/widget/ImageView;->setScaleY(F)V

    const/high16 p2, 0x41200000    # 10.0f

    invoke-direct {p0, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result p2

    int-to-float p2, p2

    invoke-virtual {v0, p2}, Landroid/widget/ImageView;->setTranslationY(F)V

    invoke-virtual {v0}, Landroid/widget/ImageView;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object p2

    invoke-virtual {p2, v1}, Landroid/view/ViewPropertyAnimator;->alpha(F)Landroid/view/ViewPropertyAnimator;

    move-result-object p2

    invoke-virtual {p2, v1}, Landroid/view/ViewPropertyAnimator;->scaleX(F)Landroid/view/ViewPropertyAnimator;

    move-result-object p2

    invoke-virtual {p2, v1}, Landroid/view/ViewPropertyAnimator;->scaleY(F)Landroid/view/ViewPropertyAnimator;

    move-result-object p2

    invoke-virtual {p2, p1}, Landroid/view/ViewPropertyAnimator;->translationY(F)Landroid/view/ViewPropertyAnimator;

    move-result-object p1

    const-wide/16 v1, 0xc8

    invoke-virtual {p1, v1, v2}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;

    move-result-object p1

    invoke-virtual {p1}, Landroid/view/ViewPropertyAnimator;->start()V

    new-instance p1, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda42;

    invoke-direct {p1, p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda42;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/widget/ImageView;)V

    iput-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205PreviewDismiss:Ljava/lang/Runnable;

    iget-object p2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    const-wide/16 v0, 0x514

    invoke-virtual {p2, p1, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void

    :cond_10d
    :goto_10d
    return-void
.end method

.method private r207CloseSavedPhoto()V
    .locals 3

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoViewer:Landroid/widget/FrameLayout;

    if-nez v0, :cond_5

    return-void

    :cond_5
    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoLoadGeneration:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoLoadGeneration:I

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoViewer:Landroid/widget/FrameLayout;

    const/4 v1, 0x0

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoViewer:Landroid/widget/FrameLayout;

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoImage:Landroid/widget/ImageView;

    if-eqz v2, :cond_1b

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoImage:Landroid/widget/ImageView;

    invoke-virtual {v2, v1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoImage:Landroid/widget/ImageView;

    :cond_1b
    invoke-virtual {v0}, Landroid/widget/FrameLayout;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    instance-of v1, v1, Landroid/view/ViewGroup;

    if-eqz v1, :cond_2c

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    check-cast v1, Landroid/view/ViewGroup;

    invoke-virtual {v1, v0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :cond_2c
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_4e

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207ResumeVideoAfterPhoto:Z

    if-eqz v0, :cond_4e

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    if-eqz v0, :cond_4e

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    if-eqz v0, :cond_4e

    :try_start_3c
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->start()V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    if-eqz v0, :cond_4e

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    const-string v1, "\u2161"

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    :try_end_4c
    .catch Ljava/lang/Exception; {:try_start_3c .. :try_end_4c} :catch_4d

    goto :goto_4e

    :catch_4d
    move-exception v0

    :cond_4e
    :goto_4e
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207ResumeVideoAfterPhoto:Z

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    if-eqz v0, :cond_5a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->requestFocus()Z

    :cond_5a
    return-void
.end method

.method private r207OpenSavedPhoto(Landroid/net/Uri;)V
    .locals 10

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_129

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    if-eqz v0, :cond_129

    if-eqz p1, :cond_129

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoViewer:Landroid/widget/FrameLayout;

    if-eqz v0, :cond_10

    goto/16 :goto_129

    :cond_10
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205PreviewDismiss:Ljava/lang/Runnable;

    const/4 v1, 0x0

    if-eqz v0, :cond_1e

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205PreviewDismiss:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205PreviewDismiss:Ljava/lang/Runnable;

    :cond_1e
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    if-eqz v0, :cond_49

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    invoke-virtual {v0}, Landroid/widget/ImageView;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    invoke-virtual {v0}, Landroid/widget/ImageView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_42

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    invoke-virtual {v0}, Landroid/widget/ImageView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :cond_42
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    :cond_49
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207ResumeVideoAfterPhoto:Z

    const/4 v0, 0x1

    :try_start_4d
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    if-eqz v1, :cond_71

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    if-eqz v1, :cond_71

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {v1}, Landroid/media/MediaPlayer;->isPlaying()Z

    move-result v1

    if-eqz v1, :cond_71

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207ResumeVideoAfterPhoto:Z

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {v1}, Landroid/media/MediaPlayer;->pause()V

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    if-eqz v1, :cond_71

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    const-string v2, "\u25b6"

    invoke-virtual {v1, v2}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    :try_end_6f
    .catch Ljava/lang/Exception; {:try_start_4d .. :try_end_6f} :catch_70

    goto :goto_71

    :catch_70
    move-exception v1

    :cond_71
    :goto_71
    nop

    new-instance v6, Landroid/widget/FrameLayout;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v6, v1}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    const/high16 v1, -0x1000000

    invoke-virtual {v6, v1}, Landroid/widget/FrameLayout;->setBackgroundColor(I)V

    invoke-virtual {v6, v0}, Landroid/widget/FrameLayout;->setClickable(Z)V

    invoke-virtual {v6, v0}, Landroid/widget/FrameLayout;->setFocusableInTouchMode(Z)V

    iput-object v6, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoViewer:Landroid/widget/FrameLayout;

    new-instance v7, Landroid/widget/ImageView;

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v7, v2}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    iput-object v7, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoImage:Landroid/widget/ImageView;

    invoke-virtual {v7, v1}, Landroid/widget/ImageView;->setBackgroundColor(I)V

    sget-object v1, Landroid/widget/ImageView$ScaleType;->FIT_CENTER:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {v7, v1}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v2, -0x1

    invoke-direct {v1, v2, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v6, v7, v1}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v1, Landroid/widget/TextView;

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v1, v3}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "\u2039  \ub3cc\uc544\uac00\uae30"

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v3, 0x41700000    # 15.0f

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const/16 v4, 0x11

    invoke-virtual {v1, v4}, Landroid/widget/TextView;->setGravity(I)V

    new-instance v4, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v4}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const v5, -0x2adddbd6

    invoke-virtual {v4, v5}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/high16 v5, 0x41b00000    # 22.0f

    invoke-direct {p0, v5}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v5

    int-to-float v5, v5

    invoke-virtual {v4, v5}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    invoke-virtual {v1, v4}, Landroid/widget/TextView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setClickable(Z)V

    new-instance v4, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda13;

    invoke-direct {v4, p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda13;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v1, v4}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;

    const/high16 v5, 0x42e00000    # 112.0f

    invoke-direct {p0, v5}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v5

    const/high16 v8, 0x42300000    # 44.0f

    invoke-direct {p0, v8}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v8

    const/16 v9, 0x33

    invoke-direct {v4, v5, v8, v9}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    const/high16 v5, 0x41200000    # 10.0f

    invoke-direct {p0, v5}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v5

    iput v5, v4, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    invoke-direct {p0, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v3

    iput v3, v4, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    invoke-virtual {v6, v1, v4}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v1, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda14;

    invoke-direct {v1, p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda14;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v6, v1}, Landroid/widget/FrameLayout;->setOnKeyListener(Landroid/view/View$OnKeyListener;)V

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v3, v2, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v6, v3}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v6}, Landroid/widget/FrameLayout;->requestFocus()Z

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoLoadGeneration:I

    add-int/lit8 v5, v1, 0x1

    iput v5, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoLoadGeneration:I

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->background:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda15;

    move-object v2, v1

    move-object v3, p0

    move-object v4, p1

    invoke-direct/range {v2 .. v7}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda15;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/net/Uri;ILandroid/widget/FrameLayout;Landroid/widget/ImageView;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    return-void

    :cond_129
    :goto_129
    return-void
.end method

.method private r225FindWebView(Landroid/view/View;)Landroid/webkit/WebView;
    .locals 2

    instance-of v0, p1, Landroid/webkit/WebView;

    if-eqz v0, :cond_7

    check-cast p1, Landroid/webkit/WebView;

    return-object p1

    :cond_7
    instance-of v0, p1, Landroid/view/ViewGroup;

    if-eqz v0, :cond_22

    check-cast p1, Landroid/view/ViewGroup;

    const/4 v0, 0x0

    :goto_e
    invoke-virtual {p1}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    if-ge v0, v1, :cond_22

    invoke-virtual {p1, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225FindWebView(Landroid/view/View;)Landroid/webkit/WebView;

    move-result-object v1

    if-eqz v1, :cond_1f

    return-object v1

    :cond_1f
    add-int/lit8 v0, v0, 0x1

    goto :goto_e

    :cond_22
    const/4 p1, 0x0

    return-object p1
.end method

.method private static r225GoodGps(DD)Z
    .locals 2

    invoke-static {p0, p1}, Ljava/lang/Double;->isNaN(D)Z

    move-result v0

    if-nez v0, :cond_3c

    invoke-static {p2, p3}, Ljava/lang/Double;->isNaN(D)Z

    move-result v0

    if-nez v0, :cond_3c

    const-wide v0, -0x3fa9800000000000L    # -90.0

    cmpl-double v0, p0, v0

    if-ltz v0, :cond_3c

    const-wide v0, 0x4056800000000000L    # 90.0

    cmpg-double v0, p0, v0

    if-gtz v0, :cond_3c

    const-wide v0, -0x3f99800000000000L    # -180.0

    cmpl-double v0, p2, v0

    if-ltz v0, :cond_3c

    const-wide v0, 0x4066800000000000L    # 180.0

    cmpg-double v0, p2, v0

    if-gtz v0, :cond_3c

    const-wide/16 v0, 0x0

    cmpl-double p0, p0, v0

    if-nez p0, :cond_3a

    cmpl-double p0, p2, v0

    if-eqz p0, :cond_3c

    :cond_3a
    const/4 p0, 0x1

    goto :goto_3d

    :cond_3c
    const/4 p0, 0x0

    :goto_3d
    return p0
.end method

.method private r225LoadMediaMetadata(ILjava/lang/String;)V
    .locals 20

    move-object/from16 v2, p0

    move-object/from16 v4, p2

    const-string v0, "date_added"

    const-string v1, "datetaken"

    invoke-direct {v2, v4}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->uri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    if-nez v3, :cond_f

    return-void

    :cond_f
    nop

    const-wide/16 v11, 0x0

    :try_start_12
    iget-object v5, v2, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v5}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v5

    filled-new-array {v1, v0}, [Ljava/lang/String;

    move-result-object v7

    const/4 v9, 0x0

    const/4 v10, 0x0

    const/4 v8, 0x0

    move-object v6, v3

    invoke-virtual/range {v5 .. v10}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v5
    :try_end_24
    .catch Ljava/lang/Exception; {:try_start_12 .. :try_end_24} :catch_7c

    if-eqz v5, :cond_73

    :try_start_26
    invoke-interface {v5}, Landroid/database/Cursor;->moveToFirst()Z

    move-result v6

    if-eqz v6, :cond_73

    invoke-interface {v5, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {v5, v0}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v0

    if-ltz v1, :cond_41

    invoke-interface {v5, v1}, Landroid/database/Cursor;->isNull(I)Z

    move-result v6

    if-nez v6, :cond_41

    invoke-interface {v5, v1}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v6
    :try_end_40
    .catchall {:try_start_26 .. :try_end_40} :catchall_5d

    goto :goto_42

    :cond_41
    move-wide v6, v11

    :goto_42
    if-ltz v0, :cond_57

    :try_start_44
    invoke-interface {v5, v0}, Landroid/database/Cursor;->isNull(I)Z

    move-result v1

    if-nez v1, :cond_57

    invoke-interface {v5, v0}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v0
    :try_end_4e
    .catchall {:try_start_44 .. :try_end_4e} :catchall_54

    const-wide/16 v8, 0x3e8

    mul-long/2addr v0, v8

    move-wide v11, v6

    move-wide v6, v0

    goto :goto_74

    :catchall_54
    move-exception v0

    move-object v1, v0

    goto :goto_60

    :cond_57
    move-wide/from16 v18, v6

    move-wide v6, v11

    move-wide/from16 v11, v18

    goto :goto_74

    :catchall_5d
    move-exception v0

    move-object v1, v0

    move-wide v6, v11

    :goto_60
    if-eqz v5, :cond_6b

    :try_start_62
    invoke-interface {v5}, Landroid/database/Cursor;->close()V
    :try_end_65
    .catchall {:try_start_62 .. :try_end_65} :catchall_66

    goto :goto_6b

    :catchall_66
    move-exception v0

    move-object v5, v0

    :try_start_68
    invoke-virtual {v1, v5}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_6b
    :goto_6b
    throw v1
    :try_end_6c
    .catch Ljava/lang/Exception; {:try_start_68 .. :try_end_6c} :catch_6c

    :catch_6c
    move-exception v0

    move-wide/from16 v18, v6

    move-wide v6, v11

    move-wide/from16 v11, v18

    goto :goto_7e

    :cond_73
    move-wide v6, v11

    :goto_74
    if-eqz v5, :cond_7e

    :try_start_76
    invoke-interface {v5}, Landroid/database/Cursor;->close()V
    :try_end_79
    .catch Ljava/lang/Exception; {:try_start_76 .. :try_end_79} :catch_7a

    goto :goto_7e

    :catch_7a
    move-exception v0

    goto :goto_7e

    :catch_7c
    move-exception v0

    move-wide v6, v11

    :cond_7e
    :goto_7e
    const-wide v8, 0x4977387000L

    const/4 v1, 0x1

    const/4 v5, 0x0

    :try_start_85
    invoke-direct {v2, v4}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->video(Ljava/lang/String;)Z

    move-result v0
    :try_end_89
    .catch Ljava/lang/Exception; {:try_start_85 .. :try_end_89} :catch_186

    const/4 v10, 0x2

    if-nez v0, :cond_12c

    nop

    :try_start_8d
    iget-object v0, v2, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    const-string v15, "android.permission.ACCESS_MEDIA_LOCATION"

    invoke-virtual {v0, v15}, Landroid/app/Activity;->checkSelfPermission(Ljava/lang/String;)I

    move-result v0
    :try_end_95
    .catch Ljava/lang/Exception; {:try_start_8d .. :try_end_95} :catch_123

    if-nez v0, :cond_9d

    :try_start_97
    invoke-static {v3}, Landroid/provider/MediaStore;->setRequireOriginal(Landroid/net/Uri;)Landroid/net/Uri;

    move-result-object v0
    :try_end_9b
    .catch Ljava/lang/Exception; {:try_start_97 .. :try_end_9b} :catch_9c

    goto :goto_9e

    :catch_9c
    move-exception v0

    :cond_9d
    move-object v0, v3

    :goto_9e
    nop

    :try_start_9f
    iget-object v15, v2, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v15}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v15

    invoke-virtual {v15, v0}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v0
    :try_end_a9
    .catch Ljava/lang/SecurityException; {:try_start_9f .. :try_end_a9} :catch_ab
    .catch Ljava/lang/Exception; {:try_start_9f .. :try_end_a9} :catch_186

    :goto_a9
    move-object v3, v0

    goto :goto_b7

    :catch_ab
    move-exception v0

    :try_start_ac
    iget-object v0, v2, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    invoke-virtual {v0, v3}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v0
    :try_end_b6
    .catch Ljava/lang/Exception; {:try_start_ac .. :try_end_b6} :catch_123

    goto :goto_a9

    :goto_b7
    nop

    if-eqz v3, :cond_111

    :try_start_ba
    new-instance v0, Landroid/media/ExifInterface;

    invoke-direct {v0, v3}, Landroid/media/ExifInterface;-><init>(Ljava/io/InputStream;)V

    new-array v10, v10, [F

    invoke-virtual {v0, v10}, Landroid/media/ExifInterface;->getLatLong([F)Z

    move-result v15

    if-eqz v15, :cond_d3

    aget v15, v10, v5
    :try_end_c9
    .catchall {:try_start_ba .. :try_end_c9} :catchall_ff

    float-to-double v13, v15

    :try_start_ca
    aget v10, v10, v1
    :try_end_cc
    .catchall {:try_start_ca .. :try_end_cc} :catchall_d0

    float-to-double v1, v10

    move-wide/from16 v16, v1

    goto :goto_d7

    :catchall_d0
    move-exception v0

    move-object v1, v0

    goto :goto_103

    :cond_d3
    const-wide/high16 v13, 0x7ff8000000000000L    # Double.NaN

    const-wide/high16 v16, 0x7ff8000000000000L    # Double.NaN

    :goto_d7
    cmp-long v1, v11, v8

    if-gez v1, :cond_115

    :try_start_db
    const-string v1, "DateTimeOriginal"

    invoke-virtual {v0, v1}, Landroid/media/ExifInterface;->getAttribute(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0
    :try_end_e1
    .catchall {:try_start_db .. :try_end_e1} :catchall_fc

    if-eqz v0, :cond_115

    :try_start_e3
    new-instance v1, Ljava/text/SimpleDateFormat;

    const-string v2, "yyyy:MM:dd HH:mm:ss"

    sget-object v10, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-direct {v1, v2, v10}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    invoke-virtual {v1, v5}, Ljava/text/SimpleDateFormat;->setLenient(Z)V

    invoke-virtual {v1, v0}, Ljava/text/SimpleDateFormat;->parse(Ljava/lang/String;)Ljava/util/Date;

    move-result-object v0

    if-eqz v0, :cond_f9

    invoke-virtual {v0}, Ljava/util/Date;->getTime()J

    move-result-wide v11
    :try_end_f9
    .catch Ljava/lang/Exception; {:try_start_e3 .. :try_end_f9} :catch_fa
    .catchall {:try_start_e3 .. :try_end_f9} :catchall_fc

    :cond_f9
    :goto_f9
    goto :goto_115

    :catch_fa
    move-exception v0

    goto :goto_f9

    :catchall_fc
    move-exception v0

    move-object v1, v0

    goto :goto_105

    :catchall_ff
    move-exception v0

    move-object v1, v0

    const-wide/high16 v13, 0x7ff8000000000000L    # Double.NaN

    :goto_103
    const-wide/high16 v16, 0x7ff8000000000000L    # Double.NaN

    :goto_105
    if-eqz v3, :cond_110

    :try_start_107
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    :try_end_10a
    .catchall {:try_start_107 .. :try_end_10a} :catchall_10b

    goto :goto_110

    :catchall_10b
    move-exception v0

    move-object v2, v0

    :try_start_10d
    invoke-virtual {v1, v2}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_110
    :goto_110
    throw v1

    :cond_111
    const-wide/high16 v13, 0x7ff8000000000000L    # Double.NaN

    const-wide/high16 v16, 0x7ff8000000000000L    # Double.NaN

    :cond_115
    :goto_115
    if-eqz v3, :cond_11e

    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    :try_end_11a
    .catch Ljava/lang/Exception; {:try_start_10d .. :try_end_11a} :catch_11b

    goto :goto_11e

    :catch_11b
    move-exception v0

    const/4 v3, 0x1

    goto :goto_129

    :cond_11e
    :goto_11e
    const/4 v3, 0x1

    move-object/from16 v2, p0

    goto/16 :goto_18c

    :catch_123
    move-exception v0

    const/4 v3, 0x1

    const-wide/high16 v13, 0x7ff8000000000000L    # Double.NaN

    const-wide/high16 v16, 0x7ff8000000000000L    # Double.NaN

    :goto_129
    move-object/from16 v2, p0

    goto :goto_18c

    :cond_12c
    :try_start_12c
    new-instance v1, Landroid/media/MediaMetadataRetriever;

    invoke-direct {v1}, Landroid/media/MediaMetadataRetriever;-><init>()V
    :try_end_131
    .catch Ljava/lang/Exception; {:try_start_12c .. :try_end_131} :catch_181

    move-object/from16 v2, p0

    :try_start_133
    iget-object v0, v2, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v1, v0, v3}, Landroid/media/MediaMetadataRetriever;->setDataSource(Landroid/content/Context;Landroid/net/Uri;)V

    const/16 v0, 0x17

    invoke-virtual {v1, v0}, Landroid/media/MediaMetadataRetriever;->extractMetadata(I)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_168

    const-string v3, "([+-][0-9]+(?:\\.[0-9]+)?)([+-][0-9]+(?:\\.[0-9]+)?)"

    invoke-static {v3}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/regex/Matcher;->find()Z

    move-result v3
    :try_end_14e
    .catchall {:try_start_133 .. :try_end_14e} :catchall_177

    if-eqz v3, :cond_166

    const/4 v3, 0x1

    :try_start_151
    invoke-virtual {v0, v3}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object v13

    invoke-static {v13}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v13
    :try_end_159
    .catchall {:try_start_151 .. :try_end_159} :catchall_164

    :try_start_159
    invoke-virtual {v0, v10}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v15
    :try_end_161
    .catchall {:try_start_159 .. :try_end_161} :catchall_162

    goto :goto_16d

    :catchall_162
    move-exception v0

    goto :goto_17b

    :catchall_164
    move-exception v0

    goto :goto_179

    :cond_166
    const/4 v3, 0x1

    goto :goto_169

    :cond_168
    const/4 v3, 0x1

    :goto_169
    const-wide/high16 v13, 0x7ff8000000000000L    # Double.NaN

    const-wide/high16 v15, 0x7ff8000000000000L    # Double.NaN

    :goto_16d
    :try_start_16d
    invoke-virtual {v1}, Landroid/media/MediaMetadataRetriever;->release()V
    :try_end_170
    .catch Ljava/lang/Exception; {:try_start_16d .. :try_end_170} :catch_173

    move-wide/from16 v16, v15

    goto :goto_18c

    :catch_173
    move-exception v0

    move-wide/from16 v16, v15

    goto :goto_18c

    :catchall_177
    move-exception v0

    const/4 v3, 0x1

    :goto_179
    const-wide/high16 v13, 0x7ff8000000000000L    # Double.NaN

    :goto_17b
    :try_start_17b
    invoke-virtual {v1}, Landroid/media/MediaMetadataRetriever;->release()V

    throw v0
    :try_end_17f
    .catch Ljava/lang/Exception; {:try_start_17b .. :try_end_17f} :catch_17f

    :catch_17f
    move-exception v0

    goto :goto_18a

    :catch_181
    move-exception v0

    const/4 v3, 0x1

    move-object/from16 v2, p0

    goto :goto_188

    :catch_186
    move-exception v0

    move v3, v1

    :goto_188
    const-wide/high16 v13, 0x7ff8000000000000L    # Double.NaN

    :goto_18a
    const-wide/high16 v16, 0x7ff8000000000000L    # Double.NaN

    :goto_18c
    move-wide v0, v11

    move-wide/from16 v10, v16

    cmp-long v8, v0, v8

    if-lez v8, :cond_194

    move-wide v6, v0

    :cond_194
    if-lez v8, :cond_198

    move v0, v3

    goto :goto_199

    :cond_198
    move v0, v5

    :goto_199
    nop

    iget-object v12, v2, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    new-instance v15, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda21;

    move-object v1, v15

    move-object/from16 v2, p0

    move/from16 v3, p1

    move-object/from16 v4, p2

    move-wide v5, v6

    move v7, v0

    move-wide v8, v13

    invoke-direct/range {v1 .. v11}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda21;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;ILjava/lang/String;JZDD)V

    invoke-virtual {v12, v15}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private r225LoadWebIndex(ILjava/lang/String;)V
    .locals 4

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    const v1, 0x1020002

    invoke-virtual {v0, v1}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225FindWebView(Landroid/view/View;)Landroid/webkit/WebView;

    move-result-object v0

    if-nez v0, :cond_10

    return-void

    :cond_10
    invoke-static {p2}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "(function(){try{var id="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ";var diary=window.FamilyJourneyDiary&&window.FamilyJourneyDiary.state;var it=diary&&diary.byId&&diary.byId.get&&(diary.byId.get(id)||diary.byId.get(id.replace(/^v/,\'\')));var data=window.FamilyJourneyExtension&&window.FamilyJourneyExtension.getData&&window.FamilyJourneyExtension.getData();var rows=data&&Array.isArray(data.photos)?data.photos:[];var row=null;for(var i=0;i<rows.length;i++){if(Array.isArray(rows[i])&&(String(rows[i][0])===id||String(rows[i][0])===id.replace(/^v/,\'\'))){row=rows[i];break}}var t=it&&Number(it.t)||0;return JSON.stringify({t:t,lat:row?Number(row[1]):null,lon:row?Number(row[2]):null});}catch(e){return \'{}\'}})();"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :try_start_2d
    new-instance v2, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda39;

    invoke-direct {v2, p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda39;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;ILjava/lang/String;)V

    invoke-virtual {v0, v1, v2}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V
    :try_end_35
    .catch Ljava/lang/Exception; {:try_start_2d .. :try_end_35} :catch_36

    goto :goto_37

    :catch_36
    move-exception p1

    :goto_37
    nop

    return-void
.end method

.method private r225MetadataCurrent(ILjava/lang/String;)Z
    .locals 1

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_16

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225CaptureTime:Landroid/widget/TextView;

    if-eqz v0, :cond_16

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetaSeq:I

    if-ne p1, v0, :cond_16

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetaId:Ljava/lang/String;

    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_16

    const/4 p1, 0x1

    goto :goto_17

    :cond_16
    const/4 p1, 0x0

    :goto_17
    return p1
.end method

.method private r225OpenNaver()V
    .locals 7

    iget-wide v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lat:D

    iget-wide v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lon:D

    invoke-static {v0, v1, v2, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225GoodGps(DD)Z

    move-result v0

    if-eqz v0, :cond_117

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-nez v0, :cond_10

    goto/16 :goto_117

    :cond_10
    iget-wide v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lat:D

    const-wide v2, 0x403f6e147ae147aeL    # 31.43

    cmpl-double v0, v0, v2

    if-ltz v0, :cond_116

    iget-wide v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lat:D

    const-wide v2, 0x40462ccccccccccdL    # 44.35

    cmpg-double v0, v0, v2

    if-gtz v0, :cond_116

    iget-wide v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lon:D

    const-wide v2, 0x405e97ae147ae148L    # 122.37

    cmpl-double v0, v0, v2

    if-ltz v0, :cond_116

    iget-wide v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lon:D

    const-wide v2, 0x4060800000000000L    # 132.0

    cmpg-double v0, v0, v2

    if-lez v0, :cond_3e

    goto/16 :goto_116

    :cond_3e
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225ResolvedAddress:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_49

    const-string v0, "\uc0ac\uc9c4 \ucd2c\uc601 \uc704\uce58"

    goto :goto_4b

    :cond_49
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225ResolvedAddress:Ljava/lang/String;

    :goto_4b
    sget-object v1, Ljava/util/Locale;->US:Ljava/util/Locale;

    iget-wide v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lat:D

    invoke-static {v2, v3}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v2

    iget-wide v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lon:D

    invoke-static {v3, v4}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v3

    invoke-static {v0}, Landroid/net/Uri;->encode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v4}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Landroid/net/Uri;->encode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    filled-new-array {v2, v3, v0, v4}, [Ljava/lang/Object;

    move-result-object v0

    const-string v2, "nmap://place?lat=%.7f&lng=%.7f&name=%s&appname=%s"

    invoke-static {v1, v2, v0}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Landroid/content/Intent;

    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    const-string v2, "android.intent.action.VIEW"

    invoke-direct {v1, v2, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    const-string v0, "android.intent.category.BROWSABLE"

    invoke-virtual {v1, v0}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;

    const-string v0, "com.nhn.android.nmap"

    invoke-virtual {v1, v0}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227ExternalMapPending:Z

    const/4 v3, 0x0

    iput-boolean v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227VideoWasPlaying:Z

    :try_start_8c
    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    if-eqz v4, :cond_b0

    iget-boolean v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    if-eqz v4, :cond_b0

    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {v4}, Landroid/media/MediaPlayer;->isPlaying()Z

    move-result v4

    if-eqz v4, :cond_b0

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227VideoWasPlaying:Z

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->pause()V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    if-eqz v0, :cond_b0

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    const-string v4, "\u25b6"

    invoke-virtual {v0, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    :try_end_ae
    .catch Ljava/lang/Exception; {:try_start_8c .. :try_end_ae} :catch_af

    goto :goto_b0

    :catch_af
    move-exception v0

    :cond_b0
    :goto_b0
    nop

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-static {v0}, Lcom/juhyeon/familyjourney/MoaNaverReturnOverlay;->show(Landroid/app/Activity;)Z

    :try_start_b6
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v0, v1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :try_end_bb
    .catch Ljava/lang/Exception; {:try_start_b6 .. :try_end_bb} :catch_bc

    goto :goto_115

    :catch_bc
    move-exception v0

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225ResolvedAddress:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_de

    sget-object v0, Ljava/util/Locale;->US:Ljava/util/Locale;

    iget-wide v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lat:D

    invoke-static {v4, v5}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v1

    iget-wide v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lon:D

    invoke-static {v4, v5}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v4

    filled-new-array {v1, v4}, [Ljava/lang/Object;

    move-result-object v1

    const-string v4, "%.6f, %.6f"

    invoke-static {v0, v4, v1}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto :goto_e0

    :cond_de
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225ResolvedAddress:Ljava/lang/String;

    :goto_e0
    :try_start_e0
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    new-instance v4, Landroid/content/Intent;

    invoke-static {v0}, Landroid/net/Uri;->encode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "https://map.naver.com/p/search/"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    invoke-direct {v4, v2, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    invoke-virtual {v1, v4}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :try_end_105
    .catch Ljava/lang/Exception; {:try_start_e0 .. :try_end_105} :catch_106

    goto :goto_115

    :catch_106
    move-exception v0

    invoke-virtual {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227ResumeFromExternalMap()V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    const-string v1, "\ub124\uc774\ubc84 \uc9c0\ub3c4\ub97c \uc5f4 \uc218 \uc5c6\uc5b4\uc694"

    invoke-static {v0, v1, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    :goto_115
    return-void

    :cond_116
    :goto_116
    return-void

    :cond_117
    :goto_117
    return-void
.end method

.method private r225ScheduleMeta()V
    .locals 4

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_71

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_71

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225CaptureTime:Landroid/widget/TextView;

    if-nez v0, :cond_11

    goto :goto_71

    :cond_11
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetaId:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_24

    return-void

    :cond_24
    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetaId:Ljava/lang/String;

    const/4 v1, 0x0

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225HasTime:Z

    const-wide/high16 v1, 0x7ff8000000000000L    # Double.NaN

    iput-wide v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lat:D

    iput-wide v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lon:D

    const-string v1, ""

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225ResolvedAddress:Ljava/lang/String;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225CaptureTime:Landroid/widget/TextView;

    const-string v2, "\ucd2c\uc601 \ub0a0\uc9dc\u00b7\uc2dc\uac04 \ud655\uc778 \uc911\u2026"

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Address:Landroid/widget/TextView;

    const-string v2, "\uc704\uce58 \ud655\uc778 \uc911\u2026"

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Naver:Landroid/view/View;

    const/16 v2, 0x8

    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetaSeq:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetaSeq:I

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225PendingMeta:Ljava/lang/Runnable;

    if-eqz v2, :cond_59

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225PendingMeta:Ljava/lang/Runnable;

    invoke-virtual {v2, v3}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    :cond_59
    new-instance v2, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda37;

    invoke-direct {v2, p0, v1, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda37;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;ILjava/lang/String;)V

    iput-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225PendingMeta:Ljava/lang/Runnable;

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225PendingMeta:Ljava/lang/Runnable;

    iget-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->browsingRail:Z

    if-eqz v2, :cond_6b

    const-wide/16 v2, 0xaa

    goto :goto_6d

    :cond_6b
    const-wide/16 v2, 0x41

    :goto_6d
    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void

    :cond_71
    :goto_71
    return-void
.end method

.method private r225SetGps(ILjava/lang/String;DDLjava/lang/String;)V
    .locals 10

    move-object v1, p0

    move-wide v2, p3

    move-wide v4, p5

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetadataCurrent(ILjava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_9b

    invoke-static/range {p3 .. p6}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225GoodGps(DD)Z

    move-result v0

    if-nez v0, :cond_11

    goto/16 :goto_9b

    :cond_11
    iget-wide v6, v1, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lat:D

    iget-wide v8, v1, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lon:D

    invoke-static {v6, v7, v8, v9}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225GoodGps(DD)Z

    move-result v0

    if-eqz v0, :cond_1c

    return-void

    :cond_1c
    iput-wide v2, v1, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lat:D

    iput-wide v4, v1, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Lon:D

    if-nez p7, :cond_25

    const-string v0, ""

    goto :goto_29

    :cond_25
    invoke-virtual/range {p7 .. p7}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    :goto_29
    iput-object v0, v1, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225ResolvedAddress:Ljava/lang/String;

    iget-object v0, v1, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Address:Landroid/widget/TextView;

    iget-object v6, v1, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225ResolvedAddress:Ljava/lang/String;

    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-eqz v6, :cond_4a

    sget-object v6, Ljava/util/Locale;->KOREA:Ljava/util/Locale;

    invoke-static {p3, p4}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v7

    invoke-static/range {p5 .. p6}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v8

    filled-new-array {v7, v8}, [Ljava/lang/Object;

    move-result-object v7

    const-string v8, "GPS %.6f, %.6f \u00b7 \uc0c1\uc138\uc8fc\uc18c \ud655\uc778 \uc911"

    invoke-static {v6, v8, v7}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    goto :goto_4c

    :cond_4a
    iget-object v6, v1, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225ResolvedAddress:Ljava/lang/String;

    :goto_4c
    invoke-virtual {v0, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const-wide v6, 0x403f6e147ae147aeL    # 31.43

    cmpl-double v0, v2, v6

    const/4 v6, 0x0

    if-ltz v0, :cond_76

    const-wide v7, 0x40462ccccccccccdL    # 44.35

    cmpg-double v0, v2, v7

    if-gtz v0, :cond_76

    const-wide v7, 0x405e97ae147ae148L    # 122.37

    cmpl-double v0, v4, v7

    if-ltz v0, :cond_76

    const-wide v7, 0x4060800000000000L    # 132.0

    cmpg-double v0, v4, v7

    if-gtz v0, :cond_76

    const/4 v0, 0x1

    goto :goto_77

    :cond_76
    move v0, v6

    :goto_77
    iget-object v7, v1, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Naver:Landroid/view/View;

    if-eqz v0, :cond_7c

    goto :goto_7e

    :cond_7c
    const/16 v6, 0x8

    :goto_7e
    invoke-virtual {v7, v6}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, v1, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225ResolvedAddress:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_8a

    return-void

    :cond_8a
    iget-object v8, v1, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetadataWorker:Ljava/util/concurrent/ExecutorService;

    new-instance v9, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda43;

    move-object v0, v9

    move-object v1, p0

    move-wide v2, p3

    move-wide v4, p5

    move v6, p1

    move-object v7, p2

    invoke-direct/range {v0 .. v7}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda43;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;DDILjava/lang/String;)V

    invoke-interface {v8, v9}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    return-void

    :cond_9b
    :goto_9b
    return-void
.end method

.method private r225SetTime(ILjava/lang/String;JZ)V
    .locals 1

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetadataCurrent(ILjava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_53

    const-wide p1, 0x4977387000L

    cmp-long p1, p3, p1

    if-ltz p1, :cond_53

    const-wide p1, 0x3bb2cc3d800L

    cmp-long p1, p3, p1

    if-lez p1, :cond_19

    goto :goto_53

    :cond_19
    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225HasTime:Z

    if-eqz p1, :cond_20

    if-nez p5, :cond_20

    return-void

    :cond_20
    const/4 p1, 0x1

    iput-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225HasTime:Z

    new-instance p1, Ljava/text/SimpleDateFormat;

    const-string p2, "yyyy.MM.dd HH:mm:ss"

    sget-object v0, Ljava/util/Locale;->KOREA:Ljava/util/Locale;

    invoke-direct {p1, p2, v0}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance p2, Ljava/util/Date;

    invoke-direct {p2, p3, p4}, Ljava/util/Date;-><init>(J)V

    invoke-virtual {p1, p2}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object p1

    iget-object p2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225CaptureTime:Landroid/widget/TextView;

    if-eqz p5, :cond_3c

    const-string p3, "\ucd2c\uc601 \u00b7 "

    goto :goto_3e

    :cond_3c
    const-string p3, "\uae30\ub85d\ub41c \uc2dc\uac04 \u00b7 "

    :goto_3e
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p4, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void

    :cond_53
    :goto_53
    return-void
.end method

.method private refreshPages()V
    .locals 11

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-nez v0, :cond_5

    return-void

    :cond_5
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->header:Landroid/widget/TextView;

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    add-int/lit8 v1, v1, 0x1

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "\uc0ac\uc9c4\u00b7\uc601\uc0c1   "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, " / "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225ScheduleMeta()V

    const/4 v0, 0x0

    move v8, v0

    :goto_36
    const/4 v1, 0x3

    const/4 v2, 0x0

    if-ge v8, v1, :cond_bc

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    add-int/2addr v1, v8

    add-int/lit8 v5, v1, -0x1

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pages:[Landroid/widget/FrameLayout;

    aget-object v1, v1, v8

    if-ltz v5, :cond_4f

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v3

    if-ge v5, v3, :cond_4f

    move v3, v0

    goto :goto_50

    :cond_4f
    const/4 v3, 0x4

    :goto_50
    invoke-virtual {v1, v3}, Landroid/widget/FrameLayout;->setVisibility(I)V

    if-ltz v5, :cond_b4

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-lt v5, v1, :cond_5e

    goto :goto_b4

    :cond_5e
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v1, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    move-object v3, v1

    check-cast v3, Ljava/lang/String;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadedPageIds:[Ljava/lang/String;

    aget-object v1, v1, v8

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    xor-int/lit8 v1, v1, 0x1

    if-eqz v1, :cond_7e

    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadedPageIds:[Ljava/lang/String;

    aput-object v3, v4, v8

    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->images:[Landroid/widget/ImageView;

    aget-object v4, v4, v8

    invoke-virtual {v4, v2}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    :cond_7e
    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->full:Landroid/util/LruCache;

    invoke-virtual {v2, v3}, Landroid/util/LruCache;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/graphics/Bitmap;

    if-nez v2, :cond_90

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->posters:Landroid/util/LruCache;

    invoke-virtual {v2, v3}, Landroid/util/LruCache;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/graphics/Bitmap;

    :cond_90
    if-eqz v2, :cond_9b

    if-eqz v1, :cond_9b

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->images:[Landroid/widget/ImageView;

    aget-object v1, v1, v8

    invoke-virtual {v1, v2}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    :cond_9b
    iget v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadToken:I

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->images:[Landroid/widget/ImageView;

    aget-object v7, v1, v8

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->browsingRail:Z

    if-eqz v1, :cond_a6

    goto :goto_b8

    :cond_a6
    iget-object v9, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->background:Ljava/util/concurrent/ExecutorService;

    new-instance v10, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda35;

    move-object v1, v10

    move-object v2, p0

    move v6, v8

    invoke-direct/range {v1 .. v7}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda35;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Ljava/lang/String;IIILandroid/widget/ImageView;)V

    invoke-interface {v9, v10}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    goto :goto_b8

    :cond_b4
    :goto_b4
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadedPageIds:[Ljava/lang/String;

    aput-object v2, v1, v8

    :goto_b8
    add-int/lit8 v8, v8, 0x1

    goto/16 :goto_36

    :cond_bc
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    iget v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    invoke-virtual {v1, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-direct {p0, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->video(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_ee

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoScrubMode:Z

    const/4 v3, 0x0

    iput v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubExpansion:F

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubAnim:Landroid/animation/ValueAnimator;

    if-eqz v3, :cond_dc

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubAnim:Landroid/animation/ValueAnimator;

    invoke-virtual {v3}, Landroid/animation/ValueAnimator;->cancel()V

    iput-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubAnim:Landroid/animation/ValueAnimator;

    :cond_dc
    const-string v2, ""

    iput-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameClip:Ljava/lang/String;

    iget v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameToken:I

    add-int/lit8 v2, v2, 0x1

    iput v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameToken:I

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrames:Ljava/util/HashMap;

    invoke-virtual {v2}, Ljava/util/HashMap;->clear()V

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->hideScrubPreview()V

    :cond_ee
    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoControls:Landroid/widget/LinearLayout;

    const/16 v3, 0x8

    if-eqz v1, :cond_f6

    move v1, v0

    goto :goto_f7

    :cond_f6
    move v1, v3

    :goto_f7
    invoke-virtual {v2, v1}, Landroid/widget/LinearLayout;->setVisibility(I)V

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seekRow:Landroid/widget/LinearLayout;

    if-eqz v1, :cond_103

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seekRow:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v3}, Landroid/widget/LinearLayout;->setVisibility(I)V

    :cond_103
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeButton:Landroid/widget/Button;

    if-eqz v1, :cond_10c

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeButton:Landroid/widget/Button;

    invoke-virtual {v1, v3}, Landroid/widget/Button;->setVisibility(I)V

    :cond_10c
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seek:Landroid/widget/SeekBar;

    if-eqz v1, :cond_11a

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seek:Landroid/widget/SeekBar;

    iget-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoScrubMode:Z

    if-eqz v2, :cond_117

    move v0, v3

    :cond_117
    invoke-virtual {v1, v0}, Landroid/widget/SeekBar;->setVisibility(I)V

    :cond_11a
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeHint:Landroid/widget/TextView;

    if-eqz v0, :cond_123

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeHint:Landroid/widget/TextView;

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setVisibility(I)V

    :cond_123
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    if-eqz v0, :cond_13d

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    int-to-float v1, v1

    invoke-static {v0, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;->-$$Nest$fputcenter(Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;F)V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    invoke-virtual {v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;->invalidate()V

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->browsingRail:Z

    if-nez v0, :cond_13d

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    invoke-virtual {v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;->prefetch()V

    :cond_13d
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->updateMediaVolume()V

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoScrubMode:Z

    if-eqz v0, :cond_14b

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    if-eqz v0, :cond_14b

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->requestScrubFrames()V

    :cond_14b
    return-void
.end method

.method private registerBack()V
    .locals 3

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x21

    if-lt v0, v1, :cond_20

    :try_start_6
    new-instance v0, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda45;

    invoke-direct {v0, p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda45;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->backCallback:Landroid/window/OnBackInvokedCallback;

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->getOnBackInvokedDispatcher()Landroid/window/OnBackInvokedDispatcher;

    move-result-object v0

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->backCallback:Landroid/window/OnBackInvokedCallback;

    const v2, 0xf4240

    invoke-interface {v0, v2, v1}, Landroid/window/OnBackInvokedDispatcher;->registerOnBackInvokedCallback(ILandroid/window/OnBackInvokedCallback;)V

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->backRegistered:Z
    :try_end_1e
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_1e} :catch_1f

    goto :goto_20

    :catch_1f
    move-exception v0

    :cond_20
    :goto_20
    return-void
.end method

.method private requestScrubFrames()V
    .locals 12

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_80

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_80

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->video(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_80

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    if-nez v0, :cond_21

    goto :goto_80

    :cond_21
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    move-object v3, v0

    check-cast v3, Ljava/lang/String;

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameClip:Ljava/lang/String;

    invoke-virtual {v3, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_35

    return-void

    :cond_35
    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameClip:Ljava/lang/String;

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrames:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->clear()V

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameToken:I

    const/4 v1, 0x1

    add-int/lit8 v6, v0, 0x1

    iput v6, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameToken:I

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoLengthMs()I

    move-result v7

    int-to-float v0, v7

    const v2, 0x451c4000    # 2500.0f

    div-float/2addr v0, v2

    float-to-double v4, v0

    invoke-static {v4, v5}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v4

    double-to-int v0, v4

    add-int/2addr v0, v1

    const/16 v2, 0x14

    invoke-static {v2, v0}, Ljava/lang/Math;->min(II)I

    move-result v0

    const/16 v2, 0xa

    invoke-static {v2, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameCount:I

    iget v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameCount:I

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoPositionMs()I

    move-result v0

    int-to-long v8, v0

    add-int/lit8 v0, v4, -0x1

    int-to-long v10, v0

    mul-long/2addr v8, v10

    invoke-static {v1, v7}, Ljava/lang/Math;->max(II)I

    move-result v0

    int-to-long v0, v0

    div-long/2addr v8, v0

    long-to-int v5, v8

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->frameWorker:Ljava/util/concurrent/ExecutorService;

    new-instance v8, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda12;

    move-object v1, v8

    move-object v2, p0

    invoke-direct/range {v1 .. v7}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda12;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Ljava/lang/String;IIII)V

    invoke-interface {v0, v8}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    return-void

    :cond_80
    :goto_80
    return-void
.end method

.method private resetPhotoZoom()V
    .locals 4

    const/high16 v0, 0x3f800000    # 1.0f

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoZoom:F

    const/4 v1, 0x0

    iput v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoPanX:F

    iput v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->photoPanY:F

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->images:[Landroid/widget/ImageView;

    const/4 v3, 0x1

    aget-object v2, v2, v3

    if-eqz v2, :cond_2c

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->images:[Landroid/widget/ImageView;

    aget-object v2, v2, v3

    invoke-virtual {v2, v0}, Landroid/widget/ImageView;->setScaleX(F)V

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->images:[Landroid/widget/ImageView;

    aget-object v2, v2, v3

    invoke-virtual {v2, v0}, Landroid/widget/ImageView;->setScaleY(F)V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->images:[Landroid/widget/ImageView;

    aget-object v0, v0, v3

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setTranslationX(F)V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->images:[Landroid/widget/ImageView;

    aget-object v0, v0, v3

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setTranslationY(F)V

    :cond_2c
    return-void
.end method

.method private scrubTouch(Landroid/view/MotionEvent;FFI)Z
    .locals 4

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    const/4 v1, 0x1

    if-eqz v0, :cond_74

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    if-nez v0, :cond_a

    goto :goto_74

    :cond_a
    const/high16 v0, 0x42c80000    # 100.0f

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v0

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    invoke-direct {p0, v2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->getWidthSafe(Landroid/view/View;)I

    move-result v2

    const/high16 v3, 0x42900000    # 72.0f

    invoke-direct {p0, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v3

    sub-int/2addr v2, v3

    invoke-static {v0, v2}, Ljava/lang/Math;->max(II)I

    move-result v0

    int-to-float v0, v0

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result p1

    sub-float/2addr p2, p1

    div-float/2addr p2, v0

    int-to-float p1, p4

    mul-float/2addr p2, p1

    add-float/2addr p3, p2

    invoke-static {p3}, Ljava/lang/Math;->round(F)I

    move-result p1

    const/4 p2, 0x0

    invoke-static {p4, p1}, Ljava/lang/Math;->min(II)I

    move-result p1

    invoke-static {p2, p1}, Ljava/lang/Math;->max(II)I

    move-result p1

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubMs:I

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    if-eqz p1, :cond_43

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    invoke-virtual {p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;->invalidate()V

    :cond_43
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    if-eqz p1, :cond_6f

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    iget p2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubMs:I

    int-to-long p2, p2

    invoke-direct {p0, p2, p3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->clock(J)Ljava/lang/String;

    move-result-object p2

    int-to-long p3, p4

    invoke-direct {p0, p3, p4}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->clock(J)Ljava/lang/String;

    move-result-object p3

    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p4, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string p4, " / "

    invoke-virtual {p2, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_6f
    iget p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubMs:I

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekWanted:I

    return v1

    :cond_74
    :goto_74
    return v1
.end method

.method private setVideoScrubMode(Z)V
    .locals 4

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_99

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_99

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->video(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1e

    goto/16 :goto_99

    :cond_1e
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubAnim:Landroid/animation/ValueAnimator;

    if-eqz v0, :cond_2a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubAnim:Landroid/animation/ValueAnimator;

    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->cancel()V

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubAnim:Landroid/animation/ValueAnimator;

    :cond_2a
    iput-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoScrubMode:Z

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubExpansion:F

    if-eqz p1, :cond_33

    const/high16 v1, 0x3f800000    # 1.0f

    goto :goto_34

    :cond_33
    const/4 v1, 0x0

    :goto_34
    const/4 v2, 0x2

    new-array v2, v2, [F

    const/4 v3, 0x0

    aput v0, v2, v3

    const/4 v0, 0x1

    aput v1, v2, v0

    invoke-static {v2}, Landroid/animation/ValueAnimator;->ofFloat([F)Landroid/animation/ValueAnimator;

    move-result-object v0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubAnim:Landroid/animation/ValueAnimator;

    const-wide/16 v1, 0xaf

    invoke-virtual {v0, v1, v2}, Landroid/animation/ValueAnimator;->setDuration(J)Landroid/animation/ValueAnimator;

    new-instance v1, Landroid/view/animation/DecelerateInterpolator;

    const v2, 0x3faccccd    # 1.35f

    invoke-direct {v1, v2}, Landroid/view/animation/DecelerateInterpolator;-><init>(F)V

    invoke-virtual {v0, v1}, Landroid/animation/ValueAnimator;->setInterpolator(Landroid/animation/TimeInterpolator;)V

    new-instance v1, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda27;

    invoke-direct {v1, p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda27;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v0, v1}, Landroid/animation/ValueAnimator;->addUpdateListener(Landroid/animation/ValueAnimator$AnimatorUpdateListener;)V

    new-instance v1, Lcom/juhyeon/familyjourney/MoaNativeGallery$9;

    invoke-direct {v1, p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$9;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/animation/ValueAnimator;)V

    invoke-virtual {v0, v1}, Landroid/animation/ValueAnimator;->addListener(Landroid/animation/Animator$AnimatorListener;)V

    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->start()V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeButton:Landroid/widget/Button;

    const/16 v1, 0x8

    if-eqz v0, :cond_71

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeButton:Landroid/widget/Button;

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setVisibility(I)V

    :cond_71
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeHint:Landroid/widget/TextView;

    if-eqz v0, :cond_7a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeHint:Landroid/widget/TextView;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    :cond_7a
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seek:Landroid/widget/SeekBar;

    if-eqz v0, :cond_86

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seek:Landroid/widget/SeekBar;

    if-eqz p1, :cond_83

    move v3, v1

    :cond_83
    invoke-virtual {v0, v3}, Landroid/widget/SeekBar;->setVisibility(I)V

    :cond_86
    if-eqz p1, :cond_8c

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->requestScrubFrames()V

    goto :goto_8f

    :cond_8c
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->hideScrubPreview()V

    :goto_8f
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    if-eqz p1, :cond_98

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    invoke-virtual {p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;->invalidate()V

    :cond_98
    return-void

    :cond_99
    :goto_99
    return-void
.end method

.method private settle(IF)V
    .locals 4

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_5a

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    if-nez v0, :cond_9

    goto :goto_5a

    :cond_9
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->motion:Landroid/animation/ValueAnimator;

    if-eqz v0, :cond_15

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->motion:Landroid/animation/ValueAnimator;

    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->cancel()V

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->motion:Landroid/animation/ValueAnimator;

    :cond_15
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->getWidth()I

    move-result v0

    const/4 v1, 0x1

    invoke-static {v1, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    if-nez p1, :cond_24

    const/4 v0, 0x0

    goto :goto_28

    :cond_24
    if-gez p1, :cond_27

    neg-int v0, v0

    :cond_27
    int-to-float v0, v0

    :goto_28
    const/4 v2, 0x2

    new-array v2, v2, [F

    const/4 v3, 0x0

    aput p2, v2, v3

    aput v0, v2, v1

    invoke-static {v2}, Landroid/animation/ValueAnimator;->ofFloat([F)Landroid/animation/ValueAnimator;

    move-result-object p2

    iput-object p2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->motion:Landroid/animation/ValueAnimator;

    const-wide/16 v0, 0xb4

    invoke-virtual {p2, v0, v1}, Landroid/animation/ValueAnimator;->setDuration(J)Landroid/animation/ValueAnimator;

    new-instance v0, Landroid/view/animation/DecelerateInterpolator;

    const v1, 0x3fd33333    # 1.65f

    invoke-direct {v0, v1}, Landroid/view/animation/DecelerateInterpolator;-><init>(F)V

    invoke-virtual {p2, v0}, Landroid/animation/ValueAnimator;->setInterpolator(Landroid/animation/TimeInterpolator;)V

    new-instance v0, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda32;

    invoke-direct {v0, p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda32;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {p2, v0}, Landroid/animation/ValueAnimator;->addUpdateListener(Landroid/animation/ValueAnimator$AnimatorUpdateListener;)V

    new-instance v0, Lcom/juhyeon/familyjourney/MoaNativeGallery$6;

    invoke-direct {v0, p0, p2, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$6;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/animation/ValueAnimator;I)V

    invoke-virtual {p2, v0}, Landroid/animation/ValueAnimator;->addListener(Landroid/animation/Animator$AnimatorListener;)V

    invoke-virtual {p2}, Landroid/animation/ValueAnimator;->start()V

    return-void

    :cond_5a
    :goto_5a
    return-void
.end method

.method private shareOriginal()V
    .locals 4

    :try_start_0
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_57

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_d

    goto :goto_57

    :cond_d
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    iget v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->uri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    if-nez v1, :cond_1e

    return-void

    :cond_1e
    new-instance v2, Landroid/content/Intent;

    const-string v3, "android.intent.action.SEND"

    invoke-direct {v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->video(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_2e

    const-string v0, "video/*"

    goto :goto_30

    :cond_2e
    const-string v0, "image/*"

    :goto_30
    invoke-virtual {v2, v0}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    const-string v0, "android.intent.extra.STREAM"

    invoke-virtual {v2, v0, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v3, "MOA original"

    invoke-static {v0, v3, v1}, Landroid/content/ClipData;->newUri(Landroid/content/ContentResolver;Ljava/lang/CharSequence;Landroid/net/Uri;)Landroid/content/ClipData;

    move-result-object v0

    invoke-virtual {v2, v0}, Landroid/content/Intent;->setClipData(Landroid/content/ClipData;)V

    const/4 v0, 0x1

    invoke-virtual {v2, v0}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    const-string v1, "\uc0ac\uc9c4\u00b7\uc601\uc0c1 \uacf5\uc720"

    invoke-static {v2, v1}, Landroid/content/Intent;->createChooser(Landroid/content/Intent;Ljava/lang/CharSequence;)Landroid/content/Intent;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :try_end_56
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_56} :catch_58

    goto :goto_65

    :cond_57
    :goto_57
    return-void

    :catch_58
    move-exception v0

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    const-string v1, "\uacf5\uc720 \ud654\uba74\uc744 \uc5f4\uc9c0 \ubabb\ud588\uc5b4\uc694"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    :goto_65
    return-void
.end method

.method private showScrubPreview(I)V
    .locals 6

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubPreview:Landroid/widget/ImageView;

    if-eqz v0, :cond_76

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrames:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_d

    goto :goto_76

    :cond_d
    const/4 v0, 0x0

    invoke-static {v0, p1}, Ljava/lang/Math;->max(II)I

    move-result p1

    int-to-float p1, p1

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoLengthMs()I

    move-result v1

    const/4 v2, 0x1

    invoke-static {v2, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    int-to-float v1, v1

    div-float/2addr p1, v1

    const/4 v1, 0x2

    iget v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameCount:I

    invoke-static {v1, v3}, Ljava/lang/Math;->max(II)I

    move-result v1

    sub-int/2addr v1, v2

    int-to-float v1, v1

    mul-float/2addr p1, v1

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p1

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrames:Ljava/util/HashMap;

    invoke-virtual {v1}, Ljava/util/HashMap;->keySet()Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v1

    const/4 v2, -0x1

    const v3, 0x7fffffff

    :cond_3a
    :goto_3a
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_57

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/Integer;

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v5

    sub-int/2addr v5, p1

    invoke-static {v5}, Ljava/lang/Math;->abs(I)I

    move-result v5

    if-ge v5, v3, :cond_3a

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v2

    move v3, v5

    goto :goto_3a

    :cond_57
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrames:Ljava/util/HashMap;

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/graphics/Bitmap;

    if-eqz p1, :cond_75

    invoke-virtual {p1}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v1

    if-nez v1, :cond_75

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubPreview:Landroid/widget/ImageView;

    invoke-virtual {v1, p1}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubPreview:Landroid/widget/ImageView;

    invoke-virtual {p1, v0}, Landroid/widget/ImageView;->setVisibility(I)V

    :cond_75
    return-void

    :cond_76
    :goto_76
    return-void
.end method

.method private startTicker()V
    .locals 2

    new-instance v0, Lcom/juhyeon/familyjourney/MoaNativeGallery$8;

    invoke-direct {v0, p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$8;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ticker:Ljava/lang/Runnable;

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ticker:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private teardownPlayer()V
    .locals 4

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ticker:Ljava/lang/Runnable;

    const/4 v1, 0x0

    if-eqz v0, :cond_e

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ticker:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ticker:Ljava/lang/Runnable;

    :cond_e
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187PendingDispatch:Ljava/lang/Runnable;

    if-eqz v0, :cond_1b

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187PendingDispatch:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187PendingDispatch:Ljava/lang/Runnable;

    :cond_1b
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekInFlight:Z

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekReleased:Z

    const-wide/16 v2, 0x0

    iput-wide v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187LastSeekTime:J

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    if-eqz v2, :cond_38

    :try_start_2a
    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {v2}, Landroid/media/MediaPlayer;->reset()V

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {v2}, Landroid/media/MediaPlayer;->release()V
    :try_end_34
    .catch Ljava/lang/Exception; {:try_start_2a .. :try_end_34} :catch_35

    goto :goto_36

    :catch_35
    move-exception v2

    :goto_36
    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    :cond_38
    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mediaSurface:Landroid/view/Surface;

    if-eqz v2, :cond_45

    :try_start_3c
    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mediaSurface:Landroid/view/Surface;

    invoke-virtual {v2}, Landroid/view/Surface;->release()V
    :try_end_41
    .catch Ljava/lang/Exception; {:try_start_3c .. :try_end_41} :catch_42

    goto :goto_43

    :catch_42
    move-exception v2

    :goto_43
    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mediaSurface:Landroid/view/Surface;

    :cond_45
    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    if-eqz v2, :cond_61

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    invoke-virtual {v2, v1}, Landroid/view/TextureView;->setSurfaceTextureListener(Landroid/view/TextureView$SurfaceTextureListener;)V

    invoke-virtual {v2}, Landroid/view/TextureView;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    instance-of v3, v3, Landroid/view/ViewGroup;

    if-eqz v3, :cond_61

    invoke-virtual {v2}, Landroid/view/TextureView;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    check-cast v3, Landroid/view/ViewGroup;

    invoke-virtual {v3, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :cond_61
    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubPreview:Landroid/widget/ImageView;

    if-eqz v2, :cond_7d

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubPreview:Landroid/widget/ImageView;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubPreview:Landroid/widget/ImageView;

    invoke-virtual {v2, v1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    invoke-virtual {v2}, Landroid/widget/ImageView;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    instance-of v1, v1, Landroid/view/ViewGroup;

    if-eqz v1, :cond_7d

    invoke-virtual {v2}, Landroid/widget/ImageView;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    check-cast v1, Landroid/view/ViewGroup;

    invoke-virtual {v1, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :cond_7d
    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubbingVideo:Z

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->images:[Landroid/widget/ImageView;

    const/4 v2, 0x1

    aget-object v1, v1, v2

    if-eqz v1, :cond_8d

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->images:[Landroid/widget/ImageView;

    aget-object v1, v1, v2

    invoke-virtual {v1, v0}, Landroid/widget/ImageView;->setVisibility(I)V

    :cond_8d
    return-void
.end method

.method private toggle()V
    .locals 2

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    if-eqz v0, :cond_43

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    if-nez v0, :cond_9

    goto :goto_43

    :cond_9
    :try_start_9
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->isPlaying()Z

    move-result v0

    if-eqz v0, :cond_17

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->pause()V

    goto :goto_1c

    :cond_17
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->start()V

    :goto_1c
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {v1}, Landroid/media/MediaPlayer;->isPlaying()Z

    move-result v1

    if-eqz v1, :cond_29

    const-string v1, "\u2161"

    goto :goto_2b

    :cond_29
    const-string v1, "\u25b6"

    :goto_2b
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {v1}, Landroid/media/MediaPlayer;->isPlaying()Z

    move-result v1

    if-eqz v1, :cond_3b

    const-string v1, "\ub3d9\uc601\uc0c1 \uc77c\uc2dc\uc815\uc9c0"

    goto :goto_3d

    :cond_3b
    const-string v1, "\ub3d9\uc601\uc0c1 \uc7ac\uc0dd"

    :goto_3d
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setContentDescription(Ljava/lang/CharSequence;)V
    :try_end_40
    .catch Ljava/lang/Exception; {:try_start_9 .. :try_end_40} :catch_41

    goto :goto_42

    :catch_41
    move-exception v0

    :goto_42
    return-void

    :cond_43
    :goto_43
    return-void
.end method

.method private toggleChrome()V
    .locals 4

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-nez v0, :cond_5

    return-void

    :cond_5
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->chromeVisible:Z

    xor-int/lit8 v0, v0, 0x1

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->chromeVisible:Z

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->header:Landroid/widget/TextView;

    const/16 v1, 0x8

    if-eqz v0, :cond_16

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->header:Landroid/widget/TextView;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    :cond_16
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Info:Landroid/widget/LinearLayout;

    const/4 v2, 0x0

    if-eqz v0, :cond_27

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Info:Landroid/widget/LinearLayout;

    iget-boolean v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->chromeVisible:Z

    if-eqz v3, :cond_23

    move v3, v2

    goto :goto_24

    :cond_23
    move v3, v1

    :goto_24
    invoke-virtual {v0, v3}, Landroid/widget/LinearLayout;->setVisibility(I)V

    :cond_27
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->backButton:Landroid/widget/Button;

    if-eqz v0, :cond_30

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->backButton:Landroid/widget/Button;

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setVisibility(I)V

    :cond_30
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->menuButton:Landroid/widget/Button;

    if-eqz v0, :cond_39

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->menuButton:Landroid/widget/Button;

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setVisibility(I)V

    :cond_39
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lowerControls:Landroid/widget/LinearLayout;

    if-eqz v0, :cond_47

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lowerControls:Landroid/widget/LinearLayout;

    iget-boolean v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->chromeVisible:Z

    if-eqz v3, :cond_44

    move v1, v2

    :cond_44
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setVisibility(I)V

    :cond_47
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->updateMediaVolume()V

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->updateChromeLayout()V

    return-void
.end method

.method private toggleMute()V
    .locals 5

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->muted:Z

    xor-int/lit8 v0, v0, 0x1

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->muted:Z

    :try_start_6
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    if-eqz v0, :cond_21

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->muted:Z

    const/4 v2, 0x0

    const/high16 v3, 0x3f800000    # 1.0f

    if-eqz v1, :cond_15

    move v1, v2

    goto :goto_16

    :cond_15
    move v1, v3

    :goto_16
    iget-boolean v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->muted:Z

    if-eqz v4, :cond_1b

    goto :goto_1c

    :cond_1b
    move v2, v3

    :goto_1c
    invoke-virtual {v0, v1, v2}, Landroid/media/MediaPlayer;->setVolume(FF)V
    :try_end_1f
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_1f} :catch_20

    goto :goto_21

    :catch_20
    move-exception v0

    :cond_21
    :goto_21
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mute:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->muted:Z

    if-eqz v1, :cond_2a

    const-string v1, "\u266a"

    goto :goto_2c

    :cond_2a
    const-string v1, "\u266b"

    :goto_2c
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mute:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->muted:Z

    if-eqz v1, :cond_38

    const-string v1, "\ub3d9\uc601\uc0c1 \uc18c\ub9ac \ucf1c\uae30"

    goto :goto_3a

    :cond_38
    const-string v1, "\ub3d9\uc601\uc0c1 \uc18c\ub9ac \ub044\uae30"

    :goto_3a
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setContentDescription(Ljava/lang/CharSequence;)V

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->updateMediaVolume()V

    return-void
.end method

.method private touchVideoFrames(Landroid/view/MotionEvent;)Z
    .locals 5

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    const/4 v1, 0x1

    if-eqz v0, :cond_93

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    if-nez v0, :cond_b

    goto/16 :goto_93

    :cond_b
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoLengthMs()I

    move-result v0

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v2

    const/4 v3, 0x0

    packed-switch v2, :pswitch_data_94

    return v1

    :pswitch_18
    iget p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubDownMs:F

    float-to-int p1, p1

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekWanted:I

    iput-boolean v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubbingVideo:Z

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekReleased:Z

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187ScheduleSeek()V

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    if-eqz p1, :cond_2d

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    invoke-virtual {p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;->invalidate()V

    :cond_2d
    return v1

    :pswitch_2e
    iget v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubDownX:F

    iget v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubDownMs:F

    invoke-direct {p0, p1, v2, v3, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubTouch(Landroid/view/MotionEvent;FFI)Z

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187ScheduleSeek()V

    return v1

    :pswitch_39
    iget v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubDownX:F

    iget v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubDownMs:F

    invoke-direct {p0, p1, v2, v4, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubTouch(Landroid/view/MotionEvent;FFI)Z

    iget p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubMs:I

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekWanted:I

    iput-boolean v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubbingVideo:Z

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekReleased:Z

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187ScheduleSeek()V

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    if-eqz p1, :cond_54

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    invoke-virtual {p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;->invalidate()V

    :cond_54
    return v1

    :pswitch_55
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187PendingDispatch:Ljava/lang/Runnable;

    if-eqz v0, :cond_63

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187PendingDispatch:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187PendingDispatch:Ljava/lang/Runnable;

    :cond_63
    iput-boolean v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekReleased:Z

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result p1

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubDownX:F

    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoPositionMs()I

    move-result p1

    int-to-float p1, p1

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubDownMs:F

    iget p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubDownMs:F

    float-to-int p1, p1

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubMs:I

    iget p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubMs:I

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r187SeekWanted:I

    iput-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubbingVideo:Z

    :try_start_7d
    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {p1}, Landroid/media/MediaPlayer;->isPlaying()Z

    move-result p1

    iput-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubWasPlaying:Z

    iget-boolean p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubWasPlaying:Z

    if-eqz p1, :cond_92

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {p1}, Landroid/media/MediaPlayer;->pause()V
    :try_end_8e
    .catch Ljava/lang/Exception; {:try_start_7d .. :try_end_8e} :catch_8f

    goto :goto_92

    :catch_8f
    move-exception p1

    iput-boolean v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubWasPlaying:Z

    :cond_92
    :goto_92
    return v1

    :cond_93
    :goto_93
    return v1

    :pswitch_data_94
    .packed-switch 0x0
        :pswitch_55
        :pswitch_39
        :pswitch_2e
        :pswitch_18
    .end packed-switch
.end method

.method private updateChromeLayout()V
    .locals 4

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    if-eqz v0, :cond_2f

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lowerControls:Landroid/widget/LinearLayout;

    if-eqz v0, :cond_2f

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_11

    goto :goto_2f

    :cond_11
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lowerControls:Landroid/widget/LinearLayout;

    invoke-virtual {v0}, Landroid/widget/LinearLayout;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    if-eqz v0, :cond_2e

    iget v1, v0, Landroid/view/ViewGroup$LayoutParams;->height:I

    const/high16 v2, 0x43500000    # 208.0f

    invoke-direct {p0, v2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v3

    if-eq v1, v3, :cond_2e

    invoke-direct {p0, v2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v1

    iput v1, v0, Landroid/view/ViewGroup$LayoutParams;->height:I

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lowerControls:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v0}, Landroid/widget/LinearLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :cond_2e
    return-void

    :cond_2f
    :goto_2f
    return-void
.end method

.method private updateMediaVolume()V
    .locals 3

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeBubble:Landroid/view/View;

    if-eqz v0, :cond_51

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    if-eqz v0, :cond_51

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_11

    goto :goto_51

    :cond_11
    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    const/4 v1, 0x0

    if-eqz v0, :cond_30

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->chromeVisible:Z

    if-eqz v0, :cond_30

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    iget v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    invoke-virtual {v0, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->video(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_30

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->muted:Z

    if-nez v0, :cond_30

    const/4 v0, 0x1

    goto :goto_31

    :cond_30
    move v0, v1

    :goto_31
    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeBubble:Landroid/view/View;

    if-eqz v0, :cond_36

    goto :goto_38

    :cond_36
    const/16 v1, 0x8

    :goto_38
    invoke-virtual {v2, v1}, Landroid/view/View;->setVisibility(I)V

    if-eqz v0, :cond_50

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeBubble:Landroid/view/View;

    new-instance v1, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda18;

    invoke-direct {v1, p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda18;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeRail:Lcom/juhyeon/familyjourney/MoaNativeGallery$VerticalMediaVolume;

    if-eqz v0, :cond_50

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeRail:Lcom/juhyeon/familyjourney/MoaNativeGallery$VerticalMediaVolume;

    invoke-virtual {v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$VerticalMediaVolume;->invalidate()V

    :cond_50
    return-void

    :cond_51
    :goto_51
    return-void
.end method

.method private updatePosition(F)V
    .locals 5

    iput p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->fingerOffset:F

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_3d

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    if-nez v0, :cond_b

    goto :goto_3d

    :cond_b
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->getWidth()I

    move-result v0

    const/4 v1, 0x1

    invoke-static {v1, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    const/4 v2, 0x0

    :goto_17
    const/4 v3, 0x3

    if-ge v2, v3, :cond_29

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pages:[Landroid/widget/FrameLayout;

    aget-object v3, v3, v2

    add-int/lit8 v4, v2, -0x1

    mul-int/2addr v4, v0

    int-to-float v4, v4

    add-float/2addr v4, p1

    invoke-virtual {v3, v4}, Landroid/widget/FrameLayout;->setTranslationX(F)V

    add-int/lit8 v2, v2, 0x1

    goto :goto_17

    :cond_29
    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    if-eqz v2, :cond_3c

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    iget v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    int-to-float v3, v3

    invoke-static {v1, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    int-to-float v0, v0

    div-float/2addr p1, v0

    sub-float/2addr v3, p1

    invoke-virtual {v2, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;->r205Track(F)V

    :cond_3c
    return-void

    :cond_3d
    :goto_3d
    return-void
.end method

.method private updateVideoGeometry(II)V
    .locals 4

    const/4 v0, 0x1

    if-lt p1, v0, :cond_44

    if-lt p2, v0, :cond_44

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    if-nez v0, :cond_a

    goto :goto_44

    :cond_a
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    invoke-virtual {v0}, Landroid/view/TextureView;->getWidth()I

    move-result v0

    int-to-float v0, v0

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    invoke-virtual {v1}, Landroid/view/TextureView;->getHeight()I

    move-result v1

    int-to-float v1, v1

    const/high16 v2, 0x3f800000    # 1.0f

    cmpg-float v3, v0, v2

    if-ltz v3, :cond_43

    cmpg-float v2, v1, v2

    if-gez v2, :cond_23

    goto :goto_43

    :cond_23
    int-to-float p1, p1

    div-float v2, v0, p1

    int-to-float p2, p2

    div-float v3, v1, p2

    invoke-static {v2, v3}, Ljava/lang/Math;->min(FF)F

    move-result v2

    mul-float/2addr p1, v2

    div-float/2addr p1, v0

    mul-float/2addr p2, v2

    div-float/2addr p2, v1

    new-instance v2, Landroid/graphics/Matrix;

    invoke-direct {v2}, Landroid/graphics/Matrix;-><init>()V

    const/high16 v3, 0x40000000    # 2.0f

    div-float/2addr v0, v3

    div-float/2addr v1, v3

    invoke-virtual {v2, p1, p2, v0, v1}, Landroid/graphics/Matrix;->setScale(FFFF)V

    iget-object p1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->texture:Landroid/view/TextureView;

    invoke-virtual {p1, v2}, Landroid/view/TextureView;->setTransform(Landroid/graphics/Matrix;)V

    return-void

    :cond_43
    :goto_43
    return-void

    :cond_44
    :goto_44
    return-void
.end method

.method private uri(Ljava/lang/String;)Landroid/net/Uri;
    .locals 3

    const/4 v0, 0x0

    if-eqz p1, :cond_2f

    const-string v1, "v?[0-9]{1,18}"

    invoke-virtual {p1, v1}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_c

    goto :goto_2f

    :cond_c
    :try_start_c
    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->video(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_18

    const/4 v1, 0x1

    invoke-virtual {p1, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v1

    goto :goto_19

    :cond_18
    move-object v1, p1

    :goto_19
    invoke-static {v1}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v1

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->video(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_26

    sget-object p1, Landroid/provider/MediaStore$Video$Media;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;

    goto :goto_28

    :cond_26
    sget-object p1, Landroid/provider/MediaStore$Images$Media;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;

    :goto_28
    invoke-static {p1, v1, v2}, Landroid/content/ContentUris;->withAppendedId(Landroid/net/Uri;J)Landroid/net/Uri;

    move-result-object p1
    :try_end_2c
    .catch Ljava/lang/Exception; {:try_start_c .. :try_end_2c} :catch_2d

    return-object p1

    :catch_2d
    move-exception p1

    return-object v0

    :cond_2f
    :goto_2f
    return-object v0
.end method

.method private video(Ljava/lang/String;)Z
    .locals 1

    if-eqz p1, :cond_c

    const-string v0, "v"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_c

    const/4 p1, 0x1

    goto :goto_d

    :cond_c
    const/4 p1, 0x0

    :goto_d
    return p1
.end method

.method private videoFailure()V
    .locals 5

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    if-nez v0, :cond_8

    return-void

    :cond_8
    new-instance v0, Landroid/widget/TextView;

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v0, v1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v1, "\ub3d9\uc601\uc0c1\uc744 \ubc14\ub85c \uc7ac\uc0dd\ud558\uc9c0 \ubabb\ud588\uc5b4\uc694. \uc6d0\ubcf8 \uac24\ub7ec\ub9ac\uc5d0\uc11c \uc5f4\uae30"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v1, 0x41600000    # 14.0f

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V

    const/4 v1, -0x1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    const/16 v2, 0x11

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setGravity(I)V

    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    const/high16 v4, 0x428c0000    # 70.0f

    invoke-direct {p0, v4}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v4

    invoke-direct {v3, v1, v4, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pages:[Landroid/widget/FrameLayout;

    const/4 v2, 0x1

    aget-object v1, v1, v2

    invoke-virtual {v1, v0, v3}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v1, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda38;

    invoke-direct {v1, p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda38;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-void
.end method

.method private videoLengthMs()I
    .locals 2

    const/16 v0, 0x3e8

    :try_start_2
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    if-eqz v1, :cond_16

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    if-eqz v1, :cond_16

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {v1}, Landroid/media/MediaPlayer;->getDuration()I

    move-result v1

    invoke-static {v0, v1}, Ljava/lang/Math;->max(II)I

    move-result v0
    :try_end_14
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_14} :catch_15

    return v0

    :catch_15
    move-exception v1

    :cond_16
    return v0
.end method

.method private videoPositionMs()I
    .locals 2

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubbingVideo:Z

    if-eqz v0, :cond_7

    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubMs:I

    return v0

    :cond_7
    const/4 v0, 0x0

    :try_start_8
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    if-eqz v1, :cond_1c

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    if-eqz v1, :cond_1c

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {v1}, Landroid/media/MediaPlayer;->getCurrentPosition()I

    move-result v1

    invoke-static {v0, v1}, Ljava/lang/Math;->max(II)I

    move-result v0
    :try_end_1a
    .catch Ljava/lang/Exception; {:try_start_8 .. :try_end_1a} :catch_1b

    return v0

    :catch_1b
    move-exception v1

    :cond_1c
    return v0
.end method


# virtual methods
.method public close()V
    .locals 6

    invoke-static {}, Lcom/juhyeon/familyjourney/MoaNaverReturnOverlay;->hide()V

    invoke-static {}, Landroid/os/Looper;->myLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    if-eq v0, v1, :cond_18

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    new-instance v1, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda26;

    invoke-direct {v1, p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda26;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void

    :cond_18
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203CancelFling()V

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203StageVelocity:Landroid/view/VelocityTracker;

    const/4 v1, 0x0

    if-eqz v0, :cond_27

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203StageVelocity:Landroid/view/VelocityTracker;

    invoke-virtual {v0}, Landroid/view/VelocityTracker;->recycle()V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r203StageVelocity:Landroid/view/VelocityTracker;

    :cond_27
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205PreviewDismiss:Ljava/lang/Runnable;

    if-eqz v0, :cond_34

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205PreviewDismiss:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205PreviewDismiss:Ljava/lang/Runnable;

    :cond_34
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    if-eqz v0, :cond_3f

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205CapturePreview:Landroid/widget/ImageView;

    :cond_3f
    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoLoadGeneration:I

    const/4 v2, 0x1

    add-int/2addr v0, v2

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoLoadGeneration:I

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoViewer:Landroid/widget/FrameLayout;

    if-eqz v0, :cond_60

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoViewer:Landroid/widget/FrameLayout;

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_60

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoViewer:Landroid/widget/FrameLayout;

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoViewer:Landroid/widget/FrameLayout;

    invoke-virtual {v0, v3}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :cond_60
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoImage:Landroid/widget/ImageView;

    if-eqz v0, :cond_69

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoImage:Landroid/widget/ImageView;

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    :cond_69
    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoViewer:Landroid/widget/FrameLayout;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207SavedPhotoImage:Landroid/widget/ImageView;

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r207ResumeVideoAfterPhoto:Z

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227ExternalMapPending:Z

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227VideoWasPlaying:Z

    iget v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadToken:I

    add-int/2addr v3, v2

    iput v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadToken:I

    iget v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoToken:I

    add-int/2addr v3, v2

    iput v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoToken:I

    iget v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameToken:I

    add-int/2addr v3, v2

    iput v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameToken:I

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    if-eqz v3, :cond_9a

    :try_start_89
    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v3}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v3

    invoke-virtual {v3}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v3

    iget v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->savedSystemUi:I

    invoke-virtual {v3, v4}, Landroid/view/View;->setSystemUiVisibility(I)V
    :try_end_98
    .catch Ljava/lang/Exception; {:try_start_89 .. :try_end_98} :catch_99

    goto :goto_9a

    :catch_99
    move-exception v3

    :cond_9a
    :goto_9a
    iput-boolean v2, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->chromeVisible:Z

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoScrubMode:Z

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrames:Ljava/util/HashMap;

    invoke-virtual {v3}, Ljava/util/HashMap;->clear()V

    const-string v3, ""

    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubFrameClip:Ljava/lang/String;

    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubAnim:Landroid/animation/ValueAnimator;

    if-eqz v4, :cond_b2

    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubAnim:Landroid/animation/ValueAnimator;

    invoke-virtual {v4}, Landroid/animation/ValueAnimator;->cancel()V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubAnim:Landroid/animation/ValueAnimator;

    :cond_b2
    const/4 v4, 0x0

    iput v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197ScrubExpansion:F

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r197CenterTapPending:Z

    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->motion:Landroid/animation/ValueAnimator;

    if-eqz v4, :cond_c2

    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->motion:Landroid/animation/ValueAnimator;

    invoke-virtual {v4}, Landroid/animation/ValueAnimator;->cancel()V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->motion:Landroid/animation/ValueAnimator;

    :cond_c2
    invoke-direct {p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->teardownPlayer()V

    iget-boolean v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->backRegistered:Z

    if-eqz v4, :cond_dc

    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v5, 0x21

    if-lt v4, v5, :cond_dc

    :try_start_cf
    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v4}, Landroid/app/Activity;->getOnBackInvokedDispatcher()Landroid/window/OnBackInvokedDispatcher;

    move-result-object v4

    iget-object v5, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->backCallback:Landroid/window/OnBackInvokedCallback;

    invoke-interface {v4, v5}, Landroid/window/OnBackInvokedDispatcher;->unregisterOnBackInvokedCallback(Landroid/window/OnBackInvokedCallback;)V
    :try_end_da
    .catch Ljava/lang/Exception; {:try_start_cf .. :try_end_da} :catch_db

    goto :goto_dc

    :catch_db
    move-exception v4

    :cond_dc
    :goto_dc
    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->backRegistered:Z

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->backCallback:Landroid/window/OnBackInvokedCallback;

    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    if-eqz v4, :cond_fb

    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    invoke-virtual {v4}, Landroid/widget/FrameLayout;->getParent()Landroid/view/ViewParent;

    move-result-object v4

    instance-of v4, v4, Landroid/view/ViewGroup;

    if-eqz v4, :cond_fb

    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    invoke-virtual {v4}, Landroid/widget/FrameLayout;->getParent()Landroid/view/ViewParent;

    move-result-object v4

    check-cast v4, Landroid/view/ViewGroup;

    iget-object v5, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :cond_fb
    nop

    :goto_fc
    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadedPageIds:[Ljava/lang/String;

    array-length v4, v4

    if-ge v0, v4, :cond_108

    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->loadedPageIds:[Ljava/lang/String;

    aput-object v1, v4, v0

    add-int/lit8 v0, v0, 0x1

    goto :goto_fc

    :cond_108
    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pendingPosters:Ljava/util/HashSet;

    invoke-virtual {v0}, Ljava/util/HashSet;->clear()V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->scrubPreview:Landroid/widget/ImageView;

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225PendingMeta:Ljava/lang/Runnable;

    if-eqz v0, :cond_11c

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->main:Landroid/os/Handler;

    iget-object v4, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225PendingMeta:Ljava/lang/Runnable;

    invoke-virtual {v0, v4}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225PendingMeta:Ljava/lang/Runnable;

    :cond_11c
    iget v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetaSeq:I

    add-int/2addr v0, v2

    iput v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetaSeq:I

    iput-object v3, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225MetaId:Ljava/lang/String;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Info:Landroid/widget/LinearLayout;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225CaptureTime:Landroid/widget/TextView;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Address:Landroid/widget/TextView;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Naver:Landroid/view/View;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lowerControls:Landroid/widget/LinearLayout;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeRow:Landroid/widget/LinearLayout;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeBubble:Landroid/view/View;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeRail:Lcom/juhyeon/familyjourney/MoaNativeGallery$VerticalMediaVolume;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeButton:Landroid/widget/Button;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeHint:Landroid/widget/TextView;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seekRow:Landroid/widget/LinearLayout;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->backButton:Landroid/widget/Button;

    iput-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->menuButton:Landroid/widget/Button;

    iget-object v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    return-void
.end method

.method public isOpen()Z
    .locals 1

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    return v0
.end method

.method public open(Ljava/lang/String;ILjava/lang/String;)Z
    .locals 16

    move-object/from16 v0, p0

    move-object/from16 v1, p3

    invoke-static {}, Landroid/os/Looper;->myLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v3

    const/4 v4, 0x0

    if-eq v2, v3, :cond_10

    return v4

    :cond_10
    :try_start_10
    new-instance v2, Lorg/json/JSONArray;

    move-object/from16 v3, p1

    invoke-direct {v2, v3}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V
    :try_end_17
    .catch Ljava/lang/Exception; {:try_start_10 .. :try_end_17} :catch_6ce

    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v3

    const/4 v5, 0x1

    if-lt v3, v5, :cond_6cd

    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v3

    const/16 v6, 0x2710

    if-le v3, v6, :cond_28

    goto/16 :goto_6cd

    :cond_28
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    move v6, v4

    :goto_2e
    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v7

    const-string v8, ""

    if-ge v6, v7, :cond_47

    invoke-virtual {v2, v6, v8}, Lorg/json/JSONArray;->optString(ILjava/lang/String;)Ljava/lang/String;

    move-result-object v7

    invoke-direct {v0, v7}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->uri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v8

    if-nez v8, :cond_41

    return v4

    :cond_41
    invoke-virtual {v3, v7}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v6, v6, 0x1

    goto :goto_2e

    :cond_47
    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v2

    sub-int/2addr v2, v5

    move/from16 v6, p2

    invoke-static {v6, v2}, Ljava/lang/Math;->min(II)I

    move-result v2

    invoke-static {v4, v2}, Ljava/lang/Math;->max(II)I

    move-result v2

    invoke-virtual {v3, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    invoke-direct {v0, v6}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->uri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v6

    :try_start_60
    iget-object v7, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v7}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v7

    const-string v9, "r"

    invoke-virtual {v7, v6, v9}, Landroid/content/ContentResolver;->openFileDescriptor(Landroid/net/Uri;Ljava/lang/String;)Landroid/os/ParcelFileDescriptor;

    move-result-object v6

    if-nez v6, :cond_74

    if-eqz v6, :cond_73

    invoke-virtual {v6}, Landroid/os/ParcelFileDescriptor;->close()V

    :cond_73
    return v4

    :cond_74
    if-eqz v6, :cond_79

    invoke-virtual {v6}, Landroid/os/ParcelFileDescriptor;->close()V
    :try_end_79
    .catch Ljava/lang/Exception; {:try_start_60 .. :try_end_79} :catch_6cb

    :cond_79
    invoke-virtual/range {p0 .. p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->close()V

    iput-boolean v4, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->browsingRail:Z

    iget-object v6, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->ids:Ljava/util/ArrayList;

    invoke-virtual {v6, v3}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    iput v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->index:I

    iput-boolean v5, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->chromeVisible:Z

    iput-boolean v4, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoScrubMode:Z

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v2}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v2

    invoke-virtual {v2}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v2

    invoke-virtual {v2}, Landroid/view/View;->getSystemUiVisibility()I

    move-result v2

    iput v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->savedSystemUi:I

    if-nez v1, :cond_9c

    goto :goto_a2

    :cond_9c
    const-string v2, "[^0-9-]"

    invoke-virtual {v1, v2, v8}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    :goto_a2
    iput-object v8, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->currentDay:Ljava/lang/String;

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    const v2, 0x1020002

    invoke-virtual {v1, v2}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/FrameLayout;

    if-nez v1, :cond_b2

    return v4

    :cond_b2
    new-instance v2, Landroid/widget/FrameLayout;

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v2, v3}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    iput-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    const/high16 v3, -0x1000000

    invoke-virtual {v2, v3}, Landroid/widget/FrameLayout;->setBackgroundColor(I)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    invoke-virtual {v2, v5}, Landroid/widget/FrameLayout;->setClickable(Z)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    invoke-virtual {v2, v5}, Landroid/widget/FrameLayout;->setFocusableInTouchMode(Z)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    new-instance v6, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v7, -0x1

    invoke-direct {v6, v7, v7}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v2, v6}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v1, Landroid/widget/FrameLayout;

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v1, v2}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    iput-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    invoke-virtual {v1, v3}, Landroid/widget/FrameLayout;->setBackgroundColor(I)V

    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v1, v7, v7}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    iput v4, v1, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    iput v4, v1, Landroid/widget/FrameLayout$LayoutParams;->bottomMargin:I

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    iget-object v6, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    invoke-virtual {v2, v6, v1}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    move v1, v4

    :goto_f6
    const/4 v2, 0x3

    if-ge v1, v2, :cond_12f

    new-instance v2, Landroid/widget/FrameLayout;

    iget-object v6, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v2, v6}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    new-instance v6, Landroid/widget/ImageView;

    iget-object v8, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v6, v8}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    sget-object v8, Landroid/widget/ImageView$ScaleType;->FIT_CENTER:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {v6, v8}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    invoke-virtual {v6, v3}, Landroid/widget/ImageView;->setBackgroundColor(I)V

    invoke-virtual {v6, v4}, Landroid/widget/ImageView;->setClickable(Z)V

    new-instance v8, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v8, v7, v7}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v6, v8}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iget-object v8, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pages:[Landroid/widget/FrameLayout;

    aput-object v2, v8, v1

    iget-object v8, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->images:[Landroid/widget/ImageView;

    aput-object v6, v8, v1

    iget-object v6, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    new-instance v8, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v8, v7, v7}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v6, v2, v8}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_f6

    :cond_12f
    new-instance v1, Landroid/view/View;

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v1, v3}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    invoke-virtual {v1, v4}, Landroid/view/View;->setBackgroundColor(I)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    new-instance v6, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v6, v7, v7}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v3, v1, v6}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v3, Lcom/juhyeon/familyjourney/MoaNativeGallery$SwipeHandler;

    const/4 v6, 0x0

    invoke-direct {v3, v0, v6}, Lcom/juhyeon/familyjourney/MoaNativeGallery$SwipeHandler;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Lcom/juhyeon/familyjourney/MoaNativeGallery$SwipeHandler-IA;)V

    invoke-virtual {v1, v3}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    new-instance v1, Landroid/widget/TextView;

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v1, v3}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    iput-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->header:Landroid/widget/TextView;

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->header:Landroid/widget/TextView;

    invoke-virtual {v1, v7}, Landroid/widget/TextView;->setTextColor(I)V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->header:Landroid/widget/TextView;

    const/high16 v3, 0x41700000    # 15.0f

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setTextSize(F)V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->header:Landroid/widget/TextView;

    const/16 v3, 0x10

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setGravity(I)V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->header:Landroid/widget/TextView;

    const/high16 v8, 0x41880000    # 17.0f

    invoke-direct {v0, v8}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v8

    invoke-virtual {v1, v8, v4, v4, v4}, Landroid/widget/TextView;->setPadding(IIII)V

    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/high16 v8, 0x42400000    # 48.0f

    invoke-direct {v0, v8}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v8

    const/16 v9, 0x30

    invoke-direct {v1, v7, v8, v9}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    iget-object v8, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->header:Landroid/widget/TextView;

    invoke-virtual {v8, v10, v1}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    const-string v1, "\u2039  \ub2eb\uae30"

    const/16 v8, 0xf

    invoke-direct {v0, v1, v8}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->button(Ljava/lang/String;I)Landroid/widget/Button;

    move-result-object v1

    new-instance v8, Landroid/widget/FrameLayout$LayoutParams;

    const/high16 v10, 0x429c0000    # 78.0f

    invoke-direct {v0, v10}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v10

    const/high16 v11, 0x42300000    # 44.0f

    invoke-direct {v0, v11}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v12

    const/16 v13, 0x33

    invoke-direct {v8, v10, v12, v13}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    invoke-virtual {v10, v1, v8}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iput-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->backButton:Landroid/widget/Button;

    new-instance v8, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda1;

    invoke-direct {v8, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda1;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v1, v8}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const-string v1, "\u22ee"

    const/16 v8, 0x14

    invoke-direct {v0, v1, v8}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->button(Ljava/lang/String;I)Landroid/widget/Button;

    move-result-object v1

    new-instance v8, Landroid/widget/FrameLayout$LayoutParams;

    const/high16 v10, 0x42540000    # 53.0f

    invoke-direct {v0, v10}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v10

    invoke-direct {v0, v11}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v12

    const/16 v14, 0x35

    invoke-direct {v8, v10, v12, v14}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    invoke-virtual {v10, v1, v8}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iput-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->menuButton:Landroid/widget/Button;

    new-instance v8, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda3;

    invoke-direct {v8, v0, v1}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda3;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/widget/Button;)V

    invoke-virtual {v1, v8}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->header:Landroid/widget/TextView;

    const/high16 v8, 0x42be0000    # 95.0f

    invoke-direct {v0, v8}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v8

    const/high16 v10, 0x42700000    # 60.0f

    invoke-direct {v0, v10}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v10

    invoke-virtual {v1, v8, v4, v10, v4}, Landroid/widget/TextView;->setPadding(IIII)V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->header:Landroid/widget/TextView;

    const/16 v8, 0x8

    invoke-virtual {v1, v8}, Landroid/widget/TextView;->setVisibility(I)V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->backButton:Landroid/widget/Button;

    invoke-virtual {v1, v8}, Landroid/widget/Button;->setVisibility(I)V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->menuButton:Landroid/widget/Button;

    invoke-virtual {v1, v8}, Landroid/widget/Button;->setVisibility(I)V

    new-instance v1, Landroid/widget/LinearLayout;

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v1, v10}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    iput-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Info:Landroid/widget/LinearLayout;

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Info:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v5}, Landroid/widget/LinearLayout;->setOrientation(I)V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Info:Landroid/widget/LinearLayout;

    const/high16 v10, 0x41600000    # 14.0f

    invoke-direct {v0, v10}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v10

    const/high16 v12, 0x41000000    # 8.0f

    invoke-direct {v0, v12}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v12

    const/high16 v14, 0x41200000    # 10.0f

    invoke-direct {v0, v14}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v14

    const/high16 v15, 0x41100000    # 9.0f

    invoke-direct {v0, v15}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v13

    invoke-virtual {v1, v10, v12, v14, v13}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v1, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v1}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const v10, -0x4ae2e1dd

    invoke-virtual {v1, v10}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/high16 v10, 0x41400000    # 12.0f

    invoke-direct {v0, v10}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v10

    int-to-float v10, v10

    invoke-virtual {v1, v10}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    const v10, 0x3f333333    # 0.7f

    invoke-direct {v0, v10}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v10

    const v12, 0x474f5562

    invoke-virtual {v1, v10, v12}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Info:Landroid/widget/LinearLayout;

    invoke-virtual {v10, v1}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    new-instance v1, Landroid/widget/TextView;

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v1, v10}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    iput-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225CaptureTime:Landroid/widget/TextView;

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225CaptureTime:Landroid/widget/TextView;

    const v10, -0xd0d0d

    invoke-virtual {v1, v10}, Landroid/widget/TextView;->setTextColor(I)V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225CaptureTime:Landroid/widget/TextView;

    const/high16 v10, 0x41480000    # 12.5f

    invoke-virtual {v1, v10}, Landroid/widget/TextView;->setTextSize(F)V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225CaptureTime:Landroid/widget/TextView;

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setGravity(I)V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225CaptureTime:Landroid/widget/TextView;

    invoke-virtual {v1, v5}, Landroid/widget/TextView;->setSingleLine(Z)V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225CaptureTime:Landroid/widget/TextView;

    const-string v10, "\ucd2c\uc601 \uc2dc\uac04 \ud655\uc778 \uc911\u2026"

    invoke-virtual {v1, v10}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Info:Landroid/widget/LinearLayout;

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225CaptureTime:Landroid/widget/TextView;

    new-instance v12, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v13, 0x41d00000    # 26.0f

    invoke-direct {v0, v13}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v13

    invoke-direct {v12, v7, v13}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v10, v12}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v1, Landroid/widget/LinearLayout;

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v1, v10}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v1, v3}, Landroid/widget/LinearLayout;->setGravity(I)V

    new-instance v10, Landroid/widget/TextView;

    iget-object v12, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v10, v12}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    iput-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Address:Landroid/widget/TextView;

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Address:Landroid/widget/TextView;

    const v12, -0x191614

    invoke-virtual {v10, v12}, Landroid/widget/TextView;->setTextColor(I)V

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Address:Landroid/widget/TextView;

    const/high16 v12, 0x41380000    # 11.5f

    invoke-virtual {v10, v12}, Landroid/widget/TextView;->setTextSize(F)V

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Address:Landroid/widget/TextView;

    invoke-virtual {v10, v3}, Landroid/widget/TextView;->setGravity(I)V

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Address:Landroid/widget/TextView;

    invoke-virtual {v10, v4}, Landroid/widget/TextView;->setSingleLine(Z)V

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Address:Landroid/widget/TextView;

    const/4 v12, 0x6

    invoke-virtual {v10, v12}, Landroid/widget/TextView;->setMaxLines(I)V

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Address:Landroid/widget/TextView;

    invoke-virtual {v10, v5}, Landroid/widget/TextView;->setBreakStrategy(I)V

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Address:Landroid/widget/TextView;

    const-string v12, "\uc704\uce58 \ud655\uc778 \uc911\u2026"

    invoke-virtual {v10, v12}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    new-instance v10, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v12, -0x2

    const/high16 v13, 0x3f800000    # 1.0f

    invoke-direct {v10, v4, v12, v13}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    const/high16 v14, 0x40c00000    # 6.0f

    invoke-direct {v0, v14}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v14

    iput v14, v10, Landroid/widget/LinearLayout$LayoutParams;->rightMargin:I

    iget-object v14, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Address:Landroid/widget/TextView;

    invoke-virtual {v1, v14, v10}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v10, Lcom/juhyeon/familyjourney/MoaNativeGallery$R227NaverPin;

    invoke-direct {v10, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$R227NaverPin;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    iput-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Naver:Landroid/view/View;

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Naver:Landroid/view/View;

    invoke-virtual {v10, v8}, Landroid/view/View;->setVisibility(I)V

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Naver:Landroid/view/View;

    const-string v14, "\ud604\uc7ac \uc0ac\uc9c4 \ucd2c\uc601 \uc704\uce58\ub97c \ub124\uc774\ubc84 \uc9c0\ub3c4\uc5d0\uc11c \ubcf4\uae30"

    invoke-virtual {v10, v14}, Landroid/view/View;->setContentDescription(Ljava/lang/CharSequence;)V

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Naver:Landroid/view/View;

    new-instance v14, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda4;

    invoke-direct {v14, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda4;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v10, v14}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Naver:Landroid/view/View;

    new-instance v14, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v0, v11}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v6

    invoke-direct {v0, v11}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v11

    invoke-direct {v14, v6, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v10, v14}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iget-object v6, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Info:Landroid/widget/LinearLayout;

    new-instance v10, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v10, v7, v12}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v6, v1, v10}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v1, v7, v12, v9}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    invoke-direct {v0, v15}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v6

    iput v6, v1, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    invoke-direct {v0, v15}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v6

    iput v6, v1, Landroid/widget/FrameLayout$LayoutParams;->rightMargin:I

    const/high16 v6, 0x41300000    # 11.0f

    invoke-direct {v0, v6}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v9

    iput v9, v1, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    iget-object v9, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Info:Landroid/widget/LinearLayout;

    invoke-virtual {v9, v10, v1}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r225Info:Landroid/widget/LinearLayout;

    new-instance v9, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda5;

    invoke-direct {v9, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda5;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v1, v9}, Landroid/widget/LinearLayout;->setOnLongClickListener(Landroid/view/View$OnLongClickListener;)V

    new-instance v1, Landroid/widget/LinearLayout;

    iget-object v9, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v1, v9}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    iput-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->lowerControls:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v5}, Landroid/widget/LinearLayout;->setOrientation(I)V

    invoke-virtual {v1, v4}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V

    iget-object v9, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-virtual {v9, v2}, Landroid/app/Activity;->setVolumeControlStream(I)V

    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;

    const/high16 v9, 0x43500000    # 208.0f

    invoke-direct {v0, v9}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v9

    const/16 v10, 0x50

    invoke-direct {v2, v7, v9, v10}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    iget-object v9, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    invoke-virtual {v9, v1, v2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v2, Landroid/widget/Space;

    iget-object v9, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v2, v9}, Landroid/widget/Space;-><init>(Landroid/content/Context;)V

    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v9, v7, v4, v13}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v1, v2, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v2, Landroid/widget/LinearLayout;

    iget-object v9, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v2, v9}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    iput-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoControls:Landroid/widget/LinearLayout;

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoControls:Landroid/widget/LinearLayout;

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setGravity(I)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoControls:Landroid/widget/LinearLayout;

    const/high16 v9, 0x40400000    # 3.0f

    invoke-direct {v0, v9}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v10

    invoke-direct {v0, v9}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v11

    invoke-virtual {v2, v10, v4, v11, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoControls:Landroid/widget/LinearLayout;

    invoke-virtual {v2, v4}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V

    new-instance v2, Lcom/juhyeon/familyjourney/MoaNativeGallery$R201VideoIconButton;

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v2, v0, v10, v4}, Lcom/juhyeon/familyjourney/MoaNativeGallery$R201VideoIconButton;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/app/Activity;I)V

    iput-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->still:Landroid/widget/Button;

    new-instance v2, Lcom/juhyeon/familyjourney/MoaNativeGallery$R201VideoIconButton;

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v2, v0, v10, v5}, Lcom/juhyeon/familyjourney/MoaNativeGallery$R201VideoIconButton;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/app/Activity;I)V

    iput-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    new-instance v2, Lcom/juhyeon/familyjourney/MoaNativeGallery$R201VideoIconButton;

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    const/4 v11, 0x2

    invoke-direct {v2, v0, v10, v11}, Lcom/juhyeon/familyjourney/MoaNativeGallery$R201VideoIconButton;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;Landroid/app/Activity;I)V

    iput-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mute:Landroid/widget/Button;

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->still:Landroid/widget/Button;

    const-string v10, "\ud604\uc7ac \ub3d9\uc601\uc0c1 \uc7a5\uba74 \uc800\uc7a5"

    invoke-virtual {v2, v10}, Landroid/widget/Button;->setContentDescription(Ljava/lang/CharSequence;)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    const-string v10, "\ub3d9\uc601\uc0c1 \uc77c\uc2dc\uc815\uc9c0"

    invoke-virtual {v2, v10}, Landroid/widget/Button;->setContentDescription(Ljava/lang/CharSequence;)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mute:Landroid/widget/Button;

    const-string v10, "\ub3d9\uc601\uc0c1 \uc18c\ub9ac \ucf1c\uae30"

    invoke-virtual {v2, v10}, Landroid/widget/Button;->setContentDescription(Ljava/lang/CharSequence;)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    const-string v10, "\u2161"

    invoke-virtual {v2, v10}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mute:Landroid/widget/Button;

    const-string v10, "\u266a"

    invoke-virtual {v2, v10}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->still:Landroid/widget/Button;

    new-instance v10, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda6;

    invoke-direct {v10, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda6;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v2, v10}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    new-instance v10, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda7;

    invoke-direct {v10, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda7;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v2, v10}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mute:Landroid/widget/Button;

    new-instance v10, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda8;

    invoke-direct {v10, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda8;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v2, v10}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v2, Landroid/widget/LinearLayout;

    iget-object v10, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v2, v10}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/16 v10, 0x11

    invoke-virtual {v2, v10}, Landroid/widget/LinearLayout;->setGravity(I)V

    iget-object v11, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mute:Landroid/widget/Button;

    new-instance v12, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v14, 0x42000000    # 32.0f

    invoke-direct {v0, v14}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v15

    invoke-direct {v0, v14}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v8

    invoke-direct {v12, v15, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v11, v12}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iget-object v8, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoControls:Landroid/widget/LinearLayout;

    new-instance v11, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v12, 0x42340000    # 45.0f

    invoke-direct {v0, v12}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v15

    invoke-direct {v11, v4, v15, v13}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v8, v2, v11}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v2, Landroid/widget/LinearLayout;

    iget-object v8, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v2, v8}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setGravity(I)V

    new-instance v8, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v8}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const v11, -0x3fe6e5e2

    invoke-virtual {v8, v11}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/high16 v11, 0x41900000    # 18.0f

    invoke-direct {v0, v11}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v15

    int-to-float v15, v15

    invoke-virtual {v8, v15}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    invoke-direct {v0, v13}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v15

    const v3, -0x655f5a56

    invoke-virtual {v8, v15, v3}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    new-instance v3, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v3}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    invoke-virtual {v3, v7}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    invoke-direct {v0, v11}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v11

    int-to-float v11, v11

    invoke-virtual {v3, v11}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    new-instance v11, Landroid/graphics/drawable/RippleDrawable;

    const v15, 0x55ffffff    # 3.518437E13f

    invoke-static {v15}, Landroid/content/res/ColorStateList;->valueOf(I)Landroid/content/res/ColorStateList;

    move-result-object v15

    invoke-direct {v11, v15, v8, v3}, Landroid/graphics/drawable/RippleDrawable;-><init>(Landroid/content/res/ColorStateList;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;)V

    invoke-virtual {v2, v11}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    invoke-direct {v0, v9}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v3

    const/high16 v8, 0x40a00000    # 5.0f

    invoke-direct {v0, v8}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v8

    invoke-virtual {v2, v3, v4, v8, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    invoke-virtual {v2, v5}, Landroid/widget/LinearLayout;->setClickable(Z)V

    invoke-virtual {v2, v5}, Landroid/widget/LinearLayout;->setFocusable(Z)V

    const-string v3, "\ub3d9\uc601\uc0c1 \uc7ac\uc0dd\u00b7\uc77c\uc2dc\uc815\uc9c0 \ubc0f \uc7ac\uc0dd\uc2dc\uac04"

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setContentDescription(Ljava/lang/CharSequence;)V

    new-instance v3, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda9;

    invoke-direct {v3, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda9;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v9, 0x41c80000    # 25.0f

    invoke-direct {v0, v9}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v9

    const/high16 v11, 0x41f00000    # 30.0f

    invoke-direct {v0, v11}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v11

    invoke-direct {v8, v9, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v3, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v3, Landroid/widget/TextView;

    iget-object v8, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v3, v8}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    iput-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    invoke-virtual {v3, v7}, Landroid/widget/TextView;->setTextColor(I)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    invoke-virtual {v3, v6}, Landroid/widget/TextView;->setTextSize(F)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    invoke-virtual {v3, v5}, Landroid/widget/TextView;->setSingleLine(Z)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    invoke-virtual {v3, v10}, Landroid/widget/TextView;->setGravity(I)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    sget-object v8, Landroid/graphics/Typeface;->MONOSPACE:Landroid/graphics/Typeface;

    invoke-virtual {v3, v8}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    const-string v8, "00:00 / 00:00"

    invoke-virtual {v3, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    invoke-virtual {v3, v5}, Landroid/widget/TextView;->setClickable(Z)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    const-string v8, "\ub3d9\uc601\uc0c1 \uc7ac\uc0dd\u00b7\uc77c\uc2dc\uc815\uc9c0"

    invoke-virtual {v3, v8}, Landroid/widget/TextView;->setContentDescription(Ljava/lang/CharSequence;)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    new-instance v8, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda10;

    invoke-direct {v8, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda10;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v3, v8}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v9, 0x41f00000    # 30.0f

    invoke-direct {v0, v9}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v9

    invoke-direct {v8, v4, v9, v13}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setClickable(Z)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setFocusable(Z)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setLongClickable(Z)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setClickable(Z)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoTime:Landroid/widget/TextView;

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setFocusable(Z)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoControls:Landroid/widget/LinearLayout;

    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v9, 0x43080000    # 136.0f

    invoke-direct {v0, v9}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v9

    const/high16 v11, 0x42080000    # 34.0f

    invoke-direct {v0, v11}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v11

    invoke-direct {v8, v9, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v3, v2, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->still:Landroid/widget/Button;

    invoke-direct {v0, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205PressFeedback(Landroid/view/View;)V

    invoke-direct {v0, v2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205PressFeedback(Landroid/view/View;)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->mute:Landroid/widget/Button;

    invoke-direct {v0, v2}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r205PressFeedback(Landroid/view/View;)V

    new-instance v2, Landroid/widget/LinearLayout;

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v2, v3}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v2, v10}, Landroid/widget/LinearLayout;->setGravity(I)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->still:Landroid/widget/Button;

    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v0, v14}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v9

    invoke-direct {v0, v14}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v10

    invoke-direct {v8, v9, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v3, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoControls:Landroid/widget/LinearLayout;

    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v0, v12}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v9

    invoke-direct {v8, v4, v9, v13}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v3, v2, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoControls:Landroid/widget/LinearLayout;

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v8, 0x42380000    # 46.0f

    invoke-direct {v0, v8}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v8

    invoke-direct {v3, v7, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v2, Landroid/widget/SeekBar;

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v2, v3}, Landroid/widget/SeekBar;-><init>(Landroid/content/Context;)V

    iput-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seek:Landroid/widget/SeekBar;

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seek:Landroid/widget/SeekBar;

    const/16 v3, 0x3e8

    invoke-virtual {v2, v3}, Landroid/widget/SeekBar;->setMax(I)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seek:Landroid/widget/SeekBar;

    new-instance v3, Lcom/juhyeon/familyjourney/MoaNativeGallery$3;

    invoke-direct {v3, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$3;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v2, v3}, Landroid/widget/SeekBar;->setOnSeekBarChangeListener(Landroid/widget/SeekBar$OnSeekBarChangeListener;)V

    new-instance v2, Landroid/widget/LinearLayout;

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v2, v3}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    iput-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seekRow:Landroid/widget/LinearLayout;

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seekRow:Landroid/widget/LinearLayout;

    const/16 v3, 0x10

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setGravity(I)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seekRow:Landroid/widget/LinearLayout;

    const/high16 v3, -0x67000000

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V

    const-string v2, "\u2039 \ubaa9\ub85d"

    const/16 v3, 0xc

    invoke-direct {v0, v2, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->button(Ljava/lang/String;I)Landroid/widget/Button;

    move-result-object v2

    iput-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeButton:Landroid/widget/Button;

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeButton:Landroid/widget/Button;

    const/16 v3, 0x8

    invoke-virtual {v2, v3}, Landroid/widget/Button;->setVisibility(I)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeButton:Landroid/widget/Button;

    new-instance v3, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda11;

    invoke-direct {v3, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda11;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v2, v3}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seekRow:Landroid/widget/LinearLayout;

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeButton:Landroid/widget/Button;

    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v9, 0x42bc0000    # 94.0f

    invoke-direct {v0, v9}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v9

    const/high16 v10, 0x42100000    # 36.0f

    invoke-direct {v0, v10}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v11

    invoke-direct {v8, v9, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v3, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seekRow:Landroid/widget/LinearLayout;

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seek:Landroid/widget/SeekBar;

    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v0, v10}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v9

    invoke-direct {v8, v4, v9, v13}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v2, Landroid/widget/TextView;

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v2, v3}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    iput-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeHint:Landroid/widget/TextView;

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeHint:Landroid/widget/TextView;

    const v3, -0x111112

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeHint:Landroid/widget/TextView;

    invoke-virtual {v2, v6}, Landroid/widget/TextView;->setTextSize(F)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeHint:Landroid/widget/TextView;

    const/16 v3, 0x10

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setGravity(I)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeHint:Landroid/widget/TextView;

    const-string v3, "\uc601\uc0c1 \uc7a5\uba74 \uc88c\uc6b0 \uc774\ub3d9 \u00b7 \uc120\ud0dd \uc601\uc0c1 \ubbf8\ub9ac\ubcf4\uae30 \ub204\ub974\uba74 \ud0d0\uc0c9"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeHint:Landroid/widget/TextView;

    const/16 v3, 0x8

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setVisibility(I)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seekRow:Landroid/widget/LinearLayout;

    iget-object v6, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->videoModeHint:Landroid/widget/TextView;

    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v0, v10}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v9

    invoke-direct {v8, v4, v9, v13}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v6, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seekRow:Landroid/widget/LinearLayout;

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setVisibility(I)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->seekRow:Landroid/widget/LinearLayout;

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v0, v10}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v4

    invoke-direct {v3, v7, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    const/4 v2, 0x0

    iput-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeRow:Landroid/widget/LinearLayout;

    new-instance v2, Landroid/widget/FrameLayout;

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->activity:Landroid/app/Activity;

    invoke-direct {v2, v3}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    iput-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeBubble:Landroid/view/View;

    new-instance v3, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v3}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const v4, -0x1adad8d3

    invoke-virtual {v3, v4}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/high16 v4, 0x41e80000    # 29.0f

    invoke-direct {v0, v4}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v4

    int-to-float v4, v4

    invoke-virtual {v3, v4}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    const v4, 0x3f4ccccd    # 0.8f

    invoke-direct {v0, v4}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v4

    const v6, -0x6238342d

    invoke-virtual {v3, v4, v6}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    invoke-virtual {v2, v3}, Landroid/widget/FrameLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    const/high16 v3, 0x41100000    # 9.0f

    invoke-direct {v0, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v3

    int-to-float v3, v3

    invoke-virtual {v2, v3}, Landroid/widget/FrameLayout;->setElevation(F)V

    const/16 v3, 0x8

    invoke-virtual {v2, v3}, Landroid/widget/FrameLayout;->setVisibility(I)V

    new-instance v3, Lcom/juhyeon/familyjourney/MoaNativeGallery$VerticalMediaVolume;

    invoke-direct {v3, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$VerticalMediaVolume;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    iput-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeRail:Lcom/juhyeon/familyjourney/MoaNativeGallery$VerticalMediaVolume;

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->volumeRail:Lcom/juhyeon/familyjourney/MoaNativeGallery$VerticalMediaVolume;

    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v4, v7, v7}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iget-object v3, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;

    const/high16 v6, 0x42680000    # 58.0f

    invoke-direct {v0, v6}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v6

    const/high16 v8, 0x433b0000    # 187.0f

    invoke-direct {v0, v8}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v8

    const/16 v9, 0x33

    invoke-direct {v4, v6, v8, v9}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    invoke-virtual {v3, v2, v4}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v2, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    invoke-direct {v2, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    iput-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    const/high16 v3, -0x58000000

    invoke-virtual {v2, v3}, Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;->setBackgroundColor(I)V

    iget-object v2, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->rail:Lcom/juhyeon/familyjourney/MoaNativeGallery$GalleryRail;

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v4, 0x42900000    # 72.0f

    invoke-direct {v0, v4}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->dp(F)I

    move-result v4

    invoke-direct {v3, v7, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iput-boolean v5, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    invoke-direct/range {p0 .. p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->registerBack()V

    invoke-direct/range {p0 .. p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->refreshPages()V

    iget-object v1, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->stage:Landroid/widget/FrameLayout;

    new-instance v2, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda2;

    invoke-direct {v2, v0}, Lcom/juhyeon/familyjourney/MoaNativeGallery$$ExternalSyntheticLambda2;-><init>(Lcom/juhyeon/familyjourney/MoaNativeGallery;)V

    invoke-virtual {v1, v2}, Landroid/widget/FrameLayout;->post(Ljava/lang/Runnable;)Z

    invoke-direct/range {p0 .. p0}, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepareCurrentVideo()V

    iget-object v0, v0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->host:Landroid/widget/FrameLayout;

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->requestFocus()Z

    return v5

    :catch_6cb
    move-exception v0

    return v4

    :cond_6cd
    :goto_6cd
    return v4

    :catch_6ce
    move-exception v0

    return v4
.end method

.method public r227ResumeFromExternalMap()V
    .locals 3

    invoke-static {}, Lcom/juhyeon/familyjourney/MoaNaverReturnOverlay;->hide()V

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227ExternalMapPending:Z

    if-nez v0, :cond_8

    return-void

    :cond_8
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227ExternalMapPending:Z

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v1, :cond_2d

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227VideoWasPlaying:Z

    if-eqz v1, :cond_2d

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    if-eqz v1, :cond_2d

    iget-boolean v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->prepared:Z

    if-eqz v1, :cond_2d

    :try_start_1b
    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->media:Landroid/media/MediaPlayer;

    invoke-virtual {v1}, Landroid/media/MediaPlayer;->start()V

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    if-eqz v1, :cond_2d

    iget-object v1, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->pause:Landroid/widget/Button;

    const-string v2, "\u2161"

    invoke-virtual {v1, v2}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    :try_end_2b
    .catch Ljava/lang/Exception; {:try_start_1b .. :try_end_2b} :catch_2c

    goto :goto_2d

    :catch_2c
    move-exception v1

    :cond_2d
    :goto_2d
    iput-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227VideoWasPlaying:Z

    return-void
.end method

.method public r227RetainForExternalMap()Z
    .locals 1

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->open:Z

    if-eqz v0, :cond_a

    iget-boolean v0, p0, Lcom/juhyeon/familyjourney/MoaNativeGallery;->r227ExternalMapPending:Z

    if-eqz v0, :cond_a

    const/4 v0, 0x1

    goto :goto_b

    :cond_a
    const/4 v0, 0x0

    :goto_b
    return v0
.end method
