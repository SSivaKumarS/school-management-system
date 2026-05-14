#  SchoolFinder — Mini School Management Module

A full-stack web application to browse, search, and filter schools across India. Built with **Flutter Web** (frontend) and **Node.js + Express** (backend), featuring clean architecture, responsive UI, and production-ready code.

---

##  Screenshots

> _Add your screenshots here after running the app._

| Home / Listing Page | Search & Filter | School Detail |
|---|---|---|
| ![Home](screenshots/home.png) | ![Filter](screenshots/filter.png) | ![Detail](screenshots/detail.png) |

---

##  Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter Web, Dart |
| UI Library | Material 3, Google Fonts (Poppins) |
| HTTP | `http` package (Dart) |
| Backend | Node.js, Express.js |
| CORS | `cors` npm package |
| Data | In-memory dummy JSON array |
| Deployment (Frontend) | Netlify |
| Deployment (Backend) | Render |
```

---

##  Quick Start

### Prerequisites

- **Node.js** v14+ → [Download](https://nodejs.org)
- **Flutter SDK** v3.0+ → [Install](https://docs.flutter.dev/get-started/install)
- **Chrome** browser (for Flutter Web)
- Verify Flutter Web is enabled: `flutter config --enable-web`

---

##  Backend Setup

```bash
# 1. Navigate to backend folder
cd school-management/backend

# 2. Install dependencies
npm install

# 3. Start the server
npm start
```

The API will run at: **http://localhost:3000**

For development with auto-reload:
```bash
npm run dev
```

---

##  Frontend Setup

```bash
# 1. Navigate to frontend folder
cd school-management/frontend

# 2. Get Flutter dependencies
flutter pub get

# 3. Run in Chrome
flutter run -d chrome
```

> **Note:** Make sure the backend is running before starting the frontend.

---

##  Run Commands

### Start Both (two terminals)

**Terminal 1 — Backend:**
```bash
cd backend && npm start
```

**Terminal 2 — Frontend:**
```bash
cd frontend && flutter run -d chrome
```

---

## 🌐 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Health check |
| GET | `/schools` | Get all schools |
| GET | `/schools/:id` | Get school by ID |

### Sample Response — `GET /schools`

```json
{
  "success": true,
  "count": 5,
  "data": [
    {
      "id": 1,
      "name": "Delhi Public School",
      "location": "Hyderabad",
      "board": "CBSE",
      "fees": 85000,
      "image": "https://...",
      "description": "...",
      "established": 1998,
      "students": 3200,
      "teachers": 180,
      "facilities": ["Smart Classrooms", "Olympic Pool"],
      "rating": 4.8,
      "contact": "+91-40-23456789",
      "website": "www.dpshyd.com",
      "address": "Sainikpuri, Hyderabad"
    }
  ]
}
```

---

##  Features

###  School Listing Page
- Displays 5 dummy schools in a responsive grid (1/2/3 columns)
- Each card shows: name, location, board badge, fees, thumbnail, rating, and "View Details" button

###  Search
- Real-time search by school name or location
- Updates results instantly as you type

###  Filters
- **Location** dropdown (dynamic from data)
- **Board** dropdown (CBSE / ICSE / State)
- **Fees Range** dual-handle slider
- "Clear All" button when filters are active

###  School Detail Page
- Hero image with gradient overlay
- Full school information: overview, stats, description, facilities, contact
- Responsive two-column layout on wide screens
- Back navigation

###  UX
- Loading indicator while fetching
- Error state with retry button
- Empty state when no results match
- Hover animations on cards

---

##  Deployment

### Backend → Render

1. Push `backend/` folder to a GitHub repo
2. Go to [render.com](https://render.com) → New → Web Service
3. Connect your GitHub repo
4. Set:
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
5. Deploy → copy the URL (e.g. `https://school-api.onrender.com`)
6. Update `_baseUrl` in `frontend/lib/services/school_service.dart`

### Frontend → Netlify

```bash
# Build Flutter Web
cd frontend
flutter build web

# The output is in: frontend/build/web/
```

1. Go to [netlify.com](https://netlify.com) → Add new site → Deploy manually
2. Drag & drop the `frontend/build/web/` folder
3. Done! Your app is live.

---

##  Environment Configuration

Before deploying, update the backend URL in:

```dart
// frontend/lib/services/school_service.dart
static const String _baseUrl = 'https://your-backend.onrender.com'; // ← change this
```

---

##  Author

Built as a full-stack assignment project demonstrating Flutter Web + Node.js integration.
