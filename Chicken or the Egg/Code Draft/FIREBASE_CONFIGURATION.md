# 🔧 Firebase Console Configuration for Google Sign-In

## 📋 **Project Status:**
- ✅ **Project Connected**: `chicken-or-the-egg-app`
- ✅ **Project ID**: `chicken-or-the-egg-app`
- ✅ **Firebase CLI**: Working and authenticated

---

## 🚀 **STEP-BY-STEP CONFIGURATION:**

### **1. Enable Google Authentication** 🔐

**Go to Firebase Console:**
1. Open: https://console.firebase.google.com/project/chicken-or-the-egg-app
2. Click **Authentication** in left sidebar
3. Click **Sign-in method** tab
4. Find **Google** provider
5. Click **Enable**
6. ✅ **Status should show: "Enabled"**

### **2. Configure Web App Settings** 🌐

**In Authentication > Settings:**
1. Click **Settings** tab
2. Scroll to **Authorized domains**
3. Add these domains:
   ```
   localhost
   127.0.0.1
   chicken-or-the-egg-app.web.app
   chicken-or-the-egg-app.firebaseapp.com
   ```
4. Click **Add domain** for each

### **3. Get Web App Configuration** ⚙️

**In Project Settings:**
1. Click ⚙️ **Project settings** (top left)
2. Scroll to **Your apps** section
3. Click **Web app** icon (</>) if not exists, or click existing web app
4. Copy the **firebaseConfig** object
5. **Important**: We'll update your config files with this

### **4. Update Your App Configuration** 📝

**I'll help you update these files:**
- `firebase-config.js` - Main web configuration
- `.env.local` - Environment variables
- Web app registration

---

## 🔍 **CURRENT CONFIGURATION CHECK:**

Let me check your current setup and update the configuration files automatically.

---

## 🎯 **What This Enables:**

✅ **Google Sign-In Button** - Full OAuth2 flow
✅ **User Profile Access** - Name, email, photo
✅ **Secure Authentication** - Firebase tokens
✅ **Cross-Platform Support** - Web, Android, iOS
✅ **Account Linking** - Upgrade anonymous users

---

## 📱 **Testing Instructions:**

After configuration:
1. Run: `E:\Flutter\bin\flutter run -d chrome`
2. Click "Sign In with Google"
3. Should open Google OAuth popup
4. Select/login to Google account
5. Should redirect back to app as signed-in user

---

## 🚨 **Troubleshooting:**

**If Google Sign-In doesn't work:**
- Check browser console for errors
- Verify domain is in authorized domains
- Check Firebase project settings
- Ensure API keys are correct

**Common Issues:**
- `unauthorized_client` → Check authorized domains
- `invalid_client` → Check web app configuration
- `popup_blocked` → Allow popups for localhost

---

**Ready to configure? I'll guide you through each step!**
