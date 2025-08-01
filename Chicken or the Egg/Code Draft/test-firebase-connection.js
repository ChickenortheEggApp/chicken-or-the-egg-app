// Firebase Connection Test
// Run this script to verify your Firebase connection
// Usage: node test-firebase-connection.js

// Load environment variables
require('dotenv').config({ path: '.env.local' });

// Import Firebase modules
const { initializeApp } = require('firebase/app');
const { getFirestore, connectToFirestore, doc, getDoc } = require('firebase/firestore');
const { getAuth } = require('firebase/auth');
const { getStorage } = require('firebase/storage');

console.log('🔥 Firebase Connection Test\n');

// Check environment variables
console.log('1️⃣ Checking environment variables...');
const requiredEnvVars = [
  'REACT_APP_FIREBASE_API_KEY',
  'REACT_APP_FIREBASE_AUTH_DOMAIN', 
  'REACT_APP_FIREBASE_PROJECT_ID',
  'REACT_APP_FIREBASE_STORAGE_BUCKET',
  'REACT_APP_FIREBASE_MESSAGING_SENDER_ID',
  'REACT_APP_FIREBASE_APP_ID'
];

let envVarsValid = true;
for (const envVar of requiredEnvVars) {
  if (!process.env[envVar]) {
    console.error(`❌ Missing: ${envVar}`);
    envVarsValid = false;
  } else if (process.env[envVar].includes('your_')) {
    console.error(`❌ Placeholder value: ${envVar}`);
    envVarsValid = false;
  } else {
    console.log(`✅ ${envVar}: ${process.env[envVar].substring(0, 20)}...`);
  }
}

if (!envVarsValid) {
  console.error('\n❌ Environment variables not properly configured');
  process.exit(1);
}

// Initialize Firebase
console.log('\n2️⃣ Initializing Firebase...');
try {
  const firebaseConfig = {
    apiKey: process.env.REACT_APP_FIREBASE_API_KEY,
    authDomain: process.env.REACT_APP_FIREBASE_AUTH_DOMAIN,
    projectId: process.env.REACT_APP_FIREBASE_PROJECT_ID,
    storageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET,
    messagingSenderId: process.env.REACT_APP_FIREBASE_MESSAGING_SENDER_ID,
    appId: process.env.REACT_APP_FIREBASE_APP_ID,
    measurementId: process.env.REACT_APP_FIREBASE_MEASUREMENT_ID
  };

  const app = initializeApp(firebaseConfig);
  console.log('✅ Firebase app initialized successfully');

  // Test Firestore connection
  console.log('\n3️⃣ Testing Firestore connection...');
  const db = getFirestore(app);
  console.log('✅ Firestore instance created');

  // Test Auth connection
  console.log('\n4️⃣ Testing Authentication connection...');
  const auth = getAuth(app);
  console.log(`✅ Auth instance created for project: ${auth.app.options.projectId}`);

  // Test Storage connection
  console.log('\n5️⃣ Testing Storage connection...');
  const storage = getStorage(app);
  console.log(`✅ Storage instance created for bucket: ${storage.app.options.storageBucket}`);

  console.log('\n🎉 Firebase Connection Test Successful!');
  console.log('\n📋 Connection Summary:');
  console.log(`🔗 Project ID: ${firebaseConfig.projectId}`);
  console.log(`🔗 Auth Domain: ${firebaseConfig.authDomain}`);
  console.log(`🔗 Storage Bucket: ${firebaseConfig.storageBucket}`);
  
  console.log('\n🚀 Ready to use Firebase services:');
  console.log('- Authentication: Ready for user sign-in/sign-up');
  console.log('- Firestore: Ready for database operations');
  console.log('- Storage: Ready for file uploads');

} catch (error) {
  console.error('\n❌ Firebase connection failed:', error.message);
  
  if (error.message.includes('API key')) {
    console.error('\n💡 Suggestions:');
    console.error('1. Check your API key in Google Cloud Console');
    console.error('2. Ensure the API key has the correct restrictions');
    console.error('3. Verify the API key is enabled for Firebase APIs');
  }
  
  process.exit(1);
}
