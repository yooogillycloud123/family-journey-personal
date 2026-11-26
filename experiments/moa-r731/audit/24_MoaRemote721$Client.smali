.class final Lcom/juhyeon/familyjournea/MoaRemote721$Client;
.super Ljava/lang/Object;
.source "MoaRemote721.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/juhyeon/familyjournea/MoaRemote721;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "Client"
.end annotation


# instance fields
.field final base:Ljava/lang/String;

.field final pin:[B

.field final tls:Ljavax/net/ssl/SSLSocketFactory;

.field final token:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 125
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 126
    new-instance v0, Ljava/net/URI;

    invoke-direct {v0, p1}, Ljava/net/URI;-><init>(Ljava/lang/String;)V

    const-string p1, "https"

    invoke-virtual {v0}, Ljava/net/URI;->getScheme()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_bb

    invoke-virtual {v0}, Ljava/net/URI;->getPort()I

    move-result p1

    const v1, 0x9524

    if-ne p1, v1, :cond_bb

    invoke-virtual {v0}, Ljava/net/URI;->getHost()Ljava/lang/String;

    move-result-object p1

    if-eqz p1, :cond_bb

    invoke-virtual {v0}, Ljava/net/URI;->getHost()Ljava/lang/String;

    move-result-object p1

    const-string v1, "[0-9.]+"

    invoke-virtual {p1, v1}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_bb

    invoke-virtual {v0}, Ljava/net/URI;->getUserInfo()Ljava/lang/String;

    move-result-object p1

    if-nez p1, :cond_bb

    invoke-virtual {v0}, Ljava/net/URI;->getFragment()Ljava/lang/String;

    move-result-object p1

    if-nez p1, :cond_bb

    invoke-virtual {v0}, Ljava/net/URI;->getQuery()Ljava/lang/String;

    move-result-object p1

    if-nez p1, :cond_bb

    const-string p1, ""

    invoke-virtual {v0}, Ljava/net/URI;->getPath()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_bb

    invoke-virtual {v0}, Ljava/net/URI;->getHost()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Ljava/net/InetAddress;->getByName(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object p1

    invoke-virtual {p1}, Ljava/net/InetAddress;->isSiteLocalAddress()Z

    move-result p1

    if-eqz p1, :cond_bb

    invoke-virtual {v0}, Ljava/net/URI;->toString()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->base:Ljava/lang/String;

    iput-object p2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->token:Ljava/lang/String;

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->token:Ljava/lang/String;

    const-string p2, "[a-f0-9]{64}"

    invoke-virtual {p1, p2}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_b3

    invoke-virtual {p3, p2}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_b3

    const/16 p1, 0x20

    new-array p2, p1, [B

    iput-object p2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->pin:[B

    const/4 p2, 0x0

    move v0, p2

    :goto_7b
    if-ge v0, p1, :cond_93

    iget-object v1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->pin:[B

    mul-int/lit8 v2, v0, 0x2

    add-int/lit8 v3, v2, 0x2

    invoke-virtual {p3, v2, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    const/16 v3, 0x10

    invoke-static {v2, v3}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;I)I

    move-result v2

    int-to-byte v2, v2

    aput-byte v2, v1, v0

    add-int/lit8 v0, v0, 0x1

    goto :goto_7b

    .line 127
    :cond_93
    new-instance p1, Lcom/juhyeon/familyjournea/MoaRemote721$Client$1;

    invoke-direct {p1, p0}, Lcom/juhyeon/familyjournea/MoaRemote721$Client$1;-><init>(Lcom/juhyeon/familyjournea/MoaRemote721$Client;)V

    const-string p3, "TLS"

    invoke-static {p3}, Ljavax/net/ssl/SSLContext;->getInstance(Ljava/lang/String;)Ljavax/net/ssl/SSLContext;

    move-result-object p3

    const/4 v0, 0x1

    new-array v0, v0, [Ljavax/net/ssl/TrustManager;

    aput-object p1, v0, p2

    new-instance p1, Ljava/security/SecureRandom;

    invoke-direct {p1}, Ljava/security/SecureRandom;-><init>()V

    const/4 p2, 0x0

    invoke-virtual {p3, p2, v0, p1}, Ljavax/net/ssl/SSLContext;->init([Ljavax/net/ssl/KeyManager;[Ljavax/net/ssl/TrustManager;Ljava/security/SecureRandom;)V

    invoke-virtual {p3}, Ljavax/net/ssl/SSLContext;->getSocketFactory()Ljavax/net/ssl/SSLSocketFactory;

    move-result-object p1

    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->tls:Ljavax/net/ssl/SSLSocketFactory;

    .line 128
    return-void

    .line 126
    :cond_b3
    new-instance p1, Ljava/io/IOException;

    const-string p2, "Pairing required"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    :cond_bb
    new-instance p1, Ljava/io/IOException;

    const-string p2, "Private LAN only"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method constructor <init>(Lorg/json/JSONObject;)V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 124
    const-string v0, "url"

    invoke-virtual {p1, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "token"

    invoke-virtual {p1, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "pin"

    invoke-virtual {p1, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, v0, v1, p1}, Lcom/juhyeon/familyjournea/MoaRemote721$Client;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method get(Ljava/lang/String;IJJJ)[B
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 131
    sget-boolean v0, Lcom/juhyeon/familyjournea/MoaRemote721;->clientAllowed:Z

    if-eqz v0, :cond_173

    new-instance v0, Ljava/net/URL;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->base:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v0, p1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->pin:[B

    iget-object v2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->token:Ljava/lang/String;

    invoke-static {v0, v1, v2}, Lcom/juhyeon/familyjournea/MoaLan725;->openPeer(Ljava/net/URL;[BLjava/lang/String;)Ljava/net/URLConnection;

    move-result-object p1

    check-cast p1, Ljavax/net/ssl/HttpsURLConnection;

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->tls:Ljavax/net/ssl/SSLSocketFactory;

    invoke-virtual {p1, v0}, Ljavax/net/ssl/HttpsURLConnection;->setSSLSocketFactory(Ljavax/net/ssl/SSLSocketFactory;)V

    new-instance v0, Lcom/juhyeon/familyjournea/MoaRemote721$Client$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0}, Lcom/juhyeon/familyjournea/MoaRemote721$Client$$ExternalSyntheticLambda0;-><init>(Lcom/juhyeon/familyjournea/MoaRemote721$Client;)V

    invoke-virtual {p1, v0}, Ljavax/net/ssl/HttpsURLConnection;->setHostnameVerifier(Ljavax/net/ssl/HostnameVerifier;)V

    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Ljavax/net/ssl/HttpsURLConnection;->setUseCaches(Z)V

    invoke-virtual {p1, v0}, Ljavax/net/ssl/HttpsURLConnection;->setInstanceFollowRedirects(Z)V

    const/16 v1, 0x1388

    invoke-virtual {p1, v1}, Ljavax/net/ssl/HttpsURLConnection;->setConnectTimeout(I)V

    const/16 v1, 0x2ee0

    invoke-virtual {p1, v1}, Ljavax/net/ssl/HttpsURLConnection;->setReadTimeout(I)V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Bearer "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->token:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "Authorization"

    invoke-virtual {p1, v2, v1}, Ljavax/net/ssl/HttpsURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "Accept-Encoding"

    const-string v2, "identity"

    invoke-virtual {p1, v1, v2}, Ljavax/net/ssl/HttpsURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const-wide/16 v1, 0x0

    cmp-long v3, p3, v1

    const-string v4, "-"

    if-ltz v3, :cond_8d

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "bytes="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, p3, p4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, p5, p6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    const-string v6, "Range"

    invoke-virtual {p1, v6, v5}, Ljavax/net/ssl/HttpsURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 132
    :cond_8d
    :try_start_8d
    invoke-virtual {p1}, Ljavax/net/ssl/HttpsURLConnection;->getResponseCode()I

    move-result v5

    if-ltz v3, :cond_96

    const/16 v6, 0xce

    goto :goto_98

    :cond_96
    const/16 v6, 0xc8

    :goto_98
    if-ne v5, v6, :cond_154

    if-ltz v3, :cond_d6

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "bytes "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, p3, p4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p5, p6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "/"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p7, p8}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p7

    invoke-virtual {p7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p7

    const-string p8, "Content-Range"

    invoke-virtual {p1, p8}, Ljavax/net/ssl/HttpsURLConnection;->getHeaderField(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p8

    invoke-virtual {p7, p8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p7

    if-eqz p7, :cond_ce

    goto :goto_d6

    :cond_ce
    new-instance p2, Ljava/io/IOException;

    const-string p3, "Range mismatch"

    invoke-direct {p2, p3}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    :cond_d5
    :goto_d5
    throw p2

    :cond_d6
    :goto_d6
    invoke-virtual {p1}, Ljavax/net/ssl/HttpsURLConnection;->getContentLengthLong()J

    move-result-wide p7

    int-to-long v4, p2

    cmp-long v4, p7, v4

    if-gtz v4, :cond_14c

    cmp-long v1, p7, v1

    if-ltz v1, :cond_14c

    if-ltz v3, :cond_ed

    sub-long/2addr p5, p3

    const-wide/16 p3, 0x1

    add-long/2addr p5, p3

    cmp-long p3, p7, p5

    if-nez p3, :cond_14c

    :cond_ed
    invoke-virtual {p1}, Ljavax/net/ssl/HttpsURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object p3
    :try_end_f1
    .catchall {:try_start_8d .. :try_end_f1} :catchall_16e

    :try_start_f1
    new-instance p4, Ljava/io/ByteArrayOutputStream;

    long-to-int p5, p7

    invoke-direct {p4, p5}, Ljava/io/ByteArrayOutputStream;-><init>(I)V
    :try_end_f7
    .catchall {:try_start_f1 .. :try_end_f7} :catchall_140

    const/16 p5, 0x4000

    :try_start_f9
    new-array p5, p5, [B

    :goto_fb
    invoke-virtual {p3, p5}, Ljava/io/InputStream;->read([B)I

    move-result p6

    const/4 v1, -0x1

    if-eq p6, v1, :cond_115

    invoke-virtual {p4}, Ljava/io/ByteArrayOutputStream;->size()I

    move-result v1

    add-int/2addr v1, p6

    if-gt v1, p2, :cond_10d

    invoke-virtual {p4, p5, v0, p6}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_fb

    :cond_10d
    new-instance p2, Ljava/io/IOException;

    const-string p5, "Response limit"

    invoke-direct {p2, p5}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    :goto_114
    throw p2

    :cond_115
    invoke-virtual {p4}, Ljava/io/ByteArrayOutputStream;->size()I

    move-result p2

    int-to-long p5, p2

    cmp-long p2, p5, p7

    if-nez p2, :cond_12e

    invoke-virtual {p4}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p2
    :try_end_122
    .catchall {:try_start_f9 .. :try_end_122} :catchall_136

    :try_start_122
    invoke-virtual {p4}, Ljava/io/ByteArrayOutputStream;->close()V
    :try_end_125
    .catchall {:try_start_122 .. :try_end_125} :catchall_140

    if-eqz p3, :cond_12a

    :try_start_127
    invoke-virtual {p3}, Ljava/io/InputStream;->close()V
    :try_end_12a
    .catchall {:try_start_127 .. :try_end_12a} :catchall_16e

    :cond_12a
    invoke-virtual {p1}, Ljavax/net/ssl/HttpsURLConnection;->disconnect()V

    return-object p2

    :cond_12e
    :try_start_12e
    new-instance p2, Ljava/io/IOException;

    const-string p5, "Incomplete response"

    invoke-direct {p2, p5}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V
    :try_end_135
    .catchall {:try_start_12e .. :try_end_135} :catchall_136

    goto :goto_114

    :catchall_136
    move-exception p2

    :try_start_137
    invoke-virtual {p4}, Ljava/io/ByteArrayOutputStream;->close()V
    :try_end_13a
    .catchall {:try_start_137 .. :try_end_13a} :catchall_13b

    goto :goto_13f

    :catchall_13b
    move-exception p4

    :try_start_13c
    invoke-virtual {p2, p4}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_13f
    throw p2
    :try_end_140
    .catchall {:try_start_13c .. :try_end_140} :catchall_140

    :catchall_140
    move-exception p2

    if-eqz p3, :cond_d5

    :try_start_143
    invoke-virtual {p3}, Ljava/io/InputStream;->close()V
    :try_end_146
    .catchall {:try_start_143 .. :try_end_146} :catchall_147

    goto :goto_d5

    :catchall_147
    move-exception p3

    :try_start_148
    invoke-virtual {p2, p3}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    goto :goto_d5

    :cond_14c
    new-instance p2, Ljava/io/IOException;

    const-string p3, "Response length"

    invoke-direct {p2, p3}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    goto :goto_d5

    :cond_154
    new-instance p2, Ljava/io/IOException;

    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string p4, "\ud5c8\ube0c \uc751\ub2f5 HTTP "

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-direct {p2, p3}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V
    :try_end_16c
    .catchall {:try_start_148 .. :try_end_16c} :catchall_16e

    goto/16 :goto_d5

    :catchall_16e
    move-exception p2

    invoke-virtual {p1}, Ljavax/net/ssl/HttpsURLConnection;->disconnect()V

    throw p2

    .line 131
    :cond_173
    new-instance p1, Ljava/io/IOException;

    const-string p2, "\ub3d9\uae30\ud654 OFF"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method synthetic lambda$get$0$com-juhyeon-familyjournea-MoaRemote721$Client(Ljava/lang/String;Ljavax/net/ssl/SSLSession;)Z
    .locals 0

    .line 131
    const/4 p1, 0x0

    :try_start_1
    invoke-interface {p2}, Ljavax/net/ssl/SSLSession;->getPeerCertificates()[Ljava/security/cert/Certificate;

    move-result-object p2

    aget-object p2, p2, p1

    invoke-virtual {p0, p2}, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->matches(Ljava/security/cert/Certificate;)Z

    move-result p1
    :try_end_b
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_b} :catch_c

    return p1

    :catch_c
    move-exception p2

    return p1
.end method

.method matches(Ljava/security/cert/Certificate;)Z
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 129
    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->pin:[B

    const-string v1, "SHA-256"

    invoke-static {v1}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v1

    invoke-virtual {p1}, Ljava/security/cert/Certificate;->getEncoded()[B

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/security/MessageDigest;->digest([B)[B

    move-result-object p1

    invoke-static {v0, p1}, Ljava/security/MessageDigest;->isEqual([B[B)Z

    move-result p1

    return p1
.end method
