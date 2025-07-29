import { getStorage, ref, uploadBytes, getDownloadURL, deleteObject } from "firebase/storage";
import { app } from "./firebase-config.js";

// Initialize Firebase Storage with correct bucket
const storage = getStorage(app, "gs://chicken-or-the-egg-app.firebasestorage.app");

// Storage helper functions
export const StorageService = {
  // Upload file to storage
  async uploadFile(file, path) {
    try {
      const storageRef = ref(storage, path);
      const snapshot = await uploadBytes(storageRef, file);
      const downloadURL = await getDownloadURL(snapshot.ref);
      return { success: true, downloadURL, path };
    } catch (error) {
      console.error("Error uploading file:", error);
      return { success: false, error: error.message };
    }
  },

  // Get download URL for a file
  async getFileURL(path) {
    try {
      const storageRef = ref(storage, path);
      const downloadURL = await getDownloadURL(storageRef);
      return { success: true, downloadURL };
    } catch (error) {
      console.error("Error getting file URL:", error);
      return { success: false, error: error.message };
    }
  },

  // Delete a file from storage
  async deleteFile(path) {
    try {
      const storageRef = ref(storage, path);
      await deleteObject(storageRef);
      return { success: true };
    } catch (error) {
      console.error("Error deleting file:", error);
      return { success: false, error: error.message };
    }
  }
};

export { storage };
