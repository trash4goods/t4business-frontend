const express = require("express");
const path = require("path");
const fs = require('fs');
const app = express();
const port = process.env.PORT || 8080;

// Define which environment variables you want to expose to the browser
const envConfig = {
  FIREBASE_API_KEY: process.env.FIREBASE_API_KEY || '',
  FIREBASE_APP_ID: process.env.FIREBASE_APP_ID || '',
  FIREBASE_MESSAGING_SENDER_ID: process.env.FIREBASE_MESSAGING_SENDER_ID || '',
  FIREBASE_PROJECT_ID: process.env.FIREBASE_PROJECT_ID || '',
  FIREBASE_AUTH_DOMAIN: process.env.FIREBASE_AUTH_DOMAIN || '',
  FIREBASE_STORAGE_BUCKET: process.env.FIREBASE_STORAGE_BUCKET || '',
  FIREBASE_MEASUREMENT_ID: process.env.FIREBASE_MEASUREMENT_ID || '',
  API_BASE_DEV_URL: process.env.API_BASE_DEV_URL || '',
};

// Intercept requests for index.html to inject variables
app.get('/', (req, res) => {
  const filePath = path.join(buildPath, 'index.html');
  fs.readFile(filePath, 'utf8', (err, data) => {
    if (err) return res.status(500).send('Error loading index.html');

    // Inject the variables into the window.__ENV__ object
    const injectedScript = `<script>window.__ENV__ = ${JSON.stringify(envConfig)};</script>`;
    const result = data.replace('<head>', `<head>${injectedScript}`);

    res.send(result);
  });
});

app.use(express.static(path.join(__dirname, "build/web")));

app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "build/web/index.html"));
});


app.listen(port);

