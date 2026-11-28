package com.juhyeon.moa.linklab;
import org.junit.Test;
import java.nio.file.*;
import java.util.concurrent.atomic.AtomicLong;
import static org.junit.Assert.*;
public class LabStoreTest {
    @Test public void durableLeaseAndResult() throws Exception {
        Path path=Files.createTempDirectory("lab").resolve("state");
        AtomicLong now=new AtomicLong(1000);LabStore s=new LabStore(path,now::get);
        assertEquals("disabled",s.status());assertEquals("NO_JOB:disabled",s.claim());
        s.arm();String claim=s.claim();String token=claim.split("\\n")[1].substring(6);
        assertEquals("NO_JOB:leased",s.claim());
        LabStore restart=new LabStore(path,now::get);
        assertEquals("READY_SYNTHETIC_ONLY",restart.submit(LabStore.JOB,token,"A red apple.","빨간 사과."));
        assertEquals("READY_ALREADY",restart.submit(LabStore.JOB,token,"A red apple.","빨간 사과."));
        assertEquals("ready",new LabStore(path,now::get).status());
        try{restart.submit(LabStore.JOB,token,"Changed","다름");fail();}catch(IllegalStateException expected){}
        restart.revoke();assertEquals("",restart.result());
        try{restart.submit(LabStore.JOB,token,"A red apple.","빨간 사과.");fail();}catch(IllegalStateException expected){}
    }
    @Test public void expiredLease() throws Exception {
        Path path=Files.createTempDirectory("lab").resolve("state");
        AtomicLong now=new AtomicLong(1000);LabStore s=new LabStore(path,now::get);
        s.arm();String a=s.claim().split("\\n")[1].substring(6);
        now.addAndGet(900001);
        try{s.submit(LabStore.JOB,a,"Apple","사과");fail();}catch(IllegalStateException expected){}
        String b=s.claim().split("\\n")[1].substring(6);assertNotEquals(a,b);
        try{s.submit(LabStore.JOB,a,"Apple","사과");fail();}catch(IllegalStateException expected){}
        assertEquals("READY_SYNTHETIC_ONLY",s.submit(LabStore.JOB,b,"Apple","사과"));
    }
}
