package com.chickenortheegg.app;

import com.google.firebase.FirebaseApp;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.auth.FirebaseAuth;

public class FirebaseManager {
    private static FirebaseManager instance;
    private FirebaseStorage storage;
    private FirebaseFirestore firestore;
    private FirebaseAuth auth;
    
    private FirebaseManager() {
        // Initialize Firebase Storage with correct bucket
        storage = FirebaseStorage.getInstance("gs://chicken-or-the-egg-app.firebasestorage.app");
        firestore = FirebaseFirestore.getInstance();
        auth = FirebaseAuth.getInstance();
    }
    
    public static synchronized FirebaseManager getInstance() {
        if (instance == null) {
            instance = new FirebaseManager();
        }
        return instance;
    }
    
    public StorageReference getStorageReference() {
        return storage.getReference();
    }
    
    public StorageReference getStorageReference(String path) {
        return storage.getReference(path);
    }
    
    public FirebaseFirestore getFirestore() {
        return firestore;
    }
    
    public FirebaseAuth getAuth() {
        return auth;
    }
}
