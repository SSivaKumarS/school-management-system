#  API Documentation

## School Management API — v1.0.0

Base URL (local): `http://localhost:3000`

---

## Endpoints

---

### `GET /`
**Health Check**

Verifies the API server is running.

**Response `200 OK`**
```json
{
  "success": true,
  "message": "School Management API is running",
  "version": "1.0.0",
  "endpoints": {
    "getAllSchools": "GET /schools",
    "getSchoolById": "GET /schools/:id"
  }
}
```

---

### `GET /schools`
**Get All Schools**

Returns the full list of schools.

**Response `200 OK`**
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
      "image": "https://images.unsplash.com/...",
      "description": "Delhi Public School Hyderabad is a premier...",
      "established": 1998,
      "students": 3200,
      "teachers": 180,
      "facilities": [
        "Smart Classrooms",
        "Olympic Pool",
        "STEM Lab",
        "Library",
        "Sports Complex"
      ],
      "rating": 4.8,
      "contact": "+91-40-23456789",
      "website": "www.dpshyd.com",
      "address": "Sainikpuri, Hyderabad, Telangana - 500094"
    }
  ]
}
```

---

### `GET /schools/:id`
**Get School by ID**

Returns a single school matching the provided numeric ID.

**Path Parameters**

 Param  Type  Description 
`id`   integer  School ID (1–5) 

**Response `200 OK`**
```json
{
  "success": true,
  "data": {
    "id": 2,
    "name": "St. Mary's High School",
    "location": "Mumbai",
    "board": "ICSE",
    "fees": 120000,
    ...
  }
}
```

**Response `404 Not Found`**
```json
{
  "success": false,
  "message": "School with id 99 not found"
}
```

---

## School Object Schema

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier |
| `name` | string | School name |
| `location` | string | City |
| `board` | string | `CBSE`, `ICSE`, or `State` |
| `fees` | integer | Annual fees in INR |
| `image` | string | Image URL |
| `description` | string | Detailed description |
| `established` | integer | Year of establishment |
| `students` | integer | Total student count |
| `teachers` | integer | Total teacher count |
| `facilities` | string[] | List of facility names |
| `rating` | float | Rating out of 5.0 |
| `contact` | string | Phone number |
| `website` | string | School website |
| `address` | string | Full postal address |

---

## Error Handling

All errors return a consistent structure:

```json
{
  "success": false,
  "message": "Description of the error"
}
```

 Status Meaning 
 `200` Success 
 `404`  Resource not found 
 `500`  Internal server error 

---

## CORS

The API has CORS enabled for all origins (`*`), suitable for development.
For production, restrict to your Netlify domain:

```js
// server.js
app.use(cors({ origin: 'https://your-app.netlify.app' }));
```
