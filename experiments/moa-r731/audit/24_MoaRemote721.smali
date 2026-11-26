.class public final Lcom/juhyeon/familyjournea/MoaRemote721;
.super Ljava/lang/Object;
.source "MoaRemote721.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/juhyeon/familyjournea/MoaRemote721$Item;,
        Lcom/juhyeon/familyjournea/MoaRemote721$Client;,
        Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;,
        Lcom/juhyeon/familyjournea/MoaRemote721$Source;
    }
.end annotation


# static fields
.field static final CHUNK:I = 0x100000

.field static final MAX_IMAGE:I = 0x800000

.field static final PAGE:I = 0x20

.field static final PHOTO:Ljava/util/concurrent/ExecutorService;

.field static final PREFIX:Ljava/lang/String; = "/v3/view/"

.field static final WORK:Ljava/util/concurrent/ExecutorService;

.field static volatile clientAllowed:Z

.field static volatile ctx:Landroid/content/Context;

.field static volatile ids:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field static incoming:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field static incomingEpoch:J

.field static incomingOffset:I

.field static volatile lastConsent:J

.field static volatile sharing:Z

.field static volatile voice:Z


# direct methods
.method static constructor <clinit>()V
    .locals 3

    .line 29
    const/4 v0, 0x0

    sput-boolean v0, Lcom/juhyeon/familyjournea/MoaRemote721;->sharing:Z

    sput-boolean v0, Lcom/juhyeon/familyjournea/MoaRemote721;->voice:Z

    sput-boolean v0, Lcom/juhyeon/familyjournea/MoaRemote721;->clientAllowed:Z

    .line 30
    const-wide/16 v1, 0x0

    sput-wide v1, Lcom/juhyeon/familyjournea/MoaRemote721;->lastConsent:J

    .line 31
    invoke-static {}, Ljava/util/Collections;->emptyMap()Ljava/util/Map;

    move-result-object v1

    sput-object v1, Lcom/juhyeon/familyjournea/MoaRemote721;->ids:Ljava/util/Map;

    .line 32
    const/4 v1, 0x2

    invoke-static {v1}, Ljava/util/concurrent/Executors;->newFixedThreadPool(I)Ljava/util/concurrent/ExecutorService;

    move-result-object v1

    sput-object v1, Lcom/juhyeon/familyjournea/MoaRemote721;->WORK:Ljava/util/concurrent/ExecutorService;

    .line 33
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v1

    sput-object v1, Lcom/juhyeon/familyjournea/MoaRemote721;->PHOTO:Ljava/util/concurrent/ExecutorService;

    .line 34
    const-wide/16 v1, -0x1

    sput-wide v1, Lcom/juhyeon/familyjournea/MoaRemote721;->incomingEpoch:J

    sput v0, Lcom/juhyeon/familyjournea/MoaRemote721;->incomingOffset:I

    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    sput-object v0, Lcom/juhyeon/familyjournea/MoaRemote721;->incoming:Ljava/util/Map;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 25
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static audioFile(Ljava/lang/String;)Ljava/io/File;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 67
    sget-boolean v0, Lcom/juhyeon/familyjournea/MoaRemote721;->voice:Z

    if-eqz v0, :cond_64

    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaRemote721;->voiceId(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_64

    const-string v0, ":"

    const/4 v1, 0x3

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object p0

    .line 68
    new-instance v0, Ljava/io/File;

    sget-object v1, Lcom/juhyeon/familyjournea/MoaRemote721;->ctx:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v1

    const-string v2, "moa-original-audio"

    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->getCanonicalFile()Ljava/io/File;

    move-result-object v0

    new-instance v1, Ljava/io/File;

    new-instance v2, Ljava/io/File;

    const/4 v3, 0x1

    aget-object v3, p0, v3

    invoke-direct {v2, v0, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    const/4 v3, 0x2

    aget-object p0, p0, v3

    invoke-direct {v1, v2, p0}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->getCanonicalFile()Ljava/io/File;

    move-result-object p0

    .line 69
    invoke-virtual {p0}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v2, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_5e

    invoke-virtual {p0}, Ljava/io/File;->isFile()Z

    move-result v0

    if-eqz v0, :cond_5e

    return-object p0

    :cond_5e
    new-instance p0, Ljava/io/FileNotFoundException;

    invoke-direct {p0}, Ljava/io/FileNotFoundException;-><init>()V

    throw p0

    .line 67
    :cond_64
    new-instance p0, Ljava/io/FileNotFoundException;

    invoke-direct {p0}, Ljava/io/FileNotFoundException;-><init>()V

    throw p0
.end method

.method static btn(Landroid/app/Activity;Ljava/lang/String;)Landroid/widget/Button;
    .locals 1

    .line 144
    new-instance v0, Landroid/widget/Button;

    invoke-direct {v0, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, p1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 p0, 0x0

    invoke-virtual {v0, p0}, Landroid/widget/Button;->setAllCaps(Z)V

    return-object v0
.end method

.method static catalog(Ljava/lang/String;)Ljava/util/List;
    .locals 13
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 81
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    sget-object v1, Lcom/juhyeon/familyjournea/MoaRemote721;->ids:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_f
    :goto_f
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_35

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/util/Map$Entry;

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_2b

    invoke-interface {v3}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v4

    invoke-virtual {p0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_f

    :cond_2b
    invoke-interface {v3}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_f

    .line 82
    :cond_35
    sget-boolean v2, Lcom/juhyeon/familyjournea/MoaRemote721;->voice:Z

    if-eqz v2, :cond_ba

    new-instance v2, Ljava/io/File;

    sget-object v3, Lcom/juhyeon/familyjournea/MoaRemote721;->ctx:Landroid/content/Context;

    invoke-virtual {v3}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v3

    const-string v4, "moa-original-audio"

    invoke-direct {v2, v3, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v2

    if-eqz v2, :cond_ba

    array-length v3, v2

    const/4 v4, 0x0

    move v5, v4

    :goto_4f
    if-ge v5, v3, :cond_ba

    aget-object v6, v2, v5

    invoke-virtual {v6}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v7

    invoke-static {v7}, Lcom/juhyeon/familyjournea/MoaRemote721;->day(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_b7

    invoke-virtual {v6}, Ljava/io/File;->isDirectory()Z

    move-result v7

    if-eqz v7, :cond_b7

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v7

    if-nez v7, :cond_74

    invoke-virtual {v6}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {p0, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-nez v7, :cond_74

    goto :goto_b7

    :cond_74
    invoke-virtual {v6}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v7

    if-eqz v7, :cond_b7

    array-length v8, v7

    move v9, v4

    :goto_7c
    if-ge v9, v8, :cond_b7

    aget-object v10, v7, v9

    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "a:"

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v6}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    const-string v12, ":"

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v10}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v10}, Ljava/io/File;->isFile()Z

    move-result v10

    if-eqz v10, :cond_b4

    invoke-static {v11}, Lcom/juhyeon/familyjournea/MoaRemote721;->voiceId(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_b4

    invoke-virtual {v0, v11}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_b4
    add-int/lit8 v9, v9, 0x1

    goto :goto_7c

    :cond_b7
    :goto_b7
    add-int/lit8 v5, v5, 0x1

    goto :goto_4f

    .line 83
    :cond_ba
    new-instance p0, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda6;

    invoke-direct {p0, v1}, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda6;-><init>(Ljava/util/Map;)V

    invoke-virtual {v0, p0}, Ljava/util/ArrayList;->sort(Ljava/util/Comparator;)V

    return-object v0
.end method

.method public static clear()V
    .locals 2

    .line 63
    const/4 v0, 0x0

    sput-boolean v0, Lcom/juhyeon/familyjournea/MoaRemote721;->sharing:Z

    sput-boolean v0, Lcom/juhyeon/familyjournea/MoaRemote721;->voice:Z

    sput-boolean v0, Lcom/juhyeon/familyjournea/MoaRemote721;->clientAllowed:Z

    invoke-static {}, Ljava/util/Collections;->emptyMap()Ljava/util/Map;

    move-result-object v0

    sput-object v0, Lcom/juhyeon/familyjournea/MoaRemote721;->ids:Ljava/util/Map;

    const-wide/16 v0, 0x0

    sput-wide v0, Lcom/juhyeon/familyjournea/MoaRemote721;->lastConsent:J

    sget-object v0, Lcom/juhyeon/familyjournea/MoaRemote721;->incoming:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->clear()V

    const-wide/16 v0, -0x1

    sput-wide v0, Lcom/juhyeon/familyjournea/MoaRemote721;->incomingEpoch:J

    return-void
.end method

.method static col(Landroid/app/Activity;)Landroid/widget/LinearLayout;
    .locals 5

    .line 143
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v1, 0xe

    invoke-static {p0, v1}, Lcom/juhyeon/familyjournea/MoaRemote721;->dp(Landroid/app/Activity;I)I

    move-result v2

    const/16 v3, 0x8

    invoke-static {p0, v3}, Lcom/juhyeon/familyjournea/MoaRemote721;->dp(Landroid/app/Activity;I)I

    move-result v4

    invoke-static {p0, v1}, Lcom/juhyeon/familyjournea/MoaRemote721;->dp(Landroid/app/Activity;I)I

    move-result v1

    invoke-static {p0, v3}, Lcom/juhyeon/familyjournea/MoaRemote721;->dp(Landroid/app/Activity;I)I

    move-result p0

    invoke-virtual {v0, v2, v4, v1, p0}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    return-object v0
.end method

.method static data(Ljava/io/OutputStream;ILjava/lang/String;[B)V
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 89
    array-length v0, p3

    int-to-long v3, v0

    const-string v6, ""

    move-object v1, p0

    move v2, p1

    move-object v5, p2

    invoke-static/range {v1 .. v6}, Lcom/juhyeon/familyjournea/MoaRemote721;->header(Ljava/io/OutputStream;IJLjava/lang/String;Ljava/lang/String;)V

    invoke-virtual {p0, p3}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {p0}, Ljava/io/OutputStream;->flush()V

    return-void
.end method

.method static day(Ljava/lang/String;)Z
    .locals 1

    .line 44
    if-eqz p0, :cond_c

    const-string v0, "[0-9]{4}-[0-9]{2}-[0-9]{2}"

    invoke-virtual {p0, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_c

    const/4 p0, 0x1

    goto :goto_d

    :cond_c
    const/4 p0, 0x0

    :goto_d
    return p0
.end method

.method static dp(Landroid/app/Activity;I)I
    .locals 0

    .line 142
    int-to-float p1, p1

    invoke-virtual {p0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    mul-float/2addr p1, p0

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p0

    return p0
.end method

.method static err(Ljava/io/OutputStream;I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 90
    const-string v0, "{\"error\":\"Unavailable\"}"

    sget-object v1, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v0, v1}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v0

    const-string v1, "application/json"

    invoke-static {p0, p1, v1, v0}, Lcom/juhyeon/familyjournea/MoaRemote721;->data(Ljava/io/OutputStream;ILjava/lang/String;[B)V

    return-void
.end method

.method public static failure(Ljava/lang/Throwable;)Ljava/lang/String;
    .locals 4

    .line 36
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\ud5c8\ube0c \uc900\ube44 \uc2e4\ud328 \u00b7 "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const/4 v1, 0x0

    :goto_8
    if-eqz p0, :cond_66

    const/4 v2, 0x3

    if-ge v1, v2, :cond_66

    if-lez v1, :cond_14

    const-string v2, " / "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_14
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_5f

    const-string v3, "Wi-Fi"

    invoke-virtual {v2, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_33

    const-string v2, " (Wi-Fi IPv4 \uc5c6\uc74c)"

    :goto_2f
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_5f

    :cond_33
    const-string v3, "Address already in use"

    invoke-virtual {v2, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_3e

    const-string v2, " (\ud3ec\ud2b8 \uc0ac\uc6a9 \uc911)"

    goto :goto_2f

    :cond_3e
    const-string v3, "\ub3d9\uae30\ud654\uac00 \uc9c4\ud589"

    invoke-virtual {v2, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_49

    const-string v2, " (\uc774\uc804 \uc804\uc1a1 \uc9c4\ud589 \uc911)"

    goto :goto_2f

    :cond_49
    const-string v3, "\uc778\uc99d\uc11c"

    invoke-virtual {v2, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_54

    const-string v2, " (\uae30\uc874 \uc778\uc99d\uc11c \uc5c6\uc74c)"

    goto :goto_2f

    :cond_54
    const-string v3, "\ud0a4 \uc5c6\uc74c"

    invoke-virtual {v2, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_5f

    const-string v2, " (\uae30\uc874 \ud0a4 \uc5c6\uc74c)"

    goto :goto_2f

    :cond_5f
    :goto_5f
    add-int/lit8 v1, v1, 0x1

    invoke-virtual {p0}, Ljava/lang/Throwable;->getCause()Ljava/lang/Throwable;

    move-result-object p0

    goto :goto_8

    :cond_66
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static handle(Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;Ljava/io/OutputStream;)Z
    .locals 12
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Ljava/io/OutputStream;",
            ")Z"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 95
    const-string v0, "/"

    const-string v1, "/v3/view/list?"

    const-string v2, "thumb"

    const-string v3, "/v1/blob/"

    invoke-virtual {p0, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    const/16 v4, 0x193

    const/4 v5, 0x1

    if-eqz v3, :cond_15

    invoke-static {p3, v4}, Lcom/juhyeon/familyjournea/MoaRemote721;->err(Ljava/io/OutputStream;I)V

    return v5

    .line 96
    :cond_15
    const-string v3, "/v3/view/"

    invoke-virtual {p0, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    const/4 v7, 0x0

    if-nez v6, :cond_1f

    return v7

    .line 97
    :cond_1f
    invoke-static {}, Lcom/juhyeon/familyjournea/MoaRemote721;->live()Z

    move-result v6

    if-nez v6, :cond_29

    invoke-static {p3, v4}, Lcom/juhyeon/familyjournea/MoaRemote721;->err(Ljava/io/OutputStream;I)V

    return v5

    .line 98
    :cond_29
    const-string v6, "GET"

    invoke-virtual {v6, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_37

    const/16 p0, 0x195

    invoke-static {p3, p0}, Lcom/juhyeon/familyjournea/MoaRemote721;->err(Ljava/io/OutputStream;I)V

    return v5

    .line 100
    :cond_37
    const/16 p1, 0x194

    :try_start_39
    invoke-virtual {p0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    const/16 v8, 0xc8

    const/4 v9, 0x2

    if-eqz v6, :cond_db

    .line 101
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result p2

    invoke-virtual {p0, p2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    const-string p2, "offset=[0-9]{1,6}(&day=[0-9]{4}-[0-9]{2}-[0-9]{2})?"

    invoke-virtual {p0, p2}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p2

    if-nez p2, :cond_58

    const/16 p0, 0x190

    invoke-static {p3, p0}, Lcom/juhyeon/familyjournea/MoaRemote721;->err(Ljava/io/OutputStream;I)V

    return v5

    .line 102
    :cond_58
    const-string p2, "&"

    invoke-virtual {p0, p2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    aget-object p2, p0, v7

    const/4 v0, 0x7

    invoke-virtual {p2, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p2

    invoke-static {p2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p2

    array-length v0, p0

    if-ne v0, v9, :cond_74

    aget-object p0, p0, v5

    const/4 v0, 0x4

    invoke-virtual {p0, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    goto :goto_76

    :cond_74
    const-string p0, ""

    :goto_76
    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaRemote721;->catalog(Ljava/lang/String;)Ljava/util/List;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v0

    if-le p2, v0, :cond_86

    const/16 p0, 0x199

    invoke-static {p3, p0}, Lcom/juhyeon/familyjournea/MoaRemote721;->err(Ljava/io/OutputStream;I)V

    return v5

    :cond_86
    new-instance v0, Lorg/json/JSONArray;

    invoke-direct {v0}, Lorg/json/JSONArray;-><init>()V

    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v1

    add-int/lit8 v2, p2, 0x20

    invoke-static {v1, v2}, Ljava/lang/Math;->min(II)I

    move-result v1
    :try_end_95
    .catch Ljava/lang/Exception; {:try_start_39 .. :try_end_95} :catch_2c0

    :goto_95
    if-ge p2, v1, :cond_ad

    :try_start_97
    invoke-interface {p0, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-static {v2}, Lcom/juhyeon/familyjournea/MoaRemote721;->item(Ljava/lang/String;)Lcom/juhyeon/familyjournea/MoaRemote721$Item;

    move-result-object v2

    invoke-virtual {v2}, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->json()Lorg/json/JSONObject;

    move-result-object v2

    invoke-virtual {v0, v2}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;
    :try_end_a8
    .catch Ljava/lang/Exception; {:try_start_97 .. :try_end_a8} :catch_a9

    goto :goto_aa

    :catch_a9
    move-exception v2

    :goto_aa
    add-int/lit8 p2, p2, 0x1

    goto :goto_95

    .line 103
    :cond_ad
    :try_start_ad
    const-string p2, "application/json"

    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V

    const-string v3, "items"

    invoke-virtual {v2, v3, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v2, "next"

    invoke-virtual {v0, v2, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    move-result-object v0

    const-string v2, "more"

    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result p0

    if-ge v1, p0, :cond_c9

    move v7, v5

    :cond_c9
    invoke-virtual {v0, v2, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    move-result-object p0

    invoke-virtual {p0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p0

    sget-object v0, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p0, v0}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p0

    invoke-static {p3, v8, p2, p0}, Lcom/juhyeon/familyjournea/MoaRemote721;->data(Ljava/io/OutputStream;ILjava/lang/String;[B)V

    return v5

    .line 105
    :cond_db
    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v1

    invoke-virtual {p0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    const/4 v1, -0x1

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object p0

    array-length v1, p0

    if-eq v1, v9, :cond_ef

    invoke-static {p3, p1}, Lcom/juhyeon/familyjournea/MoaRemote721;->err(Ljava/io/OutputStream;I)V

    return v5

    :cond_ef
    aget-object v1, p0, v5

    invoke-static {v1}, Lcom/juhyeon/familyjournea/MoaRemote721;->item(Ljava/lang/String;)Lcom/juhyeon/familyjournea/MoaRemote721$Item;

    move-result-object v1

    .line 106
    aget-object v3, p0, v7

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3
    :try_end_fb
    .catch Ljava/lang/Exception; {:try_start_ad .. :try_end_fb} :catch_2c0

    const-string v6, "image/"

    const-string v9, "image"

    if-nez v3, :cond_21f

    :try_start_101
    aget-object v3, p0, v7

    invoke-virtual {v9, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_10b

    goto/16 :goto_21f

    .line 113
    :cond_10b
    const-string v2, "raw"

    aget-object p0, p0, v7

    invoke-virtual {v2, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_21b

    iget-object p0, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->mime:Ljava/lang/String;

    invoke-virtual {p0, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_11f

    goto/16 :goto_21b

    .line 114
    :cond_11f
    const-string p0, "range"

    invoke-interface {p2, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    iget-wide v2, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->size:J

    invoke-static {p0, v2, v3}, Lcom/juhyeon/familyjournea/MoaRemote721;->range(Ljava/lang/String;J)[J

    move-result-object p0

    if-nez p0, :cond_135

    const/16 p0, 0x1a0

    invoke-static {p3, p0}, Lcom/juhyeon/familyjournea/MoaRemote721;->err(Ljava/io/OutputStream;I)V

    return v5

    .line 115
    :cond_135
    aget-wide v2, p0, v5

    aget-wide v8, p0, v7

    sub-long/2addr v2, v8

    const-wide/16 v8, 0x1

    add-long/2addr v2, v8

    long-to-int p2, v2

    new-array v2, p2, [B

    .line 116
    iget-object v3, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->id:Ljava/lang/String;

    invoke-static {v3}, Lcom/juhyeon/familyjournea/MoaRemote721;->voiceId(Ljava/lang/String;)Z

    move-result v3
    :try_end_146
    .catch Ljava/lang/Exception; {:try_start_101 .. :try_end_146} :catch_2c0

    const-string v6, "r"

    if-eqz v3, :cond_17d

    :try_start_14a
    new-instance v3, Ljava/io/RandomAccessFile;

    iget-object v8, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->id:Ljava/lang/String;

    invoke-static {v8}, Lcom/juhyeon/familyjournea/MoaRemote721;->audioFile(Ljava/lang/String;)Ljava/io/File;

    move-result-object v8

    invoke-direct {v3, v8, v6}, Ljava/io/RandomAccessFile;-><init>(Ljava/io/File;Ljava/lang/String;)V
    :try_end_155
    .catch Ljava/lang/Exception; {:try_start_14a .. :try_end_155} :catch_2c0

    :try_start_155
    invoke-virtual {v3}, Ljava/io/RandomAccessFile;->length()J

    move-result-wide v8

    iget-wide v10, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->size:J

    cmp-long v6, v8, v10

    if-nez v6, :cond_16b

    aget-wide v8, p0, v7

    invoke-virtual {v3, v8, v9}, Ljava/io/RandomAccessFile;->seek(J)V

    invoke-virtual {v3, v2}, Ljava/io/RandomAccessFile;->readFully([B)V
    :try_end_167
    .catchall {:try_start_155 .. :try_end_167} :catchall_173

    :try_start_167
    invoke-virtual {v3}, Ljava/io/RandomAccessFile;->close()V
    :try_end_16a
    .catch Ljava/lang/Exception; {:try_start_167 .. :try_end_16a} :catch_2c0

    goto :goto_1b1

    :cond_16b
    :try_start_16b
    new-instance p0, Ljava/io/IOException;

    const-string p2, "Source changed"

    invoke-direct {p0, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_173
    .catchall {:try_start_16b .. :try_end_173} :catchall_173

    :catchall_173
    move-exception p0

    :try_start_174
    invoke-virtual {v3}, Ljava/io/RandomAccessFile;->close()V
    :try_end_177
    .catchall {:try_start_174 .. :try_end_177} :catchall_178

    goto :goto_17c

    :catchall_178
    move-exception p2

    :try_start_179
    invoke-virtual {p0, p2}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_17c
    throw p0

    .line 117
    :cond_17d
    sget-object v3, Lcom/juhyeon/familyjournea/MoaRemote721;->ctx:Landroid/content/Context;

    invoke-virtual {v3}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    iget-object v8, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->id:Ljava/lang/String;

    invoke-static {v8}, Lcom/juhyeon/familyjournea/MoaRemote721;->uri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v8

    invoke-virtual {v3, v8, v6}, Landroid/content/ContentResolver;->openFileDescriptor(Landroid/net/Uri;Ljava/lang/String;)Landroid/os/ParcelFileDescriptor;

    move-result-object v3
    :try_end_18d
    .catch Ljava/lang/Exception; {:try_start_179 .. :try_end_18d} :catch_2c0

    if-eqz v3, :cond_208

    :try_start_18f
    new-instance v6, Ljava/io/FileInputStream;

    invoke-virtual {v3}, Landroid/os/ParcelFileDescriptor;->getFileDescriptor()Ljava/io/FileDescriptor;

    move-result-object v8

    invoke-direct {v6, v8}, Ljava/io/FileInputStream;-><init>(Ljava/io/FileDescriptor;)V
    :try_end_198
    .catchall {:try_start_18f .. :try_end_198} :catchall_206

    :try_start_198
    invoke-virtual {v6}, Ljava/io/FileInputStream;->getChannel()Ljava/nio/channels/FileChannel;

    move-result-object v8

    aget-wide v9, p0, v7

    invoke-virtual {v8, v9, v10}, Ljava/nio/channels/FileChannel;->position(J)Ljava/nio/channels/FileChannel;

    new-instance v8, Ljava/io/DataInputStream;

    invoke-direct {v8, v6}, Ljava/io/DataInputStream;-><init>(Ljava/io/InputStream;)V

    invoke-virtual {v8, v2}, Ljava/io/DataInputStream;->readFully([B)V
    :try_end_1a9
    .catchall {:try_start_198 .. :try_end_1a9} :catchall_1fc

    :try_start_1a9
    invoke-virtual {v6}, Ljava/io/FileInputStream;->close()V
    :try_end_1ac
    .catchall {:try_start_1a9 .. :try_end_1ac} :catchall_206

    if-eqz v3, :cond_1b1

    :try_start_1ae
    invoke-virtual {v3}, Landroid/os/ParcelFileDescriptor;->close()V

    .line 118
    :cond_1b1
    :goto_1b1
    invoke-static {}, Lcom/juhyeon/familyjournea/MoaRemote721;->live()Z

    move-result v3

    if-nez v3, :cond_1bb

    invoke-static {p3, v4}, Lcom/juhyeon/familyjournea/MoaRemote721;->err(Ljava/io/OutputStream;I)V

    return v5

    .line 119
    :cond_1bb
    int-to-long v8, p2

    iget-object v10, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->mime:Ljava/lang/String;

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Accept-Ranges: bytes\r\nContent-Range: bytes "

    invoke-virtual {p2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    aget-wide v3, p0, v7

    invoke-virtual {p2, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v3, "-"

    invoke-virtual {p2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    aget-wide v3, p0, v5

    invoke-virtual {p2, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    iget-wide v0, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->size:J

    invoke-virtual {p0, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p2, "\r\n"

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    const/16 v7, 0xce

    move-object v6, p3

    invoke-static/range {v6 .. v11}, Lcom/juhyeon/familyjournea/MoaRemote721;->header(Ljava/io/OutputStream;IJLjava/lang/String;Ljava/lang/String;)V

    invoke-virtual {p3, v2}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {p3}, Ljava/io/OutputStream;->flush()V
    :try_end_1fb
    .catch Ljava/lang/Exception; {:try_start_1ae .. :try_end_1fb} :catch_2c0

    return v5

    .line 117
    :catchall_1fc
    move-exception p0

    :try_start_1fd
    invoke-virtual {v6}, Ljava/io/FileInputStream;->close()V
    :try_end_200
    .catchall {:try_start_1fd .. :try_end_200} :catchall_201

    goto :goto_205

    :catchall_201
    move-exception p2

    :try_start_202
    invoke-virtual {p0, p2}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_205
    throw p0

    :catchall_206
    move-exception p0

    goto :goto_210

    :cond_208
    new-instance p0, Ljava/io/IOException;

    const-string p2, "Missing"

    invoke-direct {p0, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V
    :try_end_20f
    .catchall {:try_start_202 .. :try_end_20f} :catchall_206

    goto :goto_205

    :goto_210
    if-eqz v3, :cond_21a

    :try_start_212
    invoke-virtual {v3}, Landroid/os/ParcelFileDescriptor;->close()V
    :try_end_215
    .catchall {:try_start_212 .. :try_end_215} :catchall_216

    goto :goto_21a

    :catchall_216
    move-exception p2

    :try_start_217
    invoke-virtual {p0, p2}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_21a
    :goto_21a
    throw p0

    .line 113
    :cond_21b
    :goto_21b
    invoke-static {p3, p1}, Lcom/juhyeon/familyjournea/MoaRemote721;->err(Ljava/io/OutputStream;I)V

    return v5

    .line 107
    :cond_21f
    :goto_21f
    iget-object p2, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->mime:Ljava/lang/String;

    const-string v0, "audio/"

    invoke-virtual {p2, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p2

    if-nez p2, :cond_2bc

    aget-object p2, p0, v7

    invoke-virtual {v9, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_23b

    iget-object p2, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->mime:Ljava/lang/String;

    invoke-virtual {p2, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p2

    if-nez p2, :cond_23b

    goto/16 :goto_2bc

    .line 108
    :cond_23b
    aget-object p2, p0, v7

    invoke-virtual {v2, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_25c

    sget-object p2, Lcom/juhyeon/familyjournea/MoaRemote721;->ctx:Landroid/content/Context;

    invoke-virtual {p2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p2

    iget-object v0, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->id:Ljava/lang/String;

    invoke-static {v0}, Lcom/juhyeon/familyjournea/MoaRemote721;->uri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    new-instance v1, Landroid/util/Size;

    const/16 v3, 0x100

    invoke-direct {v1, v3, v3}, Landroid/util/Size;-><init>(II)V

    const/4 v3, 0x0

    invoke-virtual {p2, v0, v1, v3}, Landroid/content/ContentResolver;->loadThumbnail(Landroid/net/Uri;Landroid/util/Size;Landroid/os/CancellationSignal;)Landroid/graphics/Bitmap;

    move-result-object p2

    goto :goto_275

    .line 109
    :cond_25c
    sget-object p2, Lcom/juhyeon/familyjournea/MoaRemote721;->ctx:Landroid/content/Context;

    invoke-virtual {p2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p2

    iget-object v0, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->id:Ljava/lang/String;

    invoke-static {v0}, Lcom/juhyeon/familyjournea/MoaRemote721;->uri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    invoke-static {p2, v0}, Landroid/graphics/ImageDecoder;->createSource(Landroid/content/ContentResolver;Landroid/net/Uri;)Landroid/graphics/ImageDecoder$Source;

    move-result-object p2

    new-instance v0, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda5;

    invoke-direct {v0}, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda5;-><init>()V

    invoke-static {p2, v0}, Landroid/graphics/ImageDecoder;->decodeBitmap(Landroid/graphics/ImageDecoder$Source;Landroid/graphics/ImageDecoder$OnHeaderDecodedListener;)Landroid/graphics/Bitmap;

    move-result-object p2

    .line 110
    :goto_275
    if-nez p2, :cond_27b

    invoke-static {p3, p1}, Lcom/juhyeon/familyjournea/MoaRemote721;->err(Ljava/io/OutputStream;I)V
    :try_end_27a
    .catch Ljava/lang/Exception; {:try_start_217 .. :try_end_27a} :catch_2c0

    return v5

    :cond_27b
    :try_start_27b
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V
    :try_end_280
    .catchall {:try_start_27b .. :try_end_280} :catchall_2b7

    :try_start_280
    sget-object v1, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;

    aget-object p0, p0, v7

    invoke-virtual {v2, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_28d

    const/16 p0, 0x4b

    goto :goto_28f

    :cond_28d
    const/16 p0, 0x5a

    :goto_28f
    invoke-virtual {p2, v1, p0, v0}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0
    :try_end_296
    .catchall {:try_start_280 .. :try_end_296} :catchall_2ad

    :try_start_296
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->close()V
    :try_end_299
    .catchall {:try_start_296 .. :try_end_299} :catchall_2b7

    :try_start_299
    invoke-virtual {p2}, Landroid/graphics/Bitmap;->recycle()V

    .line 111
    array-length p2, p0

    const/high16 v0, 0x800000

    if-le p2, v0, :cond_2a7

    const/16 p0, 0x19d

    invoke-static {p3, p0}, Lcom/juhyeon/familyjournea/MoaRemote721;->err(Ljava/io/OutputStream;I)V

    return v5

    :cond_2a7
    const-string p2, "image/jpeg"

    invoke-static {p3, v8, p2, p0}, Lcom/juhyeon/familyjournea/MoaRemote721;->data(Ljava/io/OutputStream;ILjava/lang/String;[B)V
    :try_end_2ac
    .catch Ljava/lang/Exception; {:try_start_299 .. :try_end_2ac} :catch_2c0

    return v5

    .line 110
    :catchall_2ad
    move-exception p0

    :try_start_2ae
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->close()V
    :try_end_2b1
    .catchall {:try_start_2ae .. :try_end_2b1} :catchall_2b2

    goto :goto_2b6

    :catchall_2b2
    move-exception v0

    :try_start_2b3
    invoke-virtual {p0, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_2b6
    throw p0
    :try_end_2b7
    .catchall {:try_start_2b3 .. :try_end_2b7} :catchall_2b7

    :catchall_2b7
    move-exception p0

    :try_start_2b8
    invoke-virtual {p2}, Landroid/graphics/Bitmap;->recycle()V

    throw p0

    .line 107
    :cond_2bc
    :goto_2bc
    invoke-static {p3, p1}, Lcom/juhyeon/familyjournea/MoaRemote721;->err(Ljava/io/OutputStream;I)V
    :try_end_2bf
    .catch Ljava/lang/Exception; {:try_start_2b8 .. :try_end_2bf} :catch_2c0

    return v5

    .line 120
    :catch_2c0
    move-exception p0

    :try_start_2c1
    invoke-static {p3, p1}, Lcom/juhyeon/familyjournea/MoaRemote721;->err(Ljava/io/OutputStream;I)V
    :try_end_2c4
    .catch Ljava/lang/Exception; {:try_start_2c1 .. :try_end_2c4} :catch_2c5

    goto :goto_2c6

    :catch_2c5
    move-exception p0

    :goto_2c6
    return v5
.end method

.method static header(Ljava/io/OutputStream;IJLjava/lang/String;Ljava/lang/String;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 86
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "HTTP/1.1 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const/16 v1, 0xc8

    if-ne p1, v1, :cond_16

    const-string p1, " OK"

    goto :goto_1f

    :cond_16
    const/16 v1, 0xce

    if-ne p1, v1, :cond_1d

    const-string p1, " Partial Content"

    goto :goto_1f

    :cond_1d
    const-string p1, " Error"

    :goto_1f
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, "\r\nConnection: close\r\nCache-Control: no-store\r\nContent-Length: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p2, p3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, "\r\nContent-Type: "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, "\r\n"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 87
    sget-object p2, Ljava/nio/charset/StandardCharsets;->US_ASCII:Ljava/nio/charset/Charset;

    invoke-virtual {p1, p2}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/io/OutputStream;->write([B)V

    .line 88
    return-void
.end method

.method static item(Ljava/lang/String;)Lcom/juhyeon/familyjournea/MoaRemote721$Item;
    .locals 11
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 73
    invoke-static {}, Lcom/juhyeon/familyjournea/MoaRemote721;->live()Z

    move-result v0

    if-eqz v0, :cond_ae

    .line 74
    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaRemote721;->voiceId(Ljava/lang/String;)Z

    move-result v0

    const/4 v1, 0x2

    if-eqz v0, :cond_29

    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaRemote721;->audioFile(Ljava/lang/String;)Ljava/io/File;

    move-result-object v0

    new-instance v9, Lcom/juhyeon/familyjournea/MoaRemote721$Item;

    const/16 v2, 0xc

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v5

    const-string v6, "audio/mp4"

    invoke-virtual {v0}, Ljava/io/File;->length()J

    move-result-wide v7

    move-object v2, v9

    move-object v3, p0

    invoke-direct/range {v2 .. v8}, Lcom/juhyeon/familyjournea/MoaRemote721$Item;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;J)V

    return-object v9

    .line 75
    :cond_29
    sget-object v0, Lcom/juhyeon/familyjournea/MoaRemote721;->ids:Ljava/util/Map;

    invoke-interface {v0, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    move-object v4, v0

    check-cast v4, Ljava/lang/String;

    if-eqz v4, :cond_a8

    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaRemote721;->mediaId(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_a8

    .line 76
    sget-object v0, Lcom/juhyeon/familyjournea/MoaRemote721;->ctx:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v5

    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaRemote721;->uri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v6

    const-string v0, "mime_type"

    const-string v2, "_size"

    const-string v3, "_display_name"

    filled-new-array {v3, v0, v2}, [Ljava/lang/String;

    move-result-object v7

    const/4 v9, 0x0

    const/4 v10, 0x0

    const/4 v8, 0x0

    invoke-virtual/range {v5 .. v10}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v0

    .line 77
    if-eqz v0, :cond_96

    :try_start_57
    invoke-interface {v0}, Landroid/database/Cursor;->moveToFirst()Z

    move-result v2

    if-eqz v2, :cond_96

    const/4 v2, 0x1

    invoke-interface {v0, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v6

    invoke-interface {v0, v1}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v7

    if-eqz v6, :cond_90

    const-string v1, "image/"

    invoke-virtual {v6, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_78

    const-string v1, "video/"

    invoke-virtual {v6, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_90

    :cond_78
    const-wide/16 v1, 0x0

    cmp-long v1, v7, v1

    if-lez v1, :cond_90

    new-instance v1, Lcom/juhyeon/familyjournea/MoaRemote721$Item;

    const/4 v2, 0x0

    invoke-interface {v0, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v5

    move-object v2, v1

    move-object v3, p0

    invoke-direct/range {v2 .. v8}, Lcom/juhyeon/familyjournea/MoaRemote721$Item;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;J)V
    :try_end_8a
    .catchall {:try_start_57 .. :try_end_8a} :catchall_9c

    .line 78
    if-eqz v0, :cond_8f

    invoke-interface {v0}, Landroid/database/Cursor;->close()V

    .line 77
    :cond_8f
    return-object v1

    :cond_90
    :try_start_90
    new-instance p0, Ljava/io/FileNotFoundException;

    invoke-direct {p0}, Ljava/io/FileNotFoundException;-><init>()V

    :goto_95
    throw p0

    :cond_96
    new-instance p0, Ljava/io/FileNotFoundException;

    invoke-direct {p0}, Ljava/io/FileNotFoundException;-><init>()V
    :try_end_9b
    .catchall {:try_start_90 .. :try_end_9b} :catchall_9c

    goto :goto_95

    .line 76
    :catchall_9c
    move-exception p0

    if-eqz v0, :cond_a7

    :try_start_9f
    invoke-interface {v0}, Landroid/database/Cursor;->close()V
    :try_end_a2
    .catchall {:try_start_9f .. :try_end_a2} :catchall_a3

    goto :goto_a7

    :catchall_a3
    move-exception v0

    invoke-virtual {p0, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_a7
    :goto_a7
    throw p0

    .line 75
    :cond_a8
    new-instance p0, Ljava/io/FileNotFoundException;

    invoke-direct {p0}, Ljava/io/FileNotFoundException;-><init>()V

    throw p0

    .line 73
    :cond_ae
    new-instance p0, Ljava/io/IOException;

    const-string v0, "Sharing disabled"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method static synthetic lambda$catalog$0(Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;)I
    .locals 4

    .line 83
    invoke-static {p1}, Lcom/juhyeon/familyjournea/MoaRemote721;->voiceId(Ljava/lang/String;)Z

    move-result v0

    const/16 v1, 0xc

    const/4 v2, 0x2

    if-eqz v0, :cond_e

    invoke-virtual {p1, v2, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    goto :goto_14

    :cond_e
    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    :goto_14
    invoke-static {p2}, Lcom/juhyeon/familyjournea/MoaRemote721;->voiceId(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1f

    invoke-virtual {p2, v2, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    goto :goto_25

    :cond_1f
    invoke-interface {p0, p2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    :goto_25
    invoke-virtual {p0, v0}, Ljava/lang/String;->compareTo(Ljava/lang/String;)I

    move-result p0

    if-nez p0, :cond_2f

    invoke-virtual {p2, p1}, Ljava/lang/String;->compareTo(Ljava/lang/String;)I

    move-result p0

    :cond_2f
    return p0
.end method

.method static synthetic lambda$handle$1(Landroid/graphics/ImageDecoder;Landroid/graphics/ImageDecoder$ImageInfo;Landroid/graphics/ImageDecoder$Source;)V
    .locals 2

    .line 109
    invoke-virtual {p1}, Landroid/graphics/ImageDecoder$ImageInfo;->getSize()Landroid/util/Size;

    move-result-object p2

    invoke-virtual {p2}, Landroid/util/Size;->getWidth()I

    move-result p2

    invoke-virtual {p1}, Landroid/graphics/ImageDecoder$ImageInfo;->getSize()Landroid/util/Size;

    move-result-object p1

    invoke-virtual {p1}, Landroid/util/Size;->getHeight()I

    move-result p1

    invoke-static {p2, p1}, Ljava/lang/Math;->max(II)I

    move-result v0

    int-to-float v0, v0

    const/high16 v1, 0x45200000    # 2560.0f

    div-float/2addr v1, v0

    const/high16 v0, 0x3f800000    # 1.0f

    invoke-static {v0, v1}, Ljava/lang/Math;->min(FF)F

    move-result v0

    int-to-float p2, p2

    mul-float/2addr p2, v0

    invoke-static {p2}, Ljava/lang/Math;->round(F)I

    move-result p2

    const/4 v1, 0x1

    invoke-static {v1, p2}, Ljava/lang/Math;->max(II)I

    move-result p2

    int-to-float p1, p1

    mul-float/2addr p1, v0

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p1

    invoke-static {v1, p1}, Ljava/lang/Math;->max(II)I

    move-result p1

    invoke-virtual {p0, p2, p1}, Landroid/graphics/ImageDecoder;->setTargetSize(II)V

    invoke-virtual {p0, v1}, Landroid/graphics/ImageDecoder;->setAllocator(I)V

    return-void
.end method

.method static synthetic lambda$photo$2(Landroid/app/Dialog;Landroid/widget/ImageView;Landroid/graphics/Bitmap;Landroid/widget/TextView;)V
    .locals 0

    .line 154
    invoke-virtual {p0}, Landroid/app/Dialog;->isShowing()Z

    move-result p0

    if-eqz p0, :cond_f

    invoke-virtual {p1, p2}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    const-string p0, "\uc6d0\uaca9 \ubbf8\ub9ac\ubcf4\uae30 \u00b7 \ucd5c\ub300 2560px"

    invoke-virtual {p3, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_12

    :cond_f
    invoke-virtual {p2}, Landroid/graphics/Bitmap;->recycle()V

    :goto_12
    return-void
.end method

.method static synthetic lambda$photo$3(Landroid/widget/TextView;)V
    .locals 1

    .line 154
    const-string v0, "\uc0ac\uc9c4\uc744 \uc77d\uc9c0 \ubabb\ud588\uc2b5\ub2c8\ub2e4."

    invoke-virtual {p0, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method static synthetic lambda$photo$4(Lcom/juhyeon/familyjournea/MoaRemote721$Client;Ljava/lang/String;Landroid/app/Activity;Landroid/app/Dialog;Landroid/widget/ImageView;Landroid/widget/TextView;)V
    .locals 9

    .line 154
    :try_start_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "/v3/view/image/"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-wide/16 v5, -0x1

    const-wide/16 v7, -0x1

    const/high16 v2, 0x800000

    const-wide/16 v3, -0x1

    move-object v0, p0

    invoke-virtual/range {v0 .. v8}, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->get(Ljava/lang/String;IJJJ)[B

    move-result-object p0

    array-length p1, p0

    const/4 v0, 0x0

    invoke-static {p0, v0, p1}, Landroid/graphics/BitmapFactory;->decodeByteArray([BII)Landroid/graphics/Bitmap;

    move-result-object p0

    if-eqz p0, :cond_31

    new-instance p1, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda3;

    invoke-direct {p1, p3, p4, p0, p5}, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda3;-><init>(Landroid/app/Dialog;Landroid/widget/ImageView;Landroid/graphics/Bitmap;Landroid/widget/TextView;)V

    invoke-virtual {p2, p1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    goto :goto_42

    :cond_31
    new-instance p0, Ljava/io/IOException;

    const-string p1, "Invalid image"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_39
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_39} :catch_39

    :catch_39
    move-exception p0

    new-instance p0, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda4;

    invoke-direct {p0, p5}, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda4;-><init>(Landroid/widget/TextView;)V

    invoke-virtual {p2, p0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :goto_42
    return-void
.end method

.method static synthetic lambda$player$5(Landroid/app/AlertDialog;[ZLandroid/widget/SeekBar;Landroid/widget/Button;Landroid/widget/TextView;Landroid/os/Handler;Ljava/lang/Runnable;Landroid/media/MediaPlayer;)V
    .locals 1

    .line 155
    invoke-virtual {p0}, Landroid/app/AlertDialog;->isShowing()Z

    move-result p0

    if-nez p0, :cond_7

    return-void

    :cond_7
    const/4 p0, 0x0

    const/4 v0, 0x1

    aput-boolean v0, p1, p0

    invoke-virtual {p7}, Landroid/media/MediaPlayer;->getDuration()I

    move-result p0

    invoke-virtual {p2, p0}, Landroid/widget/SeekBar;->setMax(I)V

    invoke-virtual {p3, v0}, Landroid/widget/Button;->setEnabled(Z)V

    const-string p0, "\uc6d0\ubcf8 \uc800\uc7a5 \uc5c6\uc774 \uc7ac\uc0dd \uc911"

    invoke-virtual {p4, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {p7}, Landroid/media/MediaPlayer;->start()V

    invoke-virtual {p5, p6}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method static synthetic lambda$player$6(Landroid/widget/TextView;Landroid/media/MediaPlayer;II)Z
    .locals 0

    .line 155
    const-string p1, "\uc7ac\uc0dd \uc624\ub958 \u00b7 \ud5c8\ube0c \uc5f0\uacb0/\uc601\uc0c1 \ud615\uc2dd\uc744 \ud655\uc778\ud558\uc138\uc694"

    invoke-virtual {p0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 p0, 0x1

    return p0
.end method

.method static synthetic lambda$player$7([ZLandroid/media/MediaPlayer;Lcom/juhyeon/familyjournea/MoaRemote721$Source;Landroid/app/AlertDialog;[ZLandroid/widget/SeekBar;Landroid/widget/Button;Landroid/widget/TextView;Landroid/os/Handler;Ljava/lang/Runnable;)V
    .locals 11

    .line 155
    move-object v0, p1

    move-object/from16 v9, p7

    const/4 v1, 0x0

    aget-boolean v2, p0, v1

    if-eqz v2, :cond_9

    return-void

    :cond_9
    const/4 v2, 0x1

    aput-boolean v2, p0, v1

    :try_start_c
    invoke-virtual {p1, p2}, Landroid/media/MediaPlayer;->setDataSource(Landroid/media/MediaDataSource;)V

    new-instance v10, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda1;

    move-object v1, v10

    move-object v2, p3

    move-object v3, p4

    move-object/from16 v4, p5

    move-object/from16 v5, p6

    move-object/from16 v6, p7

    move-object/from16 v7, p8

    move-object/from16 v8, p9

    invoke-direct/range {v1 .. v8}, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda1;-><init>(Landroid/app/AlertDialog;[ZLandroid/widget/SeekBar;Landroid/widget/Button;Landroid/widget/TextView;Landroid/os/Handler;Ljava/lang/Runnable;)V

    invoke-virtual {p1, v10}, Landroid/media/MediaPlayer;->setOnPreparedListener(Landroid/media/MediaPlayer$OnPreparedListener;)V

    new-instance v1, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda2;

    invoke-direct {v1, v9}, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda2;-><init>(Landroid/widget/TextView;)V

    invoke-virtual {p1, v1}, Landroid/media/MediaPlayer;->setOnErrorListener(Landroid/media/MediaPlayer$OnErrorListener;)V

    invoke-virtual {p1}, Landroid/media/MediaPlayer;->prepareAsync()V
    :try_end_2f
    .catch Ljava/lang/Exception; {:try_start_c .. :try_end_2f} :catch_30

    goto :goto_36

    :catch_30
    move-exception v0

    const-string v0, "\uc2a4\ud2b8\ub9ac\ubc0d \uc900\ube44 \uc2e4\ud328"

    invoke-virtual {v9, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :goto_36
    return-void
.end method

.method static synthetic lambda$player$8([ZLandroid/media/MediaPlayer;Landroid/view/View;)V
    .locals 0

    .line 156
    const/4 p2, 0x0

    aget-boolean p0, p0, p2

    if-eqz p0, :cond_14

    :try_start_5
    invoke-virtual {p1}, Landroid/media/MediaPlayer;->isPlaying()Z

    move-result p0

    if-eqz p0, :cond_f

    invoke-virtual {p1}, Landroid/media/MediaPlayer;->pause()V

    goto :goto_14

    :cond_f
    invoke-virtual {p1}, Landroid/media/MediaPlayer;->start()V
    :try_end_12
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_12} :catch_13

    goto :goto_14

    :catch_13
    move-exception p0

    :cond_14
    :goto_14
    return-void
.end method

.method static synthetic lambda$player$9([ZLandroid/os/Handler;Ljava/lang/Runnable;Landroid/media/MediaPlayer;Lcom/juhyeon/familyjournea/MoaRemote721$Source;Landroid/content/DialogInterface;)V
    .locals 0

    .line 157
    const/4 p5, 0x0

    aput-boolean p5, p0, p5

    invoke-virtual {p1, p2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    :try_start_6
    invoke-virtual {p3}, Landroid/media/MediaPlayer;->release()V
    :try_end_9
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_9} :catch_a

    goto :goto_b

    :catch_a
    move-exception p0

    :goto_b
    invoke-virtual {p4}, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->close()V

    return-void
.end method

.method static live()Z
    .locals 4

    .line 64
    sget-boolean v0, Lcom/juhyeon/familyjournea/MoaRemote721;->sharing:Z

    if-eqz v0, :cond_1d

    sget-object v0, Lcom/juhyeon/familyjournea/MoaRemote721;->ctx:Landroid/content/Context;

    if-eqz v0, :cond_1d

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    sget-wide v2, Lcom/juhyeon/familyjournea/MoaRemote721;->lastConsent:J

    sub-long/2addr v0, v2

    const-wide/16 v2, 0x2ee0

    cmp-long v0, v0, v2

    if-ltz v0, :cond_1b

    invoke-static {}, Lcom/juhyeon/familyjournea/MoaHost723;->live()Z

    move-result v0

    if-eqz v0, :cond_1d

    :cond_1b
    const/4 v0, 0x1

    goto :goto_1e

    :cond_1d
    const/4 v0, 0x0

    :goto_1e
    return v0
.end method

.method static mediaId(Ljava/lang/String;)Z
    .locals 1

    .line 45
    if-eqz p0, :cond_c

    const-string v0, "(?:v[0-9]{1,18}|[0-9]{1,18})"

    invoke-virtual {p0, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_c

    const/4 p0, 0x1

    goto :goto_d

    :cond_c
    const/4 p0, 0x0

    :goto_d
    return p0
.end method

.method public static open(Landroid/app/Activity;Lorg/json/JSONObject;Ljava/lang/String;)V
    .locals 4

    .line 146
    if-eqz p0, :cond_50

    invoke-virtual {p0}, Landroid/app/Activity;->isFinishing()Z

    move-result v0

    if-eqz v0, :cond_9

    goto :goto_50

    :cond_9
    sget-boolean v0, Lcom/juhyeon/familyjournea/MoaRemote721;->clientAllowed:Z

    const/4 v1, 0x0

    const-string v2, "\ud655\uc778"

    if-eqz v0, :cond_3e

    if-nez p1, :cond_13

    goto :goto_3e

    :cond_13
    :try_start_13
    new-instance v0, Lcom/juhyeon/familyjournea/MoaRemote721$Client;

    invoke-direct {v0, p1}, Lcom/juhyeon/familyjournea/MoaRemote721$Client;-><init>(Lorg/json/JSONObject;)V

    new-instance p1, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;

    invoke-static {p2}, Lcom/juhyeon/familyjournea/MoaRemote721;->day(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_21

    goto :goto_23

    :cond_21
    const-string p2, ""

    :goto_23
    invoke-direct {p1, p0, v0, p2}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;-><init>(Landroid/app/Activity;Lcom/juhyeon/familyjournea/MoaRemote721$Client;Ljava/lang/String;)V

    invoke-virtual {p1}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->show()V
    :try_end_29
    .catch Ljava/lang/Exception; {:try_start_13 .. :try_end_29} :catch_2a

    goto :goto_3d

    :catch_2a
    move-exception p1

    new-instance p1, Landroid/app/AlertDialog$Builder;

    invoke-direct {p1, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string p0, "\uc5f0\uacb0 \uc815\ubcf4\ub97c \ud655\uc778\ud558\uc138\uc694."

    invoke-virtual {p1, p0}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    invoke-virtual {p0, v2, v1}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    :goto_3d
    return-void

    :cond_3e
    :goto_3e
    new-instance p1, Landroid/app/AlertDialog$Builder;

    invoke-direct {p1, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string p0, "\ub3d9\uae30\ud654\ub97c \ucf1c\uace0 \uba3c\uc800 \uae30\uae30\ub97c \uc5f0\uacb0\ud558\uc138\uc694."

    invoke-virtual {p1, p0}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    invoke-virtual {p0, v2, v1}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    :cond_50
    :goto_50
    return-void
.end method

.method public static optionalDiscovery()Ljava/net/DatagramSocket;
    .locals 4

    .line 37
    const/4 v0, 0x0

    :try_start_1
    new-instance v1, Ljava/net/DatagramSocket;

    invoke-direct {v1, v0}, Ljava/net/DatagramSocket;-><init>(Ljava/net/SocketAddress;)V
    :try_end_6
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_6} :catch_18

    const/4 v2, 0x1

    :try_start_7
    invoke-virtual {v1, v2}, Ljava/net/DatagramSocket;->setReuseAddress(Z)V

    new-instance v2, Ljava/net/InetSocketAddress;

    const v3, 0x9525

    invoke-direct {v2, v3}, Ljava/net/InetSocketAddress;-><init>(I)V

    invoke-virtual {v1, v2}, Ljava/net/DatagramSocket;->bind(Ljava/net/SocketAddress;)V
    :try_end_15
    .catch Ljava/lang/Exception; {:try_start_7 .. :try_end_15} :catch_16

    return-object v1

    :catch_16
    move-exception v2

    goto :goto_1a

    :catch_18
    move-exception v1

    move-object v1, v0

    :goto_1a
    if-eqz v1, :cond_1f

    invoke-virtual {v1}, Ljava/net/DatagramSocket;->close()V

    :cond_1f
    return-object v0
.end method

.method static photo(Landroid/app/Activity;Lcom/juhyeon/familyjournea/MoaRemote721$Client;Ljava/lang/String;)V
    .locals 10

    .line 154
    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaRemote721;->col(Landroid/app/Activity;)Landroid/widget/LinearLayout;

    move-result-object v0

    const-string v1, "\uc0ac\uc9c4 \ubd88\ub7ec\uc624\ub294 \uc911\u2026"

    const/16 v2, 0xe

    invoke-static {p0, v1, v2}, Lcom/juhyeon/familyjournea/MoaRemote721;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v9

    invoke-virtual {v0, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v8, Landroid/widget/ImageView;

    invoke-direct {v8, p0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x1

    invoke-virtual {v8, v1}, Landroid/widget/ImageView;->setAdjustViewBounds(Z)V

    sget-object v1, Landroid/widget/ImageView$ScaleType;->FIT_CENTER:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {v8, v1}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v2, 0x26c

    invoke-static {p0, v2}, Lcom/juhyeon/familyjournea/MoaRemote721;->dp(Landroid/app/Activity;I)I

    move-result v2

    invoke-virtual {p0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v3

    iget v3, v3, Landroid/util/DisplayMetrics;->heightPixels:I

    mul-int/lit8 v3, v3, 0x2

    div-int/lit8 v3, v3, 0x3

    invoke-static {v2, v3}, Ljava/lang/Math;->min(II)I

    move-result v2

    const/4 v3, -0x1

    invoke-direct {v1, v3, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v8, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v1, Landroid/app/AlertDialog$Builder;

    invoke-direct {v1, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v2, "\uc6d0\uaca9 \uc0ac\uc9c4 \u00b7 \uc800\uc7a5 \uc548 \ud568"

    invoke-virtual {v1, v2}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    invoke-virtual {v1, v0}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    const-string v1, "\ub2eb\uae30"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object v7

    invoke-virtual {v7}, Landroid/app/Dialog;->show()V

    invoke-static {v7, p0}, Lcom/juhyeon/familyjournea/MoaRemote721;->size(Landroid/app/Dialog;Landroid/app/Activity;)V

    sget-object v0, Lcom/juhyeon/familyjournea/MoaRemote721;->PHOTO:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda0;

    move-object v3, v1

    move-object v4, p1

    move-object v5, p2

    move-object v6, p0

    invoke-direct/range {v3 .. v9}, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda0;-><init>(Lcom/juhyeon/familyjournea/MoaRemote721$Client;Ljava/lang/String;Landroid/app/Activity;Landroid/app/Dialog;Landroid/widget/ImageView;Landroid/widget/TextView;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method static player(Landroid/app/Activity;Lcom/juhyeon/familyjournea/MoaRemote721$Client;Ljava/lang/String;JZ)V
    .locals 21

    .line 155
    move-object/from16 v0, p0

    invoke-static/range {p0 .. p0}, Lcom/juhyeon/familyjournea/MoaRemote721;->col(Landroid/app/Activity;)Landroid/widget/LinearLayout;

    move-result-object v1

    const-string v2, "\uc6d0\uaca9 \uc2a4\ud2b8\ub9ac\ubc0d \uc900\ube44 \uc911\u2026"

    const/16 v3, 0xe

    invoke-static {v0, v2, v3}, Lcom/juhyeon/familyjournea/MoaRemote721;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v12

    invoke-virtual {v1, v12}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    const/4 v2, 0x0

    if-eqz p5, :cond_1a

    new-instance v3, Landroid/view/SurfaceView;

    invoke-direct {v3, v0}, Landroid/view/SurfaceView;-><init>(Landroid/content/Context;)V

    goto :goto_1b

    :cond_1a
    move-object v3, v2

    :goto_1b
    if-eqz p5, :cond_3c

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v5, 0x190

    invoke-static {v0, v5}, Lcom/juhyeon/familyjournea/MoaRemote721;->dp(Landroid/app/Activity;I)I

    move-result v5

    invoke-virtual/range {p0 .. p0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object v6

    invoke-virtual {v6}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v6

    iget v6, v6, Landroid/util/DisplayMetrics;->heightPixels:I

    div-int/lit8 v6, v6, 0x2

    invoke-static {v5, v6}, Ljava/lang/Math;->min(II)I

    move-result v5

    const/4 v6, -0x1

    invoke-direct {v4, v6, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    :cond_3c
    new-instance v11, Landroid/widget/SeekBar;

    invoke-direct {v11, v0}, Landroid/widget/SeekBar;-><init>(Landroid/content/Context;)V

    invoke-virtual {v1, v11}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    const-string v4, "\uc7ac\uc0dd / \uc77c\uc2dc\uc815\uc9c0"

    invoke-static {v0, v4}, Lcom/juhyeon/familyjournea/MoaRemote721;->btn(Landroid/app/Activity;Ljava/lang/String;)Landroid/widget/Button;

    move-result-object v10

    const/4 v4, 0x0

    invoke-virtual {v10, v4}, Landroid/widget/Button;->setEnabled(Z)V

    invoke-virtual {v1, v10}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/app/AlertDialog$Builder;

    invoke-direct {v5, v0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    if-eqz p5, :cond_5b

    const-string v6, "\uc6d0\uaca9 \uc601\uc0c1 \uc7ac\uc0dd"

    goto :goto_5d

    :cond_5b
    const-string v6, "\uc6d0\uaca9 \uc74c\uc131 \uc7ac\uc0dd"

    :goto_5d
    invoke-virtual {v5, v6}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v5

    invoke-virtual {v5, v1}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    const-string v5, "\ub2eb\uae30"

    invoke-virtual {v1, v5, v2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    invoke-virtual {v1}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object v1

    new-instance v2, Landroid/media/MediaPlayer;

    invoke-direct {v2}, Landroid/media/MediaPlayer;-><init>()V

    new-instance v9, Lcom/juhyeon/familyjournea/MoaRemote721$Source;

    move-object/from16 v5, p1

    move-object/from16 v6, p2

    move-wide/from16 v7, p3

    invoke-direct {v9, v5, v6, v7, v8}, Lcom/juhyeon/familyjournea/MoaRemote721$Source;-><init>(Lcom/juhyeon/familyjournea/MoaRemote721$Client;Ljava/lang/String;J)V

    new-instance v8, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v5

    invoke-direct {v8, v5}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    const/4 v5, 0x1

    new-array v7, v5, [Z

    aput-boolean v4, v7, v4

    new-array v5, v5, [Z

    aput-boolean v4, v5, v4

    new-instance v19, Lcom/juhyeon/familyjournea/MoaRemote721$1;

    move-object/from16 v13, v19

    move-object v14, v1

    move-object v15, v7

    move-object/from16 v16, v11

    move-object/from16 v17, v2

    move-object/from16 v18, v8

    invoke-direct/range {v13 .. v18}, Lcom/juhyeon/familyjournea/MoaRemote721$1;-><init>(Landroid/app/AlertDialog;[ZLandroid/widget/SeekBar;Landroid/media/MediaPlayer;Landroid/os/Handler;)V

    new-instance v15, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda7;

    move-object v4, v15

    move-object v6, v2

    move-object v14, v7

    move-object v7, v9

    move-object/from16 v16, v8

    move-object v8, v1

    move-object/from16 v18, v9

    move-object v9, v14

    move-object v13, v10

    move-object v10, v11

    move-object v0, v11

    move-object v11, v13

    move-object/from16 v20, v1

    move-object v1, v13

    move-object/from16 v13, v16

    move-object/from16 p1, v15

    move-object v15, v14

    move-object/from16 v14, v19

    invoke-direct/range {v4 .. v14}, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda7;-><init>([ZLandroid/media/MediaPlayer;Lcom/juhyeon/familyjournea/MoaRemote721$Source;Landroid/app/AlertDialog;[ZLandroid/widget/SeekBar;Landroid/widget/Button;Landroid/widget/TextView;Landroid/os/Handler;Ljava/lang/Runnable;)V

    .line 156
    new-instance v4, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda8;

    invoke-direct {v4, v15, v2}, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda8;-><init>([ZLandroid/media/MediaPlayer;)V

    invoke-virtual {v1, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v1, Lcom/juhyeon/familyjournea/MoaRemote721$2;

    invoke-direct {v1, v15, v2}, Lcom/juhyeon/familyjournea/MoaRemote721$2;-><init>([ZLandroid/media/MediaPlayer;)V

    invoke-virtual {v0, v1}, Landroid/widget/SeekBar;->setOnSeekBarChangeListener(Landroid/widget/SeekBar$OnSeekBarChangeListener;)V

    .line 157
    if-eqz p5, :cond_de

    invoke-virtual {v3}, Landroid/view/SurfaceView;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v0

    new-instance v1, Lcom/juhyeon/familyjournea/MoaRemote721$3;

    move-object/from16 v3, p1

    invoke-direct {v1, v2, v3}, Lcom/juhyeon/familyjournea/MoaRemote721$3;-><init>(Landroid/media/MediaPlayer;Ljava/lang/Runnable;)V

    invoke-interface {v0, v1}, Landroid/view/SurfaceHolder;->addCallback(Landroid/view/SurfaceHolder$Callback;)V

    goto :goto_e0

    :cond_de
    move-object/from16 v3, p1

    :goto_e0
    new-instance v0, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda9;

    move-object v13, v0

    move-object v14, v15

    move-object v1, v3

    move-object/from16 v15, v16

    move-object/from16 v16, v19

    move-object/from16 v17, v2

    invoke-direct/range {v13 .. v18}, Lcom/juhyeon/familyjournea/MoaRemote721$$ExternalSyntheticLambda9;-><init>([ZLandroid/os/Handler;Ljava/lang/Runnable;Landroid/media/MediaPlayer;Lcom/juhyeon/familyjournea/MoaRemote721$Source;)V

    move-object/from16 v2, v20

    invoke-virtual {v2, v0}, Landroid/app/AlertDialog;->setOnDismissListener(Landroid/content/DialogInterface$OnDismissListener;)V

    invoke-virtual {v2}, Landroid/app/AlertDialog;->show()V

    move-object/from16 v0, p0

    invoke-static {v2, v0}, Lcom/juhyeon/familyjournea/MoaRemote721;->size(Landroid/app/Dialog;Landroid/app/Activity;)V

    if-nez p5, :cond_100

    invoke-interface {v1}, Ljava/lang/Runnable;->run()V

    .line 158
    :cond_100
    return-void
.end method

.method static private4(Ljava/net/InetAddress;)Z
    .locals 1

    .line 43
    instance-of v0, p0, Ljava/net/Inet4Address;

    if-eqz v0, :cond_12

    invoke-virtual {p0}, Ljava/net/InetAddress;->isSiteLocalAddress()Z

    move-result v0

    if-eqz v0, :cond_12

    invoke-virtual {p0}, Ljava/net/InetAddress;->isLoopbackAddress()Z

    move-result p0

    if-nez p0, :cond_12

    const/4 p0, 0x1

    goto :goto_13

    :cond_12
    const/4 p0, 0x0

    :goto_13
    return p0
.end method

.method public static range(Ljava/lang/String;J)[J
    .locals 11

    .line 92
    const/4 v0, 0x0

    if-eqz p0, :cond_52

    const-string v1, "bytes=[0-9]+-[0-9]+"

    invoke-virtual {p0, v1}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_52

    const-wide/16 v1, 0x0

    cmp-long v3, p1, v1

    if-gtz v3, :cond_12

    goto :goto_52

    :cond_12
    const/4 v3, 0x6

    :try_start_13
    invoke-virtual {p0, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    const-string v3, "-"

    invoke-virtual {p0, v3}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    const/4 v3, 0x0

    aget-object v4, p0, v3

    invoke-static {v4}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v4

    const/4 v6, 0x1

    aget-object p0, p0, v6

    invoke-static {p0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v7

    cmp-long p0, v4, v1

    if-ltz p0, :cond_50

    cmp-long p0, v4, p1

    if-gez p0, :cond_50

    cmp-long p0, v7, v4

    if-ltz p0, :cond_50

    sub-long v1, v7, v4

    const-wide/32 v9, 0x100000

    cmp-long p0, v1, v9

    if-ltz p0, :cond_41

    goto :goto_50

    :cond_41
    const-wide/16 v1, 0x1

    sub-long/2addr p1, v1

    invoke-static {v7, v8, p1, p2}, Ljava/lang/Math;->min(JJ)J

    move-result-wide p0

    const/4 p2, 0x2

    new-array p2, p2, [J

    aput-wide v4, p2, v3

    aput-wide p0, p2, v6
    :try_end_4f
    .catch Ljava/lang/Exception; {:try_start_13 .. :try_end_4f} :catch_51

    return-object p2

    :cond_50
    :goto_50
    return-object v0

    :catch_51
    move-exception p0

    :cond_52
    :goto_52
    return-object v0
.end method

.method static size(Landroid/app/Dialog;Landroid/app/Activity;)V
    .locals 2

    .line 145
    invoke-virtual {p0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p0

    if-eqz p0, :cond_25

    invoke-virtual {p1}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    const/16 v1, 0x18

    invoke-static {p1, v1}, Lcom/juhyeon/familyjournea/MoaRemote721;->dp(Landroid/app/Activity;I)I

    move-result v1

    sub-int/2addr v0, v1

    const/16 v1, 0x384

    invoke-static {p1, v1}, Lcom/juhyeon/familyjournea/MoaRemote721;->dp(Landroid/app/Activity;I)I

    move-result p1

    invoke-static {v0, p1}, Ljava/lang/Math;->min(II)I

    move-result p1

    const/4 v0, -0x2

    invoke-virtual {p0, p1, v0}, Landroid/view/Window;->setLayout(II)V

    :cond_25
    return-void
.end method

.method static text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;
    .locals 1

    .line 141
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    int-to-float p0, p2

    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setTextSize(F)V

    return-object v0
.end method

.method public static update(Landroid/content/Context;Lorg/json/JSONObject;)V
    .locals 8

    .line 50
    const-string v0, "off"

    const/4 v1, 0x0

    :try_start_3
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v2

    sput-object v2, Lcom/juhyeon/familyjournea/MoaRemote721;->ctx:Landroid/content/Context;

    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaLan723;->init(Landroid/content/Context;)V

    const-string p0, "mode"

    invoke-virtual {p1, p0, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    const/4 v0, 0x1

    if-nez p0, :cond_1b

    move p0, v0

    goto :goto_1c

    :cond_1b
    move p0, v1

    :goto_1c
    sput-boolean p0, Lcom/juhyeon/familyjournea/MoaRemote721;->clientAllowed:Z

    .line 51
    sget-boolean p0, Lcom/juhyeon/familyjournea/MoaRemote721;->clientAllowed:Z

    if-eqz p0, :cond_2c

    const-string p0, "viewShare"

    invoke-virtual {p1, p0, v1}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result p0

    if-eqz p0, :cond_2c

    move p0, v0

    goto :goto_2d

    :cond_2c
    move p0, v1

    :goto_2d
    sput-boolean p0, Lcom/juhyeon/familyjournea/MoaRemote721;->sharing:Z

    sget-boolean p0, Lcom/juhyeon/familyjournea/MoaRemote721;->sharing:Z

    if-eqz p0, :cond_3c

    const-string p0, "viewVoice"

    invoke-virtual {p1, p0, v1}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result p0

    if-eqz p0, :cond_3c

    goto :goto_3d

    :cond_3c
    move v0, v1

    :goto_3d
    sput-boolean v0, Lcom/juhyeon/familyjournea/MoaRemote721;->voice:Z

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    sput-wide v2, Lcom/juhyeon/familyjournea/MoaRemote721;->lastConsent:J

    .line 52
    sget-boolean p0, Lcom/juhyeon/familyjournea/MoaRemote721;->sharing:Z

    const-wide/16 v2, -0x1

    if-nez p0, :cond_59

    invoke-static {}, Ljava/util/Collections;->emptyMap()Ljava/util/Map;

    move-result-object p0

    sput-object p0, Lcom/juhyeon/familyjournea/MoaRemote721;->ids:Ljava/util/Map;

    sget-object p0, Lcom/juhyeon/familyjournea/MoaRemote721;->incoming:Ljava/util/Map;

    invoke-interface {p0}, Ljava/util/Map;->clear()V

    sput-wide v2, Lcom/juhyeon/familyjournea/MoaRemote721;->incomingEpoch:J

    return-void

    .line 53
    :cond_59
    const-string p0, "viewCatalog"

    invoke-virtual {p1, p0}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p0

    if-nez p0, :cond_62

    return-void

    .line 54
    :cond_62
    const-string v0, "viewEpoch"

    invoke-virtual {p1, v0, v2, v3}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide v4

    const-string v0, "viewOffset"

    const/4 v6, -0x1

    invoke-virtual {p1, v0, v6}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v0

    const-string v7, "viewTotal"

    invoke-virtual {p1, v7, v6}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p1

    .line 55
    if-ltz p1, :cond_ff

    const v6, 0x186a0

    if-gt p1, v6, :cond_ff

    if-ltz v0, :cond_ff

    invoke-virtual {p0}, Lorg/json/JSONArray;->length()I

    move-result v6

    const/16 v7, 0x3e8

    if-gt v6, v7, :cond_ff

    invoke-virtual {p0}, Lorg/json/JSONArray;->length()I

    move-result v6

    add-int/2addr v6, v0

    if-gt v6, p1, :cond_ff

    const-wide/16 v6, 0x0

    cmp-long v6, v4, v6

    if-gez v6, :cond_95

    goto/16 :goto_ff

    .line 56
    :cond_95
    if-nez v0, :cond_a2

    new-instance v6, Ljava/util/LinkedHashMap;

    invoke-direct {v6}, Ljava/util/LinkedHashMap;-><init>()V

    sput-object v6, Lcom/juhyeon/familyjournea/MoaRemote721;->incoming:Ljava/util/Map;

    sput-wide v4, Lcom/juhyeon/familyjournea/MoaRemote721;->incomingEpoch:J

    sput v1, Lcom/juhyeon/familyjournea/MoaRemote721;->incomingOffset:I

    .line 57
    :cond_a2
    sget-wide v6, Lcom/juhyeon/familyjournea/MoaRemote721;->incomingEpoch:J

    cmp-long v4, v4, v6

    if-nez v4, :cond_fe

    sget v4, Lcom/juhyeon/familyjournea/MoaRemote721;->incomingOffset:I

    if-eq v0, v4, :cond_ad

    goto :goto_fe

    .line 58
    :cond_ad
    move v0, v1

    :goto_ae
    invoke-virtual {p0}, Lorg/json/JSONArray;->length()I

    move-result v4

    if-ge v0, v4, :cond_dc

    invoke-virtual {p0, v0}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v4

    if-nez v4, :cond_bb

    :cond_ba
    :goto_ba
    goto :goto_d9

    :cond_bb
    const-string v5, "id"

    invoke-virtual {v4, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    const-string v6, "day"

    invoke-virtual {v4, v6}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v5}, Lcom/juhyeon/familyjournea/MoaRemote721;->mediaId(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_ba

    invoke-static {v4}, Lcom/juhyeon/familyjournea/MoaRemote721;->day(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_ba

    sget-object v6, Lcom/juhyeon/familyjournea/MoaRemote721;->incoming:Ljava/util/Map;

    invoke-interface {v6, v5, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_ba

    :goto_d9
    add-int/lit8 v0, v0, 0x1

    goto :goto_ae

    .line 59
    :cond_dc
    sget v0, Lcom/juhyeon/familyjournea/MoaRemote721;->incomingOffset:I

    invoke-virtual {p0}, Lorg/json/JSONArray;->length()I

    move-result p0

    add-int/2addr v0, p0

    sput v0, Lcom/juhyeon/familyjournea/MoaRemote721;->incomingOffset:I

    sget p0, Lcom/juhyeon/familyjournea/MoaRemote721;->incomingOffset:I

    if-ne p0, p1, :cond_fd

    new-instance p0, Ljava/util/LinkedHashMap;

    sget-object p1, Lcom/juhyeon/familyjournea/MoaRemote721;->incoming:Ljava/util/Map;

    invoke-direct {p0, p1}, Ljava/util/LinkedHashMap;-><init>(Ljava/util/Map;)V

    invoke-static {p0}, Ljava/util/Collections;->unmodifiableMap(Ljava/util/Map;)Ljava/util/Map;

    move-result-object p0

    sput-object p0, Lcom/juhyeon/familyjournea/MoaRemote721;->ids:Ljava/util/Map;

    sget-object p0, Lcom/juhyeon/familyjournea/MoaRemote721;->incoming:Ljava/util/Map;

    invoke-interface {p0}, Ljava/util/Map;->clear()V

    sput-wide v2, Lcom/juhyeon/familyjournea/MoaRemote721;->incomingEpoch:J
    :try_end_fd
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_fd} :catch_100

    .line 61
    :cond_fd
    goto :goto_10b

    .line 57
    :cond_fe
    :goto_fe
    return-void

    .line 55
    :cond_ff
    :goto_ff
    return-void

    .line 61
    :catch_100
    move-exception p0

    sput-boolean v1, Lcom/juhyeon/familyjournea/MoaRemote721;->sharing:Z

    sput-boolean v1, Lcom/juhyeon/familyjournea/MoaRemote721;->voice:Z

    invoke-static {}, Ljava/util/Collections;->emptyMap()Ljava/util/Map;

    move-result-object p0

    sput-object p0, Lcom/juhyeon/familyjournea/MoaRemote721;->ids:Ljava/util/Map;

    .line 62
    :goto_10b
    return-void
.end method

.method static uri(Ljava/lang/String;)Landroid/net/Uri;
    .locals 4

    .line 65
    const-string v0, "v"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_b

    sget-object v1, Landroid/provider/MediaStore$Video$Media;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;

    goto :goto_d

    :cond_b
    sget-object v1, Landroid/provider/MediaStore$Images$Media;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;

    :goto_d
    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_18

    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    :cond_18
    invoke-static {p0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v2

    invoke-static {v1, v2, v3}, Landroid/content/ContentUris;->withAppendedId(Landroid/net/Uri;J)Landroid/net/Uri;

    move-result-object p0

    return-object p0
.end method

.method static voiceId(Ljava/lang/String;)Z
    .locals 1

    .line 46
    if-eqz p0, :cond_c

    const-string v0, "a:[0-9]{4}-[0-9]{2}-[0-9]{2}:[A-Za-z0-9_-]{8,90}\\.m4a"

    invoke-virtual {p0, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_c

    const/4 p0, 0x1

    goto :goto_d

    :cond_c
    const/4 p0, 0x0

    :goto_d
    return p0
.end method

.method public static wifiAddress(Landroid/content/Context;)Ljava/net/InetAddress;
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 39
    :try_start_0
    const-class v0, Landroid/net/ConnectivityManager;

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/net/ConnectivityManager;

    invoke-virtual {p0}, Landroid/net/ConnectivityManager;->getAllNetworks()[Landroid/net/Network;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    :goto_e
    if-ge v2, v1, :cond_50

    aget-object v3, v0, v2

    invoke-virtual {p0, v3}, Landroid/net/ConnectivityManager;->getNetworkCapabilities(Landroid/net/Network;)Landroid/net/NetworkCapabilities;

    move-result-object v4

    if-eqz v4, :cond_4c

    const/4 v5, 0x1

    invoke-virtual {v4, v5}, Landroid/net/NetworkCapabilities;->hasTransport(I)Z

    move-result v5

    if-eqz v5, :cond_4c

    const/4 v5, 0x4

    invoke-virtual {v4, v5}, Landroid/net/NetworkCapabilities;->hasTransport(I)Z

    move-result v4

    if-eqz v4, :cond_27

    goto :goto_4c

    :cond_27
    invoke-virtual {p0, v3}, Landroid/net/ConnectivityManager;->getLinkProperties(Landroid/net/Network;)Landroid/net/LinkProperties;

    move-result-object v3

    if-eqz v3, :cond_4c

    invoke-virtual {v3}, Landroid/net/LinkProperties;->getLinkAddresses()Ljava/util/List;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_35
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_4c

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/net/LinkAddress;

    invoke-virtual {v4}, Landroid/net/LinkAddress;->getAddress()Ljava/net/InetAddress;

    move-result-object v4

    invoke-static {v4}, Lcom/juhyeon/familyjournea/MoaRemote721;->private4(Ljava/net/InetAddress;)Z

    move-result v5
    :try_end_49
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_49} :catch_4f

    if-eqz v5, :cond_35

    return-object v4

    :cond_4c
    :goto_4c
    add-int/lit8 v2, v2, 0x1

    goto :goto_e

    :catch_4f
    move-exception p0

    .line 40
    :cond_50
    :try_start_50
    invoke-static {}, Ljava/net/NetworkInterface;->getNetworkInterfaces()Ljava/util/Enumeration;

    move-result-object p0

    :cond_54
    :goto_54
    if-eqz p0, :cond_8d

    invoke-interface {p0}, Ljava/util/Enumeration;->hasMoreElements()Z

    move-result v0

    if-eqz v0, :cond_8d

    invoke-interface {p0}, Ljava/util/Enumeration;->nextElement()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/net/NetworkInterface;

    invoke-virtual {v0}, Ljava/net/NetworkInterface;->getName()Ljava/lang/String;

    move-result-object v1

    const-string v2, "(?:wlan|wifi)[0-9]+"

    invoke-virtual {v1, v2}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_54

    invoke-virtual {v0}, Ljava/net/NetworkInterface;->isUp()Z

    move-result v1

    if-nez v1, :cond_75

    goto :goto_54

    :cond_75
    invoke-virtual {v0}, Ljava/net/NetworkInterface;->getInetAddresses()Ljava/util/Enumeration;

    move-result-object v0

    :cond_79
    invoke-interface {v0}, Ljava/util/Enumeration;->hasMoreElements()Z

    move-result v1

    if-eqz v1, :cond_54

    invoke-interface {v0}, Ljava/util/Enumeration;->nextElement()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/net/InetAddress;

    invoke-static {v1}, Lcom/juhyeon/familyjournea/MoaRemote721;->private4(Ljava/net/InetAddress;)Z

    move-result v2
    :try_end_89
    .catch Ljava/lang/Exception; {:try_start_50 .. :try_end_89} :catch_8c

    if-eqz v2, :cond_79

    return-object v1

    :catch_8c
    move-exception p0

    .line 41
    :cond_8d
    new-instance p0, Ljava/io/IOException;

    const-string v0, "Wi-Fi IPv4 unavailable"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0
.end method
