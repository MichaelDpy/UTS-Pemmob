import 'package:flutter/material.dart';

/// Halaman utama aplikasi Quizify
/// Menampilkan sambutan, logo, dan form untuk memulai kuis
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar untuk responsive design
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.08),
                
                // Logo/Icon Quiz
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.quiz_outlined,
                    size: 60,
                    color: Colors.deepPurple,
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
                    color: Colors.deepPurple,
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
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Teks Sambutan
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
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
                          color: Colors.deepPurple.shade700,
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
                          color: Colors.grey.shade700,
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
                      color: Colors.deepPurple,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '10 Pertanyaan',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.timer_outlined,
                      color: Colors.deepPurple,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tanpa Batas Waktu',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
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
