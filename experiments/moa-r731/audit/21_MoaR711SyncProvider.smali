.class public final Lcom/juhyeon/familyjournea/MoaR711SyncProvider;
.super Landroid/content/ContentProvider;
.source "MoaR711SyncProvider.java"

# interfaces
.implements Landroid/app/Application$ActivityLifecycleCallbacks;


# static fields
.field private static final KEY:Ljava/lang/String; = "moa.r711.sync.pair.v1"


# instance fields
.field private active:Landroid/app/Activity;

.field private config:Lorg/json/JSONObject;

.field private dialog:Z

.field private epoch:I

.field private inFlight:Z

.field private final main:Landroid/os/Handler;

.field private scripts:Ljava/lang/String;

.field private final tick:Ljava/lang/Runnable;

.field private view:Landroid/webkit/WebView;

.field private final work:Ljava/util/concurrent/ExecutorService;


# direct methods
.method public constructor <init>()V
    .locals 2

    .line 38
    invoke-direct {p0}, Landroid/content/ContentProvider;-><init>()V

    .line 39
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->main:Landroid/os/Handler;

    .line 40
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    iput-object v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->work:Ljava/util/concurrent/ExecutorService;

    .line 42
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->inFlight:Z

    iput-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->dialog:Z

    iput v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->epoch:I

    .line 55
    new-instance v0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$1;

    invoke-direct {v0, p0}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$1;-><init>(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;)V

    iput-object v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->tick:Ljava/lang/Runnable;

    return-void
.end method

.method static synthetic access$000(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;)Landroid/app/Activity;
    .locals 0

    .line 38
    iget-object p0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->active:Landroid/app/Activity;

    return-object p0
.end method

.method static synthetic access$100(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;)Ljava/lang/String;
    .locals 0

    .line 38
    iget-object p0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->scripts:Ljava/lang/String;

    return-object p0
.end method

