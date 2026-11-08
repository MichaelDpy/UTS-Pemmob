/// Model data untuk satu pertanyaan kuis.
/// Setiap pertanyaan memiliki teks, 4 pilihan jawaban, dan indeks jawaban benar.
class Question {
  /// Teks pertanyaan yang ditampilkan ke pengguna
  final String question;

  /// Daftar 4 pilihan jawaban (indeks 0–3)
  final List<String> options;

  /// Indeks jawaban yang benar di dalam list options (0–3)
  final int correctIndex;

  /// Penjelasan singkat mengapa jawaban tersebut benar (opsional)
  final String? explanation;

  const Question({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });

  /// Mengecek apakah jawaban yang dipilih pengguna benar
  /// [selectedIndex] adalah indeks pilihan yang dipilih pengguna
  bool isCorrect(int selectedIndex) {
    return selectedIndex == correctIndex;
  }

  /// Mengambil teks jawaban yang benar
  String get correctAnswer => options[correctIndex];
}
