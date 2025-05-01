# Firebase chat Application

Deployment script 


Some of the cool features applied in the project:
- Flutter bloc(cubit)
- Enhanced clean architecture.
- Firebase Firestore, Firebase Storage, and Firebase Auth.
- Real-Time Changes from Firebase using Streams.
- Phone Number Authentication
- 1-1 Chatting with Contacts Only
- Text, Image, GIF, Audio(Recording), Video & Emoji Sharing
- Online/Offline Status
- Seen Message
- Replying to Messages
- Auto Scroll on New Messages
- Custom gallery & camera & video display

## Getting Started

This project is a starting point for a Flutter application.

#!/bin/bash

set -e

# ----------------------------
# CONFIGURATION
# ----------------------------

APP_NAME="FlutterChatApp"
BUILD_DIR="build"
FLAVOR=$1 # Accepts 'dev' or 'prod'
FIREBASE_PROJECT_ID_DEV="your-dev-project-id"
FIREBASE_PROJECT_ID_PROD="your-prod-project-id"

# ----------------------------
# UTILS
# ----------------------------

function check_flutter {
  echo "🔍 Checking Flutter version..."
  flutter --version
}

function clean_build {
  echo "🧹 Cleaning build..."
  flutter clean
  rm -rf pubspec.lock
  flutter pub get
}

function generate_files {
  echo "⚙️ Running code generation (if needed)..."
  flutter pub run build_runner build --delete-conflicting-outputs
}

function run_unit_tests {
  echo "🧪 Running unit tests..."
  flutter test
}

function setup_firebase {
  echo "🔥 Setting up Firebase for $FLAVOR..."

  if [ "$FLAVOR" == "dev" ]; then
    firebase use $FIREBASE_PROJECT_ID_DEV
    cp firebase/dev/google-services.json android/app/google-services.json
    cp firebase/dev/GoogleService-Info.plist ios/Runner/GoogleService-Info.plist
  elif [ "$FLAVOR" == "prod" ]; then
    firebase use $FIREBASE_PROJECT_ID_PROD
    cp firebase/prod/google-services.json android/app/google-services.json
    cp firebase/prod/GoogleService-Info.plist ios/Runner/GoogleService-Info.plist
  else
    echo "❌ Unknown flavor: $FLAVOR"
    exit 1
  fi
}

function build_apk {
  echo "📦 Building APK for $FLAVOR..."
  flutter build apk --flavor $FLAVOR --release
}

function build_ios {
  echo "🍎 Building iOS app for $FLAVOR..."
  flutter build ios --flavor $FLAVOR --release
}

# ----------------------------
# MAIN PROCESS
# ----------------------------

check_flutter
clean_build
setup_firebase
generate_files
run_unit_tests
build_apk
# Uncomment if building for iOS
# build_ios

echo "✅ Deployment build for '$FLAVOR' completed successfully."

