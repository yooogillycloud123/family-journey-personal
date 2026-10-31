package com.juhyeon.familyjourney;

import android.Manifest;
import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Size;
import android.widget.RemoteViews;
import java.util.Calendar;
import java.util.Locale;

/**
 * MOA home-screen family memories. Read-only, on-device; no servers,
 * no private diary database or browser state, and no new permissions.
 */
public class MoaMemoryWidget extends AppWidgetProvider {
    public static final String REFRESH = "com.juhyeon.familyjourney.MOA_WIDGET_REFRESH";

    protected int widgetLayout() { return R.layout.moa_widget_compact; }

    @Override public void onUpdate(Context context, AppWidgetManager manager, int[] ids) {
        for (int id : ids) draw(context, manager, id);
    }

    @Override public void onAppWidgetOptionsChanged(Context context,
            AppWidgetManager manager, int widgetId, Bundle options) {
        draw(context, manager, widgetId);
    }

    @Override public void onReceive(Context context, Intent intent) {
        super.onReceive(context, intent);
        if (REFRESH.equals(intent.getAction())) {
            int id = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, -1);
            if (id > 0) draw(context, AppWidgetManager.getInstance(context), id);
        }
    }

    private static final class Memory {
        final Uri uri; final int year;
        Memory(Uri image, int y) { uri=image; year=y; }
    }

    private static Memory queryPhoto(Context ctx, long start, long end, int year) {
        String[] columns = {MediaStore.Images.Media._ID};
        String where = MediaStore.Images.Media.DATE_TAKEN + ">=? AND " +
                MediaStore.Images.Media.DATE_TAKEN + "<?";
        String[] args = {String.valueOf(start), String.valueOf(end)};
        try (Cursor c = ctx.getContentResolver().query(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                columns, where, args, MediaStore.Images.Media.DATE_TAKEN + " DESC")) {
            if (c != null && c.moveToFirst()) {
                return new Memory(ContentUris.withAppendedId(
                        MediaStore.Images.Media.EXTERNAL_CONTENT_URI, c.getLong(0)), year);
            }
        } catch (SecurityException | IllegalArgumentException ignored) { }
        return null;
    }

    private static Memory findOnThisDay(Context ctx) {
        if (ctx.checkSelfPermission(Manifest.permission.READ_MEDIA_IMAGES) != PackageManager.PERMISSION_GRANTED &&
            ctx.checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED &&
            ctx.checkSelfPermission(Manifest.permission.READ_MEDIA_VISUAL_USER_SELECTED) != PackageManager.PERMISSION_GRANTED)
            return null;
        Calendar now=Calendar.getInstance();
        int year=now.get(Calendar.YEAR), month=now.get(Calendar.MONTH), day=now.get(Calendar.DAY_OF_MONTH);
        for (int y=year; y>=Math.max(2010,year-12); y--) {
            Calendar start=Calendar.getInstance();
            start.setLenient(false);
            try {
                start.clear(); start.set(y,month,day,0,0,0);
                long a=start.getTimeInMillis();
                Calendar next=(Calendar)start.clone();next.add(Calendar.DAY_OF_MONTH,1);
                Memory m=queryPhoto(ctx,a,next.getTimeInMillis(),y);
                if(m!=null)return m;
            } catch(IllegalArgumentException ignored) {}
        }
        return null;
    }

    private void draw(Context ctx, AppWidgetManager manager, int id) {
        boolean wide = widgetLayout()==R.layout.moa_widget_wide;
        RemoteViews rv=new RemoteViews(ctx.getPackageName(),widgetLayout());
        Calendar now=Calendar.getInstance();
        String today=String.format(Locale.KOREA,"%d월 %d일",now.get(Calendar.MONTH)+1,now.get(Calendar.DAY_OF_MONTH));
        rv.setTextViewText(R.id.moa_widget_date,today);
        rv.setTextViewText(R.id.moa_widget_caption,"오늘의 가족 기억");
        rv.setTextViewText(R.id.moa_widget_footer,"우리 가족의 모든 기억, 모아");
        Memory memory=findOnThisDay(ctx);
        if(memory!=null) {
            try {
                Bitmap thumb=ctx.getContentResolver().loadThumbnail(memory.uri,
                        wide?new Size(420,320):new Size(320,320),null);
                rv.setImageViewBitmap(R.id.moa_widget_photo,thumb);
                rv.setTextViewText(R.id.moa_widget_caption,
                        memory.year==now.get(Calendar.YEAR) ? "오늘 찍은 사진" : memory.year+"년 오늘의 추억");
            } catch(Exception ignored) {
                rv.setTextViewResource(R.id.moa_widget_caption,R.string.moa_widget_empty);
            }
        } else {
            rv.setTextViewText(R.id.moa_widget_caption,"사진 접근 허용 후 추억이 나타나요");
        }

        Intent launch=new Intent(ctx,HostActivity.class)
                .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP|Intent.FLAG_ACTIVITY_SINGLE_TOP);
        PendingIntent open=PendingIntent.getActivity(ctx,id*11+1,launch,
                PendingIntent.FLAG_UPDATE_CURRENT|PendingIntent.FLAG_IMMUTABLE);
        rv.setOnClickPendingIntent(R.id.moa_widget_surface,open);
        rv.setOnClickPendingIntent(R.id.moa_widget_open,open);

        Intent refresh=new Intent(ctx,getClass()).setAction(REFRESH)
                .putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID,id);
        PendingIntent update=PendingIntent.getBroadcast(ctx,id*11+2,refresh,
                PendingIntent.FLAG_UPDATE_CURRENT|PendingIntent.FLAG_IMMUTABLE);
        rv.setOnClickPendingIntent(R.id.moa_widget_refresh,update);
        manager.updateAppWidget(id,rv);
    }
}
