# 🔐 Complete Authentication Setup Guide

This guide provides step-by-step instructions to fix email confirmation and Google Sign-In issues in your Flutter app with Supabase.

## 🚨 Issues Identified

### Issue 1: Email Confirmation Redirect
- **Problem**: Links redirect to `localhost:3000` with `otp_expired` error
- **Root Cause**: Incorrect URL configuration in Supabase

### Issue 2: Google Sign-In Error
- **Problem**: `PlatformException(sign_in_failed, z0.d: 10: , null, null)`
- **Root Cause**: Missing OAuth configuration in Google Cloud Console and Supabase

## 📋 Complete Setup Checklist

### ✅ Step 1: Supabase Configuration

#### 1.1 URL Configuration
1. Go to **Supabase Dashboard** → Your Project → **Authentication** → **URL Configuration**
2. Set the following URLs:

```
Site URL: 
- Development: http://localhost:3000
- Production: https://yourdomain.com

Redirect URLs (add all of these):
- http://localhost:3000/**
- https://yourdomain.com/**
- file:///path/to/your/project/web/confirm-email.html
```

#### 1.2 Email Templates
1. Go to **Authentication** → **Email Templates**
2. Edit **"Confirm signup"** template
3. Change the confirmation URL to:
```
{{ .SiteURL }}/confirm-email.html?access_token={{ .TokenHash }}&type=signup
```

#### 1.3 Enable Google Provider
1. Go to **Authentication** → **Providers**
2. Enable **Google** provider
3. Leave Client ID and Secret empty for now (we'll fill these after Google setup)

### ✅ Step 2: Google Cloud Console Setup

#### 2.1 Create/Setup Project
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create new project or select existing one
3. Enable the following APIs:
   - **Google+ API**
   - **Google Identity API**
   - **Google Sign-In API**

#### 2.2 Configure OAuth Consent Screen
1. Go to **APIs & Services** → **OAuth consent screen**
2. Choose **External** user type
3. Fill required information:
```
App name: Weekly Dashboard
User support email: your-email@gmail.com
App domain: yourdomain.com (optional)
Developer contact information: your-email@gmail.com
```
4. Add scopes:
   - `../auth/userinfo.email`
   - `../auth/userinfo.profile`
   - `openid`

#### 2.3 Create OAuth 2.0 Credentials

**Create 3 separate OAuth clients:**

**A) Web Application (for Supabase)**
```
Application type: Web application
Name: Weekly Dashboard Web
Authorized redirect URIs:
- https://okddqskxlureguahozhh.supabase.co/auth/v1/callback
- http://localhost:3000/auth/callback
```

**B) Android Application**
```
Application type: Android
Name: Weekly Dashboard Android
Package name: com.yourapp.weeklydashboard
SHA-1 certificate fingerprint: [Run get_sha1.bat to get this]
```

**C) iOS Application** (if targeting iOS)
```
Application type: iOS
Name: Weekly Dashboard iOS
Bundle ID: com.yourapp.weeklydashboard
```

### ✅ Step 3: Get SHA-1 Certificate

#### For Windows:
1. Run the provided `get_sha1.bat` file
2. Copy the SHA-1 fingerprint
3. Add it to your Android OAuth client in Google Cloud Console

#### Manual Method:
```bash
# Navigate to Android SDK location
cd %USERPROFILE%\.android

# For debug keystore
keytool -list -v -keystore debug.keystore -alias androiddebugkey -storepass android -keypass android

# For release keystore (when publishing)
keytool -list -v -keystore your-release-key.keystore -alias your-key-alias
```

### ✅ Step 4: Update Supabase Google Provider

1. Go back to **Supabase Dashboard** → **Authentication** → **Providers**
2. Configure Google provider with:
```
Client ID: [Your Web OAuth Client ID from Google Cloud Console]
Client Secret: [Your Web OAuth Client Secret from Google Cloud Console]
```

### ✅ Step 5: Update Flutter Configuration

#### 5.1 Update Android Configuration
1. Edit `android/app/src/main/res/values/strings.xml`:
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="default_web_client_id">YOUR_WEB_CLIENT_ID.apps.googleusercontent.com</string>
    <string name="app_name">Weekly Dashboard</string>
</resources>
```

#### 5.2 Update SupabaseAuthService
Replace `YOUR_GOOGLE_OAUTH_WEB_CLIENT_ID.apps.googleusercontent.com` with your actual Web Client ID in:
```dart
static final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
  serverClientId: 'YOUR_ACTUAL_WEB_CLIENT_ID.apps.googleusercontent.com',
);
```

#### 5.3 Update Android Manifest (if needed)
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### ✅ Step 6: Test Configuration

#### 6.1 Test Email Confirmation
1. Sign up with a new email
2. Check email for confirmation link
3. Click link → should redirect to your custom confirmation page
4. Verify success message appears

#### 6.2 Test Google Sign-In
1. Try Google Sign-In from Flutter app
2. Should open Google OAuth flow
3. After approval, should return to app with user signed in

## 🔧 Troubleshooting

### Email Confirmation Issues
- **Still getting localhost:3000**: Check Site URL in Supabase
- **OTP Expired**: Ensure email template uses correct URL format
- **Access Denied**: Verify redirect URLs are properly configured

### Google Sign-In Issues
- **Error 10**: SHA-1 fingerprint not added or incorrect
- **Error 12**: OAuth client not configured properly
- **Network Error**: Check internet connection and API enablement

### Common Mistakes
1. **Using Android Client ID instead of Web Client ID** in Flutter
2. **Not adding SHA-1 fingerprint** to Android OAuth client
3. **Incorrect redirect URLs** in Supabase
4. **Not enabling required APIs** in Google Cloud Console

## 📱 Production Deployment

### Before Publishing:
1. **Generate release keystore**:
```bash
keytool -genkey -v -keystore release-key.keystore -alias key-alias -keyalg RSA -keysize 2048 -validity 10000
```

2. **Get release SHA-1**:
```bash
keytool -list -v -keystore release-key.keystore -alias key-alias
```

3. **Add release SHA-1** to Google Cloud Console Android OAuth client

4. **Update Supabase URLs** to production domains

5. **Test thoroughly** before release

## 🎯 Expected Results

After completing this setup:
- ✅ Email confirmation links work properly
- ✅ Google Sign-In works without errors
- ✅ Users can authenticate via both methods
- ✅ Sessions persist across app restarts
- ✅ Multi-device sync works correctly

## 📞 Support

If you encounter issues:
1. Double-check all configuration steps
2. Verify API keys and client IDs are correct
3. Check Supabase and Google Cloud Console logs
4. Test with different email addresses and Google accounts

Remember: OAuth configuration changes can take a few minutes to propagate!
