#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

# 0) Paths
ROOT_DIR="/workspace"
SDK_DIR="$HOME/android-sdk"
GRADLE_DIR="$HOME/gradle/gradle-8.5"
JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
PATH_UPDATE="$JAVA_HOME/bin:$GRADLE_DIR/bin:$SDK_DIR/cmdline-tools/latest/bin:$SDK_DIR/platform-tools:$PATH"

# 1) Ensure JDK and tools
if ! command -v javac >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y openjdk-17-jdk wget unzip zip lib32stdc++6 lib32z1
fi
export JAVA_HOME
export PATH="$PATH_UPDATE"

# 2) Android SDK (cmdline-tools + build-tools + platform)
mkdir -p "$SDK_DIR/cmdline-tools"
if [ ! -d "$SDK_DIR/cmdline-tools/latest" ]; then
  tmpzip="/tmp/cmdtools.zip"
  wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O "$tmpzip"
  unzip -q "$tmpzip" -d "$SDK_DIR/cmdline-tools"
  mv "$SDK_DIR/cmdline-tools/cmdline-tools" "$SDK_DIR/cmdline-tools/latest"
fi
yes | sdkmanager --sdk_root="$SDK_DIR" --install "platform-tools" "platforms;android-34" "build-tools;34.0.0"
yes | sdkmanager --sdk_root="$SDK_DIR" --licenses

# 3) local.properties
printf "sdk.dir=%s\n" "$SDK_DIR" > "$ROOT_DIR/local.properties"

# 4) Gradle 8.5 + Wrapper
if [ ! -d "$GRADLE_DIR" ]; then
  mkdir -p "$(dirname "$GRADLE_DIR")"
  wget -q https://services.gradle.org/distributions/gradle-8.5-bin.zip -O /tmp/gradle.zip
  unzip -q /tmp/gradle.zip -d "$HOME/gradle"
fi
export PATH="$PATH_UPDATE"
cd "$ROOT_DIR"
if [ ! -f "$ROOT_DIR/gradlew" ]; then
  gradle --no-daemon --console=plain wrapper -PgradleVersion=8.5
fi

# 5) Keystore (if not exists)
KEYSTORE_PATH="$ROOT_DIR/app/release.keystore"
if [ ! -f "$KEYSTORE_PATH" ]; then
  keytool -genkeypair -v \
    -keystore "$KEYSTORE_PATH" \
    -storepass android \
    -keypass android \
    -alias release \
    -keyalg RSA \
    -keysize 2048 \
    -validity 36500 \
    -dname "CN=TeacherApp,O=Example,L=Tehran,ST=Tehran,C=IR"
fi

# 6) Build Debug + Release
./gradlew --no-daemon --console=plain clean assembleDebug assembleRelease

# 7) Print outputs
ls -lh "$ROOT_DIR/app/build/outputs/apk/debug/" || true
ls -lh "$ROOT_DIR/app/build/outputs/apk/release/" || true

# 8) Final paths
echo "\nDebug APK: $ROOT_DIR/app/build/outputs/apk/debug/app-debug.apk"
echo "Release APK: $ROOT_DIR/app/build/outputs/apk/release/app-release.apk"