const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

app.post('/api/register', (req, res) => {
  const registration = req.body;
  console.log('Pendaftaran diterima:', registration);
  res.status(201).json({ message: 'Pendaftaran berhasil diterima.' });
});

app.get('/api/info', (req, res) => {
  res.json({
    school: 'SMK Nusantara',
    programs: ['Teknologi Informatika', 'Teknik Otomotif', 'Bisnis dan Manajemen']
  });
});

const port = process.env.PORT || 4000;
app.listen(port, () => {
  console.log(`Server backend berjalan di http://localhost:${port}`);
});
