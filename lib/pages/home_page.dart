import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../main.dart';
import '../utils/constants.dart';
import 'quiz_page.dart';

/// Halaman utama aplikasi Quizify
/// Menampilkan sambutan, logo, dan form untuk memulai kuis
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TextEditingController untuk mengelola input nama
  final TextEditingController _nameController = TextEditingController();

  // Menyimpan pesan error untuk ditampilkan di bawah TextField
  String? _nameError;

  /// Validasi nama pengguna sebelum memulai kuis
  /// Mengembalikan true jika valid, false jika tidak valid
  bool _validateName() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _nameError = AppConstants.nameValidationEmpty;
      });
      return false;
    }

    if (name.length < AppConstants.minUsernameLength) {
      setState(() {
        _nameError = AppConstants.nameValidationTooShort;
      });
      return false;
    }

    // Nama valid, hapus pesan error
    setState(() {
      _nameError = null;
    });
    return true;
  }

  /// Fungsi yang dipanggil ketika tombol Mulai Kuis ditekan
  void _startQuiz() {
    // Tutup keyboard jika masih terbuka
    FocusScope.of(context).unfocus();

    if (!_validateName()) {
      // Tampilkan SnackBar jika validasi gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                _nameError ?? 'Nama tidak boleh kosong',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Jika valid, inisialisasi QuizState lalu navigasi ke QuizPage
    final name = _nameController.text.trim();
    // Simpan nama ke QuizState agar bisa diakses di seluruh halaman
    QuizStateProvider.of(context).quizState.startQuiz(name);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(username: name),
      ),
    );
  }

  @override
  void dispose() {
    // Membersihkan controller saat widget di-dispose
    _nameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar untuk responsive design
    final size = MediaQuery.of(context).size;
    final provider = QuizStateProvider.of(context);
    final isDark = provider.themeMode == ThemeMode.dark;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Theme Toggle Switch di pojok kanan
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.wb_sunny_outlined,
                            size: 18,
                            color: isDark
                                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                                : Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Switch(
                            value: isDark,
                            onChanged: (_) => provider.toggleTheme(),
                            activeColor: Theme.of(context).colorScheme.primary,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.nightlight_outlined,
                            size: 18,
                            color: isDark
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: size.height * 0.04),
                
                // Logo/Icon Quiz
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.quiz_outlined,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Judul Aplikasi
                Text(
                  'Quizify',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  'Interactive Quiz App',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Teks Sambutan
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        size: 40,
                        color: Colors.amber.shade700,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Selamat Datang!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Uji pengetahuan Anda tentang komputer dan teknologi informasi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Info Jumlah Pertanyaan
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '10 Pertanyaan',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.timer_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tanpa Batas Waktu',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Input Nama Pengguna
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 8),
                      child: Text(
                        'Masukkan Nama Anda',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _nameController,
                      // Hapus error saat pengguna mulai mengetik
                      onChanged: (value) {
                        if (_nameError != null) {
                          setState(() {
                            _nameError = null;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Nama lengkap Anda',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: _nameError != null
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                        ),
                        // Menampilkan pesan error di bawah TextField
                        errorText: _nameError,
                        errorStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      // Memulai kuis saat pengguna tekan done di keyboard
                      onSubmitted: (_) => _startQuiz(),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Tombol Mulai Kuis — menggunakan CustomButton reusable widget
                CustomButton(
                  label: 'Mulai Kuis',
                  icon: Icons.play_arrow_rounded,
                  onPressed: _startQuiz,
                ),
                
                SizedBox(height: size.height * 0.08),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
