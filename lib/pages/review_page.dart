import 'package:flutter/material.dart';
import '../data/questions.dart';
import '../models/question.dart';
import '../widgets/answer_option.dart';
import '../main.dart';
import '../utils/responsive_helper.dart';

/// Halaman review jawaban — menampilkan semua soal dengan jawaban user,
/// jawaban yang benar, dan penjelasan untuk setiap soal.
class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final quizState = QuizStateProvider.of(context).quizState;

    return Scaffold(
      appBar: _buildAppBar(context, quizState),
      body: SafeArea(
        child: ResponsiveHelper.centerWithMaxWidth(
          context: context,
          maxWidth: 900,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.horizontalPadding(context),
              vertical: ResponsiveHelper.verticalPadding(context),
            ),
            itemCount: quizQuestions.length,
            itemBuilder: (context, index) {
              return _buildQuestionReviewCard(
                index,
                quizQuestions[index],
                quizState.getAnswerFor(index),
                context,
              );
            },
          ),
        ),
      ),
    );
  }

  // ─── AppBar ────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context, QuizState quizState) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Jawaban',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            '${quizState.correctCount} benar • ${quizState.wrongCount} salah',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  // ─── Question Review Card ──────────────────────────────────────

  Widget _buildQuestionReviewCard(
    int index,
    Question question,
    int userAnswer,
    BuildContext context,
  ) {
    final isCorrect = question.isCorrect(userAnswer);
    const optionLabels = ['A', 'B', 'C', 'D'];

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.spacing(context)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan nomor soal dan status
          _buildQuestionHeader(index, isCorrect),

          // Pertanyaan
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Text(
              question.question,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.5,
              ),
            ),
          ),

          // Pilihan jawaban
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              children: List.generate(
                question.options.length,
                (optionIndex) {
                  final isUserAnswer = userAnswer == optionIndex;
                  final isCorrectAnswer = question.correctIndex == optionIndex;

                  return AnswerOption(
                    label: optionLabels[optionIndex],
                    text: question.options[optionIndex],
                    isSelected: isUserAnswer,
                    mode: AnswerMode.reviewing,
                    isCorrect: isCorrectAnswer,
                    onTap: () {}, // Tidak ada aksi saat review
                  );
                },
              ),
            ),
          ),

          // Penjelasan (jika ada)
          if (question.explanation != null && question.explanation!.isNotEmpty)
            _buildExplanationSection(question.explanation!, isCorrect),

          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // ─── Question Header ───────────────────────────────────────────

  Widget _buildQuestionHeader(int index, bool isCorrect) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isCorrect
            ? Colors.green.shade50
            : Colors.red.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isCorrect ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Soal ${index + 1}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            isCorrect ? 'Benar' : 'Salah',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Explanation Section ───────────────────────────────────────

  Widget _buildExplanationSection(String explanation, bool isCorrect) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect
            ? Colors.green.shade50
            : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect
              ? Colors.green.shade200
              : Colors.orange.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: isCorrect ? Colors.green.shade700 : Colors.orange.shade700,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Penjelasan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isCorrect
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  explanation,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
