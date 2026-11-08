import 'package:flutter/material.dart';

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
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Nama lengkap Anda',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade400,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.deepPurple,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Tombol Mulai Kuis (temporary - akan diganti dengan CustomButton nanti)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implementasi navigasi ke Quiz Page
                      // Untuk sementara hanya print nama
                      print('Nama: ${_nameController.text}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: Colors.deepPurple.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Mulai Kuis',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
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
