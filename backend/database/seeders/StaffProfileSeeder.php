<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class StaffProfileSeeder extends Seeder
{
    public function run(): void
    {
        $now = now();
        $profiles = [
            [
                'group' => 'headmaster',
                'name' => 'Ahmad Fauzi, M.Pd.',
                'role' => 'Kepala Sekolah',
                'image' => 'https://randomuser.me/api/portraits/men/32.jpg',
                'description' => 'Memimpin pengembangan pendidikan dan budaya sekolah yang berkarakter, kolaboratif, serta berorientasi pada kesiapan masa depan peserta didik.',
                'expertise' => 'Manajemen pendidikan dan pengembangan sekolah',
            ],
            [
                'group' => 'leadership',
                'names' => ['Budi Santoso, M.Pd.', 'Siti Aminah, S.Pd.', 'Rizky Pratama, M.Pd.', 'Dewi Lestari, S.Pd.', 'Agus Setiawan, S.Kom.', 'Nur Aini, M.Pd.', 'Hendra Wijaya, S.Pd.', 'Lina Marlina, S.Pd.'],
                'roles' => ['Wakil Kepala Sekolah Bidang Kurikulum', 'Wakil Kepala Sekolah Bidang Kesiswaan', 'Wakil Kepala Sekolah Bidang Sarana Prasarana', 'Wakil Kepala Sekolah Bidang Humas', 'Kepala Program Keahlian RPL', 'Kepala Program Keahlian TKRO', 'Kepala Program Keahlian TBSM', 'Kepala Program Keahlian AKL'],
                'expertise' => 'Manajemen sekolah dan pengembangan program pendidikan',
            ],
            [
                'group' => 'productive',
                'names' => ['Fajar Hidayat, S.Kom.', 'Intan Permata, S.Ds.', 'Dimas Saputra, S.T.', 'Rina Kurniawati, S.E.', 'Yoga Prabowo, S.T.', 'Maya Anggraini, S.Kom.', 'Andi Firmansyah, S.Pd.', 'Putri Rahmawati, S.Ds.'],
                'roles' => ['Guru Produktif Rekayasa Perangkat Lunak', 'Guru Produktif Desain Komunikasi Visual', 'Guru Produktif Teknik Kendaraan Ringan', 'Guru Produktif Akuntansi', 'Guru Produktif Teknik Sepeda Motor', 'Guru Produktif Pemrograman Web', 'Guru Produktif Jaringan Komputer', 'Guru Produktif Multimedia'],
                'expertise' => 'Pembelajaran praktik, proyek kejuruan, dan kemitraan industri',
            ],
            [
                'group' => 'class_subject',
                'names' => ['Sri Wahyuni, S.Pd.', 'Muhammad Irfan, S.Pd.', 'Yuliana Putri, S.Pd.', 'Rudi Hartono, S.Pd.', 'Nadia Safitri, S.Pd.', 'Eko Purnomo, S.Pd.', 'Laila Fitriani, S.Pd.', 'Deni Kurniawan, S.Pd.'],
                'roles' => ['Guru Matematika dan Wali Kelas X', 'Guru Bahasa Indonesia dan Wali Kelas XI', 'Guru Bahasa Inggris dan Wali Kelas XII', 'Guru Pendidikan Pancasila', 'Guru Sejarah Indonesia', 'Guru Pendidikan Jasmani', 'Guru Pendidikan Agama Islam', 'Guru Projek Kreatif dan Kewirausahaan'],
                'expertise' => 'Pembelajaran mata pelajaran umum dan pendampingan wali kelas',
            ],
            [
                'group' => 'staff',
                'names' => ['Hasan Basri', 'Rina Oktaviani', 'Mulyono', 'Fitri Handayani', 'Imam Syafii', 'Ratna Sari', 'Slamet Riyadi', 'Novi Wulandari'],
                'roles' => ['Kepala Tata Usaha', 'Staf Administrasi Akademik', 'Teknisi Laboratorium Komputer', 'Pustakawan', 'Teknisi Bengkel Otomotif', 'Staf Keuangan', 'Petugas Layanan Sekolah', 'Pengelola Sarana Prasarana'],
                'expertise' => 'Layanan administrasi, operasional, dan fasilitas sekolah',
            ],
        ];

        $portraitIndex = 1;
        foreach ($profiles as $group) {
            $people = isset($group['name'])
                ? [[
                    'name' => $group['name'],
                    'role' => $group['role'],
                    'image' => $group['image'],
                    'description' => $group['description'],
                ]]
                : array_map(fn(string $name, int $index) => [
                    'name' => $name,
                    'role' => $group['roles'][$index],
                    'image' => 'https://randomuser.me/api/portraits/' . ($index % 2 === 0 ? 'men' : 'women') . '/' . $portraitIndex . '.jpg',
                    'description' => $group['roles'][$index] . ' yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.',
                ], $group['names'], array_keys($group['names']));

            foreach ($people as $index => $person) {
                $slug = Str::slug($group['group'] . '-' . $person['name']);
                DB::table('staff_profiles')->updateOrInsert(
                    ['slug' => $slug],
                    [
                        'name' => $person['name'],
                        'slug' => $slug,
                        'staff_role' => $person['role'],
                        'staff_group' => $group['group'],
                        'sort_order' => $index + 1,
                        'description' => $person['description'],
                        'image' => $person['image'],
                        'current_position' => $person['role'] . ' di SMK Nurul Jadid',
                        'expertise' => $group['expertise'],
                        'education' => json_encode(['Pendidikan sesuai bidang keahlian', 'Pengembangan kompetensi profesional berkelanjutan']),
                        'additional_roles' => json_encode(['Pendampingan kegiatan dan pengembangan peserta didik']),
                        'professional_experience' => json_encode(['Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan']),
                        'publications' => json_encode([]),
                        'awards' => json_encode([]),
                        'motto' => 'Terus belajar, bertumbuh, dan memberi manfaat.',
                        'status' => 'published',
                        'created_at' => $now,
                        'updated_at' => $now,
                    ]
                );
                $portraitIndex++;
            }
        }
    }
}
