package com.example.isw_mobile_sdk_sample_flutter;

import android.content.Context;

import androidx.multidex.MultiDex;
import androidx.multidex.MultiDexApplication;

import io.flutter.app.FlutterApplication;

public class SampleApplication extends FlutterApplication {


    @Override
    public void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }

    @Override
    public void onCreate() {
        super.onCreate();
    }
}
