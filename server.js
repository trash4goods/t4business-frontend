const express = require("express");
const path = require("path");
const fs = require("fs");
const app = express();
const port = process.env.PORT || 8080;

// Function to get variables and inject them into the HTML string
function injectEnv(html) {
  const envConfig = {
    FIREBASE_API_KEY: process.env.FIREBASE_API_KEY || '',
    FIREBASE_APP_ID: process.env.FIREBASE_APP_ID || '',
    FIREBASE_MESSAGING_SENDER_ID: process.env.FIREBASE_MESSAGING_SENDER_ID || '',
    FIREBASE_PROJECT_ID: process.env.FIREBASE_PROJECT_ID || '',
    FIREBASE_AUTH_DOMAIN: process.env.FIREBASE_AUTH_DOMAIN || '',
    FIREBASE_STORAGE_BUCKET: process.env.FIREBASE_STORAGE_BUCKET || '',
    FIREBASE_MEASUREMENT_ID: process.env.FIREBASE_MEASUREMENT_ID || '',
    API_BASE_DEV_URL: process.env.API_BASE_DEV_URL || ''
  };

  // Convert the object to a JS string for the window object
  const scriptTag = `<script id="heroku-env">window.__ENV__ = ${JSON.stringify(envConfig)};</script>`;
  
  // Inject the script immediately after the <head> tag
  return html.replace('<head>', `<head>\n  ${scriptTag}`);
}

// 1. Intercept index.html requests specifically
app.get("/", (req, res) => {
  const indexPath = path.join(__dirname, "build/web/index.html");
  fs.readFile(indexPath, "utf8", (err, data) => {
    if (err) return res.status(500).send("Error loading index.html");
    res.send(injectEnv(data));
  });
});

// 2. Serve all other static assets (JS, CSS, icons, etc.)
app.use(express.static(path.join(__dirname, "build/web")));

// 3. Fallback for SPA routing: serve index.html with injected env for any unknown route
app.get("*", (req, res) => {
  const indexPath = path.join(__dirname, "build/web/index.html");
  fs.readFile(indexPath, "utf8", (err, data) => {
    if (err) return res.status(500).send("Error loading index.html");
    res.send(injectEnv(data));
  });
});

app.listen(port, () => console.log(`Server running with injected env on port ${port}`));
