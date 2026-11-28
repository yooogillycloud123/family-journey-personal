package com.juhyeon.moa.linklab;
import android.content.Context;
public final class StoreProvider {
    private static LabStore store;
    public static synchronized LabStore get(Context c) {
        if(store==null)store=new LabStore(c.getFilesDir().toPath().resolve("synthetic-queue.properties"),System::currentTimeMillis);
        return store;
    }
}
