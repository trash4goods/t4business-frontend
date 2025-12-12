# Firebase Hosting Deployment Guide
## T4G for Business - Flutter Web Application

### 🚀 **Quick Deployment Commands**

#### **Deploy New Update (Most Common)**
```bash
# 1. Build the Flutter web app
flutter build web --no-tree-shake-icons

# 2. Deploy to Firebase Hosting
firebase deploy --only hosting

# 3. Optional: Deploy with message
firebase deploy --only hosting -m "Updated forgot password feature"
```

# OR run
./quick-deploy.sh "message"

#### **Full Production Deployment**
```bash
# Complete build and deploy pipeline
flutter clean && flutter pub get && flutter build web --no-tree-shake-icons && firebase deploy --only hosting
```

---

## 📋 **Prerequisites**

### **Required Tools**
- ✅ Firebase CLI (v14.4.0+ installed)
- ✅ Flutter SDK
- ✅ Firebase project: `t4g-for-business`
- ✅ Hosting configured

### **Verify Setup**
```bash
# Check Firebase CLI version
firebase --version

# Check current project
firebase use

# Check hosting status
firebase hosting:sites:list
```

---

## 🏗️ **Project Configuration**

### **Firebase Configuration Files**
```json
// firebase.json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [{"source": "**", "destination": "/index.html"}]
  }
}
```

```json
// .firebaserc
{
  "projects": {
    "default": "t4g-for-business"
  }
}
```

---

## 🚀 **Deployment Workflows**

### **1. Standard Update Deployment**
Use this for regular feature updates, bug fixes, and improvements:

```bash
#!/bin/bash
echo "🏗️  Building Flutter web app..."
flutter build web --no-tree-shake-icons

echo "🚀 Deploying to Firebase Hosting..."
firebase deploy --only hosting

echo "✅ Deployment complete!"
echo "🌐 Your app is live at: https://t4g-for-business.web.app"
```

### **2. Development to Production Pipeline**
```bash
#!/bin/bash
echo "🧹 Cleaning previous builds..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔍 Running static analysis..."
flutter analyze

echo "🏗️  Building production web app..."
flutter build web --release --no-tree-shake-icons

echo "🚀 Deploying to Firebase Hosting..."
firebase deploy --only hosting -m "Production deployment $(date)"

echo "✅ Production deployment complete!"
```

### **3. Preview Deployment (Testing)**
```bash
# Deploy to preview channel for testing
flutter build web --no-tree-shake-icons
firebase hosting:channel:deploy preview-$(date +%s) --expires 7d
```

---

## 📁 **Build Output Structure**

After `flutter build web`, your `build/web/` folder contains:
```
build/web/
├── index.html           # Main HTML file
├── main.dart.js         # Compiled Dart code
├── flutter.js           # Flutter engine
├── flutter_service_worker.js
├── manifest.json        # PWA manifest
├── favicon.png          # App icon
├── assets/              # App assets
│   ├── AssetManifest.json
│   ├── FontManifest.json
│   └── assets/
└── canvaskit/           # Flutter rendering engine
```

---

## 🔄 **Deployment Commands Reference**

### **Basic Commands**
```bash
# Deploy hosting only
firebase deploy --only hosting

# Deploy with custom message
firebase deploy --only hosting -m "Feature: Added forgot password"

# Deploy to specific project
firebase deploy --only hosting --project t4g-for-business

# Preview before deploying
firebase hosting:channel:deploy preview
```

### **Advanced Commands**
```bash
# Deploy with target specification
firebase deploy --only hosting:t4g-for-business

# Deploy and open browser
firebase deploy --only hosting && firebase open hosting:site

# Force deploy (bypass warnings)
firebase deploy --only hosting --force

# Deploy with debug info
firebase deploy --only hosting --debug
```

---

## 🌍 **Environment Management**

### **Multiple Environments**
```bash
# Production deployment
firebase use t4g-for-business
firebase deploy --only hosting

# If you have staging environment
firebase use t4g-for-business-staging
firebase deploy --only hosting
```

### **Environment Variables**
For different build configurations:
```bash
# Production build
flutter build web --release --dart-define=ENVIRONMENT=production

# Staging build  
flutter build web --release --dart-define=ENVIRONMENT=staging
```

---

## 📊 **Monitoring & Analytics**

### **Deployment Verification**
```bash
# Check hosting status
firebase hosting:sites:list

# View deployment history
firebase hosting:clone

# Check site info
firebase hosting:sites:get t4g-for-business
```

### **Performance Monitoring**
After deployment, monitor at:
- **Firebase Console**: https://console.firebase.google.com/project/t4g-for-business
- **Live Site**: https://t4g-for-business.web.app
- **Analytics**: Firebase Analytics dashboard

---

## 🛠️ **Automation Scripts**

### **Create Deployment Script**
```bash
# Create deployment script
touch deploy.sh
chmod +x deploy.sh
```

```bash
#!/bin/bash
# deploy.sh

set -e  # Exit on any error

echo "🚀 T4G for Business Deployment Script"
echo "======================================"

# Get deployment message
read -p "📝 Enter deployment message (optional): " DEPLOY_MESSAGE

# Build the app
echo "🏗️  Building Flutter web app..."
flutter build web --no-tree-shake-icons

# Deploy to Firebase
echo "🚀 Deploying to Firebase Hosting..."
if [ -n "$DEPLOY_MESSAGE" ]; then
    firebase deploy --only hosting -m "$DEPLOY_MESSAGE"
else
    firebase deploy --only hosting
fi

# Success message
echo "✅ Deployment complete!"
echo "🌐 Live at: https://t4g-for-business.web.app"

# Optional: Open in browser
read -p "🌐 Open in browser? (y/n): " OPEN_BROWSER
if [ "$OPEN_BROWSER" = "y" ]; then
    open https://t4g-for-business.web.app
fi
```

### **Usage**
```bash
# Run deployment script
./deploy.sh
```

---

## 🚨 **Troubleshooting**

### **Common Issues**

#### **1. Build Errors**
```bash
# Clear Flutter cache
flutter clean
flutter pub get

# Clear Firebase cache
firebase logout
firebase login
```

#### **2. Permission Errors**
```bash
# Re-authenticate Firebase
firebase login --reauth

# Check project access
firebase projects:list
```

#### **3. Large Bundle Size**
```bash
# Optimize build
flutter build web --release --split-debug-info=debug-info/ --obfuscate

# Enable tree shaking (remove if causing issues)
flutter build web --release
```

#### **4. Deployment Timeout**
```bash
# Deploy with increased timeout
firebase deploy --only hosting --force
```

### **Rollback Previous Deployment**
```bash
# View deployment history
firebase hosting:clone

# Rollback to previous version
firebase hosting:clone --source=PREVIOUS_RELEASE_ID
```

---

## ⚡ **Quick Reference**

### **Daily Development Workflow**
```bash
# 1. Make code changes
# 2. Test locally
flutter run -d web-server --web-port 8080

# 3. Build and deploy
flutter build web --no-tree-shake-icons
firebase deploy --only hosting
```

### **URLs**
- **Live Site**: https://t4g-for-business.web.app
- **Firebase Console**: https://console.firebase.google.com/project/t4g-for-business
- **Alternative URL**: https://t4g-for-business.firebaseapp.com

### **Key Files**
- `firebase.json` - Hosting configuration
- `.firebaserc` - Project configuration  
- `build/web/` - Build output directory
- `web/index.html` - Web entry point

---

## 🎯 **Best Practices**

### **Before Each Deployment**
1. ✅ Test locally: `flutter run -d web-server`
2. ✅ Run analysis: `flutter analyze`
3. ✅ Check for errors: `flutter doctor`
4. ✅ Build clean: `flutter clean && flutter pub get`

### **Version Control**
```bash
# Tag releases
git tag -a v1.2.0 -m "Release v1.2.0: Added forgot password"
git push origin v1.2.0

# Deploy tagged version
firebase deploy --only hosting -m "v1.2.0: Added forgot password"
```

### **Security**
- ✅ Never commit Firebase keys to git
- ✅ Use environment variables for sensitive data
- ✅ Regularly review Firebase security rules
- ✅ Monitor deployment logs

---

## 🔧 **Advanced Configuration**

### **Custom Domain Setup**
```bash
# Add custom domain
firebase hosting:sites:create your-domain.com
firebase hosting:sites:list
```

### **Headers and Redirects**
Add to `firebase.json`:
```json
{
  "hosting": {
    "public": "build/web",
    "headers": [
      {
        "source": "**/*.@(js|css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      }
    ],
    "redirects": [
      {
        "source": "/old-path",
        "destination": "/new-path",
        "type": 301
      }
    ]
  }
}
```

---

## 📈 **Performance Optimization**

### **Build Optimizations**
```bash
# Production optimized build
flutter build web \
  --release \
  --split-debug-info=debug-info/ \
  --obfuscate \
  --tree-shake-icons \
  --dart-define=flutter.inspector.structuredErrors=false
```

### **Asset Optimization**
- Optimize images before adding to `assets/`
- Use WebP format when possible
- Minimize asset bundle size

---

## 🎉 **Success Checklist**

After deployment, verify:
- [ ] Site loads at https://t4g-for-business.web.app
- [ ] All pages navigate correctly
- [ ] Login functionality works
- [ ] Forgot password feature works
- [ ] Responsive design on mobile/desktop
- [ ] No console errors
- [ ] Performance metrics are good

---

*📅 Last updated: June 10, 2025*  
*🚀 Ready for production deployment!*
