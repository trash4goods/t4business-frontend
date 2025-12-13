const express = require("express");
const path = require("path");
const fs = require("fs");
const app = express();
const port = process.env.PORT || 8080;

// 1. Generate the .env file at RUNTIME (when the server starts)
const envPath = path.join(__dirname, "build/web/assets/.env");
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

try {
  // Ensure directory exists (useful for local testing)
  fs.mkdirSync(path.dirname(envPath), { recursive: true });
  fs.writeFileSync(envPath, envContent);
  console.log(".env generated successfully at runtime.");
} catch (err) {
  console.error("Error generating .env file:", err);
}

// 2. Prevent Caching of the .env file (Fixes the 304 issue)
app.get('*/.env', (req, res, next) => {
  res.setHeader('Cache-Control', 'no-store, no-cache, must-revalidate, proxy-revalidate');
  res.setHeader('Pragma', 'no-cache');
  res.setHeader('Expires', '0');
  res.removeHeader('ETag'); // Forces a 200 OK instead of 304
  next();
});

app.use(express.static(path.join(__dirname, "build/web")));

app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "build/web/index.html"));
});

app.listen(port, () => console.log(`Server running on port ${port}`));
