import '../models/question.dart';

/// Daftar 10 pertanyaan kuis bertema komputer dan teknologi informasi.
/// Data disimpan secara lokal tanpa database eksternal.
const List<Question> quizQuestions = [
  // ─────────────────────────────────────────────
  // Pertanyaan 1 — Hardware
  // ─────────────────────────────────────────────
  Question(
    question: 'Apa kepanjangan dari CPU?',
    options: [
      'Central Processing Unit',
      'Computer Personal Unit',
      'Central Program Utility',
      'Core Processing Unit',
    ],
    correctIndex: 0,
    explanation:
        'CPU (Central Processing Unit) adalah otak dari komputer yang '
        'memproses semua instruksi dan perhitungan.',
  ),

  // ─────────────────────────────────────────────
  // Pertanyaan 2 — Storage
  // ─────────────────────────────────────────────
  Question(
    question:
        'Perangkat penyimpanan manakah yang menggunakan teknologi flash memory '
        'dan tidak memiliki komponen mekanik bergerak?',
    options: [
      'HDD (Hard Disk Drive)',
      'DVD-ROM',
      'SSD (Solid State Drive)',
      'Floppy Disk',
    ],
    correctIndex: 2,
    explanation:
        'SSD menggunakan flash memory sehingga lebih cepat, tahan banting, '
        'dan hemat daya dibanding HDD yang menggunakan piringan magnetik.',
  ),

  // ─────────────────────────────────────────────
  // Pertanyaan 3 — Jaringan
  // ─────────────────────────────────────────────
  Question(
    question: 'Apa fungsi utama dari protokol HTTP?',
    options: [
      'Mengirim email antar pengguna',
      'Mentransfer data halaman web antara server dan browser',
      'Mengenkripsi koneksi jaringan',
      'Menghubungkan perangkat dalam jaringan lokal',
    ],
    correctIndex: 1,
    explanation:
        'HTTP (HyperText Transfer Protocol) adalah protokol yang digunakan '
        'untuk mentransfer data halaman web dari server ke browser pengguna.',
  ),

  // ─────────────────────────────────────────────
  // Pertanyaan 4 — Sistem Operasi
  // ─────────────────────────────────────────────
  Question(
    question:
        'Di antara berikut ini, manakah yang termasuk sistem operasi mobile?',
    options: [
      'Windows 11 dan macOS',
      'Ubuntu dan Fedora',
      'Android dan iOS',
      'Linux dan Unix',
    ],
    correctIndex: 2,
    explanation:
        'Android (dikembangkan Google) dan iOS (dikembangkan Apple) '
        'adalah sistem operasi yang dirancang khusus untuk perangkat mobile.',
  ),

  // ─────────────────────────────────────────────
  // Pertanyaan 5 — Pemrograman
  // ─────────────────────────────────────────────
  Question(
    question:
        'Bahasa pemrograman apa yang digunakan untuk mengembangkan '
        'aplikasi Flutter?',
    options: [
      'Kotlin',
      'Swift',
      'Java',
      'Dart',
    ],
    correctIndex: 3,
    explanation:
        'Flutter menggunakan bahasa Dart yang dikembangkan oleh Google. '
        'Dart dirancang untuk membangun aplikasi multiplatform dengan performa tinggi.',
  ),

  // ─────────────────────────────────────────────
  // Pertanyaan 6 — Internet
  // ─────────────────────────────────────────────
  Question(
    question: 'Apa kepanjangan dari URL?',
    options: [
      'Uniform Resource Locator',
      'Universal Reference Link',
      'Unified Resource Library',
      'Universal Routing Language',
    ],
    correctIndex: 0,
    explanation:
        'URL (Uniform Resource Locator) adalah alamat unik yang digunakan '
        'untuk mengidentifikasi lokasi sebuah resource di internet, '
        'seperti https://www.google.com.',
  ),

  // ─────────────────────────────────────────────
  // Pertanyaan 7 — Database
  // ─────────────────────────────────────────────
  Question(
    question:
        'Perintah SQL apa yang digunakan untuk mengambil data dari tabel database?',
    options: [
      'INSERT',
      'UPDATE',
      'SELECT',
      'DELETE',
    ],
    correctIndex: 2,
    explanation:
        'Perintah SELECT digunakan untuk membaca atau mengambil data dari '
        'tabel. Contoh: SELECT * FROM users; akan mengambil semua data '
        'dari tabel users.',
  ),

  // ─────────────────────────────────────────────
  // Pertanyaan 8 — Binary
  // ─────────────────────────────────────────────
  Question(
    question: 'Berapa nilai desimal dari bilangan biner 1010?',
    options: [
      '8',
      '10',
      '12',
      '16',
    ],
    correctIndex: 1,
    explanation:
        'Biner 1010 = (1×2³) + (0×2²) + (1×2¹) + (0×2⁰) '
        '= 8 + 0 + 2 + 0 = 10 dalam desimal.',
  ),

  // ─────────────────────────────────────────────
  // Pertanyaan 9 — Keamanan
  // ─────────────────────────────────────────────
  Question(
    question:
        'Apa yang dimaksud dengan enkripsi dalam keamanan komputer?',
    options: [
      'Proses menghapus data secara permanen dari storage',
      'Proses mengubah data menjadi format yang tidak bisa dibaca '
          'tanpa kunci khusus',
      'Proses menyalin data ke lokasi cadangan',
      'Proses memindai virus dalam sistem',
    ],
    correctIndex: 1,
    explanation:
        'Enkripsi adalah proses mengubah data (plaintext) menjadi format '
        'acak (ciphertext) menggunakan algoritma dan kunci, sehingga '
        'hanya pihak yang memiliki kunci yang bisa membacanya.',
  ),

  // ─────────────────────────────────────────────
  // Pertanyaan 10 — Software
  // ─────────────────────────────────────────────
  Question(
    question:
        'Apa perbedaan utama antara RAM dan ROM pada komputer?',
    options: [
      'RAM lebih lambat dari ROM',
      'ROM dapat ditulis ulang, sedangkan RAM tidak bisa',
      'RAM bersifat sementara (hilang saat mati), '
          'sedangkan ROM bersifat permanen',
      'RAM digunakan untuk menyimpan sistem operasi secara permanen',
    ],
    correctIndex: 2,
    explanation:
        'RAM (Random Access Memory) adalah memori sementara yang digunakan '
        'saat komputer menyala dan akan hilang saat dimatikan. '
        'ROM (Read Only Memory) menyimpan data secara permanen seperti firmware BIOS.',
  ),
];
