import 'package:flutter/material.dart';

/// Widget tombol kustom yang digunakan di seluruh aplikasi Quizify.
/// Mendukung dua tipe: primary (solid) dan secondary (outline).
/// Desain konsisten dengan tema deepPurple.
class CustomButton extends StatelessWidget {
  /// Teks yang ditampilkan di dalam tombol
  final String label;

  /// Fungsi yang dipanggil saat tombol ditekan
  final VoidCallback? onPressed;

  /// Ikon opsional di sebelah kiri teks
  final IconData? icon;

  /// Tipe tombol: primary (solid) atau secondary (outline)
  final ButtonType type;

  /// Warna kustom opsional — jika null, menggunakan warna default tema
  final Color? color;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.type = ButtonType.primary,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Gunakan warna dari parameter, atau fallback ke deepPurple
    final buttonColor = color ?? Colors.deepPurple;

    // Tampilkan tombol sesuai tipe
    if (type == ButtonType.secondary) {
      return _buildSecondaryButton(buttonColor);
    }
    return _buildPrimaryButton(buttonColor);
  }

  /// Tombol solid (Primary) — background berwarna, teks putih
  Widget _buildPrimaryButton(Color buttonColor) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          // Nonaktif jika onPressed null
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade500,
          elevation: onPressed != null ? 2 : 0,
          shadowColor: buttonColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _buildButtonContent(Colors.white),
      ),
    );
  }

  /// Tombol outline (Secondary) — background transparan, border berwarna
  Widget _buildSecondaryButton(Color buttonColor) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: buttonColor,
          side: BorderSide(
            color: onPressed != null ? buttonColor : Colors.grey.shade300,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _buildButtonContent(
          onPressed != null ? buttonColor : Colors.grey.shade400,
        ),
      ),
    );
  }

  /// Konten tombol: ikon (opsional) + teks
  Widget _buildButtonContent(Color contentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tampilkan ikon jika ada
        if (icon != null) ...[
          Icon(icon, size: 22, color: contentColor),
          const SizedBox(width: 10),
        ],
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: contentColor,
          ),
        ),
      ],
    );
  }
}

/// Enum untuk tipe tampilan tombol
enum ButtonType {
  /// Tombol solid dengan background berwarna
  primary,

  /// Tombol outline dengan background transparan
  secondary,
}
