import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/questions.dart';
import '../models/question.dart';
import '../widgets/answer_option.dart';

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

  /// Controller untuk scroll otomatis ke atas saat ganti soal
  final ScrollController _scrollController = ScrollController();

  // ─── Getter Helpers ────────────────────────────────────────────

  /// Pertanyaan yang sedang aktif
  Question get _currentQuestion => quizQuestions[_currentIndex];

  /// Jawaban pengguna untuk pertanyaan saat ini
  int get _currentAnswer => _userAnswers[_currentIndex];

  /// Apakah pertanyaan saat ini sudah dijawab
  bool get _isAnswered => _currentAnswer != -1;

  /// Apakah ini pertanyaan terakhir
  bool get _isLastQuestion => _currentIndex == quizQuestions.length - 1;

  /// Hitung jumlah soal yang sudah dijawab
  int get _answeredCount =>
      _userAnswers.where((answer) => answer != -1).length;

  @override
  void initState() {
    super.initState();
    // Inisialisasi semua jawaban dengan -1 (belum dijawab)
    _userAnswers = List.filled(quizQuestions.length, -1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Scroll konten ke atas saat berpindah ke soal baru
  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Simpan pilihan jawaban pengguna
  void _selectAnswer(int index) {
    // Haptic feedback ringan saat memilih jawaban
    HapticFeedback.selectionClick();
    setState(() {
      _userAnswers[_currentIndex] = index;
    });
  }

  /// Pindah ke soal berikutnya dengan validasi
  void _goToNext() {
    if (!_isAnswered) {
      ScaffoldMessenger.of(context).clearSnackBars();
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
      // TODO: Navigasi ke Result Page (commit 18-19)
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
      _scrollToTop();
    }
  }

  /// Pindah ke soal sebelumnya
  void _goToPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _scrollToTop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Avatar huruf pertama nama
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.deepPurple.shade100,
              child: Text(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  // Info progress: "X dari 10 dijawab"
                  Text(
                    '$_answeredCount dari ${quizQuestions.length} dijawab',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Tombol keluar (dialog akan ditambahkan di commit 17)
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
            // Header: progress bar & nomor soal
            _buildHeader(),

            // Konten utama: pertanyaan & pilihan jawaban
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: size.width > 600 ? size.width * 0.1 : 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card pertanyaan
                    _buildQuestionCard(),

                    const SizedBox(height: 20),

                    // Label "Pilih jawaban:"
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        'Pilih jawaban:',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),

                    // Empat pilihan jawaban
                    _buildAnswerOptions(),

                    // Indikator dot soal (overview semua soal)
                    const SizedBox(height: 16),
                    _buildQuestionDots(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // Footer: tombol navigasi
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  // ─── Widget Builders ───────────────────────────────────────────

  /// Header: nomor soal + progress bar + persentase
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
          // Progress bar dengan animasi
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 400),
            builder: (context, value, _) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.deepPurple,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Card pertanyaan dengan gradient ungu
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
          // Badge nomor soal
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

  /// 4 pilihan jawaban menggunakan AnswerOption widget
  Widget _buildAnswerOptions() {
    const optionLabels = ['A', 'B', 'C', 'D'];
    return Column(
      children: List.generate(
        _currentQuestion.options.length,
        (index) => AnswerOption(
          label: optionLabels[index],
          text: _currentQuestion.options[index],
          isSelected: _currentAnswer == index,
          onTap: () => _selectAnswer(index),
        ),
      ),
    );
  }

  /// Indikator dot untuk overview semua soal.
  /// Dot penuh = sudah dijawab, dot kosong = belum dijawab, dot garis = aktif.
  Widget _buildQuestionDots() {
    return Center(
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: List.generate(
          quizQuestions.length,
          (index) {
            final isActive = index == _currentIndex;
            final isAnswered = _userAnswers[index] != -1;

            return GestureDetector(
              // Tap dot untuk lompat ke soal tersebut
              onTap: () {
                setState(() {
                  _currentIndex = index;
                });
                _scrollToTop();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isActive ? 24 : 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.deepPurple
                      : isAnswered
                          ? Colors.deepPurple.shade300
                          : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Footer: tombol Sebelumnya & Selanjutnya/Selesai
  Widget _buildNavigationButtons() {
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
          // Tombol Sebelumnya (hanya muncul jika bukan soal pertama)
          if (_currentIndex > 0) ...[
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: _goToPrevious,
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
            const SizedBox(width: 12),
          ],

          // Tombol Selanjutnya atau Selesai
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _goToNext,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isLastQuestion ? Colors.green.shade600 : Colors.deepPurple,
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
