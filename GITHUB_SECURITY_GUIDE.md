# 🔐 GitHub Repository Security Update Guide

## ⚠️ CRITICAL: Your Repository Contains Exposed API Keys

Your GitHub repository currently has **hardcoded Google API keys** that need immediate attention. Here's how to securely fix this:

## 🚨 Immediate Actions Required:

### Step 1: Run Security Audit
```bash
cd "Chicken or the Egg/Code Draft"
npm run secure-check
```

### Step 2: Create Environment Configuration
```bash
# Copy the example file
cp .env.example .env.local

# Edit .env.local with your real values (NEVER commit this file)
```

### Step 3: Remove Sensitive Data from Git History

Since the API key is already in your git history, you need to remove it:

```bash
# Install git-filter-repo (if not already installed)
# On Windows with Git for Windows:
pip install git-filter-repo

# OR using conda:
conda install git-filter-repo

# Remove the API key from all git history
git filter-repo --replace-text <(echo "AIzaSyD8NOwlvZE6_6fAz_isZDAx5yeFqkmt4VQ==>REMOVED_API_KEY")

# Force push to update GitHub (WARNING: This rewrites history)
git push origin --force --all
```

### Step 4: Immediately Regenerate Your API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to **APIs & Services > Credentials**
3. Find your API key `AIzaSyD8NOwlvZE6_6fAz_isZDAx5yeFqkmt4VQ`
4. **DELETE** the exposed key
5. **CREATE** a new API key
6. **RESTRICT** the new key to your specific domains/IPs

### Step 5: Update Firebase Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project "chicken-or-the-egg-app"
3. Go to **Project Settings > General**
4. In "Your apps" section, get your new web app config
5. Update your `.env.local` file with the new values

## 🛠️ Safe Git Workflow:

### Option A: Clean Approach (Recommended)
```bash
# 1. Backup your current work
git stash

# 2. Create a new branch for security fixes
git checkout -b security-fixes

# 3. Ensure .gitignore is properly configured
git add .gitignore

# 4. Update all config files to use environment variables
git add firebase-config.js firebase-init.js

# 5. Add security scripts and documentation
git add scripts/ SECURITY_IMPLEMENTATION.md

# 6. Commit the security improvements
git commit -m "🔐 Secure API keys and implement environment variables

- Remove hardcoded API keys from source code
- Add comprehensive .gitignore for sensitive files
- Implement environment variable system
- Add security validation scripts
- Update Firebase security rules"

# 7. Push the secure version
git push origin security-fixes

# 8. Create Pull Request on GitHub
```

### Option B: Force Update (If you own the repo)
```bash
# After running git filter-repo to clean history:
git add .
git commit -m "🔐 Security: Remove exposed API keys and implement secure configuration"
git push origin main --force
```

## 📋 Files That Need Security Updates:

### ✅ Already Secured:
- `firebase-config.js` - Now uses environment variables
- `firebase-init.js` - Now uses environment variables
- `firestore.rules` - Secure authentication rules
- `storage.rules` - Secure user-based access
- `.gitignore` - Prevents future credential leaks

### ⚠️ Still Need Manual Updates:
You may need to check these files for hardcoded values:
- Any Dart files in `lib/`
- Any Java files in `app/src/`
- iOS configuration files
- Android configuration files

## 🔐 GitHub Repository Settings:

### Enable GitHub Security Features:
1. Go to your repo **Settings > Security & Analysis**
2. Enable **Dependency graph**
3. Enable **Dependabot alerts**
4. Enable **Dependabot security updates**
5. Enable **Secret scanning** (GitHub will detect API keys)

### Add Repository Secrets:
1. Go to **Settings > Secrets and variables > Actions**
2. Add your environment variables as repository secrets:
   - `FIREBASE_API_KEY`
   - `FIREBASE_PROJECT_ID`
   - `FIREBASE_STORAGE_BUCKET`
   - etc.

## ⚡ Quick Commands:

```bash
# Run complete security audit
npm run secure-check

# Validate environment setup
npm run validate-env

# Deploy with security validation
npm run deploy:prod

# Setup environment from template
npm run setup-env
```

## 🚨 CRITICAL WARNING:

**The API key `AIzaSyD8NOwlvZE6_6fAz_isZDAx5yeFqkmt4VQ` is currently PUBLIC on GitHub!**

Anyone can see this key and potentially:
- Access your Firebase project
- Incur charges on your Google Cloud account
- Read/write your database data
- Access your storage buckets

**Take immediate action to:**
1. Revoke the exposed key
2. Generate a new key  
3. Clean git history
4. Implement the secure configuration

## 📞 Need Help?

If you're unsure about any of these steps, especially the git history cleaning, consider:
1. Creating a completely new repository
2. Copying only the secure files to the new repo
3. Archiving the old repository

This ensures no sensitive data remains in your git history.
