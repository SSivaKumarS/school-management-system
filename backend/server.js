const express = require("express");
const cors = require("cors");

const app = express();
const PORT = process.env.PORT || 3000;

// ─── Middleware ───────────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json());

// ─── Dummy Data ───────────────────────────────────────────────────────────────
const schools = [
  {
    id: 1,
    name: "Delhi Public School",
    location: "Hyderabad",
    board: "CBSE",
    fees: 85000,
    image: "https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=600&q=80",
    description:
      "Delhi Public School Hyderabad is a premier co-educational institution affiliated to CBSE. Established in 1998, the school is known for its academic excellence, state-of-the-art infrastructure, and holistic development programs.",
    established: 1998,
    students: 3200,
    teachers: 180,
    facilities: ["Smart Classrooms", "Olympic Pool", "STEM Lab", "Library", "Sports Complex"],
    rating: 4.8,
    contact: "+91-40-23456789",
    website: "www.dpshyd.com",
    address: "Sainikpuri, Hyderabad, Telangana - 500094"
  },
  {
    id: 2,
    name: "St. Mary's High School",
    location: "Mumbai",
    board: "ICSE",
    fees: 120000,
    image: "https://images.unsplash.com/photo-1562774053-701939374585?w=600&q=80",
    description:
      "St. Mary's High School, Mumbai, is a prestigious ICSE-affiliated institution with a legacy of over 90 years. Renowned for its exceptional faculty and rigorous academic curriculum that prepares students for national and international competitions.",
    established: 1932,
    students: 2800,
    teachers: 160,
    facilities: ["Digital Library", "Science Labs", "Music Room", "Auditorium", "Cricket Ground"],
    rating: 4.9,
    contact: "+91-22-23456789",
    website: "www.stmarysmumbai.edu.in",
    address: "Bandra West, Mumbai, Maharashtra - 400050"
  },
  {
    id: 3,
    name: "Kendriya Vidyalaya",
    location: "Delhi",
    board: "CBSE",
    fees: 22000,
    image: "https://images.unsplash.com/photo-1509062522246-3755977927d7?w=600&q=80",
    description:
      "Kendriya Vidyalaya is a central government school providing quality education at affordable fees. The school follows the CBSE curriculum and is well known for NCC, sports, and cultural activities at national level.",
    established: 1975,
    students: 4500,
    teachers: 210,
    facilities: ["Computer Labs", "NCC Training", "Basketball Court", "Art Room", "Cafeteria"],
    rating: 4.5,
    contact: "+91-11-23456789",
    website: "www.kv.edu.in",
    address: "R.K. Puram, New Delhi - 110022"
  },
  {
    id: 4,
    name: "Vidya Niketan Academy",
    location: "Bangalore",
    board: "State",
    fees: 45000,
    image: "https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=600&q=80&sat=-50",
    description:
      "Vidya Niketan Academy is affiliated to the Karnataka State Board and is celebrated for its environmental education programs, mother tongue medium instruction, and vibrant co-curricular activities throughout the academic year.",
    established: 2005,
    students: 1800,
    teachers: 95,
    facilities: ["Eco Garden", "Computer Lab", "Yoga Studio", "Art Gallery", "Indoor Sports Hall"],
    rating: 4.3,
    contact: "+91-80-23456789",
    website: "www.vidyaniketan.ac.in",
    address: "Jayanagar, Bengaluru, Karnataka - 560041"
  },
  {
    id: 5,
    name: "The Heritage School",
    location: "Chennai",
    board: "ICSE",
    fees: 95000,
    image: "https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=600&q=80",
    description:
      "The Heritage School in Chennai offers a world-class ICSE curriculum blending traditional values with modern education. The school is distinguished for its international exchange programs, robotics club, and consistently high board results.",
    established: 2001,
    students: 2100,
    teachers: 130,
    facilities: ["Robotics Lab", "Swimming Pool", "Amphitheatre", "Tennis Court", "Innovation Hub"],
    rating: 4.7,
    contact: "+91-44-23456789",
    website: "www.heritagechennai.edu.in",
    address: "Adyar, Chennai, Tamil Nadu - 600020"
  }
];

// ─── Routes ───────────────────────────────────────────────────────────────────

// GET all schools
app.get("/schools", (req, res) => {
  res.status(200).json({
    success: true,
    count: schools.length,
    data: schools
  });
});

// GET single school by ID
app.get("/schools/:id", (req, res) => {
  const id = parseInt(req.params.id);
  const school = schools.find((s) => s.id === id);

  if (!school) {
    return res.status(404).json({
      success: false,
      message: `School with id ${id} not found`
    });
  }

  res.status(200).json({
    success: true,
    data: school
  });
});

// GET health check
app.get("/", (req, res) => {
  res.status(200).json({
    success: true,
    message: "School Management API is running",
    version: "1.0.0",
    endpoints: {
      getAllSchools: "GET /schools",
      getSchoolById: "GET /schools/:id"
    }
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: "Route not found"
  });
});

// ─── Start Server ─────────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`✅ School Management API running on http://localhost:${PORT}`);
  console.log(`📚 Endpoints:`);
  console.log(`   GET /          → API health check`);
  console.log(`   GET /schools   → All schools`);
  console.log(`   GET /schools/:id → Single school`);
});
