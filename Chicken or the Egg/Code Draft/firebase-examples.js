// Firebase Usage Examples
// This file shows how to use Firebase services in your Chicken or the Egg app

// Load environment variables (for Node.js)
if (typeof window === 'undefined') {
  require('dotenv').config({ path: '.env.local' });
}

// Import Firebase modules
import { initializeApp } from 'firebase/app';
import { 
  getFirestore, 
  collection, 
  addDoc, 
  getDocs, 
  doc, 
  getDoc,
  updateDoc,
  deleteDoc,
  query,
  where,
  orderBy
} from 'firebase/firestore';
import { 
  getAuth, 
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signOut,
  onAuthStateChanged
} from 'firebase/auth';
import { 
  getStorage, 
  ref, 
  uploadBytes, 
  getDownloadURL,
  deleteObject
} from 'firebase/storage';

// Firebase configuration (uses environment variables)
const firebaseConfig = {
  apiKey: process.env.REACT_APP_FIREBASE_API_KEY,
  authDomain: process.env.REACT_APP_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.REACT_APP_FIREBASE_PROJECT_ID,
  storageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.REACT_APP_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.REACT_APP_FIREBASE_APP_ID,
  measurementId: process.env.REACT_APP_FIREBASE_MEASUREMENT_ID
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth(app);
const storage = getStorage(app);

// ===================
// AUTHENTICATION EXAMPLES
// ===================

export const FirebaseAuth = {
  // Sign up new user
  async signUp(email, password) {
    try {
      const userCredential = await createUserWithEmailAndPassword(auth, email, password);
      console.log('User created:', userCredential.user.uid);
      return userCredential.user;
    } catch (error) {
      console.error('Sign up error:', error.message);
      throw error;
    }
  },

  // Sign in existing user
  async signIn(email, password) {
    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      console.log('User signed in:', userCredential.user.uid);
      return userCredential.user;
    } catch (error) {
      console.error('Sign in error:', error.message);
      throw error;
    }
  },

  // Sign out user
  async signOut() {
    try {
      await signOut(auth);
      console.log('User signed out');
    } catch (error) {
      console.error('Sign out error:', error.message);
      throw error;
    }
  },

  // Listen for auth state changes
  onAuthStateChanged(callback) {
    return onAuthStateChanged(auth, callback);
  }
};

// ===================
// FIRESTORE EXAMPLES
// ===================

export const FirestoreOperations = {
  // Create a new coop
  async createCoop(userId, coopData) {
    try {
      const docRef = await addDoc(collection(db, 'coops'), {
        ...coopData,
        ownerId: userId,
        createdAt: new Date(),
        updatedAt: new Date()
      });
      console.log('Coop created with ID:', docRef.id);
      return docRef.id;
    } catch (error) {
      console.error('Error creating coop:', error);
      throw error;
    }
  },

  // Get user's coops
  async getUserCoops(userId) {
    try {
      const q = query(
        collection(db, 'coops'), 
        where('ownerId', '==', userId),
        orderBy('createdAt', 'desc')
      );
      const querySnapshot = await getDocs(q);
      const coops = [];
      querySnapshot.forEach((doc) => {
        coops.push({ id: doc.id, ...doc.data() });
      });
      return coops;
    } catch (error) {
      console.error('Error getting coops:', error);
      throw error;
    }
  },

  // Add a chicken to a coop
  async addChicken(coopId, chickenData) {
    try {
      const docRef = await addDoc(collection(db, 'chickens'), {
        ...chickenData,
        coopId: coopId,
        createdAt: new Date(),
        updatedAt: new Date()
      });
      console.log('Chicken added with ID:', docRef.id);
      return docRef.id;
    } catch (error) {
      console.error('Error adding chicken:', error);
      throw error;
    }
  },

  // Get chickens in a coop
  async getCoopChickens(coopId) {
    try {
      const q = query(
        collection(db, 'chickens'), 
        where('coopId', '==', coopId)
      );
      const querySnapshot = await getDocs(q);
      const chickens = [];
      querySnapshot.forEach((doc) => {
        chickens.push({ id: doc.id, ...doc.data() });
      });
      return chickens;
    } catch (error) {
      console.error('Error getting chickens:', error);
      throw error;
    }
  },

  // Update chicken data
  async updateChicken(chickenId, updates) {
    try {
      const chickenRef = doc(db, 'chickens', chickenId);
      await updateDoc(chickenRef, {
        ...updates,
        updatedAt: new Date()
      });
      console.log('Chicken updated:', chickenId);
    } catch (error) {
      console.error('Error updating chicken:', error);
      throw error;
    }
  }
};

// ===================
// STORAGE EXAMPLES
// ===================

export const FirebaseStorage = {
  // Upload chicken image
  async uploadChickenImage(chickenId, imageFile) {
    try {
      const imageRef = ref(storage, `chickens/${chickenId}/${imageFile.name}`);
      const snapshot = await uploadBytes(imageRef, imageFile);
      const downloadURL = await getDownloadURL(snapshot.ref);
      console.log('Image uploaded:', downloadURL);
      return downloadURL;
    } catch (error) {
      console.error('Error uploading image:', error);
      throw error;
    }
  },

  // Upload coop image
  async uploadCoopImage(coopId, imageFile) {
    try {
      const imageRef = ref(storage, `coops/${coopId}/${imageFile.name}`);
      const snapshot = await uploadBytes(imageRef, imageFile);
      const downloadURL = await getDownloadURL(snapshot.ref);
      console.log('Coop image uploaded:', downloadURL);
      return downloadURL;
    } catch (error) {
      console.error('Error uploading coop image:', error);
      throw error;
    }
  },

  // Delete image
  async deleteImage(imagePath) {
    try {
      const imageRef = ref(storage, imagePath);
      await deleteObject(imageRef);
      console.log('Image deleted:', imagePath);
    } catch (error) {
      console.error('Error deleting image:', error);
      throw error;
    }
  }
};

// ===================
// USAGE EXAMPLES
// ===================

// Example: Complete user registration and coop creation flow
export async function exampleUserFlow() {
  try {
    // 1. Sign up user
    const user = await FirebaseAuth.signUp('user@example.com', 'password123');
    
    // 2. Create their first coop
    const coopId = await FirestoreOperations.createCoop(user.uid, {
      name: 'My First Coop',
      description: 'A cozy coop for my chickens',
      maxCapacity: 10,
      location: 'Backyard'
    });
    
    // 3. Add chickens to the coop
    await FirestoreOperations.addChicken(coopId, {
      name: 'Henrietta',
      breed: 'Rhode Island Red',
      age: 6,
      personality: 'Friendly and curious'
    });
    
    // 4. Get all coops for the user
    const userCoops = await FirestoreOperations.getUserCoops(user.uid);
    console.log('User coops:', userCoops);
    
    // 5. Get chickens in the coop
    const chickens = await FirestoreOperations.getCoopChickens(coopId);
    console.log('Coop chickens:', chickens);
    
  } catch (error) {
    console.error('Example flow error:', error);
  }
}

// Export Firebase instances for direct use
export { app, db, auth, storage };
