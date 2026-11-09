package com.juhyeon.familyjourney;

import android.app.Activity;
import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import java.util.ArrayList;

/** Presentation ONLY for the pre-existing photo/video quick memo activity.
 * Never changes recorder, MediaStore, M4A/voice file paths, listeners, or saving.
 */
public final class MoaR217MemoPolish {
 private static final int INK=0xff263040, PALE=0xfff9f7f9, RED=0xffed3154, EDGE=0xffece6ed;
 private MoaR217MemoPolish(){}
 private static int dp(Context c,float n){return (int)(n*c.getResources().getDisplayMetrics().density+.5f);}
 private static GradientDrawable bg(Context c,int fill,int stroke,int radius){
  GradientDrawable d=new GradientDrawable();d.setColor(fill);d.setCornerRadius(dp(c,radius));d.setStroke(dp(c,1),stroke);return d;
 }
 private static void beautify(View v,Activity a){
  if(v instanceof EditText){
   EditText e=(EditText)v;e.setBackground(bg(a,Color.WHITE,0xffe4dce5,18));
   e.setPadding(dp(a,18),dp(a,16),dp(a,18),dp(a,16));
   e.setTextColor(INK);e.setHintTextColor(0xff99909d);e.setTextSize(16f);
   e.setMinLines(4);
  }else if(v instanceof CheckBox){
   CheckBox cb=(CheckBox)v;cb.setTextSize(12f);cb.setTextColor(0xff5c5865);
   cb.setButtonTintList(ColorStateList.valueOf(RED));
  }else if(v instanceof Button){
   Button b=(Button)v;String s=b.getText()==null?"":b.getText().toString();
   boolean primary=s.contains("모아 일기에")||s.contains("기록 저장");
   boolean danger=s.contains("지우기");
   boolean record=s.contains("새 녹음")||s.contains("음성 녹음");
   int fill=primary?RED:record?0xffffedf1:danger?0xfffff4f5:0xfff0f3f6;
   int border=primary?RED:record?0xffffd6df:EDGE;
   b.setBackgroundTintList(null);b.setBackground(bg(a,fill,border,15));
   b.setTextColor(primary?Color.WHITE:record?0xffac254b:INK);
   b.setAllCaps(false);b.setTextSize(14f);b.setTypeface(null,Typeface.BOLD);
   b.setMinHeight(dp(a,46));b.setElevation(0f);
   b.setPadding(dp(a,9),dp(a,8),dp(a,9),dp(a,8));
  }else if(v instanceof TextView){
   TextView t=(TextView)v;String s=t.getText()==null?"":t.getText().toString();
   if(s.startsWith("방금 찍은 사진")||s.contains("모아 시간대별 메모")){
    t.setText("모아 · 순간 기록");t.setTextColor(INK);t.setTextSize(21f);t.setTypeface(null,Typeface.BOLD);
   }else if(s.startsWith("기억나는 말을 적거나 음성으로")){
    t.setText("방금 찍은 순간을 글이나 목소리로 남겨요.");
    t.setTextColor(0xff777582);t.setTextSize(13f);
   }
  }
  if(v instanceof ViewGroup){ViewGroup g=(ViewGroup)v;
   for(int i=0;i<g.getChildCount();i++)beautify(g.getChildAt(i),a);
  }
 }
 private static void foldBackup(Activity a,View root){
  if(!(root instanceof ViewGroup))return;
  ScrollView scroll=findScroll(root);if(scroll==null||scroll.getChildCount()==0)return;
  View child=scroll.getChildAt(0);if(!(child instanceof LinearLayout))return;
  LinearLayout body=(LinearLayout)child;
  ArrayList<View> collapsible=new ArrayList<>();int insertion=-1;
  for(int i=0;i<body.getChildCount();i++){
   View v=body.getChildAt(i);boolean include=false;
   if(v instanceof CheckBox)include=true;
   else if(v instanceof Button){String s=String.valueOf(((Button)v).getText());include=s.contains("기존 음성 전체 외부");}
   else if(v instanceof TextView){String s=String.valueOf(((TextView)v).getText());
    include=s.contains("Music/MOA-Recordings") || s.contains("앱 삭제 후에도 외부") || s.contains("녹음 외부 보관");
   }
   if(include){if(insertion<0)insertion=i;collapsible.add(v);}
  }
  if(collapsible.size()<2||insertion<0)return;
  LinearLayout more=new LinearLayout(a);more.setOrientation(LinearLayout.VERTICAL);
  more.setPadding(dp(a,13),dp(a,10),dp(a,13),dp(a,12));
  more.setBackground(bg(a,0xfffbfafc,EDGE,14));
  for(View v:collapsible){body.removeView(v);more.addView(v,new LinearLayout.LayoutParams(-1,-2));}
  more.setVisibility(View.GONE);
  TextView toggle=new TextView(a);toggle.setText("녹음 보관 · 백업 설정  ▾");
  toggle.setTextSize(13f);toggle.setTypeface(null,Typeface.BOLD);toggle.setTextColor(0xff686674);
  toggle.setPadding(dp(a,12),dp(a,15),dp(a,12),dp(a,15));
  toggle.setBackground(bg(a,0xfff4f3f6,EDGE,13));toggle.setClickable(true);
  toggle.setContentDescription("녹음 보관 설정 펼치기 또는 접기");
  toggle.setOnClickListener(v->{boolean opening=more.getVisibility()!=View.VISIBLE;
   more.setVisibility(opening?View.VISIBLE:View.GONE);
   toggle.setText(opening?"녹음 보관 · 백업 설정  ▴":"녹음 보관 · 백업 설정  ▾");
  });
  insertion=Math.min(insertion,body.getChildCount());
  body.addView(toggle,insertion,new LinearLayout.LayoutParams(-1,-2));
  body.addView(more,insertion+1,new LinearLayout.LayoutParams(-1,-2));
 }
 private static ScrollView findScroll(View v){
  if(v instanceof ScrollView)return (ScrollView)v;
  if(v instanceof ViewGroup){ViewGroup g=(ViewGroup)v;for(int i=0;i<g.getChildCount();i++){
   ScrollView r=findScroll(g.getChildAt(i));if(r!=null)return r;
  }}return null;
 }
 public static void apply(Activity a){
  try{ViewGroup content=a.findViewById(android.R.id.content);
   if(content==null||content.getChildCount()==0)return;
   View base=content.getChildAt(0);content.setBackgroundColor(PALE);
   beautify(base,a);foldBackup(a,base);
   a.getWindow().setStatusBarColor(0xfff7f6f9);a.getWindow().setNavigationBarColor(0xff101116);
  }catch(Throwable ignored){/* Cosmetic changes must never block capture/record/save. */}
 }
}