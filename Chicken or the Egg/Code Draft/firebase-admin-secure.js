const admin = require("firebase-admin");
const path = require("path");

// Initialize Firebase Admin SDK with environment variables
let adminApp;

try {
  // Check if we're using environment variables (production) or service account file (development)
  if (process.env.FIREBASE_ADMIN_PRIVATE_KEY) {
    // Production: Use environment variables
    const serviceAccount = {
      type: "service_account",
      project_id: process.env.REACT_APP_FIREBASE_PROJECT_ID,
      private_key_id: process.env.FIREBASE_ADMIN_PRIVATE_KEY_ID,
      private_key: process.env.FIREBASE_ADMIN_PRIVATE_KEY.replace(/\\n/g, '\n'),
      client_email: process.env.FIREBASE_ADMIN_CLIENT_EMAIL,
      client_id: process.env.FIREBASE_ADMIN_CLIENT_ID,
      auth_uri: "https://accounts.google.com/o/oauth2/auth",
      token_uri: "https://oauth2.googleapis.com/token",
      auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
      client_x509_cert_url: `https://www.googleapis.com/robot/v1/metadata/x509/${process.env.FIREBASE_ADMIN_CLIENT_EMAIL.replace('@', '%40')}`
    };

    adminApp = admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      storageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET
    });

    console.log("Firebase Admin initialized with environment variables");
  } else {
    // Development: Check if service account file exists
    const serviceAccountPath = path.join(__dirname, "serviceAccountKey.json");
    if (require("fs").existsSync(serviceAccountPath)) {
      const serviceAccount = require(serviceAccountPath);
      
      adminApp = admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
        storageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET || "chicken-or-the-egg-app.firebasestorage.app"
      });

      console.log("Firebase Admin initialized with service account file");
    } else {
      throw new Error("No Firebase Admin credentials found. Please provide environment variables or serviceAccountKey.json");
    }
  }
} catch (error) {
  console.error("Error initializing Firebase Admin:", error);
  throw error;
}

// Export Firebase Admin services
const db = admin.firestore();
const auth = admin.auth();
const storage = admin.storage();

module.exports = {
  admin,
  db,
  auth,
  storage
};
