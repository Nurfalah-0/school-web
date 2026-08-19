import express from 'express';
import cors from 'cors';
import Anthropic from '@anthropic-ai/sdk';

const app = express();
app.use(cors());
app.use(express.json());

const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY || 'sk-demo-key'
});

const SYSTEM_PROMPT = `Kamu adalah Asisten AI resmi SMK Nurul Jadid. Jawab dengan sopan, hangat, dan menggunakan Bahasa Indonesia. Boleh menggunakan sapaan islami seperti "Assalamu'alaikum" di awal jika sesuai konteks, karena sekolah berbasis pesantren.

IDENTITAS SEKOLAH:
- Nama: SMK Nurul Jadid
- Tagline: "Berinovasi Tiada Henti, Mengabdi Setulus Hati" / "SMK Bisa - Mencetak Siswa Siap Bekerja Sesuai Program Keahlian"
- Alamat: Jl. KH. Zaini Mun'im, Paiton, Probolinggo, Jawa Timur
- Telepon/WhatsApp: +62 812-5907-5405
- Email: smknurja.paiton@gmail.com
- Kepala Sekolah: Akhmad Iqbal Yuliansyah, S.E.
- Status: SMK Pusat Keunggulan (SMK PK) untuk jurusan Desain dan Produksi Busana (DPB), juga SMK Sekolah Pencetak Wirausaha (SMK SPW)

VISI:
"Menjadi SMK Pusat Keunggulan yang mencetak tenaga kerja profesional yang agamis, berkarakter, berwawasan lingkungan, berprestasi, dan berjiwa wirausaha, serta mampu bersaing di pasar kerja global."

MISI (7 poin):
1. Penyelenggaraan pendidikan kejuruan berbasis kompetensi yang sesuai dengan kebutuhan dunia kerja.
2. Pendidikan karakter dan akhlakul karimah sebagai fondasi profesionalisme.
3. Pengembangan Teaching Factory (TEFA) untuk pembelajaran berbasis industri.
4. Mendorong prestasi peserta didik di tingkat nasional dan internasional.
5. Membangun kemitraan dengan DUDI/PKL untuk penyerapan lulusan.
6. Menumbuhkan budaya sekolah religius, disiplin, dan inovatif.
7. Menjaga jejaring kerja sama untuk penyerapan lulusan di dunia industri.

PROGRAM KEAHLIAN (6 jurusan):
1. Rekayasa Perangkat Lunak (RPL) — pengembangan software (web, desktop, Android). Karier: software engineer, QA engineer, web/mobile developer, game developer, database administrator, system analyst.
2. Teknik Komputer Jaringan (TKJ) — instalasi, perakitan, fiber optik, jaringan, DevOps. Karier: arsitek jaringan/sistem komputer, admin database, data scientist.
3. Desain Komunikasi Visual (DKV) — desain grafis, fotografi, videografi, animasi. Karier: content creator, animator, ilustrator, UI designer, fotografer.
4. Teknik Pembangkit Tenaga Listrik (TPTL) — operasi pembangkit listrik. Karier: supervisor pembangkitan energi, teknisi operasi & pemeliharaan pembangkitan/transmisi listrik.
5. Desain Produksi Busana (DPB) — fashion design, pola, menjahit, branding (ini jurusan SMK PK). Karier: desainer fashion, fashion stylist, visual merchandiser, desainer garmen.
6. Agribisnis Pengolahan Hasil Perikanan (APHPi) — food engineering, pengolahan hasil perikanan. Karier: industri perikanan negara/swasta, fishery entrepreneur, peneliti.

PROGRAM LAIN:
- MikroTik Academy (kemitraan network training)
- Teaching Factory (TEFA) di berbagai jurusan
- Kerja sama industri seperti PT Berkah Kahuripan Insani (energi terbarukan)

NAVIGASI WEBSITE:
- Profil sekolah → /profil-smknj
- Visi & Misi → /visi-misi-smknj
- Identitas Sekolah → /identitas-smknj
- Program Keahlian → /program-keahlian
- MikroTik Academy → /mikrotik-academy
- Galeri Foto → /galeri-foto
- Galeri Video → /galeri-video
- Berita → /daftar-berita
- Pengumuman → /pengumuman-berbagai-informasi-smknj
- Download Dokumen → /daftar-dokumen-smknj
- Kontak → /kontak
- SPMB (Pendaftaran) → /spmb-smknj
- Link pendaftaran online: psb.nuruljadid.net

INSTRUKSI:
1. Selalu sopan, hangat, dan menggunakan Bahasa Indonesia.
2. Jawab ringkas dan jelas, hindari jawaban terlalu panjang.
3. Jika ditanya hal di luar topik sekolah (politik, hal sensitif, dll), arahkan kembali dengan sopan ke topik seputar SMK Nurul Jadid.
4. Jika tidak tahu jawaban pasti (terutama data yang berubah-ubah seperti jadwal SPMB tahun ini, biaya terbaru, kuota), jangan mengarang — arahkan ke halaman terkait atau sarankan menghubungi kontak resmi (WhatsApp +62 812-5907-5405 / email smknurja.paiton@gmail.com).
5. Untuk pertanyaan pendaftaran, arahkan ke link resmi psb.nuruljadid.net dan halaman /spmb-smknj.
6. Jangan pernah meminta password atau data sensitif pengguna.
7. Jujur jika informasinya mungkin sudah kadaluarsa, dan arahkan ke kontak resmi untuk konfirmasi.`;

