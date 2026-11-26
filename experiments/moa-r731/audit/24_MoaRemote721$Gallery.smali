.class final Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;
.super Ljava/lang/Object;
.source "MoaRemote721.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/juhyeon/familyjournea/MoaRemote721;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "Gallery"
.end annotation


# instance fields
.field final a:Landroid/app/Activity;

.field busy:Z

.field final c:Lcom/juhyeon/familyjournea/MoaRemote721$Client;

.field day:Ljava/lang/String;

.field final dlg:Landroid/app/Dialog;

.field final list:Landroid/widget/LinearLayout;

.field final next:Landroid/widget/Button;

.field offset:I

.field final prev:Landroid/widget/Button;

.field volatile seq:I

.field final status:Landroid/widget/TextView;


# direct methods
.method constructor <init>(Landroid/app/Activity;Lcom/juhyeon/familyjournea/MoaRemote721$Client;Ljava/lang/String;)V
    .locals 7

    .line 149
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 148
    const/4 v0, 0x0

    iput v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->offset:I

    iput-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->busy:Z

    iput v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->seq:I

    .line 149
    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->a:Landroid/app/Activity;

    iput-object p2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->c:Lcom/juhyeon/familyjournea/MoaRemote721$Client;

    iput-object p3, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->day:Ljava/lang/String;

    invoke-static {p1}, Lcom/juhyeon/familyjournea/MoaRemote721;->col(Landroid/app/Activity;)Landroid/widget/LinearLayout;

    move-result-object p2

    const-string v1, "\uc6d0\uaca9 \ubcf4\uad00\ud568 \u00b7 \uc6d0\ubcf8 \uc800\uc7a5 \uc548 \ud568"

    const/16 v2, 0xe

    invoke-static {p1, v1, v2}, Lcom/juhyeon/familyjournea/MoaRemote721;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v1

    iput-object v1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->status:Landroid/widget/TextView;

    iget-object v1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->status:Landroid/widget/TextView;

    invoke-virtual {p2, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, p1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const-string v2, "\uc804\uccb4 \ub0a0\uc9dc"

    invoke-static {p1, v2}, Lcom/juhyeon/familyjournea/MoaRemote721;->btn(Landroid/app/Activity;Ljava/lang/String;)Landroid/widget/Button;

    move-result-object v2

    const-string v3, "\ub0a0\uc9dc \uc120\ud0dd"

    invoke-static {p1, v3}, Lcom/juhyeon/familyjournea/MoaRemote721;->btn(Landroid/app/Activity;Ljava/lang/String;)Landroid/widget/Button;

    move-result-object v3

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, -0x2

    const/high16 v6, 0x3f800000    # 1.0f

    invoke-direct {v4, v0, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v1, v2, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v4, v0, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v1, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {p2, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v1, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda0;-><init>(Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;)V

    invoke-virtual {v2, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v1, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda1;

    invoke-direct {v1, p0, p1}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda1;-><init>(Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;Landroid/app/Activity;)V

    invoke-virtual {v3, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v1, Landroid/widget/ScrollView;

    invoke-direct {v1, p1}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    invoke-static {p1}, Lcom/juhyeon/familyjournea/MoaRemote721;->col(Landroid/app/Activity;)Landroid/widget/LinearLayout;

    move-result-object v2

    iput-object v2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->list:Landroid/widget/LinearLayout;

    iget-object v2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->list:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v2}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v3, 0x1e0

    invoke-static {p1, v3}, Lcom/juhyeon/familyjournea/MoaRemote721;->dp(Landroid/app/Activity;I)I

    move-result v3

    invoke-virtual {p1}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    invoke-virtual {v4}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v4

    iget v4, v4, Landroid/util/DisplayMetrics;->heightPixels:I

    div-int/lit8 v4, v4, 0x2

    invoke-static {v3, v4}, Ljava/lang/Math;->min(II)I

    move-result v3

    const/4 v4, -0x1

    invoke-direct {v2, v4, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p2, v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, p1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const-string v2, "\uc774\uc804"

    invoke-static {p1, v2}, Lcom/juhyeon/familyjournea/MoaRemote721;->btn(Landroid/app/Activity;Ljava/lang/String;)Landroid/widget/Button;

    move-result-object v2

    iput-object v2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->prev:Landroid/widget/Button;

    const-string v2, "\ub2e4\uc74c"

    invoke-static {p1, v2}, Lcom/juhyeon/familyjournea/MoaRemote721;->btn(Landroid/app/Activity;Ljava/lang/String;)Landroid/widget/Button;

    move-result-object v2

    iput-object v2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->next:Landroid/widget/Button;

    iget-object v2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->prev:Landroid/widget/Button;

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v3, v0, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iget-object v2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->next:Landroid/widget/Button;

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v3, v0, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {p2, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p1}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    invoke-virtual {p3}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_c3

    const-string p1, "\uc6d0\uaca9 \uc0ac\uc9c4\u00b7\uc601\uc0c1\u00b7\uc74c\uc131"

    goto :goto_d6

    :cond_c3
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p3, " \uc6d0\uaca9 \ubcf4\uad00\ud568"

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    :goto_d6
    invoke-virtual {v0, p1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    invoke-virtual {p1, p2}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    const-string p2, "\ub2eb\uae30"

    const/4 p3, 0x0

    invoke-virtual {p1, p2, p3}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object p1

    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->dlg:Landroid/app/Dialog;

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->prev:Landroid/widget/Button;

    new-instance p2, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda2;

    invoke-direct {p2, p0}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda2;-><init>(Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;)V

    invoke-virtual {p1, p2}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->next:Landroid/widget/Button;

    new-instance p2, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda3;

    invoke-direct {p2, p0}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda3;-><init>(Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;)V

    invoke-virtual {p1, p2}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-void
.end method


# virtual methods
.method add(Lorg/json/JSONObject;I)V
    .locals 11

    .line 152
    const-string v0, "id"

    invoke-virtual {p1, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "mime"

    invoke-virtual {p1, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    const-string v1, "size"

    invoke-virtual {p1, v1}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;)J

    move-result-wide v5

    invoke-static {v0}, Lcom/juhyeon/familyjournea/MoaRemote721;->mediaId(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_1e

    invoke-static {v0}, Lcom/juhyeon/familyjournea/MoaRemote721;->voiceId(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_24

    :cond_1e
    const-wide/16 v1, 0x0

    cmp-long v1, v5, v1

    if-gtz v1, :cond_25

    :cond_24
    return-void

    :cond_25
    new-instance v8, Landroid/widget/LinearLayout;

    iget-object v1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->a:Landroid/app/Activity;

    invoke-direct {v8, v1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/16 v1, 0x10

    invoke-virtual {v8, v1}, Landroid/widget/LinearLayout;->setGravity(I)V

    iget-object v1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->a:Landroid/app/Activity;

    const/4 v2, 0x5

    invoke-static {v1, v2}, Lcom/juhyeon/familyjournea/MoaRemote721;->dp(Landroid/app/Activity;I)I

    move-result v1

    iget-object v3, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->a:Landroid/app/Activity;

    invoke-static {v3, v2}, Lcom/juhyeon/familyjournea/MoaRemote721;->dp(Landroid/app/Activity;I)I

    move-result v2

    const/4 v3, 0x0

    invoke-virtual {v8, v3, v1, v3, v2}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v9, Landroid/widget/ImageView;

    iget-object v1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->a:Landroid/app/Activity;

    invoke-direct {v9, v1}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    sget-object v1, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {v9, v1}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    iget-object v2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->a:Landroid/app/Activity;

    const/16 v4, 0x42

    invoke-static {v2, v4}, Lcom/juhyeon/familyjournea/MoaRemote721;->dp(Landroid/app/Activity;I)I

    move-result v2

    iget-object v10, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->a:Landroid/app/Activity;

    invoke-static {v10, v4}, Lcom/juhyeon/familyjournea/MoaRemote721;->dp(Landroid/app/Activity;I)I

    move-result v4

    invoke-direct {v1, v2, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v8, v9, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iget-object v1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->a:Landroid/app/Activity;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "day"

    invoke-virtual {p1, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v4, "  "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v4, "video/"

    invoke-virtual {v7, v4}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v4

    const-string v10, "audio/"

    if-eqz v4, :cond_88

    const-string v4, "\u25b6 \uc601\uc0c1"

    goto :goto_93

    :cond_88
    invoke-virtual {v7, v10}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_91

    const-string v4, "\uc74c\uc131"

    goto :goto_93

    :cond_91
    const-string v4, "\uc0ac\uc9c4"

    :goto_93
    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v4, "\n"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v4, "name"

    invoke-virtual {p1, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const/16 v2, 0xd

    invoke-static {v1, p1, v2}, Lcom/juhyeon/familyjournea/MoaRemote721;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object p1

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v2, -0x2

    const/high16 v4, 0x3f800000    # 1.0f

    invoke-direct {v1, v3, v2, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v8, p1, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->list:Landroid/widget/LinearLayout;

    invoke-virtual {p1, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance p1, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda9;

    move-object v1, p1

    move-object v2, p0

    move-object v3, v7

    move-object v4, v0

    invoke-direct/range {v1 .. v6}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda9;-><init>(Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;Ljava/lang/String;Ljava/lang/String;J)V

    invoke-virtual {v8, p1}, Landroid/widget/LinearLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v7, v10}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_dd

    sget-object p1, Lcom/juhyeon/familyjournea/MoaRemote721;->WORK:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda10;

    invoke-direct {v1, p0, p2, v0, v9}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda10;-><init>(Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;ILjava/lang/String;Landroid/widget/ImageView;)V

    invoke-interface {p1, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    :cond_dd
    return-void
.end method

.method synthetic lambda$add$10$com-juhyeon-familyjournea-MoaRemote721$Gallery(ILandroid/widget/ImageView;Landroid/graphics/Bitmap;)V
    .locals 1

    .line 152
    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->dlg:Landroid/app/Dialog;

    invoke-virtual {v0}, Landroid/app/Dialog;->isShowing()Z

    move-result v0

    if-eqz v0, :cond_10

    iget v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->seq:I

    if-ne p1, v0, :cond_10

    invoke-virtual {p2, p3}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    goto :goto_15

    :cond_10
    if-eqz p3, :cond_15

    invoke-virtual {p3}, Landroid/graphics/Bitmap;->recycle()V

    :cond_15
    :goto_15
    return-void
.end method

.method synthetic lambda$add$11$com-juhyeon-familyjournea-MoaRemote721$Gallery(ILjava/lang/String;Landroid/widget/ImageView;)V
    .locals 10

    .line 152
    iget v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->seq:I

    if-eq p1, v0, :cond_5

    return-void

    :cond_5
    :try_start_5
    iget-object v1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->c:Lcom/juhyeon/familyjournea/MoaRemote721$Client;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "/v3/view/thumb/"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-wide/16 v6, -0x1

    const-wide/16 v8, -0x1

    const/high16 v3, 0x800000

    const-wide/16 v4, -0x1

    invoke-virtual/range {v1 .. v9}, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->get(Ljava/lang/String;IJJJ)[B

    move-result-object p2

    array-length v0, p2

    const/4 v1, 0x0

    invoke-static {p2, v1, v0}, Landroid/graphics/BitmapFactory;->decodeByteArray([BII)Landroid/graphics/Bitmap;

    move-result-object p2

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->a:Landroid/app/Activity;

    new-instance v1, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda4;

    invoke-direct {v1, p0, p1, p3, p2}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda4;-><init>(Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;ILandroid/widget/ImageView;Landroid/graphics/Bitmap;)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    :try_end_36
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_36} :catch_37

    goto :goto_38

    :catch_37
    move-exception p1

    :goto_38
    return-void
.end method

.method synthetic lambda$add$9$com-juhyeon-familyjournea-MoaRemote721$Gallery(Ljava/lang/String;Ljava/lang/String;JLandroid/view/View;)V
    .locals 6

    .line 152
    const-string p5, "image/"

    invoke-virtual {p1, p5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p5

    if-eqz p5, :cond_10

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->a:Landroid/app/Activity;

    iget-object p3, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->c:Lcom/juhyeon/familyjournea/MoaRemote721$Client;

    invoke-static {p1, p3, p2}, Lcom/juhyeon/familyjournea/MoaRemote721;->photo(Landroid/app/Activity;Lcom/juhyeon/familyjournea/MoaRemote721$Client;Ljava/lang/String;)V

    goto :goto_1f

    :cond_10
    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->a:Landroid/app/Activity;

    iget-object v1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->c:Lcom/juhyeon/familyjournea/MoaRemote721$Client;

    const-string p5, "video/"

    invoke-virtual {p1, p5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    move-object v2, p2

    move-wide v3, p3

    invoke-static/range {v0 .. v5}, Lcom/juhyeon/familyjournea/MoaRemote721;->player(Landroid/app/Activity;Lcom/juhyeon/familyjournea/MoaRemote721$Client;Ljava/lang/String;JZ)V

    :goto_1f
    return-void
.end method

.method synthetic lambda$load$6$com-juhyeon-familyjournea-MoaRemote721$Gallery(IILorg/json/JSONArray;Lorg/json/JSONObject;)V
    .locals 4

    .line 151
    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->dlg:Landroid/app/Dialog;

    invoke-virtual {v0}, Landroid/app/Dialog;->isShowing()Z

    move-result v0

    if-eqz v0, :cond_6c

    iget v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->seq:I

    if-eq p1, v0, :cond_d

    goto :goto_6c

    :cond_d
    iput p2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->offset:I

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->busy:Z

    iget-object v1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->status:Landroid/widget/TextView;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->day:Ljava/lang/String;

    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_24

    const-string v3, "\uc804\uccb4"

    goto :goto_26

    :cond_24
    iget-object v3, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->day:Ljava/lang/String;

    :goto_26
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " \u00b7 "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p3}, Lorg/json/JSONArray;->length()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "\uac1c \u00b7 \uae30\uae30 \uc800\uc7a5 \uc5c6\uc74c"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->prev:Landroid/widget/Button;

    if-lez p2, :cond_4b

    const/4 p2, 0x1

    goto :goto_4c

    :cond_4b
    move p2, v0

    :goto_4c
    invoke-virtual {v1, p2}, Landroid/widget/Button;->setEnabled(Z)V

    iget-object p2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->next:Landroid/widget/Button;

    const-string v1, "more"

    invoke-virtual {p4, v1}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;)Z

    move-result p4

    invoke-virtual {p2, p4}, Landroid/widget/Button;->setEnabled(Z)V

    :goto_5a
    invoke-virtual {p3}, Lorg/json/JSONArray;->length()I

    move-result p2

    if-ge v0, p2, :cond_6c

    invoke-virtual {p3, v0}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object p2

    if-eqz p2, :cond_69

    invoke-virtual {p0, p2, p1}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->add(Lorg/json/JSONObject;I)V

    :cond_69
    add-int/lit8 v0, v0, 0x1

    goto :goto_5a

    :cond_6c
    :goto_6c
    return-void
.end method

.method synthetic lambda$load$7$com-juhyeon-familyjournea-MoaRemote721$Gallery(Ljava/lang/Exception;I)V
    .locals 4

    .line 151
    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->dlg:Landroid/app/Dialog;

    invoke-virtual {v0}, Landroid/app/Dialog;->isShowing()Z

    move-result v0

    if-nez v0, :cond_9

    return-void

    :cond_9
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->busy:Z

    iget-object v1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->status:Landroid/widget/TextView;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\ud5c8\ube0c \uc5f0\uacb0 \ub610\ub294 \uc6d0\uaca9 \uc5f4\ub78c \ud5c8\uc6a9\uc744 \ud655\uc778\ud558\uc138\uc694. "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->prev:Landroid/widget/Button;

    if-lez p2, :cond_2d

    const/4 v0, 0x1

    :cond_2d
    invoke-virtual {p1, v0}, Landroid/widget/Button;->setEnabled(Z)V

    return-void
.end method

.method synthetic lambda$load$8$com-juhyeon-familyjournea-MoaRemote721$Gallery(II)V
    .locals 18

    .line 151
    move-object/from16 v7, p0

    move/from16 v8, p1

    :try_start_4
    new-instance v6, Lorg/json/JSONObject;

    new-instance v0, Ljava/lang/String;

    iget-object v9, v7, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->c:Lcom/juhyeon/familyjournea/MoaRemote721$Client;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "/v3/view/list?offset="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, v7, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->day:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_24

    const-string v2, ""

    goto :goto_39

    :cond_24
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "&day="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, v7, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->day:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    :goto_39
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    const-wide/16 v14, -0x1

    const-wide/16 v16, -0x1

    const/high16 v11, 0x80000

    const-wide/16 v12, -0x1

    invoke-virtual/range {v9 .. v17}, Lcom/juhyeon/familyjournea/MoaRemote721$Client;->get(Ljava/lang/String;IJJJ)[B

    move-result-object v1

    sget-object v2, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v0, v1, v2}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-direct {v6, v0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v0, "items"

    invoke-virtual {v6, v0}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v5

    iget-object v0, v7, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->a:Landroid/app/Activity;

    new-instance v9, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda7;

    move-object v1, v9

    move-object/from16 v2, p0

    move/from16 v3, p2

    move/from16 v4, p1

    invoke-direct/range {v1 .. v6}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda7;-><init>(Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;IILorg/json/JSONArray;Lorg/json/JSONObject;)V

    invoke-virtual {v0, v9}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    :try_end_6c
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_6c} :catch_6d

    goto :goto_78

    :catch_6d
    move-exception v0

    iget-object v1, v7, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->a:Landroid/app/Activity;

    new-instance v2, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda8;

    invoke-direct {v2, v7, v0, v8}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda8;-><init>(Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;Ljava/lang/Exception;I)V

    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :goto_78
    return-void
.end method

.method synthetic lambda$new$0$com-juhyeon-familyjournea-MoaRemote721$Gallery(Landroid/view/View;)V
    .locals 0

    .line 149
    iget-boolean p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->busy:Z

    if-nez p1, :cond_c

    const-string p1, ""

    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->day:Ljava/lang/String;

    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->load(I)V

    :cond_c
    return-void
.end method

.method synthetic lambda$new$1$com-juhyeon-familyjournea-MoaRemote721$Gallery(Landroid/widget/DatePicker;III)V
    .locals 0

    .line 149
    sget-object p1, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    add-int/lit8 p3, p3, 0x1

    invoke-static {p3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p3

    invoke-static {p4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p4

    filled-new-array {p2, p3, p4}, [Ljava/lang/Object;

    move-result-object p2

    const-string p3, "%04d-%02d-%02d"

    invoke-static {p1, p3, p2}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->day:Ljava/lang/String;

    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->load(I)V

    return-void
.end method

.method synthetic lambda$new$2$com-juhyeon-familyjournea-MoaRemote721$Gallery(Landroid/app/Activity;Landroid/view/View;)V
    .locals 7

    .line 149
    iget-boolean p2, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->busy:Z

    if-eqz p2, :cond_5

    return-void

    :cond_5
    invoke-static {}, Ljava/util/Calendar;->getInstance()Ljava/util/Calendar;

    move-result-object p2

    new-instance v6, Landroid/app/DatePickerDialog;

    new-instance v2, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda5;

    invoke-direct {v2, p0}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda5;-><init>(Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;)V

    const/4 v0, 0x1

    invoke-virtual {p2, v0}, Ljava/util/Calendar;->get(I)I

    move-result v3

    const/4 v0, 0x2

    invoke-virtual {p2, v0}, Ljava/util/Calendar;->get(I)I

    move-result v4

    const/4 v0, 0x5

    invoke-virtual {p2, v0}, Ljava/util/Calendar;->get(I)I

    move-result v5

    move-object v0, v6

    move-object v1, p1

    invoke-direct/range {v0 .. v5}, Landroid/app/DatePickerDialog;-><init>(Landroid/content/Context;Landroid/app/DatePickerDialog$OnDateSetListener;III)V

    invoke-virtual {v6}, Landroid/app/DatePickerDialog;->show()V

    return-void
.end method

.method synthetic lambda$new$3$com-juhyeon-familyjournea-MoaRemote721$Gallery(Landroid/view/View;)V
    .locals 1

    .line 149
    iget p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->offset:I

    add-int/lit8 p1, p1, -0x20

    const/4 v0, 0x0

    invoke-static {v0, p1}, Ljava/lang/Math;->max(II)I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->load(I)V

    return-void
.end method

.method synthetic lambda$new$4$com-juhyeon-familyjournea-MoaRemote721$Gallery(Landroid/view/View;)V
    .locals 0

    .line 149
    iget p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->offset:I

    add-int/lit8 p1, p1, 0x20

    invoke-virtual {p0, p1}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->load(I)V

    return-void
.end method

.method synthetic lambda$show$5$com-juhyeon-familyjournea-MoaRemote721$Gallery(Landroid/content/DialogInterface;)V
    .locals 0

    .line 150
    iget p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->seq:I

    add-int/lit8 p1, p1, 0x1

    iput p1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->seq:I

    return-void
.end method

.method load(I)V
    .locals 3

    .line 151
    iget-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->busy:Z

    if-eqz v0, :cond_5

    return-void

    :cond_5
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->busy:Z

    iget v1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->seq:I

    add-int/2addr v1, v0

    iput v1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->seq:I

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->next:Landroid/widget/Button;

    const/4 v2, 0x0

    invoke-virtual {v0, v2}, Landroid/widget/Button;->setEnabled(Z)V

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->prev:Landroid/widget/Button;

    invoke-virtual {v0, v2}, Landroid/widget/Button;->setEnabled(Z)V

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->status:Landroid/widget/TextView;

    const-string v2, "\ud5c8\ube0c\uc5d0\uc11c \ubaa9\ub85d \uc77d\ub294 \uc911\u2026"

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->list:Landroid/widget/LinearLayout;

    invoke-virtual {v0}, Landroid/widget/LinearLayout;->removeAllViews()V

    sget-object v0, Lcom/juhyeon/familyjournea/MoaRemote721;->WORK:Ljava/util/concurrent/ExecutorService;

    new-instance v2, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda11;

    invoke-direct {v2, p0, p1, v1}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda11;-><init>(Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;II)V

    invoke-interface {v0, v2}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method show()V
    .locals 2

    .line 150
    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->dlg:Landroid/app/Dialog;

    new-instance v1, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda6;

    invoke-direct {v1, p0}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery$$ExternalSyntheticLambda6;-><init>(Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;)V

    invoke-virtual {v0, v1}, Landroid/app/Dialog;->setOnDismissListener(Landroid/content/DialogInterface$OnDismissListener;)V

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->dlg:Landroid/app/Dialog;

    invoke-virtual {v0}, Landroid/app/Dialog;->show()V

    iget-object v0, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->dlg:Landroid/app/Dialog;

    iget-object v1, p0, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->a:Landroid/app/Activity;

    invoke-static {v0, v1}, Lcom/juhyeon/familyjournea/MoaRemote721;->size(Landroid/app/Dialog;Landroid/app/Activity;)V

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Lcom/juhyeon/familyjournea/MoaRemote721$Gallery;->load(I)V

    return-void
.end method
