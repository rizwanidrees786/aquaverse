# AquaVerse — Build & Release Guide (Android APK, AAB & Google Play)

## 1. Generating an Upload Keystore (Run Locally — Never Commit to Git)
```bash
keytool -genkeypair -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias aquaverse_upload
```
Store a backup of `upload-keystore.jks` and your passwords in a secure password manager / encrypted offline vault.

## 2. GitHub Actions Secrets for Signed AAB & APK Builds
Add these secrets in **GitHub Repository -> Settings -> Secrets and variables -> Actions**:
- `ANDROID_KEYSTORE_BASE64`: Base64-encoded string of `upload-keystore.jks` (e.g. `base64 -w 0 upload-keystore.jks`).
- `ANDROID_STORE_PASSWORD`: Keystore password.
- `ANDROID_KEY_PASSWORD`: Key password.
- `ANDROID_KEY_ALIAS`: `aquaverse_upload` (your key alias).

## 3. Build Outputs
- Debug APK: `build/app/outputs/flutter-apk/app-debug.apk`
- Release APK: `build/app/outputs/flutter-apk/app-release.apk`
- Release AAB: `build/app/outputs/bundle/release/app-release.aab`

## 4. Google Play Console Checklist
- Enroll in **Play App Signing** and upload your upload certificate on first AAB upload.
- Increment `versionCode` (`+N` in `pubspec.yaml` `version: 0.1.0+1`) on every Play Console upload.
- Complete **Data Safety**, **Privacy Policy**, **Content Rating**, and **Internal / Closed Testing** tracks before production rollout.
