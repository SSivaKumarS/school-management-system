#  Deployment Guide

## Overview

Part  Platform  Cost 
Backend (Node.js) [Render](https://render.com)  Free tier available 
Frontend (Flutter Web)  [Netlify](https://netlify.com)  Free tier available 

---

## Step 1 — Deploy Backend to Render

### 1.1 Prepare your repo

Make sure your `backend/` folder has:
- `package.json` with `"start": "node server.js"`
- `server.js`

Push the project to GitHub.

### 1.2 Create Render Web Service

1. Go to [render.com](https://render.com) and sign up / log in
2. Click **New +** → **Web Service**
3. Connect your GitHub repository
4. Configure:
   - **Name:** `school-management-api`
   - **Root Directory:** `backend`
   - **Runtime:** `Node`
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
   - **Instance Type:** Free
5. Click **Create Web Service**

### 1.3 Note your backend URL

After deployment, Render provides a URL like:
```
https://school-management-api.onrender.com
```

---

## Step 2 — Update Frontend API URL

Open `frontend/lib/services/school_service.dart` and change:

```dart
// Before (local)
static const String _baseUrl = 'http://localhost:3000';

// After (production)
static const String _baseUrl = 'https://school-management-api.onrender.com';
```

---

## Step 3 — Build Flutter Web

```bash
cd frontend

# Ensure web is enabled
flutter config --enable-web

# Get packages
flutter pub get

# Build for production
flutter build web --release
```

Output files are in: `frontend/build/web/`

---

## Step 4 — Deploy Frontend to Netlify

### Option A: Drag & Drop (Easiest)

1. Go to [netlify.com](https://netlify.com) and log in
2. Click **Add new site** → **Deploy manually**
3. Drag and drop the **`frontend/build/web/`** folder onto the upload area
4. Wait for deployment (~30 seconds)
5. Your app is live at a URL like `https://amazing-school-12345.netlify.app`

### Option B: Netlify CLI

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Login
netlify login

# Deploy from build folder
cd frontend
netlify deploy --prod --dir=build/web
```

### Option C: Connect GitHub (Auto-Deploy)

1. Push project to GitHub
2. In Netlify: **New site** → **Import from Git**
3. Set build settings:
   - **Base directory:** `frontend`
   - **Build command:** `flutter build web --release`
   - **Publish directory:** `frontend/build/web`
4. Add environment variable if needed (Flutter version, etc.)

---

## Step 5 — Update CORS for Production (Optional)

In `backend/server.js`, restrict CORS to your Netlify domain:

```js
app.use(cors({
  origin: 'https://your-app.netlify.app'
}));
```

Redeploy the backend after this change.

---

##  Deployment Checklist

- [ ] Backend pushed to GitHub
- [ ] Render Web Service created and running
- [ ] Backend URL copied from Render dashboard
- [ ] `_baseUrl` in `school_service.dart` updated to Render URL
- [ ] `flutter build web --release` run successfully
- [ ] `build/web/` folder uploaded to Netlify
- [ ] App opens in browser and loads school data

---

## Updating After Changes

**Backend change:**
```bash
git add . && git commit -m "update" && git push
# Render auto-deploys on push
```

**Frontend change:**
```bash
cd frontend
flutter build web --release
# Re-upload build/web to Netlify (or Netlify auto-deploys if connected to GitHub)
```
