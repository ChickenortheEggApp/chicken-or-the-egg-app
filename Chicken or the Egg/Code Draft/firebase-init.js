import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
// Import other Firebase services you need, e.g., getStorage, getAnalytics

/**
 * Your web app's Firebase configuration.
 * 
 * IMPORTANT: These values should come from environment variables.
 * 1. Copy .env.example to .env.local
 * 2. Fill in your actual Firebase configuration values
 * 3. Never commit .env.local to version control
 */
const firebaseConfig = {
  apiKey: process.env.REACT_APP_FIREBASE_API_KEY,
  authDomain: process.env.REACT_APP_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.REACT_APP_FIREBASE_PROJECT_ID,
  storageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.REACT_APP_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.REACT_APP_FIREBASE_APP_ID
};

// Validate configuration
if (!firebaseConfig.apiKey || !firebaseConfig.projectId) {
  throw new Error('Firebase configuration is incomplete. Please check your environment variables.');
}

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Export the Firebase services you want to use in other parts of your app
export const auth = getAuth(app);
export const db = getFirestore(app);