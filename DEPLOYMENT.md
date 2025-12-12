# 🚀 Quick Deployment Reference
## T4G for Business

### **🔥 Most Used Commands**

#### **Quick Update Deploy**
```bash
./quick-deploy.sh "Your update message"
```

#### **Standard Deploy**
```bash
flutter build web --no-tree-shake-icons
firebase deploy --only hosting
```

#### **Full Production Deploy**
```bash
./deploy.sh "Major release v1.x.x"
```

---

### **📋 NPM Scripts (Alternative)**
```bash
# Build only
npm run build

# Build and deploy
npm run deploy

# Build and deploy with message
npm run deploy:message "Your message"

# Local preview
npm run serve
```

---

### **🌐 Your Live URLs**
- **Primary**: https://t4g-for-business.web.app
- **Alternative**: https://t4g-for-business.firebaseapp.com
- **Console**: https://console.firebase.google.com/project/t4g-for-business

---

### **🔧 Troubleshooting**
```bash
# If build fails
flutter clean && flutter pub get

# If deploy fails
firebase login --reauth

# If permissions error
firebase use t4g-for-business
```

---

### **📁 Key Files**
- `deploy.sh` - Full deployment script
- `quick-deploy.sh` - Fast deployment script  
- `firebase.json` - Hosting configuration
- `build/web/` - Build output (auto-generated)

---

### **✅ Deployment Checklist**
- [ ] Test locally: `flutter run -d web-server`
- [ ] Check for errors: `flutter analyze`
- [ ] Build: `flutter build web`
- [ ] Deploy: `firebase deploy --only hosting`
- [ ] Verify: Check live site

---

**🎉 Happy Deploying!**
