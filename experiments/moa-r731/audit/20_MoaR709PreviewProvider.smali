.class public final Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;
.super Landroid/content/ContentProvider;
.source "MoaR709PreviewProvider.java"


# static fields
.field private static final CHANNEL:Ljava/lang/String; = "moa_moment_capture_alerts_v2"

.field private static final MAIN:Landroid/os/Handler;

.field private static final MARKER:Ljava/lang/String; = "moa-r709-exact-media-preview"

.field private static final MEMO_ACTIVITY:Ljava/lang/String; = "com.juhyeon.familyjourney.MoaMomentMemoRecorderActivity"

.field private static final PINK:I = -0x16d79b

.field private static final PREF:Ljava/lang/String; = "moa_camera_native_v1"

.field private static final WORK:Ljava/util/concurrent/ExecutorService;


# instance fields
.field private listener:Landroid/content/SharedPreferences$OnSharedPreferenceChangeListener;

.field private prefs:Landroid/content/SharedPreferences;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 55
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->MAIN:Landroid/os/Handler;

    .line 56
    new-instance v0, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda8;

    invoke-direct {v0}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda8;-><init>()V

    invoke-static {v0}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor(Ljava/util/concurrent/ThreadFactory;)Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    sput-object v0, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->WORK:Ljava/util/concurrent/ExecutorService;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 49
    invoke-direct {p0}, Landroid/content/ContentProvider;-><init>()V

    return-void
.end method

.method static synthetic access$000()Landroid/os/Handler;
    .locals 1

    .line 49
    sget-object v0, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->MAIN:Landroid/os/Handler;

    return-object v0
.end method

.method static synthetic access$100(Landroid/app/Activity;)V
    .locals 0

    .line 49
    invoke-static {p0}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->installCard(Landroid/app/Activity;)V

    return-void
.end method

