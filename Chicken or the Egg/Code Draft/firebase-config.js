// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getFirestore, connectFirestoreEmulator } from "firebase/firestore";
import { getAuth, connectAuthEmulator } from "firebase/auth";
import { getStorage, connectStorageEmulator } from "firebase/storage";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyD8NOwlvZE6_6fAz_isZDAx5yeFqkmt4VQ",
  authDomain: "chicken-or-the-egg-app.firebaseapp.com",
  projectId: "chicken-or-the-egg-app",
  storageBucket: "chicken-or-the-egg-app.firebasestorage.app",
  messagingSenderId: "89883658019",
  appId: "1:89883658019:web:bbe65e2e538fdf372d2e96",
  measurementId: "G-85HH0QFFBE"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Firebase services
const analytics = getAnalytics(app);
const db = getFirestore(app);
const auth = getAuth(app);
const storage = getStorage(app, "gs://chicken-or-the-egg-app.firebasestorage.app");

// Connect to emulators in development
if (process.env.NODE_ENV === 'development') {
  connectFirestoreEmulator(db, 'localhost', 8080);
  connectAuthEmulator(auth, 'http://localhost:9099');
  connectStorageEmulator(storage, 'localhost', 9199);
}

// Export for use in other files
export { app, analytics, db, auth, storage };
