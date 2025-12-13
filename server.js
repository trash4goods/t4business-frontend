const fs = require('fs');
const path = require('path');
const express = require('express');
const app = express();

// 1. Define the path where Flutter expects the .env asset
// Note: Depending on your pubspec, it might be 'build/web/assets/.env' 
// or 'build/web/assets/assets/.env'
const envDir = path.join(__dirname, 'build', 'web', 'assets');
const envPath = path.join(envDir, '.env');

// 2. Create the directory if it doesn't exist
if (!fs.existsSync(envDir)) {
    fs.mkdirSync(envDir, { recursive: true });
}

// 3. Write Heroku Config Vars into the .env file
// Use process.env to grab values you set in the Heroku Dashboard
const envContent = `
FIREBASE_API_KEY=${process.env.FIREBASE_API_KEY || ''}
FIREBASE_APP_ID=${process.env.FIREBASE_APP_ID || ''}
FIREBASE_MESSAGING_SENDER_ID=${process.env.FIREBASE_MESSAGING_SENDER_ID || ''}
FIREBASE_PROJECT_ID=${process.env.FIREBASE_PROJECT_ID || ''}
FIREBASE_AUTH_DOMAIN=${process.env.FIREBASE_AUTH_DOMAIN || ''}
FIREBASE_STORAGE_BUCKET=${process.env.FIREBASE_STORAGE_BUCKET || ''}
FIREBASE_MEASUREMENT_ID=${process.env.FIREBASE_MEASUREMENT_ID || ''}
API_BASE_DEV_URL=${process.env.API_BASE_DEV_URL || ''}
`.trim();

fs.writeFileSync(envPath, envContent);
console.log(`Generated .env at ${envPath}`);

// 4. Serve your Flutter files
app.use(express.static(path.join(__dirname, 'build', 'web')));

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
