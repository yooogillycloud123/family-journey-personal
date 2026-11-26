.class final Lcom/juhyeon/familyjournea/MoaRemote721$Source;
.super Landroid/media/MediaDataSource;
.source "MoaRemote721.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/juhyeon/familyjournea/MoaRemote721;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "Source"
.end annotation


# instance fields
.field cached:[B

.field final client:Lcom/juhyeon/familyjournea/MoaRemote721$Client;

.field closed:Z

.field final id:Ljava/lang/String;

.field final length:J

.field offset:J


# direct methods
.method constructor <init>(Lcom/juhyeon/familyjournea/MoaRemote721$Client;Ljava/lang/String;J)V
    .locals 2

    .line 137
    invoke-direct {p0}, Landroid/media/MediaDataSource;-><init>()V

    .line 136
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->cached:[B

    const-wide/16 v0, -0x1

    iput-wide v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->offset:J

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->closed:Z

    .line 137
    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->client:Lcom/juhyeon/familyjournea/MoaRemote721$Client;

    iput-object p2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->id:Ljava/lang/String;

    iput-wide p3, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->length:J

    return-void
.end method


# virtual methods
.method public declared-synchronized close()V
    .locals 1

    monitor-enter p0

    .line 139
    const/4 v0, 0x1

    :try_start_2
    iput-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->closed:Z

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->cached:[B
    :try_end_7
    .catchall {:try_start_2 .. :try_end_7} :catchall_9

    monitor-exit p0

    return-void

    .line 139
    :catchall_9
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public getSize()J
    .locals 2

    .line 139
    iget-wide v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->length:J

    return-wide v0
.end method

.method public declared-synchronized readAt(J[BII)I
    .locals 19
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    move-object/from16 v1, p0

    move/from16 v0, p5

    monitor-enter p0

    .line 138
    :try_start_5
    iget-boolean v2, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->closed:Z

    if-nez v2, :cond_9c

    sget-boolean v2, Lcom/juhyeon/familyjournea/MoaRemote721;->clientAllowed:Z
    :try_end_b
    .catchall {:try_start_5 .. :try_end_b} :catchall_a4

    if-eqz v2, :cond_9c

    const-wide/16 v2, 0x0

    cmp-long v2, p1, v2

    if-ltz v2, :cond_94

    if-nez v0, :cond_18

    monitor-exit p0

    const/4 v0, 0x0

    return v0

    :cond_18
    :try_start_18
    iget-wide v2, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->length:J
    :try_end_1a
    .catchall {:try_start_18 .. :try_end_1a} :catchall_a4

    cmp-long v2, p1, v2

    if-ltz v2, :cond_21

    monitor-exit p0

    const/4 v0, -0x1

    return v0

    :cond_21
    :try_start_21
    iget-object v2, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->cached:[B

    if-eqz v2, :cond_36

    iget-wide v2, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->offset:J

    cmp-long v2, p1, v2

    if-ltz v2, :cond_36

    iget-wide v2, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->offset:J

    iget-object v4, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->cached:[B

    array-length v4, v4

    int-to-long v4, v4

    add-long/2addr v2, v4

    cmp-long v2, p1, v2

    if-ltz v2, :cond_70

    :cond_36
    const-wide/32 v2, 0x100000

    div-long v4, p1, v2

    mul-long/2addr v4, v2

    iput-wide v4, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->offset:J

    iget-wide v4, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->length:J

    const-wide/16 v6, 0x1

    sub-long/2addr v4, v6

    iget-wide v8, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->offset:J

    add-long/2addr v8, v2

    sub-long/2addr v8, v6

    invoke-static {v4, v5, v8, v9}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v15

    iget-object v10, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->client:Lcom/juhyeon/familyjournea/MoaRemote721$Client;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "/v3/view/raw/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->id:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    iget-wide v13, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->offset:J

    iget-wide v2, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->length:J

    const/high16 v12, 0x100000

    move-wide/from16 v17, v2

    invoke-virtual/range {v10 .. v18}, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->get(Ljava/lang/String;IJJJ)[B

    move-result-object v2

    iput-object v2, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->cached:[B

    :cond_70
    iget-object v2, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->cached:[B

    array-length v2, v2

    iget-wide v3, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->offset:J

    sub-long v3, p1, v3

    long-to-int v3, v3

    sub-int/2addr v2, v3

    invoke-static {v0, v2}, Ljava/lang/Math;->min(II)I

    move-result v0

    iget-object v2, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->cached:[B

    iget-wide v3, v1, Lcom/juhyeon/familyjournea/MoaRemote721$Source;->offset:J

    sub-long v3, p1, v3

    long-to-int v3, v3

    move-object/from16 v4, p3

    move/from16 v5, p4

    invoke-static {v2, v3, v4, v5, v0}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V
    :try_end_8b
    .catch Ljava/lang/Exception; {:try_start_21 .. :try_end_8b} :catch_8d
    .catchall {:try_start_21 .. :try_end_8b} :catchall_a4

    monitor-exit p0

    return v0

    :catch_8d
    move-exception v0

    :try_start_8e
    new-instance v2, Ljava/io/IOException;

    invoke-direct {v2, v0}, Ljava/io/IOException;-><init>(Ljava/lang/Throwable;)V

    throw v2

    :cond_94
    new-instance v0, Ljava/io/IOException;

    const-string v2, "Offset"

    invoke-direct {v0, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    :goto_9b
    throw v0

    :cond_9c
    new-instance v0, Ljava/io/IOException;

    const-string v2, "Closed"

    invoke-direct {v0, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V
    :try_end_a3
    .catchall {:try_start_8e .. :try_end_a3} :catchall_a4

    goto :goto_9b

    .line 138
    :catchall_a4
    move-exception v0

    monitor-exit p0

    throw v0
.end method
