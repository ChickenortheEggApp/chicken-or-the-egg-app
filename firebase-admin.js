const admin = require("firebase-admin");
const path = require("path");

// Load service account key
const serviceAccount = require(path.join(__dirname, "serviceAccountKey.json"));

try {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    // Add your Firebase project configuration here
    // databaseURL: "https://your-project-id-default-rtdb.firebaseio.com/",
    // storageBucket: "your-project-id.appspot.com"
  });
  
  console.log("Firebase Admin initialized successfully");
} catch (error) {
  console.error("Error initializing Firebase Admin:", error);
}

module.exports = admin;
