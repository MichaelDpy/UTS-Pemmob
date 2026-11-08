import 'package:flutter/material.dart';
import '../data/questions.dart';
import '../utils/constants.dart';

/// Menyimpan seluruh state kuis yang perlu dipertahankan
/// saat rotasi layar atau navigasi antarhalaman.
///
/// Menggunakan ChangeNotifier agar widget yang bergantung
/// dapat diperbarui secara otomatis saat state berubah.
class QuizState extends ChangeNotifier {
  // ─── State Data ────────────────────────────────────────────────

  /// Nama pengguna yang diinput di HomePage
  String _username = '';

  /// Indeks soal yang sedang aktif (0–9)
  int _currentIndex = 0;

  /// Jawaban pengguna: -1 = belum dijawab, 0–3 = pilihan dipilih
  late List<int> _userAnswers;

  /// Apakah sesi kuis sedang aktif
  bool _isQuizActive = false;

  // ─── Constructor ───────────────────────────────────────────────

  QuizState() {
    // Inisialisasi jawaban kosong untuk semua soal
    _userAnswers = List.filled(quizQuestions.length, -1);
  }

  // ─── Getters ───────────────────────────────────────────────────

  String get username => _username;
  int get currentIndex => _currentIndex;
  List<int> get userAnswers => List.unmodifiable(_userAnswers);
  bool get isQuizActive => _isQuizActive;

  /// Jawaban untuk soal tertentu
  int getAnswerFor(int index) => _userAnswers[index];

  /// Jawaban untuk soal yang sedang aktif
  int get currentAnswer => _userAnswers[_currentIndex];

  /// Apakah soal aktif sudah dijawab
  bool get isCurrentAnswered => currentAnswer != -1;

  /// Apakah soal aktif adalah soal terakhir
  bool get isLastQuestion => _currentIndex == quizQuestions.length - 1;

  /// Apakah soal aktif adalah soal pertama
  bool get isFirstQuestion => _currentIndex == 0;

  /// Jumlah soal yang sudah dijawab
  int get answeredCount =>
      _userAnswers.where((a) => a != -1).length;

  /// Jumlah soal yang belum dijawab
  int get unansweredCount => quizQuestions.length - answeredCount;

  /// Apakah semua soal sudah dijawab
  bool get allAnswered => unansweredCount == 0;

  /// Hitung skor akhir (0–100)
  int get finalScore {
    int correct = 0;
    for (int i = 0; i < quizQuestions.length; i++) {
      if (_userAnswers[i] == quizQuestions[i].correctIndex) {
        correct++;
      }
    }
    return (correct / quizQuestions.length * 100).round();
  }

  /// Hitung jumlah jawaban benar
  int get correctCount {
    int count = 0;
    for (int i = 0; i < quizQuestions.length; i++) {
      if (_userAnswers[i] == quizQuestions[i].correctIndex) count++;
    }
    return count;
  }

  /// Hitung jumlah jawaban salah (soal yang dijawab tapi salah)
  int get wrongCount {
    int count = 0;
    for (int i = 0; i < quizQuestions.length; i++) {
      if (_userAnswers[i] != -1 &&
          _userAnswers[i] != quizQuestions[i].correctIndex) {
        count++;
      }
    }
    return count;
  }

  // ─── Methods ───────────────────────────────────────────────────

  /// Mulai kuis baru dengan nama pengguna
  void startQuiz(String name) {
    _username = name.trim();
    _currentIndex = 0;
    _userAnswers = List.filled(quizQuestions.length, -1);
    _isQuizActive = true;
    notifyListeners();
  }

  /// Simpan jawaban untuk soal yang aktif
  void selectAnswer(int answerIndex) {
    // Validasi answer index
    if (answerIndex < 0 || answerIndex >= 4) {
      return; // Invalid answer index
    }
    _userAnswers[_currentIndex] = answerIndex;
    notifyListeners();
  }

  /// Pindah ke soal berikutnya
  void goToNext() {
    if (!isLastQuestion) {
      _currentIndex++;
      notifyListeners();
    }
  }

  /// Pindah ke soal sebelumnya
  void goToPrevious() {
    if (!isFirstQuestion) {
      _currentIndex--;
      notifyListeners();
    }
  }

  /// Lompat ke soal tertentu
  void jumpToQuestion(int index) {
    // Validasi index
    if (index < 0 || index >= quizQuestions.length) {
      return; // Invalid index, do nothing
    }
    _currentIndex = index;
    notifyListeners();
  }

  /// Reset seluruh state kuis (untuk Ulangi Kuis)
  void resetQuiz() {
    _username = '';
    _currentIndex = 0;
    _userAnswers = List.filled(quizQuestions.length, -1);
    _isQuizActive = false;
    notifyListeners();
  }
}
