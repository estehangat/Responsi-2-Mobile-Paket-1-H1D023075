const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = 3000;
const JWT_SECRET = 'superdaiva_secret_key_2024';

// Middleware
app.use(cors());
app.use(express.json());

// Database file paths
const DB_PATH = path.join(__dirname, 'database');
const USERS_FILE = path.join(DB_PATH, 'users.json');
const INVENTARIS_FILE = path.join(DB_PATH, 'inventaris.json');

// Ensure database directory exists
if (!fs.existsSync(DB_PATH)) {
  fs.mkdirSync(DB_PATH, { recursive: true });
}

// Initialize database files
const initDB = () => {
  if (!fs.existsSync(USERS_FILE)) {
    fs.writeFileSync(USERS_FILE, JSON.stringify([]));
  }
  if (!fs.existsSync(INVENTARIS_FILE)) {
    fs.writeFileSync(INVENTARIS_FILE, JSON.stringify([]));
  }
};

initDB();

// Helper functions
const readUsers = () => JSON.parse(fs.readFileSync(USERS_FILE, 'utf8'));
const writeUsers = (data) => fs.writeFileSync(USERS_FILE, JSON.stringify(data, null, 2));
const readInventaris = () => JSON.parse(fs.readFileSync(INVENTARIS_FILE, 'utf8'));
const writeInventaris = (data) => fs.writeFileSync(INVENTARIS_FILE, JSON.stringify(data, null, 2));

// Generate ID
const generateId = (items) => {
  if (items.length === 0) return 1;
  return Math.max(...items.map(item => item.id)) + 1;
};

// Middleware untuk verifikasi JWT
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Token tidak ditemukan' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Token tidak valid' });
    }
    req.user = user;
    next();
  });
};

// ==================== AUTH ROUTES ====================

// Register
app.post('/api/register', async (req, res) => {
  try {
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
      return res.status(400).json({ error: 'Semua field harus diisi' });
    }

    const users = readUsers();
    
    // Check if user exists
    const existingUser = users.find(u => u.username === username || u.email === email);
    if (existingUser) {
      return res.status(400).json({ error: 'Username atau email sudah terdaftar' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create new user
    const newUser = {
      id: generateId(users),
      username,
      email,
      password: hashedPassword,
      created_at: new Date().toISOString()
    };

    users.push(newUser);
    writeUsers(users);

    res.status(201).json({ 
      message: 'Registrasi berhasil',
      userId: newUser.id 
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
});

// Login
app.post('/api/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'Email dan password harus diisi' });
    }

    const users = readUsers();
    
    // Find user
    const user = users.find(u => u.email === email);
    if (!user) {
      return res.status(401).json({ error: 'Email atau password salah' });
    }

    // Check password
    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(401).json({ error: 'Email atau password salah' });
    }

    // Generate token
    const token = jwt.sign(
      { id: user.id, username: user.username, email: user.email },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    res.json({
      message: 'Login berhasil',
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email
      }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
});

// ==================== INVENTARIS ROUTES ====================

// Get all inventaris (for current user)
app.get('/api/inventaris', authenticateToken, (req, res) => {
  try {
    const allInventaris = readInventaris();
    const userInventaris = allInventaris
      .filter(item => item.user_id === req.user.id)
      .sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
    res.json(userInventaris);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
});

// Get single inventaris
app.get('/api/inventaris/:id', authenticateToken, (req, res) => {
  try {
    const allInventaris = readInventaris();
    const inventaris = allInventaris.find(
      item => item.id === parseInt(req.params.id) && item.user_id === req.user.id
    );
    
    if (!inventaris) {
      return res.status(404).json({ error: 'Data tidak ditemukan' });
    }
    
    res.json(inventaris);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
});

// Create inventaris
app.post('/api/inventaris', authenticateToken, (req, res) => {
  try {
    const { nama, harga, jumlah, tanggal_masuk } = req.body;

    if (!nama || harga === undefined || jumlah === undefined || !tanggal_masuk) {
      return res.status(400).json({ error: 'Semua field harus diisi' });
    }

    const allInventaris = readInventaris();
    
    const newInventaris = {
      id: generateId(allInventaris),
      nama,
      harga,
      jumlah,
      tanggal_masuk,
      user_id: req.user.id,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    };

    allInventaris.push(newInventaris);
    writeInventaris(allInventaris);

    res.status(201).json({
      message: 'Data berhasil ditambahkan',
      data: newInventaris
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
});

// Update inventaris
app.put('/api/inventaris/:id', authenticateToken, (req, res) => {
  try {
    const { nama, harga, jumlah, tanggal_masuk } = req.body;
    const id = parseInt(req.params.id);

    const allInventaris = readInventaris();
    
    // Check if exists
    const index = allInventaris.findIndex(
      item => item.id === id && item.user_id === req.user.id
    );
    
    if (index === -1) {
      return res.status(404).json({ error: 'Data tidak ditemukan' });
    }

    if (!nama || harga === undefined || jumlah === undefined || !tanggal_masuk) {
      return res.status(400).json({ error: 'Semua field harus diisi' });
    }

    allInventaris[index] = {
      ...allInventaris[index],
      nama,
      harga,
      jumlah,
      tanggal_masuk,
      updated_at: new Date().toISOString()
    };

    writeInventaris(allInventaris);

    res.json({
      message: 'Data berhasil diupdate',
      data: allInventaris[index]
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
});

// Delete inventaris
app.delete('/api/inventaris/:id', authenticateToken, (req, res) => {
  try {
    const id = parseInt(req.params.id);

    const allInventaris = readInventaris();
    
    // Check if exists
    const index = allInventaris.findIndex(
      item => item.id === id && item.user_id === req.user.id
    );
    
    if (index === -1) {
      return res.status(404).json({ error: 'Data tidak ditemukan' });
    }

    allInventaris.splice(index, 1);
    writeInventaris(allInventaris);

    res.json({ message: 'Data berhasil dihapus' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`SuperDaiva API Server berjalan di http://localhost:${PORT}`);
});
