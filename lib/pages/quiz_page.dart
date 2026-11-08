import 'package:flutter/material.dart';
import '../data/questions.dart';
import '../models/question.dart';

/// Halaman utama kuis tempat pengguna menjawab pertanyaan satu per satu.
/// Menerima nama pengguna dari HomePage.
class QuizPage extends StatefulWidget {
  /// Nama pengguna yang diinput di HomePage
  final String username;

  const QuizPage({super.key, required this.username});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // ─── State Variables ───────────────────────────────────────────
  
  /// Indeks pertanyaan yang sedang ditampilkan (0–9)
  int _currentIndex = 0;

  /// List jawaban pengguna untuk setiap pertanyaan.
  /// Nilai -1 = belum dijawab, 0–3 = indeks pilihan yang dipilih
  late List<int> _userAnswers;

  // ─── Getter Helpers ────────────────────────────────────────────

  /// Pertanyaan yang sedang aktif
  Question get _currentQuestion => quizQuestions[_currentIndex];

  /// Jawaban pengguna untuk pertanyaan saat ini
  int get _currentAnswer => _userAnswers[_currentIndex];

  /// Apakah pertanyaan saat ini sudah dijawab
  bool get _isAnswered => _currentAnswer != -1;

  /// Apakah ini pertanyaan terakhir
  bool get _isLastQuestion => _currentIndex == quizQuestions.length - 1;

  @override
  void initState() {
    super.initState();
    // Inisialisasi list jawaban dengan -1 (belum dijawab) untuk semua soal
    _userAnswers = List.filled(quizQuestions.length, -1);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar dengan nama pengguna dan tombol keluar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.deepPurple.shade100,
              child: Text(
                // Ambil huruf pertama nama sebagai avatar
                widget.username.isNotEmpty
                    ? widget.username[0].toUpperCase()
                    : 'Q',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.username,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Tombol keluar sementara (dialog akan ditambahkan di commit 17)
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: Colors.grey.shade600),
            tooltip: 'Keluar',
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ── Header: Nomor Soal & Progress ──────────────────
            _buildHeader(),

            // ── Konten Utama: Pertanyaan & Pilihan ─────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width > 600 ? size.width * 0.1 : 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nomor dan teks pertanyaan
                    _buildQuestionCard(),

                    const SizedBox(height: 24),

                    // Empat pilihan jawaban
                    _buildAnswerOptions(),
                  ],
                ),
              ),
            ),

            // ── Footer: Tombol Navigasi ─────────────────────────
            _buildNavigationButtons(size),
          ],
        ),
      ),
    );
  }

  // ─── Widget Builders ───────────────────────────────────────────

  /// Header yang menampilkan nomor soal dan progress bar
  Widget _buildHeader() {
    final progress = (_currentIndex + 1) / quizQuestions.length;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Label nomor soal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pertanyaan ${_currentIndex + 1} dari ${quizQuestions.length}',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              // Badge persentase progress
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ),
          ),
        ],
      ),
    );
  }

  /// Card pertanyaan
  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.deepPurple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge kategori soal
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Soal ${_currentIndex + 1}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Teks pertanyaan
          Text(
            _currentQuestion.question,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Daftar 4 pilihan jawaban (sementara — akan diganti AnswerOption widget)
  Widget _buildAnswerOptions() {
    return Column(
      children: List.generate(
        _currentQuestion.options.length,
        (index) => _buildAnswerItem(index),
      ),
    );
  }

  /// Satu item pilihan jawaban
  Widget _buildAnswerItem(int index) {
    // Tentukan warna berdasarkan status pilihan
    final isSelected = _currentAnswer == index;
    final optionLabels = ['A', 'B', 'C', 'D'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _userAnswers[_currentIndex] = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.grey.shade200,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.deepPurple.withOpacity(0.2)
                  : Colors.grey.shade100,
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Label A, B, C, D
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  optionLabels[index],
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.deepPurple,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Teks pilihan
            Expanded(
              child: Text(
                _currentQuestion.options[index],
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : Colors.grey.shade800,
                  height: 1.4,
                ),
              ),
            ),
            // Ikon centang jika dipilih
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  /// Footer berisi tombol Sebelumnya dan Selanjutnya/Selesai
  Widget _buildNavigationButtons(Size size) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Tombol Sebelumnya (hanya muncul bukan di soal pertama)
          if (_currentIndex > 0)
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentIndex--;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                  side: BorderSide(
                    color: Colors.deepPurple.shade200,
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_ios, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Sebelumnya',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (_currentIndex > 0) const SizedBox(width: 12),

          // Tombol Selanjutnya atau Selesai
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                if (!_isAnswered) {
                  // Validasi: harus pilih jawaban dulu
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.white),
                          SizedBox(width: 12),
                          Text(
                            'Pilih jawaban terlebih dahulu!',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.orange.shade700,
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
                if (_isLastQuestion) {
                  // TODO: Navigasi ke Result Page (commit 16)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Kuis selesai! Result page akan segera dibuat.',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      backgroundColor: Colors.green.shade700,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                } else {
                  setState(() {
                    _currentIndex++;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isLastQuestion
                    ? Colors.green.shade600
                    : Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLastQuestion ? 'Selesai' : 'Selanjutnya',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _isLastQuestion
                        ? Icons.check_circle_outline
                        : Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
