import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
// Import other Firebase services you need, e.g., getStorage, getAnalytics

/**
 * Your web app's Firebase configuration.
 * 
 * IMPORTANT: You can find these values in your Firebase project settings.
 * 1. Go to the Firebase console (console.firebase.google.com).
 * 2. Select your project ("chicken-or-the-egg").
 * 3. Go to Project settings (gear icon).
 * 4. In the "Your apps" card, find your web app and the SDK setup and configuration.
 */
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_AUTH_DOMAIN",
  projectId: "chicken-or-the-egg", // This is from your .firebaserc
  storageBucket: "YOUR_STORAGE_BUCKET",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Export the Firebase services you want to use in other parts of your app
export const auth = getAuth(app);
export const db = getFirestore(app);