#!/bin/bash

# Quick deployment script for minor updates
# Usage: ./quick-deploy.sh [message]

set -e

echo "⚡ Quick Deploy - T4G for Business"
echo "================================="

# Get deployment message
DEPLOY_MESSAGE="$1"
if [ -z "$DEPLOY_MESSAGE" ]; then
    DEPLOY_MESSAGE="Quick update $(date '+%Y-%m-%d %H:%M')"
fi

echo "🏗️  Building web app..."
flutter build web --no-tree-shake-icons

echo "🚀 Deploying to Firebase..."
firebase deploy --only hosting -m "$DEPLOY_MESSAGE"

echo "✅ Deployed successfully!"
echo "🌐 Live at: https://t4g-for-business.web.app"
