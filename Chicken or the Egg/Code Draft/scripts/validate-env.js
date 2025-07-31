#!/usr/bin/env node

/**
 * Security validation script for Firebase configuration
 * Run with: npm run validate-env
 */

require('dotenv').config({ path: '.env.local' });

const requiredEnvVars = [
  'REACT_APP_FIREBASE_API_KEY',
  'REACT_APP_FIREBASE_AUTH_DOMAIN',
  'REACT_APP_FIREBASE_PROJECT_ID',
  'REACT_APP_FIREBASE_STORAGE_BUCKET',
  'REACT_APP_FIREBASE_MESSAGING_SENDER_ID',
  'REACT_APP_FIREBASE_APP_ID'
];

const optionalEnvVars = [
  'REACT_APP_FIREBASE_MEASUREMENT_ID',
  'FIREBASE_ADMIN_PRIVATE_KEY',
  'FIREBASE_ADMIN_CLIENT_EMAIL'
];

console.log('🔍 Validating environment variables...\n');

let hasErrors = false;

// Check required variables
requiredEnvVars.forEach(envVar => {
  if (!process.env[envVar]) {
    console.error(`❌ Missing required environment variable: ${envVar}`);
    hasErrors = true;
  } else if (process.env[envVar].includes('your_') || process.env[envVar] === 'YOUR_API_KEY') {
    console.error(`❌ Environment variable ${envVar} contains placeholder value`);
    hasErrors = true;
  } else {
    console.log(`✅ ${envVar} is configured`);
  }
});

// Check optional variables
optionalEnvVars.forEach(envVar => {
  if (process.env[envVar]) {
    console.log(`✅ ${envVar} is configured (optional)`);
  } else {
    console.log(`⚠️  ${envVar} is not configured (optional)`);
  }
});

// Security checks
console.log('\n🔒 Security checks...');

// Check if we're not using hardcoded values
const configFile = require('fs').readFileSync('./firebase-config.js', 'utf8');
if (configFile.includes('AIzaSy') && !configFile.includes('process.env')) {
  console.error('❌ firebase-config.js still contains hardcoded API keys!');
  hasErrors = true;
} else {
  console.log('✅ No hardcoded API keys found in firebase-config.js');
}

// Check if .env.local exists
if (!require('fs').existsSync('.env.local')) {
  console.error('❌ .env.local file not found. Copy .env.example to .env.local and fill in your values.');
  hasErrors = true;
} else {
  console.log('✅ .env.local file exists');
}

// Check if serviceAccountKey.json has real values
if (require('fs').existsSync('./serviceAccountKey.json')) {
  const serviceAccount = JSON.parse(require('fs').readFileSync('./serviceAccountKey.json', 'utf8'));
  if (serviceAccount.project_id === 'your-project-id') {
    console.error('❌ serviceAccountKey.json contains placeholder values');
    hasErrors = true;
  } else {
    console.log('✅ serviceAccountKey.json appears to have real values');
  }
}

if (hasErrors) {
  console.error('\n❌ Environment validation failed. Please fix the issues above.');
  process.exit(1);
} else {
  console.log('\n✅ All environment variables are properly configured!');
  process.exit(0);
}
