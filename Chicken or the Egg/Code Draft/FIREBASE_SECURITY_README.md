# Firebase Security Configuration Template

This file contains placeholder values. To set up Firebase security:

1. **NEVER commit real credentials to version control**
2. Use environment variables or secure configuration files
3. Replace placeholder values with actual credentials from Firebase Console

## Setup Instructions:

### For Development:
1. Download your actual `serviceAccountKey.json` from Firebase Console
2. Place it in this directory (it's already in .gitignore)
3. Update `google-services.json` with real Android configuration
4. Update `GoogleService-Info.plist` with real iOS configuration

### For Production:
1. Set environment variables in your hosting platform
2. Use the firebase-admin-secure.js file instead of the original
3. Ensure all API keys are stored as environment variables

## Files that need real credentials:
- `serviceAccountKey.json` (Backend/Admin SDK)
- `google-services.json` (Android)
- `GoogleService-Info.plist` (iOS)
- `.env.local` (Web frontend)

## Security Best Practices:
- Enable Firebase Security Rules
- Use Firebase App Check
- Implement proper authentication
- Restrict API key usage in Firebase Console
- Monitor usage in Firebase Console
