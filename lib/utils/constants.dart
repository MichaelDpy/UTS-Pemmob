/// Constants untuk aplikasi Quizify.
/// Menyimpan semua nilai konstan yang digunakan di berbagai tempat.
class AppConstants {
  // ─── App Info ──────────────────────────────────────────────────
  
  static const String appName = 'Quizify';
  static const String appSubtitle = 'Interactive Quiz App';
  static const String appVersion = '1.0.0';

  // ─── Quiz Settings ─────────────────────────────────────────────
  
  static const int totalQuestions = 10;
  static const int minUsernameLength = 2;
  static const int maxUsernameLength = 50;
  static const int passingScore = 60; // Minimum score untuk "lulus"

  // ─── UI Constants ──────────────────────────────────────────────
  
  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 20.0;

  // Padding & Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // Avatar Sizes
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeLarge = 64.0;

  // Button Heights
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightMedium = 50.0;
  static const double buttonHeightLarge = 56.0;

  // Animation Durations (in milliseconds)
  static const int animationFast = 200;
  static const int animationNormal = 300;
  static const int animationSlow = 400;

  // ─── Score Messages ────────────────────────────────────────────
  
  static const String scoreExcellent = 'Luar Biasa! 🎉';
  static const String scoreGood = 'Bagus Sekali! 👏';
  static const String scoreFair = 'Cukup Baik! 😊';
  static const String scorePoor = 'Lumayan! 💪';
  static const String scoreFail = 'Terus Belajar! 📚';

  // ─── Messages ──────────────────────────────────────────────────
  
  static const String welcomeMessage = 
      'Uji pengetahuan Anda tentang komputer dan teknologi informasi';
  
  static const String quizInfo = '10 Pertanyaan • Tanpa Batas Waktu';
  
  static const String nameValidationEmpty = 'Nama tidak boleh kosong';
  static const String nameValidationTooShort = 'Nama minimal 2 karakter';
  
  static const String mustAnswerMessage = 'Pilih jawaban terlebih dahulu!';
  static const String exitConfirmMessage = 
      'Progress kuis Anda akan hilang jika keluar sekarang. Apakah Anda yakin ingin keluar?';
  
  static const String unansweredQuestionsMessage = 
      'Ada %d soal yang belum dijawab. Apakah Anda ingin melanjutkan?';

  // ─── Button Labels ─────────────────────────────────────────────
  
  static const String buttonStart = 'Mulai Kuis';
  static const String buttonNext = 'Selanjutnya';
  static const String buttonPrevious = 'Sebelumnya';
  static const String buttonFinish = 'Selesai';
  static const String buttonReview = 'Review Jawaban';
  static const String buttonRetry = 'Ulangi Kuis';
  static const String buttonHome = 'Kembali ke Home';
  static const String buttonContinue = 'Lanjut Kuis';
  static const String buttonExit = 'Ya, Keluar';
  static const String buttonBack = 'Kembali';

  // ─── Labels ────────────────────────────────────────────────────
  
  static const String labelUsername = 'Masukkan Nama Anda';
  static const String labelUsernamePlaceholder = 'Nama lengkap Anda';
  static const String labelQuestions = 'Pertanyaan';
  static const String labelNoTimeLimit = 'Tanpa Batas Waktu';
  static const String labelCorrect = 'Benar';
  static const String labelWrong = 'Salah';
  static const String labelAccuracy = 'Akurasi';
  static const String labelAnswered = 'Dijawab';
  static const String labelUnanswered = 'Belum';
  static const String labelExplanation = 'Penjelasan';

  // ─── Performance ───────────────────────────────────────────────
  
  // Cache sizes
  static const int maxCacheSize = 50;
  
  // Scroll physics
  static const double scrollPhysicsSpring = 0.5;
  static const double scrollPhysicsDamping = 0.9;
}
