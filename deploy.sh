#!/bin/bash

# T4G for Business - Firebase Deployment Script
# Usage: ./deploy.sh [message]

set -e  # Exit on any error

echo "🚀 T4G for Business Deployment Script"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get deployment message from argument or prompt
DEPLOY_MESSAGE="$1"
if [ -z "$DEPLOY_MESSAGE" ]; then
    read -p "📝 Enter deployment message (optional): " DEPLOY_MESSAGE
fi

# Check if Firebase CLI is available
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}❌ Firebase CLI not found. Please install it first:${NC}"
    echo "npm install -g firebase-tools"
    exit 1
fi

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter not found. Please install Flutter SDK.${NC}"
    exit 1
fi

# Check Firebase authentication
echo -e "${BLUE}🔐 Checking Firebase authentication...${NC}"
if ! firebase projects:list &> /dev/null; then
    echo -e "${RED}❌ Not authenticated with Firebase. Please run:${NC}"
    echo "firebase login"
    exit 1
fi

# Verify current project
CURRENT_PROJECT=$(firebase use --json | jq -r '.result.hosting[]' 2>/dev/null || echo "t4g-for-business")
echo -e "${GREEN}✅ Using Firebase project: ${CURRENT_PROJECT}${NC}"

# Clean previous build
echo -e "${BLUE}🧹 Cleaning previous builds...${NC}"
flutter clean

# Get dependencies
echo -e "${BLUE}📦 Getting dependencies...${NC}"
flutter pub get

# Run static analysis (optional, but recommended)
echo -e "${BLUE}🔍 Running static analysis...${NC}"
if ! flutter analyze --no-fatal-infos; then
    echo -e "${YELLOW}⚠️  Analysis found issues, but continuing...${NC}"
fi

# Build the Flutter web app
echo -e "${BLUE}🏗️  Building Flutter web app...${NC}"
if ! flutter build web --release --no-tree-shake-icons; then
    echo -e "${RED}❌ Flutter build failed!${NC}"
    exit 1
fi

# Check if build directory exists
if [ ! -d "build/web" ]; then
    echo -e "${RED}❌ Build directory not found!${NC}"
    exit 1
fi

# Display build info
BUILD_SIZE=$(du -sh build/web | cut -f1)
echo -e "${GREEN}✅ Build completed successfully (Size: ${BUILD_SIZE})${NC}"

# Deploy to Firebase Hosting
echo -e "${BLUE}🚀 Deploying to Firebase Hosting...${NC}"

if [ -n "$DEPLOY_MESSAGE" ]; then
    firebase deploy --only hosting -m "$DEPLOY_MESSAGE"
else
    firebase deploy --only hosting
fi

# Check deployment status
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
    echo ""
    echo -e "${GREEN}🌐 Your app is live at:${NC}"
    echo -e "${BLUE}   • https://t4g-for-business.web.app${NC}"
    echo -e "${BLUE}   • https://t4g-for-business.firebaseapp.com${NC}"
    echo ""
    
    # Optional: Open in browser
    read -p "🌐 Open in browser? (y/n): " OPEN_BROWSER
    if [ "$OPEN_BROWSER" = "y" ] || [ "$OPEN_BROWSER" = "Y" ]; then
        if command -v open &> /dev/null; then
            open https://t4g-for-business.web.app
        elif command -v xdg-open &> /dev/null; then
            xdg-open https://t4g-for-business.web.app
        else
            echo "Please open https://t4g-for-business.web.app in your browser"
        fi
    fi
    
    # Show deployment info
    echo ""
    echo -e "${YELLOW}📊 Deployment Information:${NC}"
    echo -e "   Date: $(date)"
    echo -e "   Project: ${CURRENT_PROJECT}"
    echo -e "   Build size: ${BUILD_SIZE}"
    if [ -n "$DEPLOY_MESSAGE" ]; then
        echo -e "   Message: ${DEPLOY_MESSAGE}"
    fi
    
else
    echo -e "${RED}❌ Deployment failed!${NC}"
    exit 1
fi
