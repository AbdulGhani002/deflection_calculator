# Publishing Guide - Deflection Calculator

## Table of Contents
1. [Fix "Dangerous App" Warning](#fix-dangerous-app-warning)
2. [Google Play Store Publishing](#google-play-store-publishing)
3. [Apple App Store Publishing](#apple-app-store-publishing)
4. [Privacy Policy & Legal Requirements](#privacy-policy--legal-requirements)

---

## Fix "Dangerous App" Warning

The "dangerous app" warning appears because:
- ❌ APK is signed with **debug keys** (not production keys)
- ❌ App is sideloaded (not from Play Store)
- ❌ Google Play Protect hasn't verified it

**Solution**: Sign with a proper release keystore (see below)

---

## Google Play Store Publishing

### Prerequisites Checklist

| Requirement | Status | Action Needed |
|-------------|--------|---------------|
| Google Play Developer Account | ❓ | $25 one-time fee |
| Release Keystore | ❌ | Generate (instructions below) |
| App Signing Configuration | ❌ | Configure build.gradle |
| Privacy Policy URL | ❌ | Create and host |
| App Icons (512x512) | ❌ | Design high-res icon |
| Feature Graphic (1024x500) | ❌ | Design promotional banner |
| Screenshots | ❌ | Capture from device/emulator |
| App Description | ❌ | Write store listing |
| Content Rating | ❌ | Complete questionnaire |

### Step 1: Create Release Keystore

Run this command to generate a keystore:

```bash
keytool -genkey -v -keystore release-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias deflection_calculator
```

**IMPORTANT**: 
- Store the keystore file safely - you need it for ALL future updates
- Never commit the keystore or passwords to version control
- Back up to multiple secure locations

### Step 2: Configure Signing

1. Create `android/keystore/` folder
2. Place your `release-keystore.jks` inside
3. Create `android/key.properties` (DO NOT commit this file):

```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=deflection_calculator
storeFile=../keystore/release-keystore.jks
```

4. Update `android/app/build.gradle.kts` (already configured in this project)

### Step 3: Build Release APK/AAB

```bash
# Build App Bundle (recommended for Play Store)
flutter build appbundle --release

# Or build APK
flutter build apk --release --split-per-abi
```

### Step 4: Create Play Store Listing

**Required Assets:**
- High-res icon: 512x512 PNG (32-bit, alpha)
- Feature graphic: 1024x500 PNG/JPG
- Screenshots: Min 2, max 8 per device type
  - Phone: 16:9 or 9:16 aspect ratio
  - Tablet (7"): Optional but recommended
  - Tablet (10"): Optional but recommended

**Store Listing Text:**
- App name: Max 30 characters
- Short description: Max 80 characters
- Full description: Max 4000 characters

### Step 5: Content Rating

Complete the IARC questionnaire in Play Console:
- This app likely qualifies for "Everyone" rating
- No violence, gambling, or mature content
- No user-generated content
- No data collection (offline app)

### Step 6: Pricing & Distribution

- Set as **Free** or **Paid**
- Select countries for distribution
- Choose "This app is not primarily child-directed" (engineering tool)

---

## Apple App Store Publishing

### Prerequisites Checklist

| Requirement | Status | Action Needed |
|-------------|--------|---------------|
| Apple Developer Account | ❓ | $99/year |
| Mac with Xcode | ❓ | Required for building |
| App Store Connect setup | ❌ | Create app record |
| iOS Distribution Certificate | ❌ | Generate in Xcode |
| Provisioning Profile | ❌ | Generate in Developer Portal |
| Privacy Policy URL | ❌ | Same as Android |
| App Icons (1024x1024) | ❌ | Design for iOS |
| Screenshots | ❌ | Multiple device sizes |

### Step 1: Apple Developer Account

1. Go to https://developer.apple.com
2. Enroll in Apple Developer Program ($99/year)
3. Wait for approval (usually 24-48 hours)

### Step 2: Configure Xcode Project

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the Runner target
3. Under "Signing & Capabilities":
   - Select your Team
   - Set Bundle Identifier: `com.deflection.deflectionCalculator`
   - Enable "Automatically manage signing"

### Step 3: Update iOS Bundle Identifier

The Bundle ID should match your Apple Developer portal app registration.

### Step 4: Build for Release

```bash
# Build iOS release
flutter build ios --release

# Then archive in Xcode:
# Product > Archive > Distribute App
```

### Step 5: App Store Connect Setup

1. Go to https://appstoreconnect.apple.com
2. Create new app with same Bundle ID
3. Fill in:
   - App name
   - Primary language
   - Bundle ID
   - SKU (unique identifier)

### Step 6: Required Screenshots

| Device | Size | Required |
|--------|------|----------|
| iPhone 6.7" | 1290 x 2796 | Yes |
| iPhone 6.5" | 1242 x 2688 | Yes |
| iPhone 5.5" | 1242 x 2208 | Yes |
| iPad Pro 12.9" (6th gen) | 2048 x 2732 | If iPad supported |
| iPad Pro 12.9" (2nd gen) | 2048 x 2732 | If iPad supported |

### Step 7: App Review Guidelines

Apple reviews for:
- ✅ Crashes and bugs
- ✅ Broken links
- ✅ Placeholder content
- ✅ Privacy policy (required)
- ✅ Accurate metadata
- ✅ Intellectual property

**Timeline**: Usually 24-48 hours, can be up to 7 days

---

## Privacy Policy & Legal Requirements

### Privacy Policy (REQUIRED for both stores)

Since this app:
- ❌ Does NOT collect personal data
- ❌ Does NOT use analytics
- ❌ Does NOT require internet
- ❌ Does NOT have user accounts

You still need a privacy policy. Here's a template:

```
Privacy Policy for Deflection Calculator

Last updated: [DATE]

[Your Company Name] built the Deflection Calculator app as a Free app. 
This SERVICE is provided at no cost and is intended for use as is.

DATA COLLECTION
This app does not collect, store, or transmit any personal information. 
All calculations are performed locally on your device.

THIRD-PARTY SERVICES
This app does not use any third-party services that collect information.

CHILDREN'S PRIVACY
This app does not collect any personal information from anyone, 
including children under 13.

CHANGES TO THIS POLICY
We may update our Privacy Policy from time to time. We will notify 
you of any changes by posting the new Privacy Policy on this page.

CONTACT US
If you have questions, contact us at: [YOUR EMAIL]
```

**Hosting Options:**
1. GitHub Pages (free)
2. Your company website
3. Firebase Hosting (free tier)
4. Notion public page

### Terms of Service (Recommended)

Basic terms covering:
- Disclaimer: Engineering calculations should be verified by professionals
- No warranty for accuracy
- Limitation of liability

---

## Quick Publishing Checklist

### For Google Play:
- [ ] Create Google Play Developer account ($25)
- [ ] Generate release keystore
- [ ] Configure signing in build.gradle
- [ ] Build signed AAB: `flutter build appbundle --release`
- [ ] Create 512x512 icon
- [ ] Create 1024x500 feature graphic
- [ ] Take phone screenshots
- [ ] Write app description
- [ ] Host privacy policy
- [ ] Complete content rating questionnaire
- [ ] Submit for review

### For App Store:
- [ ] Create Apple Developer account ($99/year)
- [ ] Configure Xcode signing
- [ ] Build in Xcode and archive
- [ ] Create 1024x1024 icon
- [ ] Take screenshots for required devices
- [ ] Write app description
- [ ] Host privacy policy
- [ ] Submit for review

---

## Estimated Costs

| Item | Cost | Frequency |
|------|------|-----------|
| Google Play Developer | $25 | One-time |
| Apple Developer | $99 | Annual |
| Privacy Policy Hosting | $0 | Free (GitHub Pages) |
| **Total (first year)** | **$124** | |
| **Total (subsequent years)** | **$99** | Apple renewal only |

---

## Timeline Estimate

| Task | Time |
|------|------|
| Keystore & signing setup | 1 hour |
| Create graphics/screenshots | 2-4 hours |
| Write store listings | 1-2 hours |
| Privacy policy | 30 min |
| Google Play submission | 1 hour |
| Google Play review | 1-7 days |
| Apple submission | 2 hours |
| Apple review | 1-7 days |

**Total active work**: ~8-12 hours
**Total wait time**: 2-14 days
