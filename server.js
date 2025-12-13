const express = require("express");
const path = require("path");
const app = express();

app.get('/env.js', (req, res) => {
  res.setHeader('Content-Type', 'application/javascript');
  res.send(`
    window.__ENV__ = {
      FIREBASE_API_KEY: "${process.env.FIREBASE_API_KEY}",
      FIREBASE_APP_ID: "${process.env.FIREBASE_APP_ID}",
      FIREBASE_MESSAGING_SENDER_ID: "${process.env.FIREBASE_MESSAGING_SENDER_ID}",
      FIREBASE_PROJECT_ID: "${process.env.FIREBASE_PROJECT_ID}",
      FIREBASE_AUTH_DOMAIN: "${process.env.FIREBASE_AUTH_DOMAIN}",
      FIREBASE_STORAGE_BUCKET: "${process.env.FIREBASE_STORAGE_BUCKET}",
      FIREBASE_MEASUREMENT_ID: "${process.env.FIREBASE_MEASUREMENT_ID}",
      API_BASE_DEV_URL: "${process.env.API_BASE_DEV_URL}"
    };
  `);
});

app.use(express.static(path.join(__dirname, "build/web")));

app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "build/web/index.html"));
});

const port = process.env.PORT || 8080;
app.listen(port);