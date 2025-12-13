const fs = require('fs');
const path = require('path');

// 1. Path to where Flutter looks for assets at runtime
// For Flutter Web, assets are usually in build/web/assets/assets/
const assetPath = path.join(__dirname, 'build', 'web', 'assets', 'assets');
const envFilePath = path.join(assetPath, '.env');

// 2. Ensure the directory exists
if (!fs.existsSync(assetPath)) {
    fs.mkdirSync(assetPath, { recursive: true });
}

// 3. Create the .env content using Heroku's process.env
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

// 4. Write the file synchronously before the server starts
try {
    fs.writeFileSync(envFilePath, envContent);
    console.log('Successfully generated .env for Flutter Web at:', envFilePath);
} catch (err) {
    console.error('Failed to generate .env file:', err);
}



const express = require("express");
const app = express();
const port = process.env.PORT || 8080;

app.use(express.static(path.join(__dirname, "build/web")));

app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "build/web/index.html"));
});

app.listen(port);