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

  /// Controller untuk animasi slide antar soal
  late PageController _pageController;

  // ─── Getter Helpers ────────────────────────────────────────────

  /// Pertanyaan yang sedang aktif
  Question get _currentQuestion => quizQuestions[_currentIndex];

  /// Jawaban pengguna untuk pertanyaan saat ini
  int get _currentAnswer => _userAnswers[_currentIndex];

  /// Apakah pertanyaan saat ini sudah dijawab
  bool get _isAnswered => _currentAnswer != -1;

  /// Apakah ini pertanyaan terakhir
  bool get _isLastQuestion => _currentIndex == quizQuestions.length - 1;

  /// Apakah ini pertanyaan pertama
  bool get _isFirstQuestion => _currentIndex == 0;

  /// Hitung soal yang sudah dijawab
  int get _answeredCount =>
      _userAnswers.where((answer) => answer != -1).length;

  /// Hitung soal yang belum dijawab
  int get _unansweredCount => quizQuestions.length - _answeredCount;

  /// Cek apakah semua soal sudah dijawab
  bool get _allAnswered => _unansweredCount == 0;

  @override
  void initState() {
    super.initState();
    // Inisialisasi semua jawaban dengan -1 (belum dijawab)
    _userAnswers = List.filled(quizQuestions.length, -1);
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ─── Navigation Methods ────────────────────────────────────────

  /// Simpan pilihan jawaban + haptic feedback
  void _selectAnswer(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _userAnswers[_currentIndex] = index;
    });
  }

  /// Pindah ke soal berikutnya
  /// Boleh maju hanya jika soal sudah dijawab (kecuali di soal terakhir)
  void _goToNext() {
    if (!_isAnswered) {
      // Tampilkan peringatan jika belum pilih jawaban
      _showMustAnswerSnackBar();
      return;
    }

    if (_isLastQuestion) {
      // Di soal terakhir — cek apakah masih ada soal yang belum dijawab
      if (!_allAnswered) {
        _showUnansweredDialog();
      } else {
        // Semua soal sudah dijawab → TODO: ke Result Page
        _showQuizCompleteSnackBar();
      }
    } else {
      // Pindah ke soal berikutnya dengan animasi slide
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Pindah ke soal sebelumnya (boleh tanpa jawab dulu)
  void _goToPrevious() {
    if (!_isFirstQuestion) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Lompat ke soal tertentu via dot indicator
  void _jumpToQuestion(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  // ─── Dialog & SnackBar ─────────────────────────────────────────

  /// SnackBar peringatan jika belum memilih jawaban
  void _showMustAnswerSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Pilih jawaban terlebih dahulu!',
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: Colors.orange.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Dialog konfirmasi jika ada soal yang belum dijawab saat klik Selesai
  void _showUnansweredDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Masih Ada Soal Belum Dijawab',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Ada $_unansweredCount soal yang belum dijawab. '
          'Apakah Anda ingin melanjutkan dan melewati soal tersebut?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
        actions: [
          // Kembali dan isi soal yang belum dijawab
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Lompat ke soal pertama yang belum dijawab
              final firstUnanswered =
                  _userAnswers.indexWhere((ans) => ans == -1);
              if (firstUnanswered != -1) {
                _jumpToQuestion(firstUnanswered);
              }
            },
            child: Text(
              'Kembali',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          // Tetap selesaikan kuis meskipun ada yang belum dijawab
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showQuizCompleteSnackBar();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Selesaikan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// SnackBar sementara saat kuis selesai (akan diganti navigasi Result Page)
  void _showQuizCompleteSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Kuis selesai! Result page segera hadir.',
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Header progress
            _buildHeader(),

            // Konten soal — gunakan PageView untuk swipe & animasi
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                // Nonaktifkan swipe agar pengguna tidak skip soal
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quizQuestions.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          size.width > 600 ? size.width * 0.1 : 20,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card pertanyaan
                        _buildQuestionCard(),

                        const SizedBox(height: 20),

                        // Label pilih jawaban
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

                        // 4 pilihan jawaban
                        _buildAnswerOptions(index),

                        const SizedBox(height: 16),

                        // Dot indicator
                        _buildQuestionDots(),

                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Footer tombol navigasi
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  // ─── Widget Builders ───────────────────────────────────────────

  /// AppBar dengan nama, progress info, dan tombol keluar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
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
                Text(
                  '$_answeredCount dari ${quizQuestions.length} dijawab',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Tombol keluar — dialog konfirmasi ditambahkan di commit 17
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: Colors.grey.shade600),
          tooltip: 'Keluar',
        ),
      ],
    );
  }

  /// Header: label nomor soal + progress bar + persentase
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
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
          // Progress bar dengan animasi tween
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
                    Colors.deepPurple),
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

  /// 4 pilihan jawaban untuk soal dengan index tertentu
  /// Menerima [questionIndex] agar PageView tiap soal punya state sendiri
  Widget _buildAnswerOptions(int questionIndex) {
    const optionLabels = ['A', 'B', 'C', 'D'];
    final question = quizQuestions[questionIndex];
    final selectedAnswer = _userAnswers[questionIndex];

    return Column(
      children: List.generate(
        question.options.length,
        (index) => AnswerOption(
          label: optionLabels[index],
          text: question.options[index],
          isSelected: selectedAnswer == index,
          onTap: () => _selectAnswer(index),
        ),
      ),
    );
  }

  /// Dot indicator: overview semua soal
  /// Abu = belum dijawab, ungu = sudah dijawab, panjang = soal aktif
  Widget _buildQuestionDots() {
    return Center(
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: List.generate(quizQuestions.length, (index) {
          final isActive = index == _currentIndex;
          final isAnswered = _userAnswers[index] != -1;

          return GestureDetector(
            onTap: () => _jumpToQuestion(index),
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
        }),
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
          // Tombol Sebelumnya — hanya muncul jika bukan soal pertama
          if (!_isFirstQuestion) ...[
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

          // Tombol Selanjutnya / Selesai
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _goToNext,
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
