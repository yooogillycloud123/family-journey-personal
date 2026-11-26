.class public final Lcom/juhyeon/familyjournea/MoaUpdate723;
.super Ljava/lang/Object;
.source "MoaUpdate723.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/juhyeon/familyjournea/MoaUpdate723$Result;
    }
.end annotation


# static fields
.field static final ASSET:Ljava/lang/String; = "https://raw.githubusercontent.com/yooogillycloud123/family-journey-personal/moa-update-channel/android/releases/"

.field public static final CERT:Ljava/lang/String; = "5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15"

.field public static final CHANNEL:Ljava/lang/String; = "https://raw.githubusercontent.com/yooogillycloud123/family-journey-personal/moa-update-channel/android/latest.json"

.field public static final PKG:Ljava/lang/String; = "com.juhyeon.familyjournea"

.field static final WORK:Ljava/util/concurrent/ExecutorService;

.field static volatile running:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 8
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    sput-object v0, Lcom/juhyeon/familyjournea/MoaUpdate723;->WORK:Ljava/util/concurrent/ExecutorService;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 4
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static allowed(Ljava/lang/String;)Z
    .locals 4

    .line 10
    const/4 v0, 0x0

    :try_start_1
    new-instance v1, Ljava/net/URI;

    invoke-direct {v1, p0}, Ljava/net/URI;-><init>(Ljava/lang/String;)V

    const-string v2, "https"

    invoke-virtual {v1}, Ljava/net/URI;->getScheme()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_28

    invoke-virtual {v1}, Ljava/net/URI;->getUserInfo()Ljava/lang/String;

    move-result-object v2

    if-nez v2, :cond_28

    invoke-virtual {v1}, Ljava/net/URI;->getPort()I

    move-result v1

    const/4 v2, -0x1

    if-ne v1, v2, :cond_28

    const-string v1, "https://raw.githubusercontent.com/yooogillycloud123/family-journey-personal/moa-update-channel/android/releases/"

    invoke-virtual {p0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0
    :try_end_25
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_25} :catch_29

    if-eqz p0, :cond_28

    const/4 v0, 0x1

    :cond_28
    return v0

    :catch_29
    move-exception p0

    return v0
.end method

