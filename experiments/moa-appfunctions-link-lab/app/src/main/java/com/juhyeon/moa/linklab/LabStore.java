package com.juhyeon.moa.linklab;

import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.function.LongSupplier;

/** Single-process durable fixture queue. No access to MOA production storage. */
public final class LabStore {
    public static final String JOB = "synthetic-apple-001";
    public static final String SCENE = "A red apple sits on a wooden table.";
    private final Path path;
    private final LongSupplier clock;
    public LabStore(Path path, LongSupplier clock) { this.path=path; this.clock=clock; }
    private Properties read() throws IOException {
        Properties p=new Properties();
        if(Files.exists(path)) try(InputStream in=Files.newInputStream(path)){p.load(in);}
        return p;
    }
    private void write(Properties p) throws IOException {
        Path dir=path.toAbsolutePath().getParent();
        Files.createDirectories(dir);
        Path tmp=Files.createTempFile(dir,"lab-",".tmp");
        try {
            try(FileOutputStream out=new FileOutputStream(tmp.toFile())){p.store(out,null);out.getFD().sync();}
            Files.move(tmp,path,StandardCopyOption.ATOMIC_MOVE,StandardCopyOption.REPLACE_EXISTING);
        } finally { Files.deleteIfExists(tmp); }
    }
    public synchronized void arm() throws IOException {
        Properties p=new Properties();p.setProperty("state","queued");write(p);
    }
    public synchronized void revoke() throws IOException {
        Properties p=new Properties();p.setProperty("state","disabled");write(p);
    }
    public synchronized String status() throws IOException {return read().getProperty("state","disabled");}
    public synchronized String claim() throws IOException {
        Properties p=read();String state=p.getProperty("state","disabled");
        if(state.equals("leased") && Long.parseLong(p.getProperty("expires","0"))<=clock.getAsLong())state="queued";
        if(!state.equals("queued"))return "NO_JOB:"+state;
        String lease=UUID.randomUUID().toString();
        p.setProperty("state","leased");p.setProperty("lease",lease);p.setProperty("expires",Long.toString(clock.getAsLong()+900000));
        write(p);
        return "job="+JOB+"\nlease="+lease+"\nscene="+SCENE;
    }
    public synchronized String submit(String job,String lease,String english,String korean) throws IOException {
        if(!JOB.equals(job)||lease==null||english==null||korean==null||english.isBlank()||korean.isBlank()
          ||english.length()>512||korean.length()>512||english.indexOf('<')>=0||korean.indexOf('<')>=0)
            throw new IllegalArgumentException("Invalid synthetic result");
        Properties p=read();String state=p.getProperty("state","disabled");
        if(!lease.equals(p.getProperty("lease")))throw new IllegalStateException("Unknown lease");
        if(state.equals("ready")){
            if(english.equals(p.getProperty("english"))&&korean.equals(p.getProperty("korean")))return "READY_ALREADY";
            throw new IllegalStateException("Completed result differs");
        }
        if(!state.equals("leased")||Long.parseLong(p.getProperty("expires","0"))<=clock.getAsLong())throw new IllegalStateException("Lease expired or disabled");
        p.setProperty("state","ready");p.setProperty("english",english);p.setProperty("korean",korean);write(p);
        return "READY_SYNTHETIC_ONLY";
    }
    public synchronized String result() throws IOException {
        Properties p=read();
        if(!"ready".equals(p.getProperty("state")))return "";
        return p.getProperty("english")+"\n"+p.getProperty("korean");
    }
}
