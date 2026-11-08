import 'package:flutter/material.dart';
import '../data/questions.dart';
import '../main.dart';
import '../state/quiz_state.dart';
import '../widgets/custom_button.dart';
import '../utils/responsive_helper.dart';
import 'home_page.dart';
import 'quiz_page.dart';
import 'review_page.dart';

/// Halaman hasil kuis — menampilkan skor, statistik, dan pesan.
/// Menggunakan data dari QuizState melalui QuizStateProvider.
class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  /// Menentukan pesan motivasi berdasarkan skor
  String _getScoreMessage(int score) {
    if (score >= 90) return 'Luar Biasa! 🎉';
    if (score >= 80) return 'Bagus Sekali! 👏';
    if (score >= 70) return 'Cukup Baik! 😊';
    if (score >= 60) return 'Lumayan! 💪';
    return 'Terus Belajar! 📚';
  }

  /// Menentukan warna berdasarkan skor
  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green.shade600;
    if (score >= 60) return Colors.orange.shade600;
    return Colors.red.shade500;
  }

  /// Menentukan ikon berdasarkan skor
  IconData _getScoreIcon(int score) {
    if (score >= 80) return Icons.emoji_events;
    if (score >= 60) return Icons.thumb_up_outlined;
    return Icons.school_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final quizState = QuizStateProvider.of(context).quizState;

    // Ambil semua data dari QuizState
    final score = quizState.finalScore;
    final correct = quizState.correctCount;
    final wrong = quizState.wrongCount;
    final total = quizQuestions.length;
    final username = quizState.username;
    final percentage = (correct / total * 100).toStringAsFixed(1);
    final scoreColor = _getScoreColor(score);

    return Scaffold(
      // PopScope mencegah tombol Back fisik kembali ke QuizPage
      body: PopScope(
        canPop: false,
        child: SafeArea(
          child: ResponsiveHelper.centerWithMaxWidth(
            context: context,
            maxWidth: 800,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.horizontalPadding(context),
                vertical: ResponsiveHelper.verticalPadding(context),
              ),
              child: Column(
                children: [
                  // Header
                  _buildHeader(username),

                  SizedBox(height: ResponsiveHelper.spacing(context) * 2),

                  // Lingkaran skor besar
                  _buildScoreCircle(score, scoreColor),

                  SizedBox(height: ResponsiveHelper.spacing(context) * 2),

                  // 3 card statistik
                  _buildStatsRow(correct, wrong, percentage, context),

                  SizedBox(height: ResponsiveHelper.spacing(context) * 1.5),

                  // Pesan detail
                  _buildDetailMessage(score),

                  SizedBox(height: ResponsiveHelper.spacing(context) * 2),

                  // Tombol-tombol aksi
                  _buildActionButtons(context, quizState),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Widget Builders ───────────────────────────────────────────

  Widget _buildHeader(String username) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.assignment_turned_in_outlined,
            color: Colors.deepPurple,
            size: 28,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hasil Kuis',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            Text(
              'Halo, $username!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreCircle(int score, Color scoreColor) {
    final message = _getScoreMessage(score);
    final icon = _getScoreIcon(score);

    return Column(
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scoreColor.withValues(alpha: 0.1),
            border: Border.all(color: scoreColor, width: 4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: scoreColor),
              const SizedBox(height: 4),
              Text(
                '$score',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: scoreColor,
                  height: 1,
                ),
              ),
              Text(
                'dari 100',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: scoreColor.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: scoreColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(int correct, int wrong, String percentage, BuildContext context) {
    // Untuk mobile: vertical stack, tablet+: horizontal row
    if (ResponsiveHelper.isMobile(context) && ResponsiveHelper.isPortrait(context)) {
      return Column(
        children: [
          _buildStatCard(
            label: 'Benar',
            value: '$correct',
            icon: Icons.check_circle_outline,
            color: Colors.green.shade600,
            context: context,
          ),
          SizedBox(height: ResponsiveHelper.spacing(context)),
          _buildStatCard(
            label: 'Salah',
            value: '$wrong',
            icon: Icons.cancel_outlined,
            color: Colors.red.shade500,
            context: context,
          ),
          SizedBox(height: ResponsiveHelper.spacing(context)),
          _buildStatCard(
            label: 'Akurasi',
            value: '$percentage%',
            icon: Icons.percent,
            color: Colors.blue.shade600,
            context: context,
          ),
        ],
      );
    }
    
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            label: 'Benar',
            value: '$correct',
            icon: Icons.check_circle_outline,
            color: Colors.green.shade600,
            context: context,
          ),
        ),
        SizedBox(width: ResponsiveHelper.spacing(context)),
        Expanded(
          child: _buildStatCard(
            label: 'Salah',
            value: '$wrong',
            icon: Icons.cancel_outlined,
            color: Colors.red.shade500,
            context: context,
          ),
        ),
        SizedBox(width: ResponsiveHelper.spacing(context)),
        Expanded(
          child: _buildStatCard(
            label: 'Akurasi',
            value: '$percentage%',
            icon: Icons.percent,
            color: Colors.blue.shade600,
            context: context,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.cardPadding(context),
        horizontal: ResponsiveHelper.cardPadding(context) * 0.6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailMessage(int score) {
    String detail;
    if (score >= 90) {
      detail = 'Pengetahuan Anda tentang komputer dan TI sangat baik! '
          'Pertahankan semangat belajar ini.';
    } else if (score >= 80) {
      detail = 'Anda menguasai sebagian besar materi dengan baik. '
          'Sedikit lagi menuju sempurna!';
    } else if (score >= 70) {
      detail = 'Hasil yang cukup baik! Pelajari kembali soal yang '
          'belum terjawab dengan benar.';
    } else if (score >= 60) {
      detail = 'Anda sudah setengah jalan. Tinjau kembali materi '
          'dan coba lagi untuk hasil lebih baik.';
    } else {
      detail = 'Jangan menyerah! Pelajari materi dasar komputer dan TI, '
          'lalu coba kuis ini kembali.';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.deepPurple.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline,
              color: Colors.deepPurple.shade400, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              detail,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, QuizState quizState) {
    return Column(
      children: [
        // Tombol Review Jawaban
        CustomButton(
          label: 'Review Jawaban',
          icon: Icons.rate_review_outlined,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReviewPage(),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        // Tombol Ulangi Kuis — reset state & kembali ke QuizPage
        CustomButton(
          label: 'Ulangi Kuis',
          icon: Icons.refresh_rounded,
          type: ButtonType.secondary,
          color: Colors.deepPurple,
          onPressed: () {
            // Mulai ulang kuis dengan nama yang sama
            quizState.startQuiz(quizState.username);
            // pushReplacement: ganti ResultPage dengan QuizPage
            // (tidak menambah ke stack)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    QuizPage(username: quizState.username),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        // Tombol Kembali ke Home — bersihkan seluruh stack navigasi
        CustomButton(
          label: 'Kembali ke Home',
          icon: Icons.home_outlined,
          type: ButtonType.secondary,
          color: Colors.grey.shade700,
          onPressed: () {
            quizState.resetQuiz();
            // pushAndRemoveUntil: hapus semua route, mulai fresh dari Home
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}
