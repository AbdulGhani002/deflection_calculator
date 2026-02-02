# GitHub Actions CI/CD Setup Guide

## Overview

This project uses GitHub Actions to automatically build Android APKs/AABs and iOS IPAs.

## Workflow Triggers

| Trigger | What Happens |
|---------|--------------|
| Push to `main`/`master` | Builds Android + iOS (unsigned) |
| Pull Request | Builds + runs tests |
| Git tag `v*` (e.g., `v1.0.0`) | Builds all + creates GitHub Release |
| Manual dispatch | Build on demand |

---

## Quick Start (No Secrets Needed)

The workflow will build **unsigned** APKs and IPAs without any setup:

1. Push your code to GitHub
2. Go to **Actions** tab
3. Builds run automatically
4. Download artifacts from the workflow run

---

## Setting Up Signed Builds

### Android Signing Setup

#### Step 1: Generate Keystore (if not done)

```bash
keytool -genkey -v -keystore release-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias deflection_calculator
```

#### Step 2: Encode Keystore to Base64

```bash
# macOS/Linux
base64 -i release-keystore.jks | pbcopy

# Windows PowerShell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("release-keystore.jks")) | Set-Clipboard

# Or save to file
[Convert]::ToBase64String([IO.File]::ReadAllBytes("release-keystore.jks")) > keystore-base64.txt
```

#### Step 3: Add GitHub Secrets

Go to: **Repository → Settings → Secrets and variables → Actions → New repository secret**

| Secret Name | Value |
|-------------|-------|
| `ANDROID_KEYSTORE_BASE64` | The base64-encoded keystore file |
| `KEYSTORE_PASSWORD` | Your keystore password |
| `KEY_PASSWORD` | Your key password |
| `KEY_ALIAS` | `deflection_calculator` (or your alias) |

---

### iOS Signing Setup

#### Prerequisites
- Apple Developer Account ($99/year)
- Distribution Certificate (.p12 file)
- Provisioning Profile (.mobileprovision file)

#### Step 1: Export Distribution Certificate

1. Open **Keychain Access** on Mac
2. Find your "Apple Distribution" certificate
3. Right-click → Export → Save as .p12 file
4. Set a password

#### Step 2: Download Provisioning Profile

1. Go to [Apple Developer Portal](https://developer.apple.com/account/resources/profiles)
2. Create an **App Store Distribution** profile
3. Download the `.mobileprovision` file

#### Step 3: Encode Files to Base64

```bash
# Certificate
base64 -i Certificates.p12 | pbcopy

# Provisioning Profile
base64 -i profile.mobileprovision | pbcopy
```

#### Step 4: Add GitHub Secrets

| Secret Name | Value |
|-------------|-------|
| `IOS_DISTRIBUTION_CERT_BASE64` | Base64-encoded .p12 certificate |
| `IOS_DISTRIBUTION_CERT_PASSWORD` | Password for .p12 file |
| `IOS_PROVISION_PROFILE_BASE64` | Base64-encoded .mobileprovision |
| `KEYCHAIN_PASSWORD` | Any random password (for temp keychain) |

#### Step 5: Update ExportOptions.plist

Edit `ios/ExportOptions.plist` and replace `YOUR_TEAM_ID` with your Apple Team ID.

Find your Team ID at: https://developer.apple.com/account → Membership → Team ID

---

## Creating a Release

### Automatic Release (Recommended)

```bash
# Create and push a tag
git tag v1.0.0
git push origin v1.0.0
```

This will:
1. Build Android APK + AAB
2. Build iOS IPA
3. Create a GitHub Release with all artifacts attached

### Manual Release

1. Go to **Actions** tab
2. Select "Build Flutter App"
3. Click "Run workflow"
4. Download artifacts manually

---

## Workflow Files

```
.github/
└── workflows/
    └── build.yml    # Main CI/CD workflow
```

---

## Artifacts Produced

| Artifact | Description | Use Case |
|----------|-------------|----------|
| `android-apk-arm64` | APK for 64-bit ARM devices | Direct install, most modern phones |
| `android-apk-arm32` | APK for 32-bit ARM devices | Older phones |
| `android-apk-x86_64` | APK for x86 devices | Emulators, Chromebooks |
| `android-aab` | App Bundle | **Play Store upload** |
| `ios-unsigned-ipa` | Unsigned iOS build | Testing, re-signing |
| `ios-signed-ipa` | Signed iOS build | **App Store upload** |

---

## Troubleshooting

### Android Build Fails

**"Keystore file not found"**
- Ensure `ANDROID_KEYSTORE_BASE64` secret is set correctly
- Verify base64 encoding is correct (no line breaks)

**"Wrong keystore password"**
- Check `KEYSTORE_PASSWORD` and `KEY_PASSWORD` secrets

### iOS Build Fails

**"No signing certificate"**
- Verify certificate is a Distribution certificate, not Development
- Check certificate hasn't expired

**"Provisioning profile doesn't match"**
- Ensure profile matches your Bundle ID: `com.deflection.deflection_calculator`
- Regenerate profile if Bundle ID changed

**"Team ID mismatch"**
- Update `ios/ExportOptions.plist` with correct Team ID

### General Issues

**"Flutter not found"**
- Workflow uses `subosito/flutter-action@v2` which auto-installs Flutter
- Check if Flutter version in workflow matches project requirements

---

## Cost Considerations

GitHub Actions is **free** for public repositories!

For private repositories:

| Plan | Minutes/Month | macOS Rate |
|------|---------------|------------|
| Free | 2,000 | 10x (200 min macOS) |
| Pro | 3,000 | 10x (300 min macOS) |

**Typical build times:**
- Android: ~5-8 minutes (Linux runner - 1x rate)
- iOS: ~10-15 minutes (macOS runner - 10x rate)

---

## Alternative: Codemagic

If you prefer a Flutter-focused CI/CD:

1. Sign up at [codemagic.io](https://codemagic.io)
2. Connect your GitHub repository
3. Use their visual workflow editor
4. **500 free minutes/month** on macOS

---

## Security Notes

⚠️ **Never commit these to your repository:**
- Keystore files (`.jks`, `.keystore`)
- `key.properties`
- Certificate files (`.p12`, `.cer`)
- Provisioning profiles (`.mobileprovision`)

✅ **Always use GitHub Secrets** for sensitive data
