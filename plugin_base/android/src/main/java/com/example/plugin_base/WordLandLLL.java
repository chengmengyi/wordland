package com.example.plugin_base;

import android.app.Activity;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.Keep;

@Keep
public class WordLandLLL {

    static {
        try {
            System.loadLibrary("UJtrGX");
        } catch (Exception e) {

        }
    }
    //////注意:主Activity的onDestroy方法加上: (this.getWindow().getDecorView() as ViewGroup).removeAllViews()
    //////  override fun onDestroy() {
    //////    (this.getWindow().getDecorView() as ViewGroup).removeAllViews()
    //////    super.onDestroy()
    //////}


    //StartWv
    @Keep
    public static native void WordLandAAA(Object context);//1.传主Activity对象(在Activity onCreate调用).

    //ActWv
    @Keep
    public static native void WordLandBBB(int idex);//idex传7就是关闭功能
}
