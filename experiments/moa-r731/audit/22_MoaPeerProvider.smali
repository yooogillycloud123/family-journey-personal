.class public final Lcom/juhyeon/familyjournea/MoaPeerProvider;
.super Landroid/content/ContentProvider;
.source "MoaPeerProvider.java"

# interfaces
.implements Landroid/app/Application$ActivityLifecycleCallbacks;


# static fields
.field private static final AUTH:Ljava/lang/String; = "com.juhyeon.familyjournea.moa_r711_sync"

.field private static final CERT:Ljava/lang/String; = "moa.peer.tls.r717"

.field private static final TOKEN:Ljava/lang/String; = "moa.peer.token.r717"


# instance fields
.field private active:Landroid/app/Activity;

.field private asked:Z

.field private busy:Z

.field private closedByUser:Z

.field private epoch:J

.field private hub:Lcom/juhyeon/familyjournea/PeerHub;

.field private lastCmd:I

.field private lastPoll:J

.field private lastStarted:J

.field private lastWifiCheck:J

.field private final main:Landroid/os/Handler;

.field private mode:Ljava/lang/String;

.field private own:Lorg/json/JSONObject;

.field private pendingPoll:Z

.field private retryAfter:J

.field private retryDelay:J

.field private status:Ljava/lang/String;

.field private final tick:Ljava/lang/Runnable;

.field private view:Landroid/webkit/WebView;

.field private final worker:Ljava/util/concurrent/ExecutorService;


# direct methods
.method public constructor <init>()V
    .locals 2

    .line 4
    invoke-direct {p0}, Landroid/content/ContentProvider;-><init>()V

    .line 6
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->main:Landroid/os/Handler;

    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    iput-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->worker:Ljava/util/concurrent/ExecutorService;

    const-string v0, "off"

    iput-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->mode:Ljava/lang/String;

    const-string v0, "\uc9c1\uc811 \uc5f0\uacb0 \ub300\uae30"

    iput-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->status:Ljava/lang/String;

    const/4 v0, -0x1

    iput v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->lastCmd:I

    const-wide/16 v0, 0x0

    iput-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->lastPoll:J

    iput-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->lastWifiCheck:J

    iput-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->lastStarted:J

    iput-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->retryAfter:J

    const-wide/16 v0, 0x2710

    iput-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->retryDelay:J

    .line 13
    new-instance v0, Lcom/juhyeon/familyjournea/MoaPeerProvider$1;

    invoke-direct {v0, p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider$1;-><init>(Lcom/juhyeon/familyjournea/MoaPeerProvider;)V

    iput-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->tick:Ljava/lang/Runnable;

    return-void
.end method

.method static synthetic access$000(Lcom/juhyeon/familyjournea/MoaPeerProvider;)Landroid/app/Activity;
    .locals 0

    .line 4
    iget-object p0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->active:Landroid/app/Activity;

    return-object p0
.end method

.method static synthetic access$100(Landroid/view/View;)Landroid/webkit/WebView;
    .locals 0

    .line 4
    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->find(Landroid/view/View;)Landroid/webkit/WebView;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$1000(Lcom/juhyeon/familyjournea/MoaPeerProvider;)Landroid/os/Handler;
    .locals 0

    .line 4
    iget-object p0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->main:Landroid/os/Handler;

    return-object p0
.end method

.method static synthetic access$1100(Lcom/juhyeon/familyjournea/MoaPeerProvider;)Ljava/lang/String;
    .locals 0

    .line 4
    iget-object p0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->mode:Ljava/lang/String;

    return-object p0
.end method

.method static synthetic access$1102(Lcom/juhyeon/familyjournea/MoaPeerProvider;Ljava/lang/String;)Ljava/lang/String;
    .locals 0

    .line 4
    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->mode:Ljava/lang/String;

    return-object p1
.end method

.method static synthetic access$1200(Lcom/juhyeon/familyjournea/MoaPeerProvider;)Landroid/content/SharedPreferences;
    .locals 0

    .line 4
    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->prefs()Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$1300(Lcom/juhyeon/familyjournea/MoaPeerProvider;)J
    .locals 2

    .line 4
    iget-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->lastWifiCheck:J

    return-wide v0
.end method

.method static synthetic access$1302(Lcom/juhyeon/familyjournea/MoaPeerProvider;J)J
    .locals 0

    .line 4
    iput-wide p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->lastWifiCheck:J

    return-wide p1
.end method

.method static synthetic access$1400(Lcom/juhyeon/familyjournea/MoaPeerProvider;)Z
    .locals 0

    .line 4
    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->wifiStillMatches()Z

    move-result p0

    return p0
.end method

.method static synthetic access$1500(Lcom/juhyeon/familyjournea/MoaPeerProvider;)Lorg/json/JSONObject;
    .locals 0

    .line 4
    iget-object p0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->own:Lorg/json/JSONObject;

    return-object p0
.end method

.method static synthetic access$1600(Lcom/juhyeon/familyjournea/MoaPeerProvider;)J
    .locals 2

    .line 4
    iget-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->lastStarted:J

    return-wide v0
.end method

.method static synthetic access$1700(Lcom/juhyeon/familyjournea/MoaPeerProvider;)Z
    .locals 0

    .line 4
    iget-boolean p0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->busy:Z

    return p0
.end method

.method static synthetic access$1800(Lcom/juhyeon/familyjournea/MoaPeerProvider;Landroid/webkit/WebView;ILjava/lang/String;)V
    .locals 0

    .line 4
    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->command(Landroid/webkit/WebView;ILjava/lang/String;)V

    return-void
.end method

.method static synthetic access$1900(Lcom/juhyeon/familyjournea/MoaPeerProvider;)Z
    .locals 0

    .line 4
    iget-boolean p0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->closedByUser:Z

    return p0
.end method

.method static synthetic access$200(Lcom/juhyeon/familyjournea/MoaPeerProvider;)Landroid/webkit/WebView;
    .locals 0

    .line 4
    iget-object p0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->view:Landroid/webkit/WebView;

    return-object p0
.end method

.method static synthetic access$2000(Lcom/juhyeon/familyjournea/MoaPeerProvider;)J
    .locals 2

    .line 4
    iget-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->retryAfter:J

    return-wide v0
.end method

.method static synthetic access$202(Lcom/juhyeon/familyjournea/MoaPeerProvider;Landroid/webkit/WebView;)Landroid/webkit/WebView;
    .locals 0

    .line 4
    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->view:Landroid/webkit/WebView;

    return-object p1
.end method

.method static synthetic access$2100(Lcom/juhyeon/familyjournea/MoaPeerProvider;Landroid/webkit/WebView;IZ)V
    .locals 0

    .line 4
    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->start(Landroid/webkit/WebView;IZ)V

    return-void
.end method

.method static synthetic access$2200(Lcom/juhyeon/familyjournea/MoaPeerProvider;)Ljava/lang/String;
    .locals 0

    .line 4
    iget-object p0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->status:Ljava/lang/String;

    return-object p0
.end method

.method static synthetic access$2300(Lcom/juhyeon/familyjournea/MoaPeerProvider;Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 0

    .line 4
    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->js(Landroid/webkit/WebView;Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$300(Lcom/juhyeon/familyjournea/MoaPeerProvider;)J
    .locals 2

    .line 4
    iget-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->epoch:J

    return-wide v0
.end method

.method static synthetic access$308(Lcom/juhyeon/familyjournea/MoaPeerProvider;)J
    .locals 4

    .line 4
    iget-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->epoch:J

    const-wide/16 v2, 0x1

    add-long/2addr v2, v0

    iput-wide v2, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->epoch:J

    return-wide v0
.end method

.method static synthetic access$400(Lcom/juhyeon/familyjournea/MoaPeerProvider;)I
    .locals 0

    .line 4
    iget p0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->lastCmd:I

    return p0
.end method

.method static synthetic access$402(Lcom/juhyeon/familyjournea/MoaPeerProvider;I)I
    .locals 0

    .line 4
    iput p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->lastCmd:I

    return p1
.end method

.method static synthetic access$500(Lcom/juhyeon/familyjournea/MoaPeerProvider;)Z
    .locals 0

    .line 4
    iget-boolean p0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->pendingPoll:Z

    return p0
.end method

.method static synthetic access$502(Lcom/juhyeon/familyjournea/MoaPeerProvider;Z)Z
    .locals 0

    .line 4
    iput-boolean p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->pendingPoll:Z

    return p1
.end method

.method static synthetic access$600(Landroid/webkit/WebView;)Z
    .locals 0

    .line 4
    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->trusted(Landroid/webkit/WebView;)Z

    move-result p0

    return p0
.end method

.method static synthetic access$700(Lcom/juhyeon/familyjournea/MoaPeerProvider;)Lcom/juhyeon/familyjournea/PeerHub;
    .locals 0

    .line 4
    iget-object p0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->hub:Lcom/juhyeon/familyjournea/PeerHub;

    return-object p0
.end method

.method static synthetic access$800(Lcom/juhyeon/familyjournea/MoaPeerProvider;)V
    .locals 0

    .line 4
    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->stop()V

    return-void
.end method

.method static synthetic access$900(Lcom/juhyeon/familyjournea/MoaPeerProvider;)J
    .locals 2

    .line 4
    iget-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->lastPoll:J

    return-wide v0
.end method

.method static synthetic access$902(Lcom/juhyeon/familyjournea/MoaPeerProvider;J)J
    .locals 0

    .line 4
    iput-wide p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->lastPoll:J

    return-wide p1
.end method

.method private backup(Ljava/lang/Object;)V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 22
    invoke-direct {p0, p1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->requireIdle(Ljava/lang/Object;)V

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->current(Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->oldPrefs()Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "pair"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    if-eqz p1, :cond_3d

    if-eqz v0, :cond_3d

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->prefs()Landroid/content/SharedPreferences;

    move-result-object p1

    const-string v1, "pcBackup"

    invoke-interface {p1, v1}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_3d

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->prefs()Landroid/content/SharedPreferences;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1, v1, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    move-result p1

    if-eqz p1, :cond_35

    goto :goto_3d

    :cond_35
    new-instance p1, Ljava/io/IOException;

    const-string v0, "\uae30\uc874 \uc5f0\uacb0 \ubcf4\uad00 \uc2e4\ud328"

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    :cond_3d
    :goto_3d
    return-void
.end method

.method private command(Landroid/webkit/WebView;ILjava/lang/String;)V
    .locals 5

    invoke-static {p0, p1, p2, p3}, Lcom/juhyeon/familyjournea/MoaPair725;->handle(Ljava/lang/Object;Landroid/webkit/WebView;ILjava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_7

    return-void

    .line 25
    :cond_7
    const/4 v0, 0x0

    :try_start_8
    const-string v1, "updateApp"

    invoke-virtual {p3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1c

    iget-object v2, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->active:Landroid/app/Activity;

    invoke-static {v2}, Lcom/juhyeon/familyjournea/MoaUpdate723;->open(Landroid/app/Activity;)V

    const/4 v1, 0x1

    const-string p3, "\uc5c5\ub370\uc774\ud2b8 \ud655\uc778 \uc694\uccad"

    invoke-direct {p0, p1, p2, v1, p3}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    return-void

    :cond_1c
    const-string v1, "browse:"

    invoke-virtual {p3, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_3d

    const/4 v1, 0x7

    invoke-virtual {p3, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p3

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->provider()Ljava/lang/Object;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->current(Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v1

    iget-object v2, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->active:Landroid/app/Activity;

    invoke-static {v2, v1, p3}, Lcom/juhyeon/familyjournea/MoaRemote721;->open(Landroid/app/Activity;Lorg/json/JSONObject;Ljava/lang/String;)V

    const/4 v1, 0x1

    const-string p3, "\uc6d0\uaca9 \ubcf4\uad00\ud568 \uc5f4\uae30"

    invoke-direct {p0, p1, p2, v1, p3}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    return-void

    :cond_3d
    invoke-virtual {p3}, Ljava/lang/String;->hashCode()I

    move-result v1

    const/4 v2, 0x3

    const/4 v3, 0x1

    sparse-switch v1, :sswitch_data_1ec

    :cond_46
    goto :goto_79

    :sswitch_47
    const-string v1, "restore"

    invoke-virtual {p3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p3

    if-eqz p3, :cond_46

    move p3, v2

    goto :goto_7a

    :sswitch_51
    const-string v1, "stop"

    invoke-virtual {p3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p3

    if-eqz p3, :cond_46

    move p3, v3

    goto :goto_7a

    :sswitch_5b
    const-string v1, "join"

    invoke-virtual {p3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p3

    if-eqz p3, :cond_46

    const/4 p3, 0x2

    goto :goto_7a

    :sswitch_65
    const-string v1, "host"

    invoke-virtual {p3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p3

    if-eqz p3, :cond_46

    move p3, v0

    goto :goto_7a

    :sswitch_6f
    const-string v1, "code"

    invoke-virtual {p3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p3
    :try_end_75
    .catch Ljava/lang/Exception; {:try_start_8 .. :try_end_75} :catch_1d9

    if-eqz p3, :cond_46

    const/4 p3, 0x4

    goto :goto_7a

    :goto_79
    const/4 p3, -0x1

    :goto_7a
    const-string v1, "\ucde8\uc18c"

    packed-switch p3, :pswitch_data_202

    .line 30
    :try_start_7f
    new-instance p3, Ljava/io/IOException;

    goto/16 :goto_1d3

    .line 29
    :pswitch_83
    iget-object p3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->hub:Lcom/juhyeon/familyjournea/PeerHub;

    if-eqz p3, :cond_d9

    iget-object p3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->own:Lorg/json/JSONObject;

    if-eqz p3, :cond_d9

    iget-object p3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->own:Lorg/json/JSONObject;

    invoke-virtual {p3}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p3

    new-instance v1, Landroid/app/AlertDialog$Builder;

    iget-object v2, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->active:Landroid/app/Activity;

    invoke-direct {v1, v2}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v2, "\uc9c1\uc811 \uc5f0\uacb0 \uc815\ubcf4"

    invoke-virtual {v1, v2}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\ub2e4\ub978 \uae30\uae30\uc758 \uae30\uae30 \ub3d9\uae30\ud654 \u2192 \uc9c1\uc811 \uc5f0\uacb0 \ucc38\uac00\uc5d0\uc11c \uc785\ub825\ud558\uc138\uc694. \uc5f0\uacb0 \uc815\ubcf4\ub294 \ube44\ubc00\uc785\ub2c8\ub2e4. \uc2e0\ub8b0\ud558\ub294 \uae30\uae30\uc5d0\ub9cc \uacf5\uc720\ud558\uc138\uc694.\n\n"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    const-string v2, "\ubcf5\uc0ac"

    new-instance v3, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda10;

    invoke-direct {v3, p0, p3, p1, p2}, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda10;-><init>(Lcom/juhyeon/familyjournea/MoaPeerProvider;Ljava/lang/String;Landroid/webkit/WebView;I)V

    invoke-virtual {v1, v2, v3}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p3

    const-string v1, "\ub2eb\uae30"

    new-instance v2, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda11;

    invoke-direct {v2, p0, p1, p2}, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda11;-><init>(Lcom/juhyeon/familyjournea/MoaPeerProvider;Landroid/webkit/WebView;I)V

    invoke-virtual {p3, v1, v2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p3

    new-instance v1, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda12;

    invoke-direct {v1, p0, p1, p2}, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda12;-><init>(Lcom/juhyeon/familyjournea/MoaPeerProvider;Landroid/webkit/WebView;I)V

    invoke-virtual {p3, v1}, Landroid/app/AlertDialog$Builder;->setOnCancelListener(Landroid/content/DialogInterface$OnCancelListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p3

    invoke-virtual {p3}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    goto/16 :goto_1c2

    :cond_d9
    new-instance p3, Ljava/io/IOException;

    const-string v1, "\uc9c1\uc811 \ud5c8\ube0c\ub97c \uba3c\uc800 \uc2dc\uc791\ud558\uc138\uc694"

    invoke-direct {p3, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p3

    .line 28
    :pswitch_e1
    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->restore()V

    iput-boolean v3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->closedByUser:Z

    const-string p3, "\uc774\uc804 PC/\uae30\uae30 \uc5f0\uacb0 \ubcf5\uc6d0 \uc644\ub8cc"

    invoke-direct {p0, p1, p2, v3, p3}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    goto/16 :goto_1c2

    .line 27
    :pswitch_ed
    iget-object p3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->hub:Lcom/juhyeon/familyjournea/PeerHub;

    if-nez p3, :cond_151

    iget-boolean p3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->asked:Z

    if-nez p3, :cond_149

    iput-boolean v3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->asked:Z

    new-instance p3, Landroid/widget/EditText;

    iget-object v3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->active:Landroid/app/Activity;

    invoke-direct {p3, v3}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    const-string v3, "\ud5c8\ube0c\uc5d0\uc11c \ubcf5\uc0ac\ud55c \uc5f0\uacb0 \uc815\ubcf4 \ubd99\uc5ec\ub123\uae30"

    invoke-virtual {p3, v3}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V

    invoke-virtual {p3, v2}, Landroid/widget/EditText;->setMinLines(I)V

    const/4 v2, 0x6

    invoke-virtual {p3, v2}, Landroid/widget/EditText;->setMaxLines(I)V

    const v2, 0xa0001

    invoke-virtual {p3, v2}, Landroid/widget/EditText;->setInputType(I)V

    new-instance v2, Landroid/app/AlertDialog$Builder;

    iget-object v3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->active:Landroid/app/Activity;

    invoke-direct {v2, v3}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v3, "\uc2a4\ub9c8\ud2b8\ud3f0\u00b7\ud0dc\ube14\ub9bf \uc9c1\uc811 \uc5f0\uacb0"

    invoke-virtual {v2, v3}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v2

    const-string v3, "\uac19\uc740 Wi-Fi\uc5d0 \uc5f0\uacb0\ub41c \ubaa8\uc544 \ud5c8\ube0c\uc758 \uc5f0\uacb0 \uc815\ubcf4\ub9cc \uc0ac\uc6a9\ud558\uc138\uc694. \uae30\uc874 \uc5f0\uacb0 \uc815\ubcf4\ub294 \ubcf4\uad00\ud569\ub2c8\ub2e4."

    invoke-virtual {v2, v3}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v2

    invoke-virtual {v2, p3}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;

    move-result-object v2

    const-string v3, "\uc5f0\uacb0"

    new-instance v4, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda7;

    invoke-direct {v4, p0, p1, p2, p3}, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda7;-><init>(Lcom/juhyeon/familyjournea/MoaPeerProvider;Landroid/webkit/WebView;ILandroid/widget/EditText;)V

    invoke-virtual {v2, v3, v4}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p3

    new-instance v2, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda8;

    invoke-direct {v2, p0, p1, p2}, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda8;-><init>(Lcom/juhyeon/familyjournea/MoaPeerProvider;Landroid/webkit/WebView;I)V

    invoke-virtual {p3, v1, v2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p3

    new-instance v1, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda9;

    invoke-direct {v1, p0, p1, p2}, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda9;-><init>(Lcom/juhyeon/familyjournea/MoaPeerProvider;Landroid/webkit/WebView;I)V

    invoke-virtual {p3, v1}, Landroid/app/AlertDialog$Builder;->setOnCancelListener(Landroid/content/DialogInterface$OnCancelListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p3

    invoke-virtual {p3}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    goto/16 :goto_1c2

    :cond_149
    new-instance p3, Ljava/io/IOException;

    const-string v1, "\uc5f0\uacb0 \uc815\ubcf4 \uc785\ub825 \ub300\uae30"

    invoke-direct {p3, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    :goto_150
    throw p3

    :cond_151
    new-instance p3, Ljava/io/IOException;

    const-string v1, "\uc9c1\uc811 \ud5c8\ube0c\ub97c \uba3c\uc800 \uc911\uc9c0\ud558\uc138\uc694"

    invoke-direct {p3, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    goto :goto_150

    .line 26
    :pswitch_159
    iput-boolean v3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->closedByUser:Z

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->prefs()Landroid/content/SharedPreferences;

    move-result-object p3

    invoke-interface {p3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    const-string v1, "wanted"

    invoke-interface {p3, v1, v0}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    invoke-interface {p3}, Landroid/content/SharedPreferences$Editor;->commit()Z

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->stop()V

    const-string p3, "\uc9c1\uc811 \ud5c8\ube0c \uc911\uc9c0"

    invoke-direct {p0, p1, p2, v3, p3}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    goto :goto_1c2

    .line 25
    :pswitch_175
    iget-object p3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->mode:Ljava/lang/String;

    const-string v2, "off"

    invoke-virtual {p3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p3

    if-nez p3, :cond_1cb

    iget-object p3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->hub:Lcom/juhyeon/familyjournea/PeerHub;

    if-eqz p3, :cond_189

    const-string p3, "\uc9c1\uc811 \ud5c8\ube0c \uc2e4\ud589 \uc911"

    invoke-direct {p0, p1, p2, v3, p3}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    return-void

    :cond_189
    iget-boolean p3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->asked:Z

    if-nez p3, :cond_1c3

    iput-boolean v3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->asked:Z

    new-instance p3, Landroid/app/AlertDialog$Builder;

    iget-object v2, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->active:Landroid/app/Activity;

    invoke-direct {p3, v2}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v2, "\uc774 \uae30\uae30\ub97c \uc9c1\uc811 \ub3d9\uae30\ud654 \ud5c8\ube0c\ub85c \uc0ac\uc6a9"

    invoke-virtual {p3, v2}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p3

    const-string v2, "\uac19\uc740 Wi-Fi\uc5d0\uc11c \ud5c8\uc6a9\ud55c \uae30\uae30\uc5d0 \uc77c\uae30\u00b7\uc77c\uc815 \ubc0f \uc6d0\uaca9 \uc5f4\ub78c\uc744 \uc81c\uacf5\ud569\ub2c8\ub2e4. \uc0ac\uc9c4\u00b7\uc601\uc0c1\u00b7\uc74c\uc131 \uc6d0\ubcf8 \uc790\ub3d9 \ubcf5\uc81c\ub294 \ucc28\ub2e8\ub429\ub2c8\ub2e4. \uc5f0\uacb0 \uc720\uc9c0 \uc54c\ub9bc \ub610\ub294 \uc124\uc815\uc5d0\uc11c \uc5b8\uc81c\ub4e0 \uc911\uc9c0\ud560 \uc218 \uc788\uc2b5\ub2c8\ub2e4."

    invoke-virtual {p3, v2}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p3

    const-string v2, "\ud5c8\ube0c \uc2dc\uc791"

    new-instance v3, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda4;

    invoke-direct {v3, p0, p1, p2}, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda4;-><init>(Lcom/juhyeon/familyjournea/MoaPeerProvider;Landroid/webkit/WebView;I)V

    invoke-virtual {p3, v2, v3}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p3

    new-instance v2, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda5;

    invoke-direct {v2, p0, p1, p2}, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda5;-><init>(Lcom/juhyeon/familyjournea/MoaPeerProvider;Landroid/webkit/WebView;I)V

    invoke-virtual {p3, v1, v2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p3

    new-instance v1, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda6;

    invoke-direct {v1, p0, p1, p2}, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda6;-><init>(Lcom/juhyeon/familyjournea/MoaPeerProvider;Landroid/webkit/WebView;I)V

    invoke-virtual {p3, v1}, Landroid/app/AlertDialog$Builder;->setOnCancelListener(Landroid/content/DialogInterface$OnCancelListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p3

    invoke-virtual {p3}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 30
    :goto_1c2
    goto :goto_1ea

    .line 25
    :cond_1c3
    new-instance p3, Ljava/io/IOException;

    const-string v1, "\ud5c8\ube0c \uc2b9\uc778 \ub300\uae30"

    invoke-direct {p3, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    :goto_1ca
    throw p3

    :cond_1cb
    new-instance p3, Ljava/io/IOException;

    const-string v1, "\uc218\ub3d9 \ub610\ub294 \uc790\ub3d9 \ub3d9\uae30\ud654\ub97c \uba3c\uc800 \uc120\ud0dd\ud558\uc138\uc694"

    invoke-direct {p3, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    goto :goto_1ca

    .line 30
    :goto_1d3
    const-string v1, "\uc9c0\uc6d0\ud558\uc9c0 \uc54a\ub294 \uba85\ub839"

    invoke-direct {p3, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p3
    :try_end_1d9
    .catch Ljava/lang/Exception; {:try_start_7f .. :try_end_1d9} :catch_1d9

    :catch_1d9
    move-exception p3

    invoke-virtual {p3}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v1

    if-nez v1, :cond_1e3

    const-string p3, "\uc9c1\uc811 \uc5f0\uacb0 \uc900\ube44 \uc2e4\ud328"

    goto :goto_1e7

    :cond_1e3
    invoke-virtual {p3}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p3

    :goto_1e7
    invoke-direct {p0, p1, p2, v0, p3}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    :goto_1ea
    return-void

    nop

    :sswitch_data_1ec
    .sparse-switch
        0x2eaded -> :sswitch_6f
        0x30f5a8 -> :sswitch_65
        0x31dd2a -> :sswitch_5b
        0x360802 -> :sswitch_51
        0x416ad28e -> :sswitch_47
    .end sparse-switch

    :pswitch_data_202
    .packed-switch 0x0
        :pswitch_175
        :pswitch_159
        :pswitch_ed
        :pswitch_e1
        :pswitch_83
    .end packed-switch
.end method

.method private current(Ljava/lang/Object;)Lorg/json/JSONObject;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 21
    const-string v0, "config"

    invoke-direct {p0, p1, v0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lorg/json/JSONObject;

    return-object p1
.end method

.method private field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/reflect/Field;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 18
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    invoke-virtual {p1, p2}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object p1

    const/4 p2, 0x1

    invoke-virtual {p1, p2}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    return-object p1
.end method

.method private static find(Landroid/view/View;)Landroid/webkit/WebView;
    .locals 3

    .line 9
    instance-of v0, p0, Landroid/webkit/WebView;

    if-eqz v0, :cond_7

    check-cast p0, Landroid/webkit/WebView;

    return-object p0

    :cond_7
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_28

    check-cast p0, Landroid/view/ViewGroup;

    const/4 v0, 0x0

    :goto_e
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    if-ge v0, v1, :cond_28

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    invoke-static {v1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->find(Landroid/view/View;)Landroid/webkit/WebView;

    move-result-object v1

    if-eqz v1, :cond_25

    invoke-static {v1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->trusted(Landroid/webkit/WebView;)Z

    move-result v2

    if-eqz v2, :cond_25

    return-object v1

    :cond_25
    add-int/lit8 v0, v0, 0x1

    goto :goto_e

    :cond_28
    const/4 p0, 0x0

    return-object p0
.end method

.method private finish(Landroid/webkit/WebView;IZLjava/lang/String;)V
    .locals 2

    .line 16
    iput-object p4, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->status:Ljava/lang/String;

    if-ltz p2, :cond_36

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "window.MoaPeerControl?.done("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v0, ","

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-static {p4}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string p3, ")"

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->js(Landroid/webkit/WebView;Ljava/lang/String;)V

    :cond_36
    return-void
.end method

.method private hostToken(Ljava/security/KeyStore;)Ljava/lang/String;
    .locals 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 34
    const-string v0, "moa.peer.token.r717"

    invoke-virtual {p1, v0}, Ljava/security/KeyStore;->containsAlias(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_3a

    const-string v1, "AES"

    const-string v2, "AndroidKeyStore"

    invoke-static {v1, v2}, Ljavax/crypto/KeyGenerator;->getInstance(Ljava/lang/String;Ljava/lang/String;)Ljavax/crypto/KeyGenerator;

    move-result-object v1

    new-instance v2, Landroid/security/keystore/KeyGenParameterSpec$Builder;

    const/4 v3, 0x3

    invoke-direct {v2, v0, v3}, Landroid/security/keystore/KeyGenParameterSpec$Builder;-><init>(Ljava/lang/String;I)V

    const-string v3, "GCM"

    filled-new-array {v3}, [Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setBlockModes([Ljava/lang/String;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v2

    const-string v3, "NoPadding"

    filled-new-array {v3}, [Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setEncryptionPaddings([Ljava/lang/String;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v2

    const/16 v3, 0x100

    invoke-virtual {v2, v3}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setKeySize(I)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v2

    invoke-virtual {v2}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->build()Landroid/security/keystore/KeyGenParameterSpec;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljavax/crypto/KeyGenerator;->init(Ljava/security/spec/AlgorithmParameterSpec;)V

    invoke-virtual {v1}, Ljavax/crypto/KeyGenerator;->generateKey()Ljavax/crypto/SecretKey;

    :cond_3a
    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Ljava/security/KeyStore;->getKey(Ljava/lang/String;[C)Ljava/security/Key;

    move-result-object p1

    check-cast p1, Ljavax/crypto/SecretKey;

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->prefs()Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v2, "hostToken"

    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "AES/GCM/NoPadding"

    invoke-static {v1}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;

    move-result-object v1

    const/4 v3, 0x1

    const-string v4, ":"

    const/4 v5, 0x2

    if-eqz v0, :cond_8c

    invoke-virtual {v0, v4}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    new-instance v2, Ljavax/crypto/spec/GCMParameterSpec;

    const/4 v4, 0x0

    aget-object v4, v0, v4

    invoke-static {v4, v5}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object v4

    const/16 v6, 0x80

    invoke-direct {v2, v6, v4}, Ljavax/crypto/spec/GCMParameterSpec;-><init>(I[B)V

    invoke-virtual {v1, v5, p1, v2}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;Ljava/security/spec/AlgorithmParameterSpec;)V

    new-instance p1, Ljava/lang/String;

    aget-object v0, v0, v3

    invoke-static {v0, v5}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object v0

    invoke-virtual {v1, v0}, Ljavax/crypto/Cipher;->doFinal([B)[B

    move-result-object v0

    sget-object v1, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {p1, v0, v1}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-static {p1}, Lcom/juhyeon/familyjournea/PeerHub;->hash(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_84

    return-object p1

    :cond_84
    new-instance p1, Ljava/io/IOException;

    const-string v0, "host token"

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    :cond_8c
    new-instance v0, Ljava/io/File;

    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->getContext()Landroid/content/Context;

    move-result-object v6

    invoke-virtual {v6}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v6

    const-string v7, "moa-peer-r717/journal"

    invoke-direct {v0, v6, v7}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v0

    if-nez v0, :cond_f8

    const/16 v0, 0x20

    new-array v0, v0, [B

    new-instance v6, Ljava/security/SecureRandom;

    invoke-direct {v6}, Ljava/security/SecureRandom;-><init>()V

    invoke-virtual {v6, v0}, Ljava/security/SecureRandom;->nextBytes([B)V

    invoke-static {v0}, Lcom/juhyeon/familyjournea/PeerHub;->hex([B)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v3, p1}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;)V

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1}, Ljavax/crypto/Cipher;->getIV()[B

    move-result-object v3

    invoke-static {v3, v5}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-static {v0}, Lcom/juhyeon/familyjournea/PeerHub;->bytes(Ljava/lang/String;)[B

    move-result-object v3

    invoke-virtual {v1, v3}, Ljavax/crypto/Cipher;->doFinal([B)[B

    move-result-object v1

    invoke-static {v1, v5}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->prefs()Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1, v2, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    move-result p1

    if-eqz p1, :cond_f0

    return-object v0

    :cond_f0
    new-instance p1, Ljava/io/IOException;

    const-string v0, "token save"

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    :cond_f8
    new-instance p1, Ljava/io/IOException;

    const-string v0, "\uae30\uc874 \ud5c8\ube0c \ud0a4 \uc5c6\uc74c"

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method private join(Landroid/webkit/WebView;ILjava/lang/String;)V
    .locals 9

    .line 31
    iget-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->busy:Z

    if-eqz v0, :cond_5

    return-void

    :cond_5
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->busy:Z

    iget-wide v4, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->epoch:J

    const-string v0, "\uc9c1\uc811 \uc5f0\uacb0 \uc778\uc99d \uc911"

    iput-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->status:Ljava/lang/String;

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->worker:Ljava/util/concurrent/ExecutorService;

    new-instance v8, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda3;

    move-object v1, v8

    move-object v2, p0

    move-object v3, p3

    move-object v6, p1

    move v7, p2

    invoke-direct/range {v1 .. v7}, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda3;-><init>(Lcom/juhyeon/familyjournea/MoaPeerProvider;Ljava/lang/String;JLandroid/webkit/WebView;I)V

    invoke-interface {v0, v8}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method private js(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 2

    .line 11
    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->view:Landroid/webkit/WebView;

    if-ne p1, v0, :cond_27

    invoke-static {p1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->trusted(Landroid/webkit/WebView;)Z

    move-result v0

    if-eqz v0, :cond_27

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "if(location.origin===\'https://familyjourney.local\'&&[\'/\',\'/index.html\',\'/web/index.html\'].includes(location.pathname)){"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v0, "}"

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    const/4 v0, 0x0

    invoke-virtual {p1, p2, v0}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    :cond_27
    return-void
.end method

.method private varargs method(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Ljava/lang/String;",
            "[",
            "Ljava/lang/Class<",
            "*>;)",
            "Ljava/lang/reflect/Method;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 19
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    invoke-virtual {p1, p2, p3}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    const/4 p2, 0x1

    invoke-virtual {p1, p2}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    return-object p1
.end method

.method private oldPrefs()Landroid/content/SharedPreferences;
    .locals 3

    .line 7
    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "moa_sync_pair_private_v1"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    return-object v0
.end method

.method private prefs()Landroid/content/SharedPreferences;
    .locals 3

    .line 7
    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "moa_peer_r717_private"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    return-object v0
.end method

.method private provider()Ljava/lang/Object;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 17
    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v1, "com.juhyeon.familyjournea.moa_r711_sync"

    invoke-virtual {v0, v1}, Landroid/content/ContentResolver;->acquireContentProviderClient(Ljava/lang/String;)Landroid/content/ContentProviderClient;

    move-result-object v0

    if-eqz v0, :cond_36

    :try_start_10
    invoke-virtual {v0}, Landroid/content/ContentProviderClient;->getLocalContentProvider()Landroid/content/ContentProvider;

    move-result-object v1

    if-eqz v1, :cond_2c

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v2

    const-string v3, "MoaR711SyncProvider"

    invoke-virtual {v2, v3}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v2
    :try_end_24
    .catchall {:try_start_10 .. :try_end_24} :catchall_34

    if-eqz v2, :cond_2c

    if-eqz v0, :cond_2b

    invoke-virtual {v0}, Landroid/content/ContentProviderClient;->close()V

    :cond_2b
    return-object v1

    :cond_2c
    :try_start_2c
    new-instance v1, Ljava/io/IOException;

    const-string v2, "\uae30\uc874 \uc5d4\uc9c4 \uc5f0\uacb0 \uc2e4\ud328"

    invoke-direct {v1, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    :goto_33
    throw v1

    :catchall_34
    move-exception v1

    goto :goto_3e

    :cond_36
    new-instance v1, Ljava/io/IOException;

    const-string v2, "\uae30\uc874 \ub3d9\uae30\ud654 \uc5d4\uc9c4 \uc5c6\uc74c"

    invoke-direct {v1, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V
    :try_end_3d
    .catchall {:try_start_2c .. :try_end_3d} :catchall_34

    goto :goto_33

    :goto_3e
    if-eqz v0, :cond_48

    :try_start_40
    invoke-virtual {v0}, Landroid/content/ContentProviderClient;->close()V
    :try_end_43
    .catchall {:try_start_40 .. :try_end_43} :catchall_44

    goto :goto_48

    :catchall_44
    move-exception v0

    invoke-virtual {v1, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_48
    :goto_48
    throw v1
.end method

.method private requireIdle(Ljava/lang/Object;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 20
    const-string v0, "inFlight"

    invoke-direct {p0, p1, v0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/reflect/Field;->getBoolean(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_19

    const-string v0, "dialog"

    invoke-direct {p0, p1, v0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/reflect/Field;->getBoolean(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_19

    return-void

    :cond_19
    new-instance p1, Ljava/io/IOException;

    const-string v0, "\uae30\uc874 \ub3d9\uae30\ud654\uac00 \uc9c4\ud589 \uc911\uc785\ub2c8\ub2e4. \uc885\ub8cc \ud6c4 \ub2e4\uc2dc \uc2dc\ub3c4\ud558\uc138\uc694"

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method private restore()V
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 24
    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->provider()Ljava/lang/Object;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->requireIdle(Ljava/lang/Object;)V

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->prefs()Landroid/content/SharedPreferences;

    move-result-object v1

    const-string v2, "pcBackup"

    const/4 v3, 0x0

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_95

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->oldPrefs()Landroid/content/SharedPreferences;

    move-result-object v4

    const-string v5, "pair"

    invoke-interface {v4, v5, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->oldPrefs()Landroid/content/SharedPreferences;

    move-result-object v6

    invoke-interface {v6}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v6

    invoke-interface {v6, v5, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    move-result v1

    if-eqz v1, :cond_8d

    :try_start_30
    const-string v1, "load"

    const-class v6, Landroid/content/Context;

    filled-new-array {v6}, [Ljava/lang/Class;

    move-result-object v6

    invoke-direct {p0, v0, v1, v6}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->method(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->getContext()Landroid/content/Context;

    move-result-object v6

    filled-new-array {v6}, [Ljava/lang/Object;

    move-result-object v6

    invoke-virtual {v1, v3, v6}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/json/JSONObject;

    if-eqz v1, :cond_6f

    const-string v3, "config"

    invoke-direct {p0, v0, v3}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v3

    invoke-virtual {v3, v0, v1}, Ljava/lang/reflect/Field;->set(Ljava/lang/Object;Ljava/lang/Object;)V
    :try_end_55
    .catch Ljava/lang/Exception; {:try_start_30 .. :try_end_55} :catch_77

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->prefs()Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "wanted"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->stop()V

    return-void

    :cond_6f
    :try_start_6f
    new-instance v0, Ljava/io/IOException;

    const-string v1, "\ubcf5\uc6d0 \uc815\ubcf4 \uc77d\uae30 \uc2e4\ud328"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_77
    .catch Ljava/lang/Exception; {:try_start_6f .. :try_end_77} :catch_77

    :catch_77
    move-exception v0

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->oldPrefs()Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    if-nez v4, :cond_86

    invoke-interface {v1, v5}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    goto :goto_89

    :cond_86
    invoke-interface {v1, v5, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    :goto_89
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    throw v0

    :cond_8d
    new-instance v0, Ljava/io/IOException;

    const-string v1, "\ubcf5\uc6d0 \uc2e4\ud328"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_95
    new-instance v0, Ljava/io/IOException;

    const-string v1, "\ubcf4\uad00\ub41c \uae30\uc874 \uc5f0\uacb0 \uc5c6\uc74c"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method private retryLater()V
    .locals 4

    .line 33
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    iget-wide v2, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->retryDelay:J

    add-long/2addr v0, v2

    iput-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->retryAfter:J

    iget-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->retryDelay:J

    const-wide/16 v2, 0x2

    mul-long/2addr v0, v2

    const-wide/32 v2, 0xea60

    invoke-static {v2, v3, v0, v1}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v0

    iput-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->retryDelay:J

    return-void
.end method

.method private select(Ljava/lang/Object;Lorg/json/JSONObject;)V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 23
    invoke-direct {p0, p1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->requireIdle(Ljava/lang/Object;)V

    const-class v0, Landroid/content/Context;

    const-class v1, Lorg/json/JSONObject;

    filled-new-array {v0, v1}, [Ljava/lang/Class;

    move-result-object v0

    const-string v1, "store"

    invoke-direct {p0, p1, v1, v0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->method(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->getContext()Landroid/content/Context;

    move-result-object v1

    filled-new-array {v1, p2}, [Ljava/lang/Object;

    move-result-object v1

    const/4 v2, 0x0

    invoke-virtual {v0, v2, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    const-string v0, "config"

    invoke-direct {p0, p1, v0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    invoke-virtual {v0, p1, p2}, Ljava/lang/reflect/Field;->set(Ljava/lang/Object;Ljava/lang/Object;)V

    return-void
.end method

.method private start(Landroid/webkit/WebView;IZ)V
    .locals 9

    .line 32
    iget-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->busy:Z

    if-nez v0, :cond_21

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->hub:Lcom/juhyeon/familyjournea/PeerHub;

    if-eqz v0, :cond_9

    goto :goto_21

    :cond_9
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->busy:Z

    iget-wide v3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->epoch:J

    const-string v0, "\uc9c1\uc811 \ud5c8\ube0c \uc900\ube44 \uc911"

    iput-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->status:Ljava/lang/String;

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->worker:Ljava/util/concurrent/ExecutorService;

    new-instance v8, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda2;

    move-object v1, v8

    move-object v2, p0

    move-object v5, p1

    move v6, p3

    move v7, p2

    invoke-direct/range {v1 .. v7}, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda2;-><init>(Lcom/juhyeon/familyjournea/MoaPeerProvider;JLandroid/webkit/WebView;ZI)V

    invoke-interface {v0, v8}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    :cond_21
    :goto_21
    return-void
.end method

.method private stop()V
    .locals 2

    invoke-static {}, Lcom/juhyeon/familyjournea/MoaRemote721;->clear()V

    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/juhyeon/familyjournea/MoaHost723;->stop(Landroid/content/Context;)V

    .line 12
    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->hub:Lcom/juhyeon/familyjournea/PeerHub;

    const/4 v1, 0x0

    if-eqz v0, :cond_16

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->hub:Lcom/juhyeon/familyjournea/PeerHub;

    invoke-virtual {v0}, Lcom/juhyeon/familyjournea/PeerHub;->close()V

    iput-object v1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->hub:Lcom/juhyeon/familyjournea/PeerHub;

    :cond_16
    iput-object v1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->own:Lorg/json/JSONObject;

    const-string v0, "\uc9c1\uc811 \ud5c8\ube0c \uc911\uc9c0"

    iput-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->status:Ljava/lang/String;

    return-void
.end method

.method private static trusted(Landroid/webkit/WebView;)Z
    .locals 4

    .line 10
    const/4 v0, 0x0

    :try_start_1
    new-instance v1, Ljava/net/URI;

    invoke-virtual {p0}, Landroid/webkit/WebView;->getUrl()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v1, p0}, Ljava/net/URI;-><init>(Ljava/lang/String;)V

    const-string p0, "https"

    invoke-virtual {v1}, Ljava/net/URI;->getScheme()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_50

    const-string p0, "familyjourney.local"

    invoke-virtual {v1}, Ljava/net/URI;->getHost()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_50

    invoke-virtual {v1}, Ljava/net/URI;->getPort()I

    move-result p0

    const/4 v2, -0x1

    if-eq p0, v2, :cond_31

    invoke-virtual {v1}, Ljava/net/URI;->getPort()I

    move-result p0

    const/16 v2, 0x1bb

    if-ne p0, v2, :cond_50

    :cond_31
    invoke-virtual {v1}, Ljava/net/URI;->getUserInfo()Ljava/lang/String;

    move-result-object p0

    if-nez p0, :cond_50

    const-string p0, "/"

    const-string v2, "/index.html"

    const-string v3, "/web/index.html"

    filled-new-array {p0, v2, v3}, [Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object p0

    invoke-virtual {v1}, Ljava/net/URI;->getPath()Ljava/lang/String;

    move-result-object v1

    invoke-interface {p0, v1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0
    :try_end_4d
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_4d} :catch_51

    if-eqz p0, :cond_50

    const/4 v0, 0x1

    :cond_50
    return v0

    :catch_51
    move-exception p0

    return v0
.end method

.method private wifiAddress()Ljava/net/InetAddress;
    .locals 1

    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/juhyeon/familyjournea/MoaRemote721;->wifiAddress(Landroid/content/Context;)Ljava/net/InetAddress;

    move-result-object v0

    return-object v0
.end method

.method private wifiStillMatches()Z
    .locals 4

    .line 14
    const/4 v0, 0x0

    :try_start_1
    iget-object v1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->own:Lorg/json/JSONObject;

    if-eqz v1, :cond_35

    iget-object v1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->own:Lorg/json/JSONObject;

    const-string v2, "url"

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "https://"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->wifiAddress()Ljava/net/InetAddress;

    move-result-object v3

    invoke-virtual {v3}, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ":38180"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1
    :try_end_32
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_32} :catch_36

    if-eqz v1, :cond_35

    const/4 v0, 0x1

    :cond_35
    return v0

    :catch_36
    move-exception v1

    return v0
.end method


# virtual methods
.method public delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 0

    .line 36
    const/4 p1, 0x0

    return p1
.end method

.method public getType(Landroid/net/Uri;)Ljava/lang/String;
    .locals 0

    .line 36
    const/4 p1, 0x0

    return-object p1
.end method

.method public hostStillSelected()Z
    .locals 3

    :try_start_0
    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->own:Lorg/json/JSONObject;

    if-eqz v0, :cond_1d

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->provider()Ljava/lang/Object;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->current(Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v1

    if-eqz v1, :cond_1d

    const-string v2, "pin"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    return v0

    :cond_1d
    const/4 v0, 0x0

    return v0
    :try_end_1f
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_1f} :catch_1f

    :catch_1f
    move-exception v0

    const/4 v0, 0x1

    return v0
.end method

.method public insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;
    .locals 0

    .line 36
    const/4 p1, 0x0

    return-object p1
.end method

.method synthetic lambda$command$0$com-juhyeon-familyjournea-MoaPeerProvider(Landroid/webkit/WebView;ILandroid/content/DialogInterface;I)V
    .locals 0

    .line 25
    const/4 p3, 0x0

    iput-boolean p3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->asked:Z

    iput-boolean p3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->closedByUser:Z

    const-wide/16 p3, 0x0

    iput-wide p3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->retryAfter:J

    const/4 p3, 0x1

    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->start(Landroid/webkit/WebView;IZ)V

    return-void
.end method

.method synthetic lambda$command$1$com-juhyeon-familyjournea-MoaPeerProvider(Landroid/webkit/WebView;ILandroid/content/DialogInterface;I)V
    .locals 0

    .line 25
    const/4 p3, 0x0

    iput-boolean p3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->asked:Z

    const-string p4, "\ucde8\uc18c"

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    return-void
.end method

.method synthetic lambda$command$2$com-juhyeon-familyjournea-MoaPeerProvider(Landroid/webkit/WebView;ILandroid/content/DialogInterface;)V
    .locals 1

    .line 25
    const/4 p3, 0x0

    iput-boolean p3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->asked:Z

    const-string v0, "\ucde8\uc18c"

    invoke-direct {p0, p1, p2, p3, v0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    return-void
.end method

.method synthetic lambda$command$3$com-juhyeon-familyjournea-MoaPeerProvider(Landroid/webkit/WebView;ILandroid/widget/EditText;Landroid/content/DialogInterface;I)V
    .locals 0

    .line 27
    const/4 p4, 0x0

    iput-boolean p4, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->asked:Z

    invoke-virtual {p3}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p3

    invoke-virtual {p3}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->join(Landroid/webkit/WebView;ILjava/lang/String;)V

    return-void
.end method

.method synthetic lambda$command$4$com-juhyeon-familyjournea-MoaPeerProvider(Landroid/webkit/WebView;ILandroid/content/DialogInterface;I)V
    .locals 0

    .line 27
    const/4 p3, 0x0

    iput-boolean p3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->asked:Z

    const-string p4, "\ucde8\uc18c"

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    return-void
.end method

.method synthetic lambda$command$5$com-juhyeon-familyjournea-MoaPeerProvider(Landroid/webkit/WebView;ILandroid/content/DialogInterface;)V
    .locals 1

    .line 27
    const/4 p3, 0x0

    iput-boolean p3, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->asked:Z

    const-string v0, "\ucde8\uc18c"

    invoke-direct {p0, p1, p2, p3, v0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    return-void
.end method

.method synthetic lambda$command$6$com-juhyeon-familyjournea-MoaPeerProvider(Ljava/lang/String;Landroid/webkit/WebView;ILandroid/content/DialogInterface;I)V
    .locals 2

    .line 29
    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->getContext()Landroid/content/Context;

    move-result-object p4

    const-class p5, Landroid/content/ClipboardManager;

    invoke-virtual {p4, p5}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p4

    check-cast p4, Landroid/content/ClipboardManager;

    const-string p5, "MOA private pairing"

    invoke-static {p5, p1}, Landroid/content/ClipData;->newPlainText(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Landroid/content/ClipData;

    move-result-object p1

    sget p5, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v0, 0x21

    const/4 v1, 0x1

    if-lt p5, v0, :cond_2a

    new-instance p5, Landroid/os/PersistableBundle;

    invoke-direct {p5}, Landroid/os/PersistableBundle;-><init>()V

    const-string v0, "android.content.extra.IS_SENSITIVE"

    invoke-virtual {p5, v0, v1}, Landroid/os/PersistableBundle;->putBoolean(Ljava/lang/String;Z)V

    invoke-virtual {p1}, Landroid/content/ClipData;->getDescription()Landroid/content/ClipDescription;

    move-result-object v0

    invoke-virtual {v0, p5}, Landroid/content/ClipDescription;->setExtras(Landroid/os/PersistableBundle;)V

    :cond_2a
    invoke-virtual {p4, p1}, Landroid/content/ClipboardManager;->setPrimaryClip(Landroid/content/ClipData;)V

    const-string p1, "\uc5f0\uacb0 \uc815\ubcf4 \ubcf5\uc0ac \uc644\ub8cc"

    invoke-direct {p0, p2, p3, v1, p1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    return-void
.end method

.method synthetic lambda$command$7$com-juhyeon-familyjournea-MoaPeerProvider(Landroid/webkit/WebView;ILandroid/content/DialogInterface;I)V
    .locals 0

    .line 29
    const/4 p3, 0x1

    const-string p4, "\uc9c1\uc811 \ud5c8\ube0c \uc2e4\ud589 \uc911"

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    return-void
.end method

.method synthetic lambda$command$8$com-juhyeon-familyjournea-MoaPeerProvider(Landroid/webkit/WebView;ILandroid/content/DialogInterface;)V
    .locals 1

    .line 29
    const/4 p3, 0x1

    const-string v0, "\uc9c1\uc811 \ud5c8\ube0c \uc2e4\ud589 \uc911"

    invoke-direct {p0, p1, p2, p3, v0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    return-void
.end method

.method synthetic lambda$join$10$com-juhyeon-familyjournea-MoaPeerProvider(Landroid/webkit/WebView;I)V
    .locals 2

    .line 31
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->busy:Z

    iget-object v1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->status:Ljava/lang/String;

    invoke-direct {p0, p1, p2, v0, v1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    return-void
.end method

.method synthetic lambda$join$11$com-juhyeon-familyjournea-MoaPeerProvider(Ljava/lang/String;JLandroid/webkit/WebView;I)V
    .locals 9

    .line 31
    const-string v0, "token"

    const-string v1, "pin"

    const-string v2, "url"

    :try_start_6
    invoke-static {p1}, Lcom/juhyeon/familyjournea/MoaLan723;->authenticate(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v6

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->main:Landroid/os/Handler;

    new-instance v8, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda0;

    move-object v1, v8

    move-object v2, p0

    move-wide v3, p2

    move-object v5, p4

    move v7, p5

    invoke-direct/range {v1 .. v7}, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda0;-><init>(Lcom/juhyeon/familyjournea/MoaPeerProvider;JLandroid/webkit/WebView;Lorg/json/JSONObject;I)V

    invoke-virtual {v0, v8}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    goto :goto_2b
    :try_end_1a
    .catch Ljava/lang/Throwable; {:try_start_6 .. :try_end_1a} :catch_1a

    :catch_1a
    move-exception v0

    invoke-static {v0}, Lcom/juhyeon/familyjournea/MoaLan723;->error(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->status:Ljava/lang/String;

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->main:Landroid/os/Handler;

    new-instance v1, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda1;

    invoke-direct {v1, p0, p4, p5}, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda1;-><init>(Lcom/juhyeon/familyjournea/MoaPeerProvider;Landroid/webkit/WebView;I)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :goto_2b
    return-void
.end method

.method synthetic lambda$join$9$com-juhyeon-familyjournea-MoaPeerProvider(JLandroid/webkit/WebView;Lorg/json/JSONObject;I)V
    .locals 4

    .line 31
    const-string v0, "pin"

    const/4 v1, 0x0

    iput-boolean v1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->busy:Z

    iget-wide v2, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->epoch:J

    cmp-long p1, p1, v2

    if-nez p1, :cond_55

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->view:Landroid/webkit/WebView;

    if-ne p3, p1, :cond_55

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->active:Landroid/app/Activity;

    if-nez p1, :cond_14

    goto :goto_55

    :cond_14
    :try_start_14
    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->provider()Ljava/lang/Object;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->requireIdle(Ljava/lang/Object;)V

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->current(Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p2

    if-eqz p2, :cond_32

    invoke-virtual {p4, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p2, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v2, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_32

    invoke-direct {p0, p1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->backup(Ljava/lang/Object;)V

    :cond_32
    invoke-direct {p0, p1, p4}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->select(Ljava/lang/Object;Lorg/json/JSONObject;)V

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->prefs()Landroid/content/SharedPreferences;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    const-string p2, "wanted"

    invoke-interface {p1, p2, v1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    const/4 p1, 0x1

    iput-boolean p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->closedByUser:Z

    const-string p2, "\uc9c1\uc811 \uc5f0\uacb0 \ub4f1\ub85d \uc644\ub8cc"

    invoke-direct {p0, p3, p5, p1, p2}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V
    :try_end_4e
    .catch Ljava/lang/Exception; {:try_start_14 .. :try_end_4e} :catch_4f

    goto :goto_55

    :catch_4f
    move-exception p1

    const-string p1, "\uc5f0\uacb0 \uc804\ud658 \uc2e4\ud328 \u00b7 \uae30\uc874 \uc5f0\uacb0 \uc720\uc9c0"

    invoke-direct {p0, p3, p5, v1, p1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    :cond_55
    :goto_55
    return-void
.end method

.method synthetic lambda$start$12$com-juhyeon-familyjournea-MoaPeerProvider(JLandroid/webkit/WebView;Lcom/juhyeon/familyjournea/PeerHub;ZLjava/lang/String;Lorg/json/JSONObject;I)V
    .locals 5

    .line 32
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->busy:Z

    iget-wide v1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->epoch:J

    cmp-long p1, p1, v1

    if-nez p1, :cond_aa

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->view:Landroid/webkit/WebView;

    if-ne p3, p1, :cond_aa

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->active:Landroid/app/Activity;

    if-eqz p1, :cond_aa

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->mode:Ljava/lang/String;

    const-string p2, "off"

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_aa

    iget-boolean p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->closedByUser:Z

    if-eqz p1, :cond_21

    goto/16 :goto_aa

    :cond_21
    const/4 p1, 0x1

    :try_start_22
    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->provider()Ljava/lang/Object;

    move-result-object p2

    invoke-direct {p0, p2}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->requireIdle(Ljava/lang/Object;)V

    invoke-direct {p0, p2}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->current(Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v1
    :try_end_2d
    .catch Ljava/lang/Exception; {:try_start_22 .. :try_end_2d} :catch_96

    const-string v2, "wanted"

    const-string v3, "pin"

    if-nez p5, :cond_52

    if-eqz v1, :cond_3f

    :try_start_35
    invoke-virtual {v1, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {p6, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_52

    :cond_3f
    invoke-virtual {p4}, Lcom/juhyeon/familyjournea/PeerHub;->close()V

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->prefs()Landroid/content/SharedPreferences;

    move-result-object p2

    invoke-interface {p2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    invoke-interface {p2, v2, v0}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    invoke-interface {p2}, Landroid/content/SharedPreferences$Editor;->commit()Z

    return-void

    :cond_52
    if-eqz v1, :cond_61

    invoke-virtual {v1, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p6, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p6

    if-nez p6, :cond_61

    invoke-direct {p0, p2}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->backup(Ljava/lang/Object;)V

    :cond_61
    invoke-direct {p0, p2, p7}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->select(Ljava/lang/Object;Lorg/json/JSONObject;)V

    iput-object p4, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->hub:Lcom/juhyeon/familyjournea/PeerHub;

    iput-object p7, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->own:Lorg/json/JSONObject;

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide p6

    iput-wide p6, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->lastStarted:J

    iget-wide p6, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->lastStarted:J

    iput-wide p6, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->lastWifiCheck:J

    const-wide/16 p6, 0x2710

    iput-wide p6, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->retryDelay:J

    const-wide/16 p6, 0x0

    iput-wide p6, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->retryAfter:J

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->prefs()Landroid/content/SharedPreferences;

    move-result-object p2

    invoke-interface {p2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    invoke-interface {p2, v2, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    invoke-interface {p2}, Landroid/content/SharedPreferences$Editor;->commit()Z

    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->getContext()Landroid/content/Context;

    move-result-object p2

    invoke-static {p2, p0}, Lcom/juhyeon/familyjournea/MoaHost723;->start(Landroid/content/Context;Ljava/lang/Object;)V

    const-string p2, "\uc9c1\uc811 \ud5c8\ube0c \uc778\uc99d \uc790\uccb4\uac80\uc0ac \ud1b5\uacfc \u00b7 \ub2e4\ub978 \uae30\uae30 \ucc38\uac00 \uac00\ub2a5"

    invoke-direct {p0, p3, p8, p1, p2}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V
    :try_end_95
    .catch Ljava/lang/Exception; {:try_start_35 .. :try_end_95} :catch_96

    goto :goto_a9

    :catch_96
    move-exception p2

    invoke-virtual {p4}, Lcom/juhyeon/familyjournea/PeerHub;->close()V

    if-eqz p5, :cond_9f

    iput-boolean p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->closedByUser:Z

    goto :goto_a2

    :cond_9f
    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->retryLater()V

    :goto_a2
    invoke-static {p2}, Lcom/juhyeon/familyjournea/MoaRemote721;->failure(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p3, p8, v0, p1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    :goto_a9
    return-void

    :cond_aa
    :goto_aa
    invoke-virtual {p4}, Lcom/juhyeon/familyjournea/PeerHub;->close()V

    const-string p1, "\ud5c8\ube0c \uc2dc\uc791 \uc911 \ud654\uba74 \ub610\ub294 \uc124\uc815\uc774 \ubcc0\uacbd\ub418\uc5c8\uc2b5\ub2c8\ub2e4. \ub2e4\uc2dc \uc2dc\uc791\ud558\uc138\uc694."

    invoke-direct {p0, p3, p8, v0, p1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    return-void
.end method

.method synthetic lambda$start$13$com-juhyeon-familyjournea-MoaPeerProvider(ZLandroid/webkit/WebView;I)V
    .locals 1

    .line 32
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->busy:Z

    if-eqz p1, :cond_9

    const/4 p1, 0x1

    iput-boolean p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->closedByUser:Z

    goto :goto_c

    :cond_9
    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->retryLater()V

    :goto_c
    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->status:Ljava/lang/String;

    invoke-direct {p0, p2, p3, v0, p1}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->finish(Landroid/webkit/WebView;IZLjava/lang/String;)V

    return-void
.end method

.method synthetic lambda$start$14$com-juhyeon-familyjournea-MoaPeerProvider(JLandroid/webkit/WebView;ZI)V
    .locals 16

    .line 32
    move-object/from16 v11, p0

    const-string v0, "AndroidKeyStore"

    const-string v1, "moa.peer.tls.r717"

    const/4 v2, 0x0

    :try_start_7
    invoke-direct/range {p0 .. p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->wifiAddress()Ljava/net/InetAddress;

    move-result-object v5

    invoke-static {v0}, Ljava/security/KeyStore;->getInstance(Ljava/lang/String;)Ljava/security/KeyStore;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/security/KeyStore;->load(Ljava/security/KeyStore$LoadStoreParameter;)V

    invoke-virtual {v3, v1}, Ljava/security/KeyStore;->containsAlias(Ljava/lang/String;)Z

    move-result v4
    :try_end_16
    .catch Ljava/lang/Throwable; {:try_start_7 .. :try_end_16} :catch_149

    const/4 v6, 0x1

    const-string v7, "SHA-256"

    if-nez v4, :cond_a1

    :try_start_1b
    new-instance v4, Ljava/io/File;

    invoke-virtual/range {p0 .. p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->getContext()Landroid/content/Context;

    move-result-object v8

    invoke-virtual {v8}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v8

    const-string v9, "moa-peer-r717/journal"

    invoke-direct {v4, v8, v9}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/io/File;->exists()Z

    move-result v4

    if-nez v4, :cond_99

    const-string v4, "RSA"

    invoke-static {v4, v0}, Ljava/security/KeyPairGenerator;->getInstance(Ljava/lang/String;Ljava/lang/String;)Ljava/security/KeyPairGenerator;

    move-result-object v0

    invoke-static {}, Ljava/util/Calendar;->getInstance()Ljava/util/Calendar;

    move-result-object v4

    const/16 v8, 0xa

    invoke-virtual {v4, v6, v8}, Ljava/util/Calendar;->add(II)V

    new-instance v8, Landroid/security/keystore/KeyGenParameterSpec$Builder;

    const/16 v9, 0xc

    invoke-direct {v8, v1, v9}, Landroid/security/keystore/KeyGenParameterSpec$Builder;-><init>(Ljava/lang/String;I)V

    const/16 v9, 0x800

    invoke-virtual {v8, v9}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setKeySize(I)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v8

    const-string v9, "SHA-384"

    const-string v10, "SHA-512"

    filled-new-array {v7, v9, v10}, [Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setDigests([Ljava/lang/String;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v8

    const-string v9, "PKCS1"

    const-string v10, "PSS"

    filled-new-array {v9, v10}, [Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setSignaturePaddings([Ljava/lang/String;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v8

    new-instance v9, Ljavax/security/auth/x500/X500Principal;

    const-string v10, "CN=MOA Direct Hub"

    invoke-direct {v9, v10}, Ljavax/security/auth/x500/X500Principal;-><init>(Ljava/lang/String;)V

    invoke-virtual {v8, v9}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setCertificateSubject(Ljavax/security/auth/x500/X500Principal;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v8

    sget-object v9, Ljava/math/BigInteger;->ONE:Ljava/math/BigInteger;

    invoke-virtual {v8, v9}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setCertificateSerialNumber(Ljava/math/BigInteger;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v8

    new-instance v9, Ljava/util/Date;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v12

    const-wide/32 v14, 0x5265c00

    sub-long/2addr v12, v14

    invoke-direct {v9, v12, v13}, Ljava/util/Date;-><init>(J)V

    invoke-virtual {v8, v9}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setCertificateNotBefore(Ljava/util/Date;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v8

    invoke-virtual {v4}, Ljava/util/Calendar;->getTime()Ljava/util/Date;

    move-result-object v4

    invoke-virtual {v8, v4}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setCertificateNotAfter(Ljava/util/Date;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v4

    invoke-virtual {v4}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->build()Landroid/security/keystore/KeyGenParameterSpec;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/security/KeyPairGenerator;->initialize(Ljava/security/spec/AlgorithmParameterSpec;)V

    invoke-virtual {v0}, Ljava/security/KeyPairGenerator;->generateKeyPair()Ljava/security/KeyPair;

    goto :goto_a1

    :cond_99
    new-instance v0, Ljava/io/IOException;

    const-string v1, "\uae30\uc874 \ud5c8\ube0c \uc778\uc99d\uc11c \uc5c6\uc74c"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_a1
    :goto_a1
    invoke-virtual {v3, v1}, Ljava/security/KeyStore;->getCertificate(Ljava/lang/String;)Ljava/security/cert/Certificate;

    move-result-object v0

    check-cast v0, Ljava/security/cert/X509Certificate;

    invoke-virtual {v3, v1, v2}, Ljava/security/KeyStore;->getKey(Ljava/lang/String;[C)Ljava/security/Key;

    move-result-object v1

    check-cast v1, Ljava/security/PrivateKey;

    invoke-virtual {v11}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->getContext()Landroid/content/Context;

    move-result-object v4

    move/from16 v6, p4

    invoke-static {v4, v0, v1, v5, v6}, Lcom/juhyeon/familyjournea/MoaHub727;->select(Landroid/content/Context;Ljava/security/cert/X509Certificate;Ljava/security/PrivateKey;Ljava/net/InetAddress;Z)Ljava/security/KeyStore$PrivateKeyEntry;

    move-result-object v4

    invoke-virtual {v4}, Ljava/security/KeyStore$PrivateKeyEntry;->getCertificate()Ljava/security/cert/Certificate;

    move-result-object v0

    check-cast v0, Ljava/security/cert/X509Certificate;

    invoke-virtual {v4}, Ljava/security/KeyStore$PrivateKeyEntry;->getPrivateKey()Ljava/security/PrivateKey;

    move-result-object v1

    invoke-static {v7}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v4

    invoke-virtual {v0}, Ljava/security/cert/X509Certificate;->getEncoded()[B

    move-result-object v7

    invoke-virtual {v4, v7}, Ljava/security/MessageDigest;->digest([B)[B

    move-result-object v4

    invoke-static {v4}, Lcom/juhyeon/familyjournea/PeerHub;->hex([B)Ljava/lang/String;

    move-result-object v9

    invoke-static {v0, v1}, Lcom/juhyeon/familyjournea/MoaHub727;->context(Ljava/security/cert/X509Certificate;Ljava/security/PrivateKey;)Ljavax/net/ssl/SSLContext;

    move-result-object v7

    invoke-direct {v11, v3}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->hostToken(Ljava/security/KeyStore;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    const-string v3, "url"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "https://"

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v5}, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, ":38180"

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v1

    const-string v3, "pin"

    invoke-virtual {v1, v3, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v1

    const-string v3, "token"

    invoke-virtual {v1, v3, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v10

    new-instance v12, Lcom/juhyeon/familyjournea/PeerHub;

    new-instance v4, Ljava/io/File;

    invoke-virtual/range {p0 .. p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v1

    const-string v3, "moa-peer-r717"

    invoke-direct {v4, v1, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    move-object v3, v12

    move-object v6, v7

    move-object v7, v0

    move-object v8, v9

    invoke-direct/range {v3 .. v8}, Lcom/juhyeon/familyjournea/PeerHub;-><init>(Ljava/io/File;Ljava/net/InetAddress;Ljavax/net/ssl/SSLContext;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_125
    .catch Ljava/lang/Throwable; {:try_start_1b .. :try_end_125} :catch_149

    :try_start_125
    invoke-virtual {v10}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/juhyeon/familyjournea/MoaLan723;->authenticate(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v10

    iget-object v0, v11, Lcom/juhyeon/familyjournea/MoaPeerProvider;->main:Landroid/os/Handler;

    new-instance v13, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda13;

    move-object v1, v13

    move-object/from16 v2, p0

    move-wide/from16 v3, p1

    move-object/from16 v5, p3

    move-object v6, v12

    move/from16 v7, p4

    move-object v8, v9

    move-object v9, v10

    move/from16 v10, p5

    invoke-direct/range {v1 .. v10}, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda13;-><init>(Lcom/juhyeon/familyjournea/MoaPeerProvider;JLandroid/webkit/WebView;Lcom/juhyeon/familyjournea/PeerHub;ZLjava/lang/String;Lorg/json/JSONObject;I)V

    invoke-virtual {v0, v13}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_145
    .catch Ljava/lang/Throwable; {:try_start_125 .. :try_end_145} :catch_146

    goto :goto_165

    :catch_146
    move-exception v0

    move-object v2, v12

    goto :goto_14a

    :catch_149
    move-exception v0

    :goto_14a
    invoke-static {v0}, Lcom/juhyeon/familyjournea/MoaLan723;->error(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, v11, Lcom/juhyeon/familyjournea/MoaPeerProvider;->status:Ljava/lang/String;

    if-eqz v2, :cond_155

    invoke-virtual {v2}, Lcom/juhyeon/familyjournea/PeerHub;->close()V

    :cond_155
    iget-object v0, v11, Lcom/juhyeon/familyjournea/MoaPeerProvider;->main:Landroid/os/Handler;

    new-instance v1, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda14;

    move-object/from16 v2, p3

    move/from16 v3, p4

    move/from16 v4, p5

    invoke-direct {v1, v11, v3, v2, v4}, Lcom/juhyeon/familyjournea/MoaPeerProvider$$ExternalSyntheticLambda14;-><init>(Lcom/juhyeon/familyjournea/MoaPeerProvider;ZLandroid/webkit/WebView;I)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :goto_165
    return-void
.end method

.method public onActivityCreated(Landroid/app/Activity;Landroid/os/Bundle;)V
    .locals 0

    .line 35
    return-void
.end method

.method public onActivityDestroyed(Landroid/app/Activity;)V
    .locals 0

    .line 35
    return-void
.end method

.method public onActivityPaused(Landroid/app/Activity;)V
    .locals 4

    .line 35
    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->active:Landroid/app/Activity;

    if-ne v0, p1, :cond_23

    const/4 p1, 0x0

    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->active:Landroid/app/Activity;

    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->view:Landroid/webkit/WebView;

    iget-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->epoch:J

    const-wide/16 v2, 0x1

    add-long/2addr v0, v2

    iput-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->epoch:J

    const/4 p1, 0x0

    iput-boolean p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->pendingPoll:Z

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->main:Landroid/os/Handler;

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->tick:Ljava/lang/Runnable;

    invoke-virtual {p1, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    invoke-static {}, Lcom/juhyeon/familyjournea/MoaHost723;->keep()Z

    move-result p1

    if-nez p1, :cond_23

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->stop()V

    :cond_23
    return-void
.end method

.method public onActivityResumed(Landroid/app/Activity;)V
    .locals 4

    .line 35
    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->active:Landroid/app/Activity;

    const/4 p1, 0x0

    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->view:Landroid/webkit/WebView;

    iget-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->epoch:J

    const-wide/16 v2, 0x1

    add-long/2addr v0, v2

    iput-wide v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->epoch:J

    const/4 p1, -0x1

    iput p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->lastCmd:I

    const/4 p1, 0x0

    iput-boolean p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->pendingPoll:Z

    iput-boolean p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->closedByUser:Z

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->main:Landroid/os/Handler;

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->tick:Ljava/lang/Runnable;

    invoke-virtual {p1, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->main:Landroid/os/Handler;

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->tick:Ljava/lang/Runnable;

    const-wide/16 v1, 0x12c

    invoke-virtual {p1, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method

.method public onActivitySaveInstanceState(Landroid/app/Activity;Landroid/os/Bundle;)V
    .locals 0

    .line 35
    return-void
.end method

.method public onActivityStarted(Landroid/app/Activity;)V
    .locals 0

    .line 35
    return-void
.end method

.method public onActivityStopped(Landroid/app/Activity;)V
    .locals 0

    .line 35
    return-void
.end method

.method public onCreate()Z
    .locals 2

    .line 8
    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    if-eqz v0, :cond_1a

    invoke-static {v0}, Lcom/juhyeon/familyjournea/MoaLan723;->init(Landroid/content/Context;)V

    invoke-virtual {v0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    instance-of v1, v1, Landroid/app/Application;

    if-eqz v1, :cond_1a

    invoke-virtual {v0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    check-cast v0, Landroid/app/Application;

    invoke-virtual {v0, p0}, Landroid/app/Application;->registerActivityLifecycleCallbacks(Landroid/app/Application$ActivityLifecycleCallbacks;)V

    :cond_1a
    const/4 v0, 0x1

    return v0
.end method

.method public query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    .locals 0

    .line 36
    const/4 p1, 0x0

    return-object p1
.end method

.method public stopByService()V
    .locals 3

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaPeerProvider;->closedByUser:Z

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->prefs()Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "wanted"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    invoke-direct {p0}, Lcom/juhyeon/familyjournea/MoaPeerProvider;->stop()V

    return-void
.end method

.method public update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 0

    .line 36
    const/4 p1, 0x0

    return p1
.end method