.method static synthetic access$1000(Ljava/lang/String;)Ljava/lang/String;
    .locals 0

    .line 38
    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->guarded(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$1100(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;)Lorg/json/JSONObject;
    .locals 0

    .line 38
    iget-object p0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->config:Lorg/json/JSONObject;

    return-object p0
.end method

.method static synthetic access$1200(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;Landroid/webkit/WebView;ILorg/json/JSONObject;)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 38
    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->dispatch(Landroid/webkit/WebView;ILorg/json/JSONObject;)V

    return-void
.end method

.method static synthetic access$200(Landroid/view/View;)Landroid/webkit/WebView;
    .locals 0

    .line 38
    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->find(Landroid/view/View;)Landroid/webkit/WebView;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$300(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;)Landroid/webkit/WebView;
    .locals 0

    .line 38
    iget-object p0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->view:Landroid/webkit/WebView;

    return-object p0
.end method

.method static synthetic access$302(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;Landroid/webkit/WebView;)Landroid/webkit/WebView;
    .locals 0

    .line 38
    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->view:Landroid/webkit/WebView;

    return-object p1
.end method

.method static synthetic access$400(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;)I
    .locals 0

    .line 38
    iget p0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->epoch:I

    return p0
.end method

.method static synthetic access$408(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;)I
    .locals 2

    .line 38
    iget v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->epoch:I

    add-int/lit8 v1, v0, 0x1

    iput v1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->epoch:I

    return v0
.end method

.method static synthetic access$500(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;)Z
    .locals 0

    .line 38
    iget-boolean p0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->inFlight:Z

    return p0
.end method

.method static synthetic access$502(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;Z)Z
    .locals 0

    .line 38
    iput-boolean p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->inFlight:Z

    return p1
.end method

.method static synthetic access$600(Landroid/webkit/WebView;)Z
    .locals 0

    .line 38
    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->trusted(Landroid/webkit/WebView;)Z

    move-result p0

    return p0
.end method

.method static synthetic access$700(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;)Z
    .locals 0

    .line 38
    iget-boolean p0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->dialog:Z

    return p0
.end method

.method static synthetic access$800(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;)Landroid/os/Handler;
    .locals 0

    .line 38
    iget-object p0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->main:Landroid/os/Handler;

    return-object p0
.end method

.method static synthetic access$900(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;Landroid/webkit/WebView;I)Z
    .locals 0

    .line 38
    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->current(Landroid/webkit/WebView;I)Z

    move-result p0

    return p0
.end method

.method private static asset(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 44
    invoke-virtual {p0}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object p0

    :try_start_8
    new-instance p1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {p1}, Ljava/io/ByteArrayOutputStream;-><init>()V
    :try_end_d
    .catchall {:try_start_8 .. :try_end_d} :catchall_3b

    const/16 v0, 0x2000

    :try_start_f
    new-array v0, v0, [B

    :goto_11
    invoke-virtual {p0, v0}, Ljava/io/InputStream;->read([B)I

    move-result v1

    const/4 v2, -0x1

    if-eq v1, v2, :cond_1d

    const/4 v2, 0x0

    invoke-virtual {p1, v0, v2, v1}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_11

    :cond_1d
    new-instance v0, Ljava/lang/String;

    invoke-virtual {p1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v1

    sget-object v2, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v0, v1, v2}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V
    :try_end_28
    .catchall {:try_start_f .. :try_end_28} :catchall_31

    :try_start_28
    invoke-virtual {p1}, Ljava/io/ByteArrayOutputStream;->close()V
    :try_end_2b
    .catchall {:try_start_28 .. :try_end_2b} :catchall_3b

    if-eqz p0, :cond_30

    invoke-virtual {p0}, Ljava/io/InputStream;->close()V

    :cond_30
    return-object v0

    :catchall_31
    move-exception v0

    :try_start_32
    invoke-virtual {p1}, Ljava/io/ByteArrayOutputStream;->close()V
    :try_end_35
    .catchall {:try_start_32 .. :try_end_35} :catchall_36

    goto :goto_3a

    :catchall_36
    move-exception p1

    :try_start_37
    invoke-virtual {v0, p1}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_3a
    throw v0
    :try_end_3b
    .catchall {:try_start_37 .. :try_end_3b} :catchall_3b

    :catchall_3b
    move-exception p1

    if-eqz p0, :cond_46

    :try_start_3e
    invoke-virtual {p0}, Ljava/io/InputStream;->close()V
    :try_end_41
    .catchall {:try_start_3e .. :try_end_41} :catchall_42

    goto :goto_46

    :catchall_42
    move-exception p0

    invoke-virtual {p1, p0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_46
    :goto_46
    throw p1
.end method

.method private complete(Landroid/webkit/WebView;IIZLjava/lang/Object;)V
    .locals 1

    .line 56
    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->current(Landroid/webkit/WebView;I)Z

    move-result p2

    if-nez p2, :cond_7

    return-void

    :cond_7
    const/4 p2, 0x0

    iput-boolean p2, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->inFlight:Z

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "window.MoaSyncMailbox&&window.MoaSyncMailbox.complete("

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string p3, ","

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-static {p5}, Lorg/json/JSONObject;->wrap(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string p3, ")"

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->guarded(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    const/4 p3, 0x0

    invoke-virtual {p1, p2, p3}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    return-void
.end method

.method private current(Landroid/webkit/WebView;I)Z
    .locals 1

    .line 52
    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->active:Landroid/app/Activity;

    if-eqz v0, :cond_1c

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->active:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->isDestroyed()Z

    move-result v0

    if-nez v0, :cond_1c

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->view:Landroid/webkit/WebView;

    if-ne v0, p1, :cond_1c

    iget v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->epoch:I

    if-ne v0, p2, :cond_1c

    invoke-static {p1}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->trusted(Landroid/webkit/WebView;)Z

    move-result p1

    if-eqz p1, :cond_1c

    const/4 p1, 0x1

    goto :goto_1d

    :cond_1c
    const/4 p1, 0x0

    :goto_1d
    return p1
.end method

.method private dispatch(Landroid/webkit/WebView;ILorg/json/JSONObject;)V
    .locals 9
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 58
    iget-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->inFlight:Z

    if-nez v0, :cond_105

    iget-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->dialog:Z

    if-eqz v0, :cond_a

    goto/16 :goto_105

    :cond_a
    const-string v0, "id"

    invoke-virtual {p3, v0}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v8

    const-string v0, "kind"

    invoke-virtual {p3, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v0, "exportMedia"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_36

    const-string v0, "importMedia"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_36

    const-string v0, "exportVoice"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_36

    const-string v0, "importVoice"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3c

    :cond_36
    const-string p3, "R721 \uc6d0\ubcf8 \uc790\ub3d9 \ubcf5\uc81c \uae08\uc9c0"

    invoke-direct {p0, p1, p2, v8, p3}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->fail(Landroid/webkit/WebView;IILjava/lang/String;)V

    return-void

    :cond_3c
    const-string v0, "pair"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_48

    invoke-direct {p0, p1, p2, v8}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->pair(Landroid/webkit/WebView;II)V

    return-void

    :cond_48
    const-string v1, "unpair"

    invoke-virtual {v1, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_7d

    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->getContext()Landroid/content/Context;

    move-result-object p3

    invoke-static {p3}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p3

    invoke-interface {p3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    invoke-interface {p3, v0}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    invoke-interface {p3}, Landroid/content/SharedPreferences$Editor;->commit()Z

    move-result p3

    if-eqz p3, :cond_77

    const/4 p3, 0x0

    iput-object p3, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->config:Lorg/json/JSONObject;

    new-instance v6, Lorg/json/JSONObject;

    invoke-direct {v6}, Lorg/json/JSONObject;-><init>()V

    const/4 v5, 0x1

    move-object v1, p0

    move-object v2, p1

    move v3, p2

    move v4, v8

    invoke-direct/range {v1 .. v6}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->complete(Landroid/webkit/WebView;IIZLjava/lang/Object;)V

    goto :goto_7c

    :cond_77
    const-string p3, "\uc5f0\uacb0 \ud574\uc81c \uc800\uc7a5 \uc2e4\ud328"

    invoke-direct {p0, p1, p2, v8, p3}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->fail(Landroid/webkit/WebView;IILjava/lang/String;)V

    :goto_7c
    return-void

    :cond_7d
    const-string v0, "permit"

    const/4 v1, 0x0

    invoke-virtual {p3, v0, v1}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v0

    if-eqz v0, :cond_100

    const-string v0, "mode"

    const-string v1, "off"

    invoke-virtual {p3, v0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_95

    goto :goto_100

    :cond_95
    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->config:Lorg/json/JSONObject;

    if-nez v0, :cond_9f

    const-string p3, "PC \uc5f0\uacb0 \ud544\uc694"

    invoke-direct {p0, p1, p2, v8, p3}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->fail(Landroid/webkit/WebView;IILjava/lang/String;)V

    return-void

    :cond_9f
    const-string v0, "push"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_dd

    const-string v0, "pull"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_dd

    const-string v0, "exportMedia"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_dd

    const-string v0, "importMedia"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_dd

    const-string v0, "listVoice"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_dd

    const-string v0, "exportVoice"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_dd

    const-string v0, "importVoice"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_dd

    const-string p3, "Unsupported command"

    invoke-direct {p0, p1, p2, v8, p3}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->fail(Landroid/webkit/WebView;IILjava/lang/String;)V

    return-void

    :cond_dd
    new-instance v3, Lorg/json/JSONObject;

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->config:Lorg/json/JSONObject;

    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v3, v0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v0, "data"

    invoke-virtual {p3, v0}, Lorg/json/JSONObject;->get(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v5

    const/4 p3, 0x1

    iput-boolean p3, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->inFlight:Z

    iget-object p3, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->work:Ljava/util/concurrent/ExecutorService;

    new-instance v0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda3;

    move-object v1, v0

    move-object v2, p0

    move-object v6, p1

    move v7, p2

    invoke-direct/range {v1 .. v8}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda3;-><init>(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;Lorg/json/JSONObject;Ljava/lang/String;Ljava/lang/Object;Landroid/webkit/WebView;II)V

    invoke-interface {p3, v0}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    return-void

    :cond_100
    :goto_100
    const-string p3, "\ub3d9\uae30\ud654 \uc911\uc9c0"

    invoke-direct {p0, p1, p2, v8, p3}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->fail(Landroid/webkit/WebView;IILjava/lang/String;)V

    :cond_105
    :goto_105
    return-void
.end method

.method private fail(Landroid/webkit/WebView;IILjava/lang/String;)V
    .locals 1

    .line 57
    invoke-direct {p0, p1, p2}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->current(Landroid/webkit/WebView;I)Z

    move-result p2

    if-nez p2, :cond_7

    return-void

    :cond_7
    const/4 p2, 0x0

    iput-boolean p2, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->inFlight:Z

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "window.MoaSyncMailbox&&window.MoaSyncMailbox.complete("

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string p3, ",false,"

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

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

    invoke-static {p2}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->guarded(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    const/4 p3, 0x0

    invoke-virtual {p1, p2, p3}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    return-void
.end method

.method private static find(Landroid/view/View;)Landroid/webkit/WebView;
    .locals 2

    .line 50
    instance-of v0, p0, Landroid/webkit/WebView;

    if-eqz v0, :cond_e

    move-object v0, p0

    check-cast v0, Landroid/webkit/WebView;

    invoke-static {v0}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->trusted(Landroid/webkit/WebView;)Z

    move-result v1

    if-eqz v1, :cond_e

    return-object v0

    :cond_e
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_29

    check-cast p0, Landroid/view/ViewGroup;

    const/4 v0, 0x0

    :goto_15
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    if-ge v0, v1, :cond_29

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    invoke-static {v1}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->find(Landroid/view/View;)Landroid/webkit/WebView;

    move-result-object v1

    if-eqz v1, :cond_26

    return-object v1

    :cond_26
    add-int/lit8 v0, v0, 0x1

    goto :goto_15

    :cond_29
    const/4 p0, 0x0

    return-object p0
.end method

.method private static guarded(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 51
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "if(location.origin===\'https://familyjourney.local\' && [\'/\',\'/index.html\',\'/web/index.html\'].includes(location.pathname)){"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v0, "}"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private invoke(Lcom/juhyeon/familyjournea/MoaPinnedTransport;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/String;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 60
    invoke-virtual {p2}, Ljava/lang/String;->hashCode()I

    move-result v0

    sparse-switch v0, :sswitch_data_ba

    :cond_7
    goto :goto_4e

    :sswitch_8
    const-string v0, "importVoice"

    invoke-virtual {p2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_7

    const/4 p2, 0x2

    goto :goto_4f

    :sswitch_12
    const-string v0, "importMedia"

    invoke-virtual {p2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_7

    const/4 p2, 0x6

    goto :goto_4f

    :sswitch_1c
    const-string v0, "push"

    invoke-virtual {p2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_7

    const/4 p2, 0x3

    goto :goto_4f

    :sswitch_26
    const-string v0, "pull"

    invoke-virtual {p2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_7

    const/4 p2, 0x4

    goto :goto_4f

    :sswitch_30
    const-string v0, "listVoice"

    invoke-virtual {p2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_7

    const/4 p2, 0x0

    goto :goto_4f

    :sswitch_3a
    const-string v0, "exportVoice"

    invoke-virtual {p2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_7

    const/4 p2, 0x1

    goto :goto_4f

    :sswitch_44
    const-string v0, "exportMedia"

    invoke-virtual {p2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_7

    const/4 p2, 0x5

    goto :goto_4f

    :goto_4e
    const/4 p2, -0x1

    :goto_4f
    packed-switch p2, :pswitch_data_d8

    new-instance p1, Ljava/lang/SecurityException;

    const-string p2, "Unknown command"

    invoke-direct {p1, p2}, Ljava/lang/SecurityException;-><init>(Ljava/lang/String;)V

    throw p1

    :pswitch_5a
    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->getContext()Landroid/content/Context;

    move-result-object p2

    check-cast p3, Lorg/json/JSONObject;

    invoke-static {p2, p1, p3}, Lcom/juhyeon/familyjournea/MoaMediaSync;->importMedia(Landroid/content/Context;Lcom/juhyeon/familyjournea/MoaPinnedTransport;Lorg/json/JSONObject;)Lorg/json/JSONObject;

    move-result-object p1

    invoke-virtual {p1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p1

    return-object p1

    :pswitch_69
    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->getContext()Landroid/content/Context;

    move-result-object p2

    check-cast p3, Lorg/json/JSONObject;

    invoke-static {p2, p1, p3}, Lcom/juhyeon/familyjournea/MoaMediaSync;->exportMedia(Landroid/content/Context;Lcom/juhyeon/familyjournea/MoaPinnedTransport;Lorg/json/JSONObject;)Lorg/json/JSONObject;

    move-result-object p1

    invoke-virtual {p1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p1

    return-object p1

    :pswitch_78
    check-cast p3, Ljava/lang/Number;

    invoke-virtual {p3}, Ljava/lang/Number;->longValue()J

    move-result-wide p2

    invoke-virtual {p1, p2, p3}, Lcom/juhyeon/familyjournea/MoaPinnedTransport;->pullRecords(J)Ljava/lang/String;

    move-result-object p1

    return-object p1

    :pswitch_83
    check-cast p3, Lorg/json/JSONObject;

    invoke-virtual {p3}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Lcom/juhyeon/familyjournea/MoaPinnedTransport;->pushRecord(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    :pswitch_8e
    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->getContext()Landroid/content/Context;

    move-result-object p2

    check-cast p3, Lorg/json/JSONObject;

    invoke-static {p2, p1, p3}, Lcom/juhyeon/familyjournea/MoaVoiceSync;->receive(Landroid/content/Context;Lcom/juhyeon/familyjournea/MoaPinnedTransport;Lorg/json/JSONObject;)Lorg/json/JSONObject;

    move-result-object p1

    invoke-virtual {p1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p1

    return-object p1

    :pswitch_9d
    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->getContext()Landroid/content/Context;

    move-result-object p2

    check-cast p3, Lorg/json/JSONObject;

    invoke-static {p2, p1, p3}, Lcom/juhyeon/familyjournea/MoaVoiceSync;->send(Landroid/content/Context;Lcom/juhyeon/familyjournea/MoaPinnedTransport;Lorg/json/JSONObject;)Lorg/json/JSONObject;

    move-result-object p1

    invoke-virtual {p1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p1

    return-object p1

    :pswitch_ac
    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/juhyeon/familyjournea/MoaVoiceSync;->list(Landroid/content/Context;)Lorg/json/JSONObject;

    move-result-object p1

    invoke-virtual {p1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p1

    return-object p1

    nop

    :sswitch_data_ba
    .sparse-switch
        -0x7de06370 -> :sswitch_44
        -0x7d5cf222 -> :sswitch_3a
        -0x49770ccc -> :sswitch_30
        0x34ae45 -> :sswitch_26
        0x34af1a -> :sswitch_1c
        0x568a8b3f -> :sswitch_12
        0x570dfc8d -> :sswitch_8
    .end sparse-switch

    :pswitch_data_d8
    .packed-switch 0x0
        :pswitch_ac
        :pswitch_9d
        :pswitch_8e
        :pswitch_83
        :pswitch_78
        :pswitch_69
        :pswitch_5a
    .end packed-switch
.end method

.method private static key()Ljavax/crypto/SecretKey;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 45
    const-string v0, "AndroidKeyStore"

    invoke-static {v0}, Ljava/security/KeyStore;->getInstance(Ljava/lang/String;)Ljava/security/KeyStore;

    move-result-object v1

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Ljava/security/KeyStore;->load(Ljava/security/KeyStore$LoadStoreParameter;)V

    const-string v3, "moa.r711.sync.pair.v1"

    invoke-virtual {v1, v3, v2}, Ljava/security/KeyStore;->getKey(Ljava/lang/String;[C)Ljava/security/Key;

    move-result-object v1

    instance-of v2, v1, Ljavax/crypto/SecretKey;

    if-eqz v2, :cond_17

    check-cast v1, Ljavax/crypto/SecretKey;

    return-object v1

    :cond_17
    const-string v1, "AES"

    invoke-static {v1, v0}, Ljavax/crypto/KeyGenerator;->getInstance(Ljava/lang/String;Ljava/lang/String;)Ljavax/crypto/KeyGenerator;

    move-result-object v0

    new-instance v1, Landroid/security/keystore/KeyGenParameterSpec$Builder;

    const/4 v2, 0x3

    invoke-direct {v1, v3, v2}, Landroid/security/keystore/KeyGenParameterSpec$Builder;-><init>(Ljava/lang/String;I)V

    const-string v2, "GCM"

    filled-new-array {v2}, [Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setBlockModes([Ljava/lang/String;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v1

    const-string v2, "NoPadding"

    filled-new-array {v2}, [Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setEncryptionPaddings([Ljava/lang/String;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v1

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setRandomizedEncryptionRequired(Z)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v1

    invoke-virtual {v1}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->build()Landroid/security/keystore/KeyGenParameterSpec;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljavax/crypto/KeyGenerator;->init(Ljava/security/spec/AlgorithmParameterSpec;)V

    invoke-virtual {v0}, Ljavax/crypto/KeyGenerator;->generateKey()Ljavax/crypto/SecretKey;

    move-result-object v0

    return-object v0
.end method

.method private static load(Landroid/content/Context;)Lorg/json/JSONObject;
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 47
    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "pair"

    const/4 v1, 0x0

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    if-nez p0, :cond_e

    return-object v1

    :cond_e
    const-string v0, ":"

    const/4 v1, -0x1

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object p0

    array-length v0, p0

    const/4 v1, 0x2

    if-ne v0, v1, :cond_4c

    const-string v0, "AES/GCM/NoPadding"

    invoke-static {v0}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;

    move-result-object v0

    invoke-static {}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->key()Ljavax/crypto/SecretKey;

    move-result-object v2

    new-instance v3, Ljavax/crypto/spec/GCMParameterSpec;

    const/4 v4, 0x0

    aget-object v4, p0, v4

    invoke-static {v4, v1}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object v4

    const/16 v5, 0x80

    invoke-direct {v3, v5, v4}, Ljavax/crypto/spec/GCMParameterSpec;-><init>(I[B)V

    invoke-virtual {v0, v1, v2, v3}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;Ljava/security/spec/AlgorithmParameterSpec;)V

    new-instance v2, Lorg/json/JSONObject;

    new-instance v3, Ljava/lang/String;

    const/4 v4, 0x1

    aget-object p0, p0, v4

    invoke-static {p0, v1}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object p0

    invoke-virtual {v0, p0}, Ljavax/crypto/Cipher;->doFinal([B)[B

    move-result-object p0

    sget-object v0, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v3, p0, v0}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-direct {v2, v3}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    return-object v2

    :cond_4c
    new-instance p0, Ljava/lang/SecurityException;

    const-string v0, "Invalid pair envelope"

    invoke-direct {p0, v0}, Ljava/lang/SecurityException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private pair(Landroid/webkit/WebView;II)V
    .locals 9

    .line 61
    iget-object v3, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->active:Landroid/app/Activity;

    if-nez v3, :cond_5

    return-void

    :cond_5
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->dialog:Z

    new-instance v2, Landroid/widget/EditText;

    invoke-direct {v2, v3}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    const-string v0, "PC \uc5f0\uacb0 \uc815\ubcf4 JSON \ubd99\uc5ec\ub123\uae30"

    invoke-virtual {v2, v0}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V

    const/4 v0, 0x0

    invoke-virtual {v2, v0}, Landroid/widget/EditText;->setSingleLine(Z)V

    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, v3}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v1, "\ubaa8\uc544 PC \uc5f0\uacb0"

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    const-string v1, "PC \uc5f0\ub3d9 \uba54\ub274\uc758 \uc5f0\uacb0 \uc815\ubcf4\ub97c \ubcf5\uc0ac\ud574 \ubd99\uc5ec\ub123\uc73c\uc138\uc694. \uc5f0\uacb0 \ub4a4\uc5d0\ub294 \uac19\uc740 Wi-Fi\uc5d0\uc11c \uc790\ub3d9 \uc7ac\uc5f0\uacb0\uc744 \uc2dc\ub3c4\ud569\ub2c8\ub2e4."

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;

    move-result-object v7

    new-instance v8, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda6;

    move-object v0, v8

    move-object v1, p0

    move-object v4, p1

    move v5, p2

    move v6, p3

    invoke-direct/range {v0 .. v6}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda6;-><init>(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;Landroid/widget/EditText;Landroid/app/Activity;Landroid/webkit/WebView;II)V

    const-string v0, "\uc5f0\uacb0"

    invoke-virtual {v7, v0, v8}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda7;

    invoke-direct {v1, p0, p1, p2, p3}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda7;-><init>(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;Landroid/webkit/WebView;II)V

    const-string v2, "\ucde8\uc18c"

    invoke-virtual {v0, v2, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda8;

    invoke-direct {v1, p0, p1, p2, p3}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda8;-><init>(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;Landroid/webkit/WebView;II)V

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setOnCancelListener(Landroid/content/DialogInterface$OnCancelListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    return-void
.end method

.method private static prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 46
    const-string v0, "moa_sync_pair_private_v1"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method private static store(Landroid/content/Context;Lorg/json/JSONObject;)V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 48
    const-string v0, "AES/GCM/NoPadding"

    invoke-static {v0}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;

    move-result-object v0

    const/4 v1, 0x1

    invoke-static {}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->key()Ljavax/crypto/SecretKey;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;)V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0}, Ljavax/crypto/Cipher;->getIV()[B

    move-result-object v2

    const/4 v3, 0x2

    invoke-static {v2, v3}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ":"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p1

    sget-object v2, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, v2}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    invoke-virtual {v0, p1}, Ljavax/crypto/Cipher;->doFinal([B)[B

    move-result-object p1

    invoke-static {p1, v3}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "pair"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    move-result p0

    if-eqz p0, :cond_55

    return-void

    :cond_55
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "Pair save failed"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static transport(Lorg/json/JSONObject;)Lcom/juhyeon/familyjournea/MoaPinnedTransport;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 59
    new-instance v0, Lcom/juhyeon/familyjournea/MoaPinnedTransport;

    const-string v1, "url"

    invoke-virtual {p0, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "pin"

    invoke-virtual {p0, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const-string v3, "token"

    invoke-virtual {p0, v3}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, v1, v2, p0}, Lcom/juhyeon/familyjournea/MoaPinnedTransport;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-object v0
.end method

.method private static trusted(Landroid/webkit/WebView;)Z
    .locals 4

    .line 49
    const/4 v0, 0x0

    :try_start_1
    new-instance v1, Ljava/net/URI;

    invoke-virtual {p0}, Landroid/webkit/WebView;->getUrl()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v1, p0}, Ljava/net/URI;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/net/URI;->getPath()Ljava/lang/String;

    move-result-object p0

    const-string v2, "https"

    invoke-virtual {v1}, Ljava/net/URI;->getScheme()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_54

    const-string v2, "familyjourney.local"

    invoke-virtual {v1}, Ljava/net/URI;->getHost()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_54

    invoke-virtual {v1}, Ljava/net/URI;->getPort()I

    move-result v2

    const/4 v3, -0x1

    if-eq v2, v3, :cond_35

    invoke-virtual {v1}, Ljava/net/URI;->getPort()I

    move-result v2

    const/16 v3, 0x1bb

    if-ne v2, v3, :cond_54

    :cond_35
    invoke-virtual {v1}, Ljava/net/URI;->getUserInfo()Ljava/lang/String;

    move-result-object v1

    if-nez v1, :cond_54

    const-string v1, "/"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_53

    const-string v1, "/index.html"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_53

    const-string v1, "/web/index.html"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0
    :try_end_51
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_51} :catch_55

    if-eqz p0, :cond_54

    :cond_53
    const/4 v0, 0x1

    :cond_54
    return v0

    :catch_55
    move-exception p0

    return v0
.end method


# virtual methods
.method public delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 0

    .line 63
    const/4 p1, 0x0

    return p1
.end method

.method public getType(Landroid/net/Uri;)Ljava/lang/String;
    .locals 0

    .line 63
    const/4 p1, 0x0

    return-object p1
.end method

.method public insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;
    .locals 0

    .line 63
    const/4 p1, 0x0

    return-object p1
.end method

.method synthetic lambda$dispatch$0$com-juhyeon-familyjournea-MoaR711SyncProvider(Landroid/webkit/WebView;IILorg/json/JSONObject;)V
    .locals 6

    .line 58
    const/4 v4, 0x1

    move-object v0, p0

    move-object v1, p1

    move v2, p2

    move v3, p3

    move-object v5, p4

    invoke-direct/range {v0 .. v5}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->complete(Landroid/webkit/WebView;IIZLjava/lang/Object;)V

    return-void
.end method

.method synthetic lambda$dispatch$1$com-juhyeon-familyjournea-MoaR711SyncProvider(Landroid/webkit/WebView;II)V
    .locals 1

    .line 58
    const-string v0, "PC \uc5f0\uacb0 \ub610\ub294 \uc804\uc1a1 \uc2e4\ud328"

    invoke-direct {p0, p1, p2, p3, v0}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->fail(Landroid/webkit/WebView;IILjava/lang/String;)V

    return-void
.end method

.method synthetic lambda$dispatch$2$com-juhyeon-familyjournea-MoaR711SyncProvider(Lorg/json/JSONObject;Ljava/lang/String;Ljava/lang/Object;Landroid/webkit/WebView;II)V
    .locals 6

    .line 58
    :try_start_0
    invoke-static {p1}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->transport(Lorg/json/JSONObject;)Lcom/juhyeon/familyjournea/MoaPinnedTransport;

    move-result-object v0

    invoke-direct {p0, v0, p2, p3}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->invoke(Lcom/juhyeon/familyjournea/MoaPinnedTransport;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1
    :try_end_8
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_8} :catch_b
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_8} :catch_9

    goto :goto_2f

    :catch_9
    move-exception p1

    goto :goto_44

    :catch_b
    move-exception v0

    :try_start_c
    const-string v0, "255.255.255.255"

    invoke-static {v0}, Ljava/net/InetAddress;->getByName(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object v0

    const-string v1, "token"

    invoke-virtual {p1, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "pin"

    invoke-virtual {p1, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v1, v2}, Lcom/juhyeon/familyjournea/MoaDiscovery;->find(Ljava/net/InetAddress;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "url"

    invoke-virtual {p1, v1, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    invoke-static {p1}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->transport(Lorg/json/JSONObject;)Lcom/juhyeon/familyjournea/MoaPinnedTransport;

    move-result-object p1

    invoke-direct {p0, p1, p2, p3}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->invoke(Lcom/juhyeon/familyjournea/MoaPinnedTransport;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    :goto_2f
    new-instance v5, Lorg/json/JSONObject;

    invoke-direct {v5, p1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->main:Landroid/os/Handler;

    new-instance p2, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda0;

    move-object v0, p2

    move-object v1, p0

    move-object v2, p4

    move v3, p5

    move v4, p6

    invoke-direct/range {v0 .. v5}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda0;-><init>(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;Landroid/webkit/WebView;IILorg/json/JSONObject;)V

    invoke-virtual {p1, p2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_43
    .catch Ljava/lang/Exception; {:try_start_c .. :try_end_43} :catch_9

    goto :goto_4e

    :goto_44
    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->main:Landroid/os/Handler;

    new-instance p2, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda1;

    invoke-direct {p2, p0, p4, p5, p6}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda1;-><init>(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;Landroid/webkit/WebView;II)V

    invoke-virtual {p1, p2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :goto_4e
    return-void
.end method

.method synthetic lambda$pair$3$com-juhyeon-familyjournea-MoaR711SyncProvider(Lorg/json/JSONObject;Landroid/webkit/WebView;II)V
    .locals 6

    .line 61
    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->config:Lorg/json/JSONObject;

    new-instance v5, Lorg/json/JSONObject;

    invoke-direct {v5}, Lorg/json/JSONObject;-><init>()V

    const/4 v4, 0x1

    move-object v0, p0

    move-object v1, p2

    move v2, p3

    move v3, p4

    invoke-direct/range {v0 .. v5}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->complete(Landroid/webkit/WebView;IIZLjava/lang/Object;)V

    return-void
.end method

.method synthetic lambda$pair$4$com-juhyeon-familyjournea-MoaR711SyncProvider(Landroid/webkit/WebView;II)V
    .locals 1

    .line 61
    const-string v0, "\uc5f0\uacb0 \ud655\uc778 \uc2e4\ud328"

    invoke-direct {p0, p1, p2, p3, v0}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->fail(Landroid/webkit/WebView;IILjava/lang/String;)V

    return-void
.end method

.method synthetic lambda$pair$5$com-juhyeon-familyjournea-MoaR711SyncProvider(Lorg/json/JSONObject;Landroid/app/Activity;Landroid/webkit/WebView;II)V
    .locals 7

    .line 61
    :try_start_0
    invoke-static {p1}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->transport(Lorg/json/JSONObject;)Lcom/juhyeon/familyjournea/MoaPinnedTransport;

    move-result-object v0

    const-wide/16 v1, 0x0

    invoke-virtual {v0, v1, v2}, Lcom/juhyeon/familyjournea/MoaPinnedTransport;->pullRecords(J)Ljava/lang/String;

    invoke-virtual {p2}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object p2

    invoke-static {p2, p1}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->store(Landroid/content/Context;Lorg/json/JSONObject;)V

    iget-object p2, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->main:Landroid/os/Handler;

    new-instance v6, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda4;

    move-object v0, v6

    move-object v1, p0

    move-object v2, p1

    move-object v3, p3

    move v4, p4

    move v5, p5

    invoke-direct/range {v0 .. v5}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda4;-><init>(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;Lorg/json/JSONObject;Landroid/webkit/WebView;II)V

    invoke-virtual {p2, v6}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_20
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_20} :catch_21

    goto :goto_2c

    :catch_21
    move-exception p1

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->main:Landroid/os/Handler;

    new-instance p2, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda5;

    invoke-direct {p2, p0, p3, p4, p5}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda5;-><init>(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;Landroid/webkit/WebView;II)V

    invoke-virtual {p1, p2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :goto_2c
    return-void
.end method

.method synthetic lambda$pair$6$com-juhyeon-familyjournea-MoaR711SyncProvider(Landroid/widget/EditText;Landroid/app/Activity;Landroid/webkit/WebView;IILandroid/content/DialogInterface;I)V
    .locals 7

    .line 61
    const/4 p6, 0x0

    iput-boolean p6, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->dialog:Z

    :try_start_3
    new-instance v2, Lorg/json/JSONObject;

    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v2, p1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    invoke-static {v2}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->transport(Lorg/json/JSONObject;)Lcom/juhyeon/familyjournea/MoaPinnedTransport;

    const/4 p1, 0x1

    iput-boolean p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->inFlight:Z

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->work:Ljava/util/concurrent/ExecutorService;

    new-instance p6, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda2;

    move-object v0, p6

    move-object v1, p0

    move-object v3, p2

    move-object v4, p3

    move v5, p4

    move v6, p5

    invoke-direct/range {v0 .. v6}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider$$ExternalSyntheticLambda2;-><init>(Lcom/juhyeon/familyjournea/MoaR711SyncProvider;Lorg/json/JSONObject;Landroid/app/Activity;Landroid/webkit/WebView;II)V

    invoke-interface {p1, p6}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V
    :try_end_26
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_26} :catch_27

    goto :goto_2d

    :catch_27
    move-exception p1

    const-string p1, "\uc798\ubabb\ub41c \uc5f0\uacb0 \uc815\ubcf4"

    invoke-direct {p0, p3, p4, p5, p1}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->fail(Landroid/webkit/WebView;IILjava/lang/String;)V

    :goto_2d
    return-void
.end method

.method synthetic lambda$pair$7$com-juhyeon-familyjournea-MoaR711SyncProvider(Landroid/webkit/WebView;IILandroid/content/DialogInterface;I)V
    .locals 0

    .line 61
    const/4 p4, 0x0

    iput-boolean p4, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->dialog:Z

    const-string p4, "\uc5f0\uacb0 \ucde8\uc18c"

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->fail(Landroid/webkit/WebView;IILjava/lang/String;)V

    return-void
.end method

.method synthetic lambda$pair$8$com-juhyeon-familyjournea-MoaR711SyncProvider(Landroid/webkit/WebView;IILandroid/content/DialogInterface;)V
    .locals 0

    .line 61
    const/4 p4, 0x0

    iput-boolean p4, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->dialog:Z

    const-string p4, "\uc5f0\uacb0 \ucde8\uc18c"

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->fail(Landroid/webkit/WebView;IILjava/lang/String;)V

    return-void
.end method

.method public onActivityCreated(Landroid/app/Activity;Landroid/os/Bundle;)V
    .locals 0

    .line 62
    return-void
.end method

.method public onActivityDestroyed(Landroid/app/Activity;)V
    .locals 0

    .line 62
    return-void
.end method

.method public onActivityPaused(Landroid/app/Activity;)V
    .locals 1

    .line 54
    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->active:Landroid/app/Activity;

    if-ne v0, p1, :cond_19

    const/4 p1, 0x0

    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->active:Landroid/app/Activity;

    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->view:Landroid/webkit/WebView;

    iget p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->epoch:I

    add-int/lit8 p1, p1, 0x1

    iput p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->epoch:I

    const/4 p1, 0x0

    iput-boolean p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->inFlight:Z

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->main:Landroid/os/Handler;

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->tick:Ljava/lang/Runnable;

    invoke-virtual {p1, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    :cond_19
    return-void
.end method

.method public onActivityResumed(Landroid/app/Activity;)V
    .locals 3

    .line 53
    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->active:Landroid/app/Activity;

    const/4 p1, 0x0

    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->view:Landroid/webkit/WebView;

    iget p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->epoch:I

    add-int/lit8 p1, p1, 0x1

    iput p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->epoch:I

    const/4 p1, 0x0

    iput-boolean p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->inFlight:Z

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->main:Landroid/os/Handler;

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->tick:Ljava/lang/Runnable;

    invoke-virtual {p1, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->main:Landroid/os/Handler;

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->tick:Ljava/lang/Runnable;

    const-wide/16 v1, 0x190

    invoke-virtual {p1, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method

.method public onActivitySaveInstanceState(Landroid/app/Activity;Landroid/os/Bundle;)V
    .locals 0

    .line 62
    return-void
.end method

.method public onActivityStarted(Landroid/app/Activity;)V
    .locals 0

    .line 62
    return-void
.end method

.method public onActivityStopped(Landroid/app/Activity;)V
    .locals 0

    .line 62
    return-void
.end method

.method public onCreate()Z
    .locals 5

    .line 43
    const-string v0, "\n"

    invoke-virtual {p0}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->getContext()Landroid/content/Context;

    move-result-object v1

    if-nez v1, :cond_a

    const/4 v0, 0x0

    return v0

    :cond_a
    const/4 v2, 0x0

    :try_start_b
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "web/moa-r713-controls.js"

    invoke-static {v1, v4}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->asset(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "web/moa-r711-mailbox.js"

    invoke-static {v1, v4}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->asset(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "web/moa-r711-live-diary.js"

    invoke-static {v1, v4}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->asset(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "web/moa-r711-schedule.js"

    invoke-static {v1, v4}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->asset(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "web/moa-r711-media.js"

    invoke-static {v1, v4}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->asset(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v3, "web/moa-r713-extras.js"

    invoke-static {v1, v3}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->asset(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->scripts:Ljava/lang/String;
    :try_end_66
    .catch Ljava/lang/Exception; {:try_start_b .. :try_end_66} :catch_67

    goto :goto_6a

    :catch_67
    move-exception v0

    iput-object v2, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->scripts:Ljava/lang/String;

    :goto_6a
    :try_start_6a
    invoke-static {v1}, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->load(Landroid/content/Context;)Lorg/json/JSONObject;

    move-result-object v0

    iput-object v0, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->config:Lorg/json/JSONObject;
    :try_end_70
    .catch Ljava/lang/Exception; {:try_start_6a .. :try_end_70} :catch_71

    goto :goto_74

    :catch_71
    move-exception v0

    iput-object v2, p0, Lcom/juhyeon/familyjournea/MoaR711SyncProvider;->config:Lorg/json/JSONObject;

    :goto_74
    invoke-virtual {v1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    instance-of v1, v0, Landroid/app/Application;

    if-eqz v1, :cond_81

    check-cast v0, Landroid/app/Application;

    invoke-virtual {v0, p0}, Landroid/app/Application;->registerActivityLifecycleCallbacks(Landroid/app/Application$ActivityLifecycleCallbacks;)V

    :cond_81
    const/4 v0, 0x1

    return v0
.end method

.method public query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    .locals 0

    .line 63
    const/4 p1, 0x0

    return-object p1
.end method

.method public update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 0

    .line 63
    const/4 p1, 0x0

    return p1
.end method
