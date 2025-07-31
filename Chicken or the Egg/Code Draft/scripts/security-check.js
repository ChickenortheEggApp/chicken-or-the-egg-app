#!/usr/bin/env node

/**
 * Security audit script for the project
 * Run with: npm run secure-check
 */

const fs = require('fs');
const path = require('path');

console.log('🛡️  Running security audit...\n');

const securityIssues = [];
const warnings = [];

// Check for hardcoded API keys in files
const filesToCheck = [
  './firebase-config.js',
  './firebase-init.js',
  './firebase-admin.js',
  './firebase-admin-secure.js',
  './src/**/*.js',
  './lib/**/*.dart',
  './app/src/**/*.java'
];

function scanFileRecursively(dir, extensions = ['.js', '.dart', '.java', '.ts', '.jsx']) {
  if (!fs.existsSync(dir)) return;
  
  const files = fs.readdirSync(dir);
  files.forEach(file => {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    
    if (stat.isDirectory() && !file.startsWith('.') && file !== 'node_modules') {
      scanFileRecursively(filePath, extensions);
    } else if (stat.isFile() && extensions.some(ext => file.endsWith(ext))) {
      scanFile(filePath);
    }
  });
}

function scanFile(filePath) {
  if (!fs.existsSync(filePath)) return;
  
  const content = fs.readFileSync(filePath, 'utf8');
  
  // Check for Google API keys
  const apiKeyPattern = /AIzaSy[0-9A-Za-z_-]{33}/g;
  const matches = content.match(apiKeyPattern);
  
  if (matches && !content.includes('process.env')) {
    securityIssues.push(`🚨 Hardcoded Google API key found in ${filePath}: ${matches.join(', ')}`);
  }
  
  // Check for Firebase project IDs that might be hardcoded
  if (content.includes('chicken-or-the-egg-app') && !content.includes('process.env') && !filePath.includes('README')) {
    warnings.push(`⚠️  Hardcoded project ID found in ${filePath}`);
  }
  
  // Check for other sensitive patterns
  if (content.includes('"private_key"') && !content.includes('process.env')) {
    securityIssues.push(`🚨 Hardcoded private key found in ${filePath}`);
  }
  
  if (content.includes('client_secret') && !content.includes('process.env')) {
    securityIssues.push(`🚨 Hardcoded client secret found in ${filePath}`);
  }
}

// Check main files
['firebase-config.js', 'firebase-init.js', 'firebase-admin.js'].forEach(file => {
  if (fs.existsSync(file)) {
    scanFile(file);
  }
});

// Scan all source directories recursively
const sourceDirs = ['./lib', './app/src', './src'];
sourceDirs.forEach(dir => {
  scanFileRecursively(dir);
});

// Check .gitignore
if (!fs.existsSync('.gitignore')) {
  securityIssues.push('🚨 No .gitignore file found');
} else {
  const gitignore = fs.readFileSync('.gitignore', 'utf8');
  
  const requiredEntries = [
    '.env',
    '.env.local',
    'serviceAccountKey.json',
    'GoogleService-Info.plist',
    'google-services.json'
  ];
  
  requiredEntries.forEach(entry => {
    if (!gitignore.includes(entry)) {
      securityIssues.push(`🚨 .gitignore missing: ${entry}`);
    }
  });
}

// Check Firebase security rules
if (fs.existsSync('firestore.rules')) {
  const rules = fs.readFileSync('firestore.rules', 'utf8');
  if (rules.includes('allow read, write: if true')) {
    securityIssues.push('🚨 Firestore rules allow public read/write access');
  }
}

if (fs.existsSync('storage.rules')) {
  const rules = fs.readFileSync('storage.rules', 'utf8');
  if (rules.includes('allow read, write: if true')) {
    securityIssues.push('🚨 Storage rules allow public read/write access');
  }
}

// Check for sensitive files that shouldn't be committed
const sensitiveFiles = [
  'serviceAccountKey.json',
  '.env.local',
  'GoogleService-Info.plist'
];

sensitiveFiles.forEach(file => {
  if (fs.existsSync(file)) {
    warnings.push(`⚠️  Sensitive file ${file} exists (ensure it's in .gitignore)`);
  }
});

// Report results
if (securityIssues.length === 0) {
  console.log('✅ No critical security issues found!');
} else {
  console.log('❌ Security issues found:');
  securityIssues.forEach(issue => console.log(issue));
}

if (warnings.length > 0) {
  console.log('\n⚠️  Warnings:');
  warnings.forEach(warning => console.log(warning));
}

console.log('\n🔐 Security recommendations:');
console.log('1. Use environment variables for all API keys');
console.log('2. Enable Firebase Security Rules');
console.log('3. Enable Firebase App Check');
console.log('4. Regularly rotate API keys');
console.log('5. Monitor Firebase usage in console');
console.log('6. Set up API key restrictions in Google Cloud Console');

if (securityIssues.length > 0) {
  process.exit(1);
} else {
  process.exit(0);
}
