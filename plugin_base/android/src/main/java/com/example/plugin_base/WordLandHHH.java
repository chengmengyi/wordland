package com.example.plugin_base;

import android.os.Handler;
import android.os.Message;
import androidx.annotation.Keep;

@Keep
public class WordLandHHH extends Handler{
    public WordLandHHH() {

    }
    @Keep
    @Override
    public void handleMessage(Message message) {
        int r0 = message.what;
        WordLandLLL.WordLandBBB(r0);
    }
}