.method private static available(Landroid/content/Context;Landroid/net/Uri;)Z
    .locals 7

    .line 111
    const/4 v0, 0x0

    :try_start_1
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v1

    const-string p0, "_id"

    filled-new-array {p0}, [Ljava/lang/String;

    move-result-object v3

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v4, 0x0

    move-object v2, p1

    invoke-virtual/range {v1 .. v6}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0
    :try_end_13
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_13} :catch_30

    .line 112
    if-eqz p0, :cond_29

    :try_start_15
    invoke-interface {p0}, Landroid/database/Cursor;->moveToFirst()Z

    move-result p1
    :try_end_19
    .catchall {:try_start_15 .. :try_end_19} :catchall_1d

    if-eqz p1, :cond_29

    const/4 p1, 0x1

    goto :goto_2a

    .line 111
    :catchall_1d
    move-exception p1

    if-eqz p0, :cond_28

    :try_start_20
    invoke-interface {p0}, Landroid/database/Cursor;->close()V
    :try_end_23
    .catchall {:try_start_20 .. :try_end_23} :catchall_24

    goto :goto_28

    :catchall_24
    move-exception p0

    :try_start_25
    invoke-virtual {p1, p0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_28
    :goto_28
    throw p1

    .line 112
    :cond_29
    move p1, v0

    .line 113
    :goto_2a
    if-eqz p0, :cond_2f

    invoke-interface {p0}, Landroid/database/Cursor;->close()V
    :try_end_2f
    .catch Ljava/lang/Exception; {:try_start_25 .. :try_end_2f} :catch_30

    .line 112
    :cond_2f
    return p1

    .line 113
    :catch_30
    move-exception p0

    return v0
.end method

.method private static decorateNotification(Landroid/content/Context;Ljava/lang/String;I)V
    .locals 0

    return-void
.end method

.method private static dp(Landroid/content/Context;I)I
    .locals 0

    .line 131
    int-to-float p1, p1

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

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

.method private static draft(Landroid/content/Context;Ljava/lang/String;)Lorg/json/JSONObject;
    .locals 3

    .line 96
    invoke-static {p1}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->valid(Ljava/lang/String;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_8

    return-object v1

    .line 98
    :cond_8
    :try_start_8
    const-string v0, "moa_camera_native_v1"

    const/4 v2, 0x0

    invoke-virtual {p0, v0, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "m:"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 99
    if-nez p0, :cond_29

    return-object v1

    .line 100
    :cond_29
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0, p0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 101
    const-string p0, "id"

    invoke-virtual {v0, p0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0
    :try_end_38
    .catch Ljava/lang/Exception; {:try_start_8 .. :try_end_38} :catch_3c

    if-nez p0, :cond_3b

    return-object v1

    .line 102
    :cond_3b
    return-object v0

    .line 103
    :catch_3c
    move-exception p0

    return-object v1
.end method

.method private static findEdit(Landroid/view/View;)Landroid/view/View;
    .locals 2

    .line 137
    instance-of v0, p0, Landroid/widget/EditText;

    if-eqz v0, :cond_5

    return-object p0

    .line 138
    :cond_5
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_20

    .line 139
    check-cast p0, Landroid/view/ViewGroup;

    .line 140
    const/4 v0, 0x0

    :goto_c
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    if-ge v0, v1, :cond_20

    .line 141
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    invoke-static {v1}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->findEdit(Landroid/view/View;)Landroid/view/View;

    move-result-object v1

    if-eqz v1, :cond_1d

    return-object v1

    .line 140
    :cond_1d
    add-int/lit8 v0, v0, 0x1

    goto :goto_c

    .line 144
    :cond_20
    const/4 p0, 0x0

    return-object p0
.end method

.method private static installCard(Landroid/app/Activity;)V
    .locals 12

    .line 147
    const-string v0, "v"

    const-string v1, "moa-r709-exact-media-preview"

    invoke-virtual {p0}, Landroid/app/Activity;->isFinishing()Z

    move-result v2

    if-nez v2, :cond_174

    invoke-virtual {p0}, Landroid/app/Activity;->isDestroyed()Z

    move-result v2

    if-eqz v2, :cond_12

    goto/16 :goto_174

    .line 149
    :cond_12
    :try_start_12
    invoke-virtual {p0}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    move-result-object v2

    if-nez v2, :cond_1b

    const/4 v2, 0x0

    :goto_19
    move-object v5, v2

    goto :goto_26

    :cond_1b
    invoke-virtual {p0}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    move-result-object v2

    const-string v3, "id"

    invoke-virtual {v2, v3}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    goto :goto_19

    .line 150
    :goto_26
    invoke-static {v5}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->valid(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_2d

    return-void

    .line 151
    :cond_2d
    invoke-static {p0, v5}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->draft(Landroid/content/Context;Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v2

    .line 152
    if-nez v2, :cond_34

    return-void

    .line 153
    :cond_34
    const v3, 0x1020002

    invoke-virtual {p0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/view/ViewGroup;

    .line 154
    if-nez v3, :cond_40

    return-void

    .line 155
    :cond_40
    invoke-virtual {v3, v1}, Landroid/view/ViewGroup;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v4

    .line 156
    if-eqz v4, :cond_47

    return-void

    .line 157
    :cond_47
    invoke-static {v3}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->findEdit(Landroid/view/View;)Landroid/view/View;

    move-result-object v3

    .line 158
    if-eqz v3, :cond_170

    invoke-virtual {v3}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v4

    instance-of v4, v4, Landroid/widget/LinearLayout;

    if-nez v4, :cond_57

    goto/16 :goto_170

    .line 159
    :cond_57
    invoke-virtual {v3}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v4

    check-cast v4, Landroid/widget/LinearLayout;

    .line 160
    invoke-virtual {v4, v3}, Landroid/widget/LinearLayout;->indexOfChild(Landroid/view/View;)I

    move-result v3

    .line 161
    if-gez v3, :cond_64

    return-void

    .line 163
    :cond_64
    new-instance v6, Landroid/widget/LinearLayout;

    invoke-direct {v6, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v6, v1}, Landroid/widget/LinearLayout;->setTag(Ljava/lang/Object;)V

    .line 164
    const/4 v1, 0x0

    invoke-virtual {v6, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v7, 0x10

    invoke-virtual {v6, v7}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 165
    const/16 v7, 0xa

    invoke-static {p0, v7}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->dp(Landroid/content/Context;I)I

    move-result v8

    invoke-static {p0, v7}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->dp(Landroid/content/Context;I)I

    move-result v9

    invoke-static {p0, v7}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->dp(Landroid/content/Context;I)I

    move-result v10

    invoke-static {p0, v7}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->dp(Landroid/content/Context;I)I

    move-result v7

    invoke-virtual {v6, v8, v9, v10, v7}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 166
    const v7, -0x80c0a

    const/16 v8, 0xf

    invoke-static {p0, v7, v8}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->rounded(Landroid/content/Context;II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v7

    invoke-virtual {v6, v7}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 167
    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v8, -0x1

    const/4 v9, -0x2

    invoke-direct {v7, v8, v9}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 168
    const/16 v8, 0xc

    invoke-static {p0, v8}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->dp(Landroid/content/Context;I)I

    move-result v10

    iput v10, v7, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    .line 169
    invoke-virtual {v4, v6, v3, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)V

    .line 171
    new-instance v10, Landroid/widget/ImageView;

    invoke-direct {v10, p0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    sget-object v3, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {v10, v3}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    .line 172
    const v3, -0x141d18

    invoke-static {p0, v3, v8}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->rounded(Landroid/content/Context;II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v3

    invoke-virtual {v10, v3}, Landroid/widget/ImageView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 173
    const/4 v3, 0x1

    invoke-virtual {v10, v3}, Landroid/widget/ImageView;->setClipToOutline(Z)V

    .line 174
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v7, 0x64

    invoke-static {p0, v7}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->dp(Landroid/content/Context;I)I

    move-result v11

    invoke-static {p0, v7}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->dp(Landroid/content/Context;I)I

    move-result v7

    invoke-direct {v4, v11, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v6, v10, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 175
    new-instance v4, Landroid/widget/LinearLayout;

    invoke-direct {v4, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v4, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 176
    invoke-static {p0, v8}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->dp(Landroid/content/Context;I)I

    move-result v7

    invoke-virtual {v4, v7, v1, v1, v1}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 177
    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v11, 0x3f800000    # 1.0f

    invoke-direct {v7, v1, v9, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v6, v4, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 178
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v9

    if-eqz v9, :cond_f9

    const-string v9, "\u25b6 \uc601\uc0c1"

    goto :goto_fb

    :cond_f9
    const-string v9, "\u25a3 \uc0ac\uc9c4"

    :goto_fb
    invoke-virtual {v7, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    const-string v9, " \u00b7 \uc9c0\uae08 \uae30\ub85d\ud560 \uc6d0\ubcf8"

    invoke-virtual {v7, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    const/16 v9, 0xe

    const v11, -0xd6cfc4

    invoke-static {p0, v7, v9, v11, v3}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->text(Landroid/content/Context;Ljava/lang/String;IIZ)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v4, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 179
    invoke-static {v2}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->stamp(Lorg/json/JSONObject;)Ljava/lang/String;

    move-result-object v3

    const/16 v7, 0xd

    const v9, -0x91988f

    invoke-static {p0, v3, v7, v9, v1}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->text(Landroid/content/Context;Ljava/lang/String;IIZ)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v4, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 180
    const-string v3, "\ubbf8\ub9ac\ubcf4\uae30\ub97c \ubd88\ub7ec\uc624\ub294 \uc911\u2026"

    const v7, -0x848f85

    invoke-static {p0, v3, v8, v7, v1}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->text(Landroid/content/Context;Ljava/lang/String;IIZ)Landroid/widget/TextView;

    move-result-object v7

    .line 181
    invoke-virtual {v4, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 182
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\ud604\uc7ac \uba54\ubaa8 \ub300\uc0c1 "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v5, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_145

    const-string v0, "\uc601\uc0c1 "

    goto :goto_147

    :cond_145
    const-string v0, "\uc0ac\uc9c4 "

    :goto_147
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {v2}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->stamp(Lorg/json/JSONObject;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v6, v0}, Landroid/widget/LinearLayout;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 183
    new-instance v0, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda1;

    invoke-direct {v0, p0, v5}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda1;-><init>(Landroid/app/Activity;Ljava/lang/String;)V

    invoke-virtual {v6, v0}, Landroid/widget/LinearLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 185
    sget-object v0, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->WORK:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda2;

    move-object v3, v1

    move-object v4, p0

    move-object v8, v10

    invoke-direct/range {v3 .. v8}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda2;-><init>(Landroid/app/Activity;Ljava/lang/String;Landroid/widget/LinearLayout;Landroid/widget/TextView;Landroid/widget/ImageView;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V
    :try_end_16f
    .catchall {:try_start_12 .. :try_end_16f} :catchall_171

    goto :goto_172

    .line 158
    :cond_170
    :goto_170
    return-void

    .line 197
    :catchall_171
    move-exception p0

    :goto_172
    nop

    .line 198
    return-void

    .line 147
    :cond_174
    :goto_174
    return-void
.end method

.method static synthetic lambda$decorateNotification$10(Landroid/content/Context;Ljava/lang/String;ILandroid/graphics/Bitmap;Lorg/json/JSONObject;)V
    .locals 9

    .line 237
    :try_start_0
    const-class v0, Landroid/app/NotificationManager;

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/NotificationManager;

    .line 238
    if-nez v0, :cond_b

    return-void

    .line 239
    :cond_b
    invoke-virtual {p1}, Ljava/lang/String;->hashCode()I

    move-result v1

    and-int/lit16 v1, v1, 0x7fff

    const v2, 0xa7f8

    add-int/2addr v1, v2

    .line 240
    nop

    .line 241
    invoke-virtual {v0}, Landroid/app/NotificationManager;->getActiveNotifications()[Landroid/service/notification/StatusBarNotification;

    move-result-object v2

    array-length v3, v2
    :try_end_1b
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_1b} :catch_cb

    const/4 v4, 0x0

    move v5, v4

    :goto_1d
    const-string v6, "moa_moment_capture_alerts_v2"

    if-ge v5, v3, :cond_3b

    :try_start_21
    aget-object v7, v2, v5

    .line 242
    invoke-virtual {v7}, Landroid/service/notification/StatusBarNotification;->getId()I

    move-result v8

    if-ne v8, v1, :cond_38

    invoke-virtual {v7}, Landroid/service/notification/StatusBarNotification;->getNotification()Landroid/app/Notification;

    move-result-object v8

    invoke-virtual {v8}, Landroid/app/Notification;->getChannelId()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v6, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_38

    .line 243
    goto :goto_3c

    .line 241
    :cond_38
    add-int/lit8 v5, v5, 0x1

    goto :goto_1d

    :cond_3b
    const/4 v7, 0x0

    .line 246
    :goto_3c
    if-nez v7, :cond_4e

    .line 247
    const/4 p3, 0x2

    if-ge p2, p3, :cond_4d

    sget-object p3, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->MAIN:Landroid/os/Handler;

    new-instance p4, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda7;

    invoke-direct {p4, p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda7;-><init>(Landroid/content/Context;Ljava/lang/String;I)V

    const-wide/16 p0, 0x258

    invoke-virtual {p3, p4, p0, p1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 248
    :cond_4d
    return-void

    .line 250
    :cond_4e
    invoke-virtual {v7}, Landroid/service/notification/StatusBarNotification;->getNotification()Landroid/app/Notification;

    move-result-object p2

    .line 251
    invoke-static {p0, p2}, Landroid/app/Notification$Builder;->recoverBuilder(Landroid/content/Context;Landroid/app/Notification;)Landroid/app/Notification$Builder;

    move-result-object p2

    .line 252
    invoke-virtual {p2, p3}, Landroid/app/Notification$Builder;->setLargeIcon(Landroid/graphics/Bitmap;)Landroid/app/Notification$Builder;

    move-result-object v1

    new-instance v2, Landroid/app/Notification$BigPictureStyle;

    invoke-direct {v2}, Landroid/app/Notification$BigPictureStyle;-><init>()V

    .line 253
    invoke-virtual {v2, p3}, Landroid/app/Notification$BigPictureStyle;->bigPicture(Landroid/graphics/Bitmap;)Landroid/app/Notification$BigPictureStyle;

    move-result-object p3

    invoke-virtual {v1, p3}, Landroid/app/Notification$Builder;->setStyle(Landroid/app/Notification$Style;)Landroid/app/Notification$Builder;

    move-result-object p3

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 254
    const-string v2, "v"

    invoke-virtual {p1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_77

    const-string p1, "\uc601\uc0c1"

    goto :goto_79

    :cond_77
    const-string p1, "\uc0ac\uc9c4"

    :goto_79
    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, " \u00b7 "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-static {p4}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->stamp(Lorg/json/JSONObject;)Ljava/lang/String;

    move-result-object p4

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p4, " \u00b7 \ub20c\ub7ec\uc11c \ud655\uc778"

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p3, p1}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object p1

    .line 255
    invoke-virtual {p1, v4}, Landroid/app/Notification$Builder;->setVisibility(I)Landroid/app/Notification$Builder;

    .line 256
    new-instance p1, Landroid/app/Notification$Builder;

    invoke-direct {p1, p0, v6}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 257
    const p0, 0x108003e

    invoke-virtual {p1, p0}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;

    move-result-object p0

    const-string p1, "\ubaa8\uc544 \u00b7 \uc0c8\ub85c\uc6b4 \ucd2c\uc601 \uae30\ub85d"

    .line 258
    invoke-virtual {p0, p1}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object p0

    const-string p1, "\uc7a0\uae08 \ud574\uc81c \ud6c4 \uc0ac\uc9c4\uacfc \uae30\ub85d\uc744 \ud655\uc778\ud558\uc138\uc694"

    .line 259
    invoke-virtual {p0, p1}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object p0

    .line 260
    invoke-virtual {p0}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object p0

    .line 261
    invoke-virtual {p2, p0}, Landroid/app/Notification$Builder;->setPublicVersion(Landroid/app/Notification;)Landroid/app/Notification$Builder;

    .line 264
    invoke-virtual {v7}, Landroid/service/notification/StatusBarNotification;->getTag()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v7}, Landroid/service/notification/StatusBarNotification;->getId()I

    move-result p1

    invoke-virtual {p2}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object p2

    invoke-virtual {v0, p0, p1, p2}, Landroid/app/NotificationManager;->notify(Ljava/lang/String;ILandroid/app/Notification;)V
    :try_end_ca
    .catch Ljava/lang/Exception; {:try_start_21 .. :try_end_ca} :catch_cb

    goto :goto_cc

    .line 265
    :catch_cb
    move-exception p0

    :goto_cc
    nop

    .line 266
    return-void
.end method

.method static synthetic lambda$decorateNotification$11(Landroid/content/Context;Ljava/lang/String;ILorg/json/JSONObject;)V
    .locals 8

    .line 233
    const/16 v0, 0x190

    const/16 v1, 0x154

    invoke-static {p0, p1, v0, v1}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->thumbnail(Landroid/content/Context;Ljava/lang/String;II)Landroid/graphics/Bitmap;

    move-result-object v6

    .line 234
    if-nez v6, :cond_b

    return-void

    .line 235
    :cond_b
    sget-object v0, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda5;

    move-object v2, v1

    move-object v3, p0

    move-object v4, p1

    move v5, p2

    move-object v7, p3

    invoke-direct/range {v2 .. v7}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda5;-><init>(Landroid/content/Context;Ljava/lang/String;ILandroid/graphics/Bitmap;Lorg/json/JSONObject;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 267
    return-void
.end method

.method static synthetic lambda$decorateNotification$9(Landroid/content/Context;Ljava/lang/String;I)V
    .locals 0

    .line 247
    add-int/lit8 p2, p2, 0x1

    invoke-static {p0, p1, p2}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->decorateNotification(Landroid/content/Context;Ljava/lang/String;I)V

    return-void
.end method

.method static synthetic lambda$installCard$3(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View;)V
    .locals 0

    .line 183
    invoke-static {p0, p1}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->showMedia(Landroid/app/Activity;Ljava/lang/String;)V

    return-void
.end method

.method static synthetic lambda$installCard$4(Landroid/app/Activity;Landroid/widget/LinearLayout;Landroid/graphics/Bitmap;Landroid/widget/TextView;Landroid/widget/ImageView;Ljava/lang/String;)V
    .locals 0

    .line 188
    invoke-virtual {p0}, Landroid/app/Activity;->isDestroyed()Z

    move-result p0

    if-nez p0, :cond_2d

    invoke-virtual {p1}, Landroid/widget/LinearLayout;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    if-nez p0, :cond_d

    goto :goto_2d

    .line 189
    :cond_d
    if-nez p2, :cond_19

    const-string p0, "\uc6d0\ubcf8\uc744 \ud655\uc778\ud560 \uc218 \uc5c6\uc74c \u00b7 \ub2e4\ub978 \uc0ac\uc9c4\uc73c\ub85c \ubc14\uafb8\uc9c0 \uc54a\uc74c"

    invoke-virtual {p3, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 190
    const/4 p0, 0x0

    invoke-virtual {p1, p0}, Landroid/widget/LinearLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    goto :goto_2c

    .line 192
    :cond_19
    invoke-virtual {p4, p2}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    .line 193
    const-string p0, "v"

    invoke-virtual {p5, p0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_27

    const-string p0, "\ub20c\ub7ec\uc11c \uc6d0\ubcf8 \uc601\uc0c1 \uc7ac\uc0dd"

    goto :goto_29

    :cond_27
    const-string p0, "\ub20c\ub7ec\uc11c \uc0ac\uc9c4 \ud06c\uac8c \ud655\uc778"

    :goto_29
    invoke-virtual {p3, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 195
    :goto_2c
    return-void

    .line 188
    :cond_2d
    :goto_2d
    return-void
.end method

.method static synthetic lambda$installCard$5(Landroid/app/Activity;Ljava/lang/String;Landroid/widget/LinearLayout;Landroid/widget/TextView;Landroid/widget/ImageView;)V
    .locals 9

    .line 186
    invoke-virtual {p0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    const/16 v1, 0x168

    invoke-static {v0, p1, v1, v1}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->thumbnail(Landroid/content/Context;Ljava/lang/String;II)Landroid/graphics/Bitmap;

    move-result-object v5

    .line 187
    sget-object v0, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda6;

    move-object v2, v1

    move-object v3, p0

    move-object v4, p2

    move-object v6, p3

    move-object v7, p4

    move-object v8, p1

    invoke-direct/range {v2 .. v8}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda6;-><init>(Landroid/app/Activity;Landroid/widget/LinearLayout;Landroid/graphics/Bitmap;Landroid/widget/TextView;Landroid/widget/ImageView;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 196
    return-void
.end method

.method static synthetic lambda$onCreate$1(Landroid/content/Context;Ljava/lang/String;)V
    .locals 1

    .line 77
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->decorateNotification(Landroid/content/Context;Ljava/lang/String;I)V

    return-void
.end method

.method static synthetic lambda$onCreate$2(Landroid/content/Context;Landroid/content/SharedPreferences;Ljava/lang/String;)V
    .locals 5

    .line 67
    if-eqz p2, :cond_64

    const-string v0, "m:"

    invoke-virtual {p2, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_b

    goto :goto_64

    .line 68
    :cond_b
    const/4 v0, 0x2

    invoke-virtual {p2, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v0

    .line 69
    invoke-static {v0}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->valid(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_17

    return-void

    .line 70
    :cond_17
    const/4 v1, 0x0

    invoke-interface {p1, p2, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 71
    if-nez p1, :cond_1f

    return-void

    .line 73
    :cond_1f
    :try_start_1f
    new-instance p2, Lorg/json/JSONObject;

    invoke-direct {p2, p1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 74
    const-string p1, "id"

    invoke-virtual {p2, p1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_60

    const-string p1, "memoSaved"

    const/4 v1, 0x0

    invoke-virtual {p2, p1, v1}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result p1

    if-eqz p1, :cond_3a

    goto :goto_60

    .line 75
    :cond_3a
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    const-string p1, "capturedAt"

    const-wide/16 v3, 0x0

    invoke-virtual {p2, p1, v3, v4}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide p1

    sub-long/2addr v1, p1

    .line 76
    cmp-long p1, v1, v3

    if-ltz p1, :cond_5f

    const-wide/16 p1, 0x7530

    cmp-long p1, v1, p1

    if-lez p1, :cond_52

    goto :goto_5f

    .line 77
    :cond_52
    sget-object p1, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->MAIN:Landroid/os/Handler;

    new-instance p2, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda0;

    invoke-direct {p2, p0, v0}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda0;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    const-wide/16 v0, 0x3e8

    invoke-virtual {p1, p2, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    :try_end_5e
    .catch Ljava/lang/Exception; {:try_start_1f .. :try_end_5e} :catch_61

    goto :goto_62

    .line 76
    :cond_5f
    :goto_5f
    return-void

    .line 74
    :cond_60
    :goto_60
    return-void

    .line 78
    :catch_61
    move-exception p0

    :goto_62
    nop

    .line 79
    return-void

    .line 67
    :cond_64
    :goto_64
    return-void
.end method

.method static synthetic lambda$showMedia$6(Landroid/app/Dialog;Landroid/view/View;)V
    .locals 0

    .line 211
    invoke-virtual {p0}, Landroid/app/Dialog;->dismiss()V

    return-void
.end method

.method static synthetic lambda$showMedia$7(Landroid/app/Dialog;Landroid/graphics/Bitmap;Landroid/widget/ImageView;)V
    .locals 1

    .line 221
    invoke-virtual {p0}, Landroid/app/Dialog;->isShowing()Z

    move-result v0

    if-nez v0, :cond_7

    return-void

    .line 222
    :cond_7
    if-eqz p1, :cond_d

    invoke-virtual {p2, p1}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    goto :goto_10

    .line 223
    :cond_d
    invoke-virtual {p0}, Landroid/app/Dialog;->dismiss()V

    .line 224
    :goto_10
    return-void
.end method

.method static synthetic lambda$showMedia$8(Landroid/app/Activity;Ljava/lang/String;Landroid/app/Dialog;Landroid/widget/ImageView;)V
    .locals 2

    .line 219
    invoke-virtual {p0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    const/16 v0, 0x438

    const/16 v1, 0x5a0

    invoke-static {p0, p1, v0, v1}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->thumbnail(Landroid/content/Context;Ljava/lang/String;II)Landroid/graphics/Bitmap;

    move-result-object p0

    .line 220
    sget-object p1, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->MAIN:Landroid/os/Handler;

    new-instance v0, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda4;

    invoke-direct {v0, p2, p0, p3}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda4;-><init>(Landroid/app/Dialog;Landroid/graphics/Bitmap;Landroid/widget/ImageView;)V

    invoke-virtual {p1, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 225
    return-void
.end method

.method static synthetic lambda$static$0(Ljava/lang/Runnable;)Ljava/lang/Thread;
    .locals 2

    .line 57
    new-instance v0, Ljava/lang/Thread;

    const-string v1, "MOA-R709-Preview"

    invoke-direct {v0, p0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    const/4 p0, 0x1

    invoke-virtual {v0, p0}, Ljava/lang/Thread;->setDaemon(Z)V

    return-object v0
.end method

.method private static mediaUri(Ljava/lang/String;)Landroid/net/Uri;
    .locals 3

    .line 106
    const-string v0, "v"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_e

    const/4 v1, 0x1

    invoke-virtual {p0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v1

    goto :goto_f

    :cond_e
    move-object v1, p0

    :goto_f
    invoke-static {v1}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v1

    .line 107
    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_1c

    .line 108
    sget-object p0, Landroid/provider/MediaStore$Video$Media;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;

    goto :goto_1e

    :cond_1c
    sget-object p0, Landroid/provider/MediaStore$Images$Media;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;

    .line 107
    :goto_1e
    invoke-static {p0, v1, v2}, Landroid/content/ContentUris;->withAppendedId(Landroid/net/Uri;J)Landroid/net/Uri;

    move-result-object p0

    return-object p0
.end method

.method private static rounded(Landroid/content/Context;II)Landroid/graphics/drawable/GradientDrawable;
    .locals 1

    .line 128
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v0}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    invoke-virtual {v0, p1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    .line 129
    invoke-static {p0, p2}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->dp(Landroid/content/Context;I)I

    move-result p0

    int-to-float p0, p0

    invoke-virtual {v0, p0}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    return-object v0
.end method

.method private static showMedia(Landroid/app/Activity;Ljava/lang/String;)V
    .locals 4

    .line 201
    :try_start_0
    invoke-static {p1}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->mediaUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    .line 202
    const-string v1, "v"

    invoke-virtual {p1, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_22

    .line 203
    new-instance p1, Landroid/content/Intent;

    const-string v1, "android.intent.action.VIEW"

    invoke-direct {p1, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v1, "video/*"

    invoke-virtual {p1, v0, v1}, Landroid/content/Intent;->setDataAndType(Landroid/net/Uri;Ljava/lang/String;)Landroid/content/Intent;

    move-result-object p1

    .line 204
    const/4 v0, 0x1

    invoke-virtual {p1, v0}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    move-result-object p1

    .line 205
    invoke-virtual {p0, p1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    return-void

    .line 207
    :cond_22
    new-instance v0, Landroid/app/Dialog;

    invoke-direct {v0, p0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    .line 208
    new-instance v1, Landroid/widget/ImageView;

    invoke-direct {v1, p0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    .line 209
    sget-object v2, Landroid/widget/ImageView$ScaleType;->FIT_CENTER:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {v1, v2}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    .line 210
    const/high16 v2, -0x1000000

    invoke-virtual {v1, v2}, Landroid/widget/ImageView;->setBackgroundColor(I)V

    .line 211
    new-instance v2, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda9;

    invoke-direct {v2, v0}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda9;-><init>(Landroid/app/Dialog;)V

    invoke-virtual {v1, v2}, Landroid/widget/ImageView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 212
    invoke-virtual {v0, v1}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 213
    invoke-virtual {v0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v2

    invoke-virtual {v2}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v2

    .line 214
    const/4 v3, -0x1

    iput v3, v2, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 215
    iput v3, v2, Landroid/view/WindowManager$LayoutParams;->height:I

    .line 216
    invoke-virtual {v0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v3

    invoke-virtual {v3, v2}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    .line 217
    invoke-virtual {v0}, Landroid/app/Dialog;->show()V

    .line 218
    sget-object v2, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->WORK:Ljava/util/concurrent/ExecutorService;

    new-instance v3, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda10;

    invoke-direct {v3, p0, p1, v0, v1}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda10;-><init>(Landroid/app/Activity;Ljava/lang/String;Landroid/app/Dialog;Landroid/widget/ImageView;)V

    invoke-interface {v2, v3}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V
    :try_end_62
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_62} :catch_63

    goto :goto_64

    .line 226
    :catch_63
    move-exception p0

    :goto_64
    nop

    .line 227
    return-void
.end method

.method private static stamp(Lorg/json/JSONObject;)Ljava/lang/String;
    .locals 5

    .line 123
    const-string v0, "at"

    const-wide/16 v1, 0x0

    invoke-virtual {p0, v0, v1, v2}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide v3

    .line 124
    cmp-long p0, v3, v1

    if-gtz p0, :cond_f

    const-string p0, "\ucd2c\uc601 \uc2dc\uac01 \ud655\uc778 \uc911"

    return-object p0

    .line 125
    :cond_f
    new-instance p0, Ljava/text/SimpleDateFormat;

    const-string v0, "M\uc6d4 d\uc77c a h:mm"

    sget-object v1, Ljava/util/Locale;->KOREA:Ljava/util/Locale;

    invoke-direct {p0, v0, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v0, Ljava/util/Date;

    invoke-direct {v0, v3, v4}, Ljava/util/Date;-><init>(J)V

    invoke-virtual {p0, v0}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static text(Landroid/content/Context;Ljava/lang/String;IIZ)Landroid/widget/TextView;
    .locals 1

    .line 133
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    int-to-float p0, p2

    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-virtual {v0, p3}, Landroid/widget/TextView;->setTextColor(I)V

    .line 134
    if-eqz p4, :cond_16

    const/4 p0, 0x0

    const/4 p1, 0x1

    invoke-virtual {v0, p0, p1}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;I)V

    :cond_16
    return-object v0
.end method

.method private static thumbnail(Landroid/content/Context;Ljava/lang/String;II)Landroid/graphics/Bitmap;
    .locals 2

    .line 117
    const/4 v0, 0x0

    :try_start_1
    invoke-static {p1}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->mediaUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    .line 118
    invoke-static {p0, p1}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->available(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v1

    if-nez v1, :cond_c

    return-object v0

    .line 119
    :cond_c
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    new-instance v1, Landroid/util/Size;

    invoke-direct {v1, p2, p3}, Landroid/util/Size;-><init>(II)V

    invoke-virtual {p0, p1, v1, v0}, Landroid/content/ContentResolver;->loadThumbnail(Landroid/net/Uri;Landroid/util/Size;Landroid/os/CancellationSignal;)Landroid/graphics/Bitmap;

    move-result-object p0
    :try_end_19
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_19} :catch_1a

    return-object p0

    .line 120
    :catch_1a
    move-exception p0

    return-object v0
.end method

.method private static valid(Ljava/lang/String;)Z
    .locals 1

    .line 94
    if-eqz p0, :cond_c

    const-string v0, "(?:v[0-9]{1,18}|[0-9]{1,19})"

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


# virtual methods
.method public delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 0

    .line 273
    const/4 p1, 0x0

    return p1
.end method

.method public getType(Landroid/net/Uri;)Ljava/lang/String;
    .locals 0

    .line 271
    const/4 p1, 0x0

    return-object p1
.end method

.method public insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;
    .locals 0

    .line 272
    const/4 p1, 0x0

    return-object p1
.end method

.method public onCreate()Z
    .locals 4

    .line 63
    invoke-virtual {p0}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 64
    const/4 v1, 0x1

    if-nez v0, :cond_8

    return v1

    .line 65
    :cond_8
    const-string v2, "moa_camera_native_v1"

    const/4 v3, 0x0

    invoke-virtual {v0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    iput-object v2, p0, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->prefs:Landroid/content/SharedPreferences;

    .line 66
    new-instance v2, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda3;

    invoke-direct {v2, v0}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$$ExternalSyntheticLambda3;-><init>(Landroid/content/Context;)V

    iput-object v2, p0, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->listener:Landroid/content/SharedPreferences$OnSharedPreferenceChangeListener;

    .line 80
    iget-object v2, p0, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->prefs:Landroid/content/SharedPreferences;

    iget-object v3, p0, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;->listener:Landroid/content/SharedPreferences$OnSharedPreferenceChangeListener;

    invoke-interface {v2, v3}, Landroid/content/SharedPreferences;->registerOnSharedPreferenceChangeListener(Landroid/content/SharedPreferences$OnSharedPreferenceChangeListener;)V

    .line 81
    invoke-virtual {v0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    .line 82
    instance-of v2, v0, Landroid/app/Application;

    if-eqz v2, :cond_31

    check-cast v0, Landroid/app/Application;

    new-instance v2, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$1;

    invoke-direct {v2, p0}, Lcom/juhyeon/familyjourney/MoaR709PreviewProvider$1;-><init>(Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;)V

    invoke-virtual {v0, v2}, Landroid/app/Application;->registerActivityLifecycleCallbacks(Landroid/app/Application$ActivityLifecycleCallbacks;)V

    .line 91
    :cond_31
    return v1
.end method

.method public query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    .locals 0

    .line 270
    const/4 p1, 0x0

    return-object p1
.end method

.method public update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 0

    .line 274
    const/4 p1, 0x0

    return p1
.end method
