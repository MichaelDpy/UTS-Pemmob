import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/questions.dart';
import '../models/question.dart';
import '../widgets/answer_option.dart';
import '../main.dart';
import 'result_page.dart';

/// Halaman kuis — menampilkan pertanyaan satu per satu.
/// State kuis dikelola oleh QuizState yang hidup di MyApp,
/// sehingga tidak hilang saat rotasi atau navigasi.
class QuizPage extends StatefulWidget {
  final String username;
  const QuizPage({super.key, required this.username});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // PageController untuk animasi slide antar soal
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi PageController sesuai posisi soal terakhir
    // agar saat rotasi, kembali ke soal yang sama
    final quizState = QuizStateProvider.of(context).quizState;
    _pageController = PageController(initialPage: quizState.currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ─── Navigation Methods ────────────────────────────────────────

  void _selectAnswer(int index) {
    HapticFeedback.selectionClick();
    final quizState = QuizStateProvider.of(context).quizState;
    quizState.selectAnswer(index);
    // Panggil setState agar UI quiz_page ikut update
    setState(() {});
  }

  void _goToNext() {
    final quizState = QuizStateProvider.of(context).quizState;

    if (!quizState.isCurrentAnswered) {
      _showMustAnswerSnackBar();
      return;
    }

    if (quizState.isLastQuestion) {
      if (!quizState.allAnswered) {
        _showUnansweredDialog(quizState);
      } else {
        // Navigasi ke ResultPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(username: widget.username),
          ),
        );
      }
    } else {
      quizState.goToNext();
      setState(() {});
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPrevious() {
    final quizState = QuizStateProvider.of(context).quizState;
    if (!quizState.isFirstQuestion) {
      quizState.goToPrevious();
      setState(() {});
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _jumpToQuestion(int index) {
    final quizState = QuizStateProvider.of(context).quizState;
    quizState.jumpToQuestion(index);
    setState(() {});
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  // ─── Dialogs & SnackBars ───────────────────────────────────────

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
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
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
  }

  void _showUnansweredDialog(QuizState quizState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Masih Ada Soal Belum Dijawab',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Ada ${quizState.unansweredCount} soal yang belum dijawab. '
          'Apakah Anda ingin melanjutkan?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Lompat ke soal pertama yang belum dijawab
              final idx = quizState.userAnswers.indexWhere((a) => a == -1);
              if (idx != -1) _jumpToQuestion(idx);
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
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Navigasi ke ResultPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultPage(username: widget.username),
                ),
              );
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

  void _showQuizCompleteSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Kuis selesai! Result page segera hadir.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final quizState = QuizStateProvider.of(context).quizState;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(quizState),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(quizState),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quizQuestions.length,
                onPageChanged: (index) {
                  quizState.jumpToQuestion(index);
                  setState(() {});
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
                        _buildQuestionCard(quizState),
                        const SizedBox(height: 20),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 4, bottom: 12),
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
                        _buildAnswerOptions(index, quizState),
                        const SizedBox(height: 16),
                        _buildQuestionDots(quizState),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildNavigationButtons(quizState),
          ],
        ),
      ),
    );
  }

  // ─── Widget Builders ───────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(QuizState quizState) {
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
                  '${quizState.answeredCount} dari ${quizQuestions.length} dijawab',
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
        // Tombol keluar — dialog konfirmasi di commit 17
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: Colors.grey.shade600),
          tooltip: 'Keluar',
        ),
      ],
    );
  }

  Widget _buildHeader(QuizState quizState) {
    final progress =
        (quizState.currentIndex + 1) / quizQuestions.length;
    final answeredProgress =
        quizState.answeredCount / quizQuestions.length;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Soal ',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    TextSpan(
                      text: '${quizState.currentIndex + 1}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    TextSpan(
                      text: ' / ${quizQuestions.length}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatChip(
                  icon: Icons.check_circle_outline,
                  label: 'Dijawab',
                  value: quizState.answeredCount,
                  color: Colors.green.shade600,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatChip(
                  icon: Icons.radio_button_unchecked,
                  label: 'Belum',
                  value: quizState.unansweredCount,
                  color: Colors.orange.shade600,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAnsweredProgressChip(
                    answeredProgress, quizState.answeredCount),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            '$value',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: color.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnsweredProgressChip(
      double answeredProgress, int answeredCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.deepPurple.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${(answeredCount / quizQuestions.length * 100).toInt()}% selesai',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.deepPurple.shade700,
            ),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: answeredProgress,
              minHeight: 4,
              backgroundColor: Colors.deepPurple.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.deepPurple.shade400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuizState quizState) {
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
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Soal ${quizState.currentIndex + 1}',
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
            quizQuestions[quizState.currentIndex].question,
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

  Widget _buildAnswerOptions(int questionIndex, QuizState quizState) {
    const optionLabels = ['A', 'B', 'C', 'D'];
    final question = quizQuestions[questionIndex];
    final selectedAnswer = quizState.getAnswerFor(questionIndex);

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

  Widget _buildQuestionDots(QuizState quizState) {
    return Center(
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: List.generate(quizQuestions.length, (index) {
          final isActive = index == quizState.currentIndex;
          final isAnswered = quizState.getAnswerFor(index) != -1;

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

  Widget _buildNavigationButtons(QuizState quizState) {
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
          if (!quizState.isFirstQuestion) ...[
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: _goToPrevious,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                  side: BorderSide(
                      color: Colors.deepPurple.shade200, width: 1.5),
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
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _goToNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: quizState.isLastQuestion
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
                    quizState.isLastQuestion ? 'Selesai' : 'Selanjutnya',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    quizState.isLastQuestion
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