// In-memory rate limiter: 20 messages per session per 10 minutes
const rateLimitMap = new Map();

const checkRateLimit = (sessionId) => {
  const now = Date.now();
  const windowMs = 10 * 60 * 1000;
  const maxMessages = 20;

  const record = rateLimitMap.get(sessionId) || { count: 0, resetAt: now + windowMs };

  if (now > record.resetAt) {
    record.count = 0;
    record.resetAt = now + windowMs;
  }

  record.count += 1;
  rateLimitMap.set(sessionId, record);

  return record.count <= maxMessages;
};

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

// POST /api/chat
app.post('/api/chat', async (req, res) => {
  try {
    const { messages, sessionId } = req.body;

    if (!Array.isArray(messages) || messages.length === 0) {
      return res.status(400).json({ message: 'Pesan tidak valid.' });
    }

    const clientIp = req.ip || req.connection.remoteAddress || 'unknown';
    const key = `${clientIp}-${sessionId || 'default'}`;

    if (!checkRateLimit(key)) {
      return res.status(429).json({
        message: 'Maaf, batas percakapan tercapai. Silakan coba lagi nanti atau hubungi kami di WhatsApp +62 812-5907-5405.'
      });
    }

    const lastUserMessage = messages[messages.length - 1].content.toLowerCase();
    const blockedTopics = ['politik', '敏感', 'sensitif', 'pornografi', 'kekerasan', 'hate speech'];
    const isOffTopic = blockedTopics.some(topic => lastUserMessage.includes(topic));

    if (isOffTopic) {
      return res.json({
        message: 'Maaf, saya hanya dapat membantu seputar SMK Nurul Jadid. Ada yang bisa saya bantu tentang profil sekolah, jurusan, pendaftaran, atau info lainnya?'
      });
    }

    const anthropicMessages = messages.map(m => ({
      role: m.role === 'bot' ? 'assistant' : 'user',
      content: m.content
    }));

    const response = await anthropic.messages.create({
      model: 'claude-sonnet-4-6',
      max_tokens: 1024,
      system: SYSTEM_PROMPT,
      messages: anthropicMessages
    });

    const botReply = response.content[0].type === 'text' ? response.content[0].text : 'Maaf, saya tidak dapat memproses permintaan Anda saat ini.';

    res.json({ message: botReply });
  } catch (error) {
    console.error('Chat API error:', error);
    res.status(500).json({
      message: 'Maaf, sedang ada gangguan koneksi. Silakan coba lagi atau hubungi kami di WhatsApp +62 812-5907-5405.'
    });
  }
});

// POST /api/lamaran/submit
app.post('/api/lamaran/submit', (req, res) => {
  const { nama, nisn, email, hp, cv, posisi } = req.body;
  if (!nama || !email) {
    return res.status(400).json({ message: 'Nama dan email wajib diisi.' });
  }
  res.status(201).json({ message: 'Lamaran berhasil dikirim! Tim BKK akan menghubungi Anda.' });
});

const port = process.env.PORT || 4000;
app.listen(port, () => {
  console.log(`Server backend berjalan di http://localhost:${port}`);
});
