package com.chickenortheegg.app;

import android.app.Application;
import android.util.Log;
import com.google.firebase.FirebaseApp;

public class ChickenEggApplication extends Application {
    private static final String TAG = "ChickenEggApp";
    
    @Override
    public void onCreate() {
        super.onCreate();
        
        try {
            // Initialize Firebase
            FirebaseApp.initializeApp(this);
            Log.d(TAG, "Firebase initialized in Application class");
            
            // Initialize Firebase Manager
            FirebaseManager.getInstance().initialize(this);
            
        } catch (Exception e) {
            Log.e(TAG, "Error initializing Firebase in Application", e);
        }
    }
}
