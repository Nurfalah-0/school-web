import express from 'express';
import cors from 'cors';

const app = express();
app.use(cors());
app.use(express.json());

// In-memory data store
let registrations = [
  {
    id: 1,
    name: 'Ahmad Rizky',
    email: 'rizky@gmail.com',
    nisn: '0051234567',
    program: 'Teknologi Informatika',
    status: 'Disetujui',
    createdAt: '2026-07-28 10:15'
  },
  {
    id: 2,
    name: 'Siti Nurhaliza',
    email: 'siti.nur@gmail.com',
    nisn: '0059876543',
    program: 'Bisnis dan Manajemen',
    status: 'Menunggu',
    createdAt: '2026-07-30 14:20'
  },
  {
    id: 3,
    name: 'Budi Santoso',
    email: 'budi.santoso@yahoo.com',
    nisn: '0054567890',
    program: 'Teknik Otomotif',
    status: 'Menunggu',
    createdAt: '2026-08-01 09:00'
  }
];

// POST /api/register
app.post('/api/register', (req, res) => {
  const { name, email, nisn, program } = req.body;
  if (!name || !email || !nisn) {
    return res.status(400).json({ message: 'Mohon isi semua data yang diperlukan.' });
  }

  const newReg = {
    id: Date.now(),
    name,
    email,
    nisn,
    program: program || 'Teknologi Informatika',
    status: 'Menunggu',
    createdAt: new Date().toISOString().replace('T', ' ').substring(0, 16)
  };

  registrations.unshift(newReg);
  console.log('Pendaftaran baru diterima:', newReg);
  res.status(201).json({ message: 'Pendaftaran berhasil diterima.', registration: newReg });
});

// GET /api/registrations
app.get('/api/registrations', (req, res) => {
  res.json(registrations);
});

// PATCH /api/registrations/:id
app.patch('/api/registrations/:id', (req, res) => {
  const { id } = req.params;
  const { status } = req.body;
  const item = registrations.find(r => r.id == id);
  if (!item) {
    return res.status(404).json({ message: 'Data tidak ditemukan.' });
  }
  item.status = status || item.status;
  res.json({ message: 'Status berhasil diperbarui.', registration: item });
});

// POST /api/login
app.post('/api/login', (req, res) => {
  const { username, password } = req.body;
  if (username === 'admin' && password === 'admin123') {
    return res.json({
      success: true,
      token: 'mock-jwt-token-smk-2026',
      user: { name: 'Administrator BKK', role: 'admin', email: 'admin@smknusantara.sch.id' }
    });
  } else if (username && password) {
    // Demo mode: allow login with any credentials if valid format
    return res.json({
      success: true,
      token: 'mock-jwt-token-demo',
      user: { name: username, role: 'admin', email: `${username}@smknusantara.sch.id` }
    });
  }
  res.status(401).json({ message: 'Username atau password salah!' });
});

// GET /api/info
app.get('/api/info', (req, res) => {
  res.json({
    school: 'SMK Nusantara',
    programs: ['Teknologi Informatika', 'Teknik Otomotif', 'Bisnis dan Manajemen'],
    totalRegistrations: registrations.length
  });
});

const port = process.env.PORT || 4000;
app.listen(port, () => {
  console.log(`Server backend berjalan di http://localhost:${port}`);
});
