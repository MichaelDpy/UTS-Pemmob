import 'package:flutter/material.dart';

/// Widget untuk menampilkan satu pilihan jawaban kuis.
/// Digunakan di QuizPage (mode pilih) dan ReviewPage (mode review).
///
/// Ada dua mode tampilan:
/// - [AnswerMode.selecting] : pengguna sedang memilih jawaban (ungu jika dipilih)
/// - [AnswerMode.reviewing] : menampilkan hasil (hijau = benar, merah = salah)
class AnswerOption extends StatelessWidget {
  /// Label opsi: A, B, C, atau D
  final String label;

  /// Teks isi pilihan jawaban
  final String text;

  /// Apakah opsi ini sedang dipilih pengguna
  final bool isSelected;

  /// Callback saat opsi ditekan (null = tidak bisa diklik)
  final VoidCallback? onTap;

  /// Mode tampilan widget
  final AnswerMode mode;

  /// Apakah ini adalah jawaban yang benar (hanya relevan di mode reviewing)
  final bool isCorrect;

  const AnswerOption({
    super.key,
    required this.label,
    required this.text,
    required this.isSelected,
    this.onTap,
    this.mode = AnswerMode.selecting,
    this.isCorrect = false,
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan warna berdasarkan mode dan status
    final colors = _resolveColors();

    // Wrap dengan RepaintBoundary untuk isolasi repaint
    return RepaintBoundary(
      child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        // Animasi transisi warna saat dipilih
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colors.border,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Label (A/B/C/D) ────────────────────────
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.labelBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colors.labelText,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ── Teks Pilihan ───────────────────────────
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: colors.text,
                  height: 1.4,
                ),
              ),
            ),

            // ── Ikon Status (kanan) ────────────────────
            _buildTrailingIcon(colors),
          ],
        ),
      ),
      ), // RepaintBoundary
    );
  }

  /// Menentukan ikon di sebelah kanan berdasarkan mode dan status
  Widget _buildTrailingIcon(_AnswerColors colors) {
    if (mode == AnswerMode.reviewing) {
      // Mode review: tampilkan centang atau silang
      if (isSelected && isCorrect) {
        // Dipilih dan benar
        return const Icon(Icons.check_circle, color: Colors.green, size: 22);
      } else if (isSelected && !isCorrect) {
        // Dipilih tapi salah
        return const Icon(Icons.cancel, color: Colors.red, size: 22);
      } else if (!isSelected && isCorrect) {
        // Tidak dipilih tapi ini jawaban benar
        return const Icon(Icons.check_circle_outline,
            color: Colors.green, size: 22);
      }
      return const SizedBox.shrink(); // Tidak dipilih dan bukan jawaban benar
    }

    // Mode selecting: tampilkan centang jika dipilih
    if (isSelected) {
      return const Icon(Icons.check_circle, color: Colors.white, size: 22);
    }
    return const SizedBox.shrink();
  }

  /// Menentukan semua warna berdasarkan mode, isSelected, dan isCorrect
  _AnswerColors _resolveColors() {
    if (mode == AnswerMode.reviewing) {
      return _resolveReviewColors();
    }
    return _resolveSelectingColors();
  }

  /// Warna untuk mode memilih jawaban
  _AnswerColors _resolveSelectingColors() {
    if (isSelected) {
      return _AnswerColors(
        background: Colors.deepPurple,
        border: Colors.deepPurple,
        shadow: Colors.deepPurple.withOpacity(0.2),
        labelBackground: Colors.white.withOpacity(0.2),
        labelText: Colors.white,
        text: Colors.white,
      );
    }
    return _AnswerColors(
      background: Colors.white,
      border: Colors.grey.shade200,
      shadow: Colors.grey.shade100,
      labelBackground: Colors.deepPurple.shade50,
      labelText: Colors.deepPurple,
      text: Colors.grey.shade800,
    );
  }

  /// Warna untuk mode review jawaban
  _AnswerColors _resolveReviewColors() {
    if (isSelected && isCorrect) {
      // Dipilih dan benar → hijau
      return _AnswerColors(
        background: Colors.green.shade50,
        border: Colors.green,
        shadow: Colors.green.withOpacity(0.15),
        labelBackground: Colors.green.shade100,
        labelText: Colors.green.shade800,
        text: Colors.green.shade800,
      );
    } else if (isSelected && !isCorrect) {
      // Dipilih tapi salah → merah
      return _AnswerColors(
        background: Colors.red.shade50,
        border: Colors.red,
        shadow: Colors.red.withOpacity(0.15),
        labelBackground: Colors.red.shade100,
        labelText: Colors.red.shade800,
        text: Colors.red.shade800,
      );
    } else if (!isSelected && isCorrect) {
      // Tidak dipilih tapi ini jawaban benar → hijau outline tipis
      return _AnswerColors(
        background: Colors.green.shade50.withOpacity(0.5),
        border: Colors.green.shade300,
        shadow: Colors.transparent,
        labelBackground: Colors.green.shade50,
        labelText: Colors.green.shade700,
        text: Colors.green.shade700,
      );
    }
    // Tidak dipilih dan bukan jawaban benar → abu-abu
    return _AnswerColors(
      background: Colors.grey.shade50,
      border: Colors.grey.shade200,
      shadow: Colors.transparent,
      labelBackground: Colors.grey.shade100,
      labelText: Colors.grey.shade400,
      text: Colors.grey.shade400,
    );
  }
}

/// Enum untuk mode tampilan AnswerOption
enum AnswerMode {
  /// Mode memilih: pengguna sedang mengerjakan kuis
  selecting,

  /// Mode review: menampilkan jawaban benar/salah setelah kuis
  reviewing,
}

/// Helper class untuk menyimpan semua warna yang dibutuhkan AnswerOption.
/// Tidak perlu diexport keluar karena hanya dipakai internal.
class _AnswerColors {
  final Color background;
  final Color border;
  final Color shadow;
  final Color labelBackground;
  final Color labelText;
  final Color text;

  const _AnswerColors({
    required this.background,
    required this.border,
    required this.shadow,
    required this.labelBackground,
    required this.labelText,
    required this.text,
  });
}