.method static bounded(Ljava/io/InputStream;I)[B
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 12
    :try_start_0
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V
    :try_end_5
    .catchall {:try_start_0 .. :try_end_5} :catchall_3b

    const/16 v1, 0x2000

    :try_start_7
    new-array v1, v1, [B

    :goto_9
    invoke-virtual {p0, v1}, Ljava/io/InputStream;->read([B)I

    move-result v2

    const/4 v3, -0x1

    if-eq v2, v3, :cond_24

    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->size()I

    move-result v3

    add-int/2addr v3, v2

    if-gt v3, p1, :cond_1c

    const/4 v3, 0x0

    invoke-virtual {v0, v1, v3, v2}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_9

    :cond_1c
    new-instance p1, Ljava/io/IOException;

    const-string v1, "\uc751\ub2f5 \ud06c\uae30 \ucd08\uacfc"

    invoke-direct {p1, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    :cond_24
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p1
    :try_end_28
    .catchall {:try_start_7 .. :try_end_28} :catchall_31

    :try_start_28
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->close()V
    :try_end_2b
    .catchall {:try_start_28 .. :try_end_2b} :catchall_3b

    if-eqz p0, :cond_30

    invoke-virtual {p0}, Ljava/io/InputStream;->close()V

    :cond_30
    return-object p1

    :catchall_31
    move-exception p1

    :try_start_32
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->close()V
    :try_end_35
    .catchall {:try_start_32 .. :try_end_35} :catchall_36

    goto :goto_3a

    :catchall_36
    move-exception v0

    :try_start_37
    invoke-virtual {p1, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_3a
    throw p1
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

.method static download(Landroid/app/Activity;Lorg/json/JSONObject;)V
    .locals 2

    .line 17
    sget-boolean v0, Lcom/juhyeon/familyjournea/MoaUpdate723;->running:Z

    if-eqz v0, :cond_5

    return-void

    :cond_5
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/pm/PackageManager;->canRequestPackageInstalls()Z

    move-result v0

    if-nez v0, :cond_36

    new-instance p1, Landroid/app/AlertDialog$Builder;

    invoke-direct {p1, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v0, "\ucd5c\ucd08 1\ud68c \uc124\uce58 \uad8c\ud55c"

    invoke-virtual {p1, v0}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    const-string v0, "\ubaa8\uc544\uc758 \uc5c5\ub370\uc774\ud2b8 \uc124\uce58 \uad8c\ud55c\uc744 \ud5c8\uc6a9\ud55c \ub4a4 \ub2e4\uc2dc \uc5c5\ub370\uc774\ud2b8 \ud655\uc778\uc744 \ub204\ub974\uc138\uc694."

    invoke-virtual {p1, v0}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    new-instance v0, Lcom/juhyeon/familyjournea/MoaUpdate723$$ExternalSyntheticLambda4;

    invoke-direct {v0, p0}, Lcom/juhyeon/familyjournea/MoaUpdate723$$ExternalSyntheticLambda4;-><init>(Landroid/app/Activity;)V

    const-string p0, "\uc124\uc815 \uc5f4\uae30"

    invoke-virtual {p1, p0, v0}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    const-string p1, "\ucde8\uc18c"

    const/4 v0, 0x0

    invoke-virtual {p0, p1, v0}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    return-void

    :cond_36
    const/4 v0, 0x1

    sput-boolean v0, Lcom/juhyeon/familyjournea/MoaUpdate723;->running:Z

    sget-object v0, Lcom/juhyeon/familyjournea/MoaUpdate723;->WORK:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/juhyeon/familyjournea/MoaUpdate723$$ExternalSyntheticLambda5;

    invoke-direct {v1, p0, p1}, Lcom/juhyeon/familyjournea/MoaUpdate723$$ExternalSyntheticLambda5;-><init>(Landroid/app/Activity;Lorg/json/JSONObject;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method static get(Ljava/lang/String;Z)Ljava/net/HttpURLConnection;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 11
    const/4 v0, 0x0

    move v1, v0

    :goto_2
    const/4 v2, 0x5

    if-ge v1, v2, :cond_86

    if-eqz p1, :cond_10

    const-string v2, "https://raw.githubusercontent.com/yooogillycloud123/family-journey-personal/moa-update-channel/android/latest.json"

    invoke-virtual {v2, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_7e

    goto :goto_16

    :cond_10
    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaUpdate723;->allowed(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_7e

    :goto_16
    new-instance v2, Ljava/net/URL;

    invoke-direct {v2, p0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object p0

    check-cast p0, Ljava/net/HttpURLConnection;

    invoke-virtual {p0, v0}, Ljava/net/HttpURLConnection;->setInstanceFollowRedirects(Z)V

    const/16 v2, 0x2710

    invoke-virtual {p0, v2}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    const/16 v2, 0x4e20

    invoke-virtual {p0, v2}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    const-string v2, "Accept-Encoding"

    const-string v3, "identity"

    invoke-virtual {p0, v2, v3}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {p0, v0}, Ljava/net/HttpURLConnection;->setUseCaches(Z)V

    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v2

    const/16 v3, 0xc8

    if-ne v2, v3, :cond_41

    return-object p0

    :cond_41
    if-nez p1, :cond_62

    const/16 v3, 0x12c

    if-lt v2, v3, :cond_62

    const/16 v3, 0x190

    if-ge v2, v3, :cond_62

    const-string v2, "Location"

    invoke-virtual {p0, v2}, Ljava/net/HttpURLConnection;->getHeaderField(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->disconnect()V

    if-eqz v2, :cond_5a

    add-int/lit8 v1, v1, 0x1

    move-object p0, v2

    goto :goto_2

    :cond_5a
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\ubc30\ud3ec \uc8fc\uc18c \uc5c6\uc74c"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_62
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->disconnect()V

    new-instance p0, Ljava/io/IOException;

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "\ubc30\ud3ec \uc11c\ubc84 HTTP "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_7e
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\ud5c8\uc6a9\ub418\uc9c0 \uc54a\uc740 \ubc30\ud3ec \uc8fc\uc18c"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_86
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\ubc30\ud3ec \uc8fc\uc18c \uc774\ub3d9 \ucd08\uacfc"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method static hex([B)Ljava/lang/String;
    .locals 6

    .line 9
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    array-length v1, p0

    const/4 v2, 0x0

    :goto_7
    if-ge v2, v1, :cond_23

    aget-byte v3, p0, v2

    sget-object v4, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    and-int/lit16 v3, v3, 0xff

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    filled-new-array {v3}, [Ljava/lang/Object;

    move-result-object v3

    const-string v5, "%02x"

    invoke-static {v4, v5, v3}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v2, v2, 0x1

    goto :goto_7

    :cond_23
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static installed(Landroid/content/Context;)J
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 13
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p0

    const-string v0, "com.juhyeon.familyjournea"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/pm/PackageInfo;->getLongVersionCode()J

    move-result-wide v0

    return-wide v0
.end method

.method static synthetic lambda$download$4(Landroid/app/Activity;Landroid/content/DialogInterface;I)V
    .locals 1

    .line 17
    new-instance p1, Landroid/content/Intent;

    const-string p2, "package:com.juhyeon.familyjournea"

    invoke-static {p2}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p2

    const-string v0, "android.settings.MANAGE_UNKNOWN_APP_SOURCES"

    invoke-direct {p1, v0, p2}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    invoke-virtual {p0, p1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method static synthetic lambda$download$5(Landroid/app/Activity;Lorg/json/JSONObject;)V
    .locals 19

    .line 17
    move-object/from16 v1, p0

    move-object/from16 v0, p1

    const-string v2, "com.juhyeon.familyjournea"

    const-string v3, "SHA-256"

    const-string v4, "versionCode"

    new-instance v5, Ljava/io/File;

    invoke-virtual/range {p0 .. p0}, Landroid/app/Activity;->getCacheDir()Ljava/io/File;

    move-result-object v6

    const-string v7, "moa-verified-update.apk"

    invoke-direct {v5, v6, v7}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual/range {p0 .. p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v6

    invoke-virtual {v6}, Landroid/content/pm/PackageManager;->getPackageInstaller()Landroid/content/pm/PackageInstaller;

    move-result-object v6

    const/4 v7, 0x0

    const/4 v8, -0x1

    :try_start_1f
    invoke-static/range {p0 .. p0}, Lcom/juhyeon/familyjournea/MoaUpdate723;->installed(Landroid/content/Context;)J

    move-result-wide v9

    invoke-static {v0, v9, v10}, Lcom/juhyeon/familyjournea/MoaUpdate723;->validate(Lorg/json/JSONObject;J)Lorg/json/JSONObject;

    invoke-virtual {v0, v4}, Lorg/json/JSONObject;->getLong(Ljava/lang/String;)J

    move-result-wide v11

    cmp-long v9, v11, v9

    if-lez v9, :cond_1e4

    const-string v9, "bytes"

    invoke-virtual {v0, v9}, Lorg/json/JSONObject;->getLong(Ljava/lang/String;)J

    move-result-wide v14

    invoke-static {v3}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v9

    const-string v10, "apkUrl"

    invoke-virtual {v0, v10}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    invoke-static {v10, v7}, Lcom/juhyeon/familyjournea/MoaUpdate723;->get(Ljava/lang/String;Z)Ljava/net/HttpURLConnection;

    move-result-object v10
    :try_end_42
    .catch Ljava/lang/Exception; {:try_start_1f .. :try_end_42} :catch_1f3
    .catchall {:try_start_1f .. :try_end_42} :catchall_1f1

    :try_start_42
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v11
    :try_end_46
    .catchall {:try_start_42 .. :try_end_46} :catchall_1de

    :try_start_46
    new-instance v12, Ljava/io/FileOutputStream;

    invoke-direct {v12, v5}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_4b
    .catchall {:try_start_46 .. :try_end_4b} :catchall_1cd

    const/high16 v13, 0x10000

    :try_start_4d
    new-array v7, v13, [B

    const-wide/16 v16, 0x0

    :goto_51
    invoke-virtual {v11, v7}, Ljava/io/InputStream;->read([B)I

    move-result v13
    :try_end_55
    .catchall {:try_start_4d .. :try_end_55} :catchall_1be

    if-eq v13, v8, :cond_7b

    move-object/from16 v18, v9

    int-to-long v8, v13

    add-long v16, v16, v8

    cmp-long v8, v16, v14

    if-gtz v8, :cond_73

    move-object/from16 v8, v18

    const/4 v9, 0x0

    :try_start_63
    invoke-virtual {v8, v7, v9, v13}, Ljava/security/MessageDigest;->update([BII)V

    invoke-virtual {v12, v7, v9, v13}, Ljava/io/FileOutputStream;->write([BII)V

    move-object v9, v8

    const/4 v8, -0x1

    const/high16 v13, 0x10000

    goto :goto_51

    :catchall_6e
    move-exception v0

    move-object v2, v0

    const/4 v9, -0x1

    goto/16 :goto_1c1

    :cond_73
    new-instance v0, Ljava/io/IOException;

    const-string v2, "\ud30c\uc77c \ud06c\uae30 \ubd88\uc77c\uce58"

    invoke-direct {v0, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_7b
    .catchall {:try_start_63 .. :try_end_7b} :catchall_6e

    :cond_7b
    move-object v8, v9

    :try_start_7c
    invoke-virtual {v12}, Ljava/io/FileOutputStream;->getFD()Ljava/io/FileDescriptor;

    move-result-object v7

    invoke-virtual {v7}, Ljava/io/FileDescriptor;->sync()V
    :try_end_83
    .catchall {:try_start_7c .. :try_end_83} :catchall_1bb

    :try_start_83
    invoke-virtual {v12}, Ljava/io/FileOutputStream;->close()V
    :try_end_86
    .catchall {:try_start_83 .. :try_end_86} :catchall_1b8

    if-eqz v11, :cond_90

    :try_start_88
    invoke-virtual {v11}, Ljava/io/InputStream;->close()V
    :try_end_8b
    .catchall {:try_start_88 .. :try_end_8b} :catchall_8c

    goto :goto_90

    :catchall_8c
    move-exception v0

    const/4 v9, -0x1

    goto/16 :goto_1e0

    :cond_90
    :goto_90
    :try_start_90
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->disconnect()V

    cmp-long v7, v16, v14

    if-nez v7, :cond_1ac

    invoke-virtual {v8}, Ljava/security/MessageDigest;->digest()[B

    move-result-object v7

    invoke-static {v7}, Lcom/juhyeon/familyjournea/MoaUpdate723;->hex([B)Ljava/lang/String;

    move-result-object v7

    const-string v8, "sha256"

    invoke-virtual {v0, v8}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v7, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_1ac

    invoke-virtual/range {p0 .. p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v7

    invoke-virtual {v5}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v8

    const/high16 v9, 0x8000000

    invoke-virtual {v7, v8, v9}, Landroid/content/pm/PackageManager;->getPackageArchiveInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v7

    if-eqz v7, :cond_1a3

    iget-object v8, v7, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    invoke-virtual {v2, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_1a3

    invoke-virtual {v7}, Landroid/content/pm/PackageInfo;->getLongVersionCode()J

    move-result-wide v8

    invoke-virtual {v0, v4}, Lorg/json/JSONObject;->getLong(Ljava/lang/String;)J

    move-result-wide v10

    cmp-long v0, v8, v10

    if-nez v0, :cond_1a3

    iget-object v0, v7, Landroid/content/pm/PackageInfo;->signingInfo:Landroid/content/pm/SigningInfo;

    if-eqz v0, :cond_1a3

    iget-object v0, v7, Landroid/content/pm/PackageInfo;->signingInfo:Landroid/content/pm/SigningInfo;

    invoke-virtual {v0}, Landroid/content/pm/SigningInfo;->getApkContentsSigners()[Landroid/content/pm/Signature;

    move-result-object v0

    array-length v0, v0

    const/4 v4, 0x1

    if-ne v0, v4, :cond_1a3

    const-string v0, "5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15"

    invoke-static {v3}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v3

    iget-object v7, v7, Landroid/content/pm/PackageInfo;->signingInfo:Landroid/content/pm/SigningInfo;

    invoke-virtual {v7}, Landroid/content/pm/SigningInfo;->getApkContentsSigners()[Landroid/content/pm/Signature;

    move-result-object v7

    const/4 v8, 0x0

    aget-object v7, v7, v8

    invoke-virtual {v7}, Landroid/content/pm/Signature;->toByteArray()[B

    move-result-object v7

    invoke-virtual {v3, v7}, Ljava/security/MessageDigest;->digest([B)[B

    move-result-object v3

    invoke-static {v3}, Lcom/juhyeon/familyjournea/MoaUpdate723;->hex([B)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1a3

    new-instance v0, Landroid/content/pm/PackageInstaller$SessionParams;

    invoke-direct {v0, v4}, Landroid/content/pm/PackageInstaller$SessionParams;-><init>(I)V

    invoke-virtual {v0, v2}, Landroid/content/pm/PackageInstaller$SessionParams;->setAppPackageName(Ljava/lang/String;)V

    invoke-virtual {v0, v14, v15}, Landroid/content/pm/PackageInstaller$SessionParams;->setSize(J)V

    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I
    :try_end_10b
    .catch Ljava/lang/Exception; {:try_start_90 .. :try_end_10b} :catch_1b5
    .catchall {:try_start_90 .. :try_end_10b} :catchall_1f1

    const/16 v3, 0x1f

    if-lt v2, v3, :cond_118

    :try_start_10f
    invoke-virtual {v0, v4}, Landroid/content/pm/PackageInstaller$SessionParams;->setRequireUserAction(I)V
    :try_end_112
    .catch Ljava/lang/Exception; {:try_start_10f .. :try_end_112} :catch_113
    .catchall {:try_start_10f .. :try_end_112} :catchall_1f1

    goto :goto_118

    :catch_113
    move-exception v0

    move-object v2, v0

    const/4 v8, -0x1

    goto/16 :goto_1f6

    :cond_118
    :goto_118
    :try_start_118
    invoke-virtual {v6, v0}, Landroid/content/pm/PackageInstaller;->createSession(Landroid/content/pm/PackageInstaller$SessionParams;)I

    move-result v2
    :try_end_11c
    .catch Ljava/lang/Exception; {:try_start_118 .. :try_end_11c} :catch_1b5
    .catchall {:try_start_118 .. :try_end_11c} :catchall_1f1

    :try_start_11c
    invoke-virtual {v6, v2}, Landroid/content/pm/PackageInstaller;->openSession(I)Landroid/content/pm/PackageInstaller$Session;

    move-result-object v3
    :try_end_120
    .catch Ljava/lang/Exception; {:try_start_11c .. :try_end_120} :catch_19f
    .catchall {:try_start_11c .. :try_end_120} :catchall_1f1

    :try_start_120
    new-instance v4, Ljava/io/FileInputStream;

    invoke-direct {v4, v5}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_125
    .catchall {:try_start_120 .. :try_end_125} :catchall_18d

    :try_start_125
    const-string v11, "base.apk"

    const-wide/16 v12, 0x0

    move-object v10, v3

    const/high16 v0, 0x10000

    invoke-virtual/range {v10 .. v15}, Landroid/content/pm/PackageInstaller$Session;->openWrite(Ljava/lang/String;JJ)Ljava/io/OutputStream;

    move-result-object v7
    :try_end_130
    .catchall {:try_start_125 .. :try_end_130} :catchall_17e

    :try_start_130
    new-array v0, v0, [B

    :goto_132
    invoke-virtual {v4, v0}, Ljava/io/InputStream;->read([B)I

    move-result v8

    const/4 v9, -0x1

    if-eq v8, v9, :cond_13e

    const/4 v10, 0x0

    invoke-virtual {v7, v0, v10, v8}, Ljava/io/OutputStream;->write([BII)V

    goto :goto_132

    :cond_13e
    invoke-virtual {v3, v7}, Landroid/content/pm/PackageInstaller$Session;->fsync(Ljava/io/OutputStream;)V

    invoke-virtual {v7}, Ljava/io/OutputStream;->close()V

    new-instance v0, Landroid/content/Intent;

    const-class v8, Lcom/juhyeon/familyjournea/MoaUpdate723$Result;

    invoke-direct {v0, v1, v8}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const/high16 v8, 0xa000000

    invoke-static {v1, v2, v0, v8}, Landroid/app/PendingIntent;->getBroadcast(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/PendingIntent;->getIntentSender()Landroid/content/IntentSender;

    move-result-object v0

    invoke-virtual {v3, v0}, Landroid/content/pm/PackageInstaller$Session;->commit(Landroid/content/IntentSender;)V
    :try_end_158
    .catchall {:try_start_130 .. :try_end_158} :catchall_170

    if-eqz v7, :cond_162

    :try_start_15a
    invoke-virtual {v7}, Ljava/io/OutputStream;->close()V
    :try_end_15d
    .catchall {:try_start_15a .. :try_end_15d} :catchall_15e

    goto :goto_162

    :catchall_15e
    move-exception v0

    move-object v2, v0

    move v8, v9

    goto :goto_181

    :cond_162
    :goto_162
    :try_start_162
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V
    :try_end_165
    .catchall {:try_start_162 .. :try_end_165} :catchall_16c

    if-eqz v3, :cond_217

    :try_start_167
    invoke-virtual {v3}, Landroid/content/pm/PackageInstaller$Session;->close()V
    :try_end_16a
    .catch Ljava/lang/Exception; {:try_start_167 .. :try_end_16a} :catch_1ed
    .catchall {:try_start_167 .. :try_end_16a} :catchall_1f1

    goto/16 :goto_217

    :catchall_16c
    move-exception v0

    move-object v2, v0

    move v8, v9

    goto :goto_190

    :catchall_170
    move-exception v0

    move-object v8, v0

    if-eqz v7, :cond_17d

    :try_start_174
    invoke-virtual {v7}, Ljava/io/OutputStream;->close()V
    :try_end_177
    .catchall {:try_start_174 .. :try_end_177} :catchall_178

    goto :goto_17d

    :catchall_178
    move-exception v0

    move-object v7, v0

    :try_start_17a
    invoke-virtual {v8, v7}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_17d
    :goto_17d
    throw v8
    :try_end_17e
    .catchall {:try_start_17a .. :try_end_17e} :catchall_17e

    :catchall_17e
    move-exception v0

    move v8, v2

    move-object v2, v0

    :goto_181
    :try_start_181
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V
    :try_end_184
    .catchall {:try_start_181 .. :try_end_184} :catchall_185

    goto :goto_18a

    :catchall_185
    move-exception v0

    move-object v4, v0

    :try_start_187
    invoke-virtual {v2, v4}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_18a
    throw v2
    :try_end_18b
    .catchall {:try_start_187 .. :try_end_18b} :catchall_18b

    :catchall_18b
    move-exception v0

    goto :goto_18f

    :catchall_18d
    move-exception v0

    move v8, v2

    :goto_18f
    move-object v2, v0

    :goto_190
    if-eqz v3, :cond_19b

    :try_start_192
    invoke-virtual {v3}, Landroid/content/pm/PackageInstaller$Session;->close()V
    :try_end_195
    .catchall {:try_start_192 .. :try_end_195} :catchall_196

    goto :goto_19b

    :catchall_196
    move-exception v0

    move-object v3, v0

    :try_start_198
    invoke-virtual {v2, v3}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_19b
    :goto_19b
    throw v2
    :try_end_19c
    .catch Ljava/lang/Exception; {:try_start_198 .. :try_end_19c} :catch_19c
    .catchall {:try_start_198 .. :try_end_19c} :catchall_1f1

    :catch_19c
    move-exception v0

    goto/16 :goto_1f5

    :catch_19f
    move-exception v0

    move v8, v2

    goto/16 :goto_1f5

    :cond_1a3
    const/4 v9, -0x1

    :try_start_1a4
    new-instance v0, Ljava/io/IOException;

    const-string v2, "APK \ud328\ud0a4\uc9c0\u00b7\ubc84\uc804\u00b7\uc11c\uba85 \ubd88\uc77c\uce58"

    invoke-direct {v0, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    :goto_1ab
    throw v0

    :cond_1ac
    const/4 v9, -0x1

    new-instance v0, Ljava/io/IOException;

    const-string v2, "SHA-256 \uac80\uc99d \uc2e4\ud328"

    invoke-direct {v0, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V
    :try_end_1b4
    .catch Ljava/lang/Exception; {:try_start_1a4 .. :try_end_1b4} :catch_1ed
    .catchall {:try_start_1a4 .. :try_end_1b4} :catchall_1f1

    goto :goto_1ab

    :catch_1b5
    move-exception v0

    const/4 v9, -0x1

    goto :goto_1ee

    :catchall_1b8
    move-exception v0

    const/4 v9, -0x1

    goto :goto_1cf

    :catchall_1bb
    move-exception v0

    const/4 v9, -0x1

    goto :goto_1c0

    :catchall_1be
    move-exception v0

    move v9, v8

    :goto_1c0
    move-object v2, v0

    :goto_1c1
    :try_start_1c1
    invoke-virtual {v12}, Ljava/io/FileOutputStream;->close()V
    :try_end_1c4
    .catchall {:try_start_1c1 .. :try_end_1c4} :catchall_1c5

    goto :goto_1ca

    :catchall_1c5
    move-exception v0

    move-object v3, v0

    :try_start_1c7
    invoke-virtual {v2, v3}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_1ca
    throw v2
    :try_end_1cb
    .catchall {:try_start_1c7 .. :try_end_1cb} :catchall_1cb

    :catchall_1cb
    move-exception v0

    goto :goto_1cf

    :catchall_1cd
    move-exception v0

    move v9, v8

    :goto_1cf
    move-object v2, v0

    if-eqz v11, :cond_1db

    :try_start_1d2
    invoke-virtual {v11}, Ljava/io/InputStream;->close()V
    :try_end_1d5
    .catchall {:try_start_1d2 .. :try_end_1d5} :catchall_1d6

    goto :goto_1db

    :catchall_1d6
    move-exception v0

    move-object v3, v0

    :try_start_1d8
    invoke-virtual {v2, v3}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_1db
    :goto_1db
    throw v2
    :try_end_1dc
    .catchall {:try_start_1d8 .. :try_end_1dc} :catchall_1dc

    :catchall_1dc
    move-exception v0

    goto :goto_1e0

    :catchall_1de
    move-exception v0

    move v9, v8

    :goto_1e0
    :try_start_1e0
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->disconnect()V

    goto :goto_1ab

    :cond_1e4
    move v9, v8

    new-instance v0, Ljava/io/IOException;

    const-string v2, "\uc774\ubbf8 \ucd5c\uc2e0 \ubc84\uc804"

    invoke-direct {v0, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V
    :try_end_1ec
    .catch Ljava/lang/Exception; {:try_start_1e0 .. :try_end_1ec} :catch_1ed
    .catchall {:try_start_1e0 .. :try_end_1ec} :catchall_1f1

    goto :goto_1ab

    :catch_1ed
    move-exception v0

    :goto_1ee
    move-object v2, v0

    move v8, v9

    goto :goto_1f6

    :catchall_1f1
    move-exception v0

    goto :goto_21e

    :catch_1f3
    move-exception v0

    move v9, v8

    :goto_1f5
    move-object v2, v0

    :goto_1f6
    if-ltz v8, :cond_1fd

    :try_start_1f8
    invoke-virtual {v6, v8}, Landroid/content/pm/PackageInstaller;->abandonSession(I)V
    :try_end_1fb
    .catch Ljava/lang/Exception; {:try_start_1f8 .. :try_end_1fb} :catch_1fc
    .catchall {:try_start_1f8 .. :try_end_1fb} :catchall_1f1

    goto :goto_1fd

    :catch_1fc
    move-exception v0

    :cond_1fd
    :goto_1fd
    :try_start_1fd
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\uc124\uce58 \uc900\ube44 \uc2e4\ud328 \u00b7 "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v2}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Lcom/juhyeon/familyjournea/MoaUpdate723;->msg(Landroid/app/Activity;Ljava/lang/String;)V
    :try_end_217
    .catchall {:try_start_1fd .. :try_end_217} :catchall_1f1

    :cond_217
    :goto_217
    invoke-virtual {v5}, Ljava/io/File;->delete()Z

    const/4 v1, 0x0

    sput-boolean v1, Lcom/juhyeon/familyjournea/MoaUpdate723;->running:Z

    return-void

    :goto_21e
    invoke-virtual {v5}, Ljava/io/File;->delete()Z

    const/4 v1, 0x0

    sput-boolean v1, Lcom/juhyeon/familyjournea/MoaUpdate723;->running:Z

    throw v0
.end method

.method static synthetic lambda$msg$0(Landroid/app/Activity;Ljava/lang/String;)V
    .locals 1

    .line 15
    invoke-virtual {p0}, Landroid/app/Activity;->isFinishing()Z

    move-result v0

    if-nez v0, :cond_25

    invoke-virtual {p0}, Landroid/app/Activity;->isDestroyed()Z

    move-result v0

    if-nez v0, :cond_25

    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string p0, "\ubaa8\uc544 \uc5c5\ub370\uc774\ud2b8"

    invoke-virtual {v0, p0}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    const-string p1, "\ud655\uc778"

    const/4 v0, 0x0

    invoke-virtual {p0, p1, v0}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    :cond_25
    return-void
.end method

.method static synthetic lambda$open$1(Landroid/app/Activity;Lorg/json/JSONObject;Landroid/content/DialogInterface;I)V
    .locals 0

    .line 16
    invoke-static {p0, p1}, Lcom/juhyeon/familyjournea/MoaUpdate723;->download(Landroid/app/Activity;Lorg/json/JSONObject;)V

    return-void
.end method

.method static synthetic lambda$open$2(Landroid/app/Activity;JJLorg/json/JSONObject;)V
    .locals 3

    .line 16
    invoke-virtual {p0}, Landroid/app/Activity;->isFinishing()Z

    move-result v0

    if-nez v0, :cond_77

    invoke-virtual {p0}, Landroid/app/Activity;->isDestroyed()Z

    move-result v0

    if-eqz v0, :cond_d

    goto :goto_77

    :cond_d
    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\uc0c8 \ubc84\uc804 R"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\ud604\uc7ac R"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p3, p4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p3

    const-string p4, " \u2192 R"

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, "\n"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, "notes"

    const-string p3, ""

    invoke-virtual {p5, p2, p3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, "\n\uae30\uc874 \uc790\ub8cc\ub97c \uc720\uc9c0\ud558\ub294 \uc5c5\ub370\uc774\ud2b8 \uc124\uce58\uc785\ub2c8\ub2e4."

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    new-instance p2, Lcom/juhyeon/familyjournea/MoaUpdate723$$ExternalSyntheticLambda0;

    invoke-direct {p2, p0, p5}, Lcom/juhyeon/familyjournea/MoaUpdate723$$ExternalSyntheticLambda0;-><init>(Landroid/app/Activity;Lorg/json/JSONObject;)V

    const-string p0, "\ub2e4\uc6b4\ub85c\ub4dc \ubc0f \uc124\uce58"

    invoke-virtual {p1, p0, p2}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    const-string p1, "\ucde8\uc18c"

    const/4 p2, 0x0

    invoke-virtual {p0, p1, p2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    :cond_77
    :goto_77
    return-void
.end method

.method static synthetic lambda$open$3(Landroid/app/Activity;)V
    .locals 9

    .line 16
    const/4 v0, 0x0

    :try_start_1
    invoke-static {p0}, Lcom/juhyeon/familyjournea/MoaUpdate723;->installed(Landroid/content/Context;)J

    move-result-wide v5

    const-string v1, "https://raw.githubusercontent.com/yooogillycloud123/family-journey-personal/moa-update-channel/android/latest.json"

    const/4 v2, 0x1

    invoke-static {v1, v2}, Lcom/juhyeon/familyjournea/MoaUpdate723;->get(Ljava/lang/String;Z)Ljava/net/HttpURLConnection;

    move-result-object v1
    :try_end_c
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_c} :catch_87
    .catchall {:try_start_1 .. :try_end_c} :catchall_85

    :try_start_c
    new-instance v2, Lorg/json/JSONObject;

    new-instance v3, Ljava/lang/String;

    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v4

    const v7, 0x8000

    invoke-static {v4, v7}, Lcom/juhyeon/familyjournea/MoaUpdate723;->bounded(Ljava/io/InputStream;I)[B

    move-result-object v4

    sget-object v7, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v3, v4, v7}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-direct {v2, v3}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    invoke-static {v2, v5, v6}, Lcom/juhyeon/familyjournea/MoaUpdate723;->validate(Lorg/json/JSONObject;J)Lorg/json/JSONObject;

    move-result-object v7
    :try_end_27
    .catchall {:try_start_c .. :try_end_27} :catchall_80

    :try_start_27
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->disconnect()V

    const-string v1, "versionCode"

    invoke-virtual {v7, v1}, Lorg/json/JSONObject;->getLong(Ljava/lang/String;)J

    move-result-wide v3

    const-string v1, "published"

    invoke-virtual {v7, v1, v0}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v1

    if-nez v1, :cond_57

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\uc124\uce58 \ubc84\uc804 R"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " \u00b7 GitHub APK \ubc30\ud3ec \ub300\uae30 \uc911\uc785\ub2c8\ub2e4."

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :goto_51
    invoke-static {p0, v1}, Lcom/juhyeon/familyjournea/MoaUpdate723;->msg(Landroid/app/Activity;Ljava/lang/String;)V
    :try_end_54
    .catch Ljava/lang/Exception; {:try_start_27 .. :try_end_54} :catch_87
    .catchall {:try_start_27 .. :try_end_54} :catchall_85

    sput-boolean v0, Lcom/juhyeon/familyjournea/MoaUpdate723;->running:Z

    return-void

    :cond_57
    cmp-long v1, v3, v5

    if-gtz v1, :cond_75

    :try_start_5b
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\ud604\uc7ac R"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " \u00b7 \ucd5c\uc2e0 \ubc30\ud3ec \ubc84\uc804\uc785\ub2c8\ub2e4."

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    goto :goto_51

    :cond_75
    new-instance v8, Lcom/juhyeon/familyjournea/MoaUpdate723$$ExternalSyntheticLambda2;

    move-object v1, v8

    move-object v2, p0

    invoke-direct/range {v1 .. v7}, Lcom/juhyeon/familyjournea/MoaUpdate723$$ExternalSyntheticLambda2;-><init>(Landroid/app/Activity;JJLorg/json/JSONObject;)V

    invoke-virtual {p0, v8}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    goto :goto_a2

    :catchall_80
    move-exception v2

    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->disconnect()V

    throw v2
    :try_end_85
    .catch Ljava/lang/Exception; {:try_start_5b .. :try_end_85} :catch_87
    .catchall {:try_start_5b .. :try_end_85} :catchall_85

    :catchall_85
    move-exception p0

    goto :goto_a5

    :catch_87
    move-exception v1

    :try_start_88
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\ubc84\uc804 \ud655\uc778 \uc2e4\ud328 \u00b7 "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {p0, v1}, Lcom/juhyeon/familyjournea/MoaUpdate723;->msg(Landroid/app/Activity;Ljava/lang/String;)V
    :try_end_a2
    .catchall {:try_start_88 .. :try_end_a2} :catchall_85

    :goto_a2
    sput-boolean v0, Lcom/juhyeon/familyjournea/MoaUpdate723;->running:Z

    return-void

    :goto_a5
    sput-boolean v0, Lcom/juhyeon/familyjournea/MoaUpdate723;->running:Z

    throw p0
.end method

.method static msg(Landroid/app/Activity;Ljava/lang/String;)V
    .locals 1

    .line 15
    new-instance v0, Lcom/juhyeon/familyjournea/MoaUpdate723$$ExternalSyntheticLambda3;

    invoke-direct {v0, p0, p1}, Lcom/juhyeon/familyjournea/MoaUpdate723$$ExternalSyntheticLambda3;-><init>(Landroid/app/Activity;Ljava/lang/String;)V

    invoke-virtual {p0, v0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method

.method public static open(Landroid/app/Activity;)V
    .locals 2

    .line 16
    if-eqz p0, :cond_20

    invoke-virtual {p0}, Landroid/app/Activity;->isFinishing()Z

    move-result v0

    if-eqz v0, :cond_9

    goto :goto_20

    :cond_9
    sget-boolean v0, Lcom/juhyeon/familyjournea/MoaUpdate723;->running:Z

    if-eqz v0, :cond_13

    const-string v0, "\uc5c5\ub370\uc774\ud2b8 \ud655\uc778 \ub610\ub294 \ub2e4\uc6b4\ub85c\ub4dc \uc911\uc785\ub2c8\ub2e4."

    invoke-static {p0, v0}, Lcom/juhyeon/familyjournea/MoaUpdate723;->msg(Landroid/app/Activity;Ljava/lang/String;)V

    return-void

    :cond_13
    const/4 v0, 0x1

    sput-boolean v0, Lcom/juhyeon/familyjournea/MoaUpdate723;->running:Z

    sget-object v0, Lcom/juhyeon/familyjournea/MoaUpdate723;->WORK:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/juhyeon/familyjournea/MoaUpdate723$$ExternalSyntheticLambda1;

    invoke-direct {v1, p0}, Lcom/juhyeon/familyjournea/MoaUpdate723$$ExternalSyntheticLambda1;-><init>(Landroid/app/Activity;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    :cond_20
    :goto_20
    return-void
.end method

.method static validate(Lorg/json/JSONObject;J)Lorg/json/JSONObject;
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 14
    const-string v0, "packageName"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "com.juhyeon.familyjournea"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_9b

    const-string v0, "signerSha256"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_9b

    const-string v0, "versionCode"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getLong(Ljava/lang/String;)J

    move-result-wide v0

    cmp-long p1, v0, p1

    if-lez p1, :cond_9a

    const-string p1, "published"

    const/4 p2, 0x0

    invoke-virtual {p0, p1, p2}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result p1

    if-nez p1, :cond_30

    goto :goto_9a

    :cond_30
    const-wide/32 p1, 0x7fffffff

    cmp-long p1, v0, p1

    if-gtz p1, :cond_92

    const-wide/16 p1, 0x1

    cmp-long p1, v0, p1

    if-ltz p1, :cond_92

    const-string p1, "sha256"

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const-string p2, "[a-f0-9]{64}"

    invoke-virtual {p1, p2}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_92

    const-string p1, "bytes"

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->getLong(Ljava/lang/String;)J

    move-result-wide v2

    const-wide/16 v4, 0x0

    cmp-long p2, v2, v4

    if-lez p2, :cond_92

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->getLong(Ljava/lang/String;)J

    move-result-wide p1

    const-wide/32 v2, 0x6400000

    cmp-long p1, p1, v2

    if-gtz p1, :cond_92

    const-string p1, "apkUrl"

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "https://raw.githubusercontent.com/yooogillycloud123/family-journey-personal/moa-update-channel/android/releases/moa-r"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ".apk"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_92

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/juhyeon/familyjournea/MoaUpdate723;->allowed(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_92

    return-object p0

    :cond_92
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\ubc30\ud3ec \uba85\uc138 \uc624\ub958"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_9a
    :goto_9a
    return-object p0

    :cond_9b
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\ubc30\ud3ec \ub300\uc0c1 \ub610\ub294 \uc11c\uba85 \ubd88\uc77c\uce58"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0
.end method
