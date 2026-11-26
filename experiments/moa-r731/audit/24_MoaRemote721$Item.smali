.class Lcom/juhyeon/familyjournea/MoaRemote721$Item;
.super Ljava/lang/Object;
.source "MoaRemote721.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/juhyeon/familyjournea/MoaRemote721;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "Item"
.end annotation


# instance fields
.field final day:Ljava/lang/String;

.field final id:Ljava/lang/String;

.field final mime:Ljava/lang/String;

.field final name:Ljava/lang/String;

.field final size:J


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;J)V
    .locals 0

    .line 71
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->id:Ljava/lang/String;

    iput-object p2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->day:Ljava/lang/String;

    iput-object p3, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->name:Ljava/lang/String;

    iput-object p4, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->mime:Ljava/lang/String;

    iput-wide p5, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->size:J

    return-void
.end method


# virtual methods
.method json()Lorg/json/JSONObject;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 71
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    const-string v1, "id"

    iget-object v2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->id:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "day"

    iget-object v2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->day:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "name"

    iget-object v2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->name:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "mime"

    iget-object v2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->mime:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "size"

    iget-wide v2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Item;->size:J

    invoke-virtual {v0, v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    move-result-object v0

    return-object v0
.end method
