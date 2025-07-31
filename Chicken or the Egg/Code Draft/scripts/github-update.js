#!/usr/bin/env node

/**
 * Safe GitHub update script
 * This script helps you safely update your GitHub repository with secured API keys
 */

const fs = require('fs');
const { execSync } = require('child_process');

console.log('🔐 GitHub Security Update Script\n');

// Step 1: Run security check
console.log('1️⃣ Running security audit...');
try {
  execSync('node scripts/security-check.js', { stdio: 'inherit' });
  console.log('✅ Security audit passed!\n');
} catch (error) {
  console.error('❌ Security audit failed. Please fix issues before proceeding.');
  process.exit(1);
}

// Step 2: Check if .env.local exists
console.log('2️⃣ Checking environment configuration...');
if (!fs.existsSync('.env.local')) {
  console.log('⚠️  .env.local not found. Creating from template...');
  execSync('cp .env.example .env.local');
  console.log('📝 Please edit .env.local with your actual Firebase configuration values');
  console.log('❌ Cannot proceed until .env.local is properly configured.');
  process.exit(1);
}

// Step 3: Validate environment
console.log('3️⃣ Validating environment variables...');
try {
  execSync('node scripts/validate-env.js', { stdio: 'inherit' });
  console.log('✅ Environment validation passed!\n');
} catch (error) {
  console.error('❌ Environment validation failed. Please fix your .env.local file.');
  process.exit(1);
}

// Step 4: Git status check
console.log('4️⃣ Checking git status...');
try {
  const status = execSync('git status --porcelain', { encoding: 'utf8' });
  if (status.trim()) {
    console.log('📋 Files to be committed:');
    console.log(status);
  } else {
    console.log('✅ No changes to commit.');
    process.exit(0);
  }
} catch (error) {
  console.error('❌ Git status check failed:', error.message);
  process.exit(1);
}

// Step 5: Prompt for commit
console.log('5️⃣ Ready to commit security improvements...');
console.log('\n🚨 IMPORTANT REMINDERS:');
console.log('- The old API key AIzaSyD8NOwlvZE6_6fAz_isZDAx5yeFqkmt4VQ should be REVOKED');
console.log('- Generate a NEW API key in Google Cloud Console');
console.log('- Update your .env.local with the NEW key');
console.log('- Consider cleaning git history if the old key was committed');

console.log('\n📝 Suggested commit message:');
console.log('🔐 Security: Implement secure API key management\n');
console.log('- Remove hardcoded API keys from source code');
console.log('- Add comprehensive .gitignore for sensitive files');
console.log('- Implement environment variable system');
console.log('- Add security validation scripts');
console.log('- Update Firebase security rules');
console.log('- Secure Android build configuration');

console.log('\n⚡ Run these commands to commit:');
console.log('git add .');
console.log('git commit -m "🔐 Security: Implement secure API key management"');
console.log('git push origin main');

console.log('\n✅ Security update preparation complete!');
