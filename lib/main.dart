import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'state/quiz_state.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget aplikasi Quizify.
/// QuizState diletakkan di sini agar bertahan selama app berjalan,
/// termasuk saat rotasi layar atau navigasi antarhalaman.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// State kuis dibuat sekali di sini dan tidak akan hilang
  /// selama aplikasi berjalan
  final QuizState _quizState = QuizState();

  /// Mode tema: terang atau gelap (akan digunakan di commit 22)
  ThemeMode _themeMode = ThemeMode.light;

  /// Toggle antara tema terang dan gelap
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return QuizStateProvider(
      quizState: _quizState,
      toggleTheme: _toggleTheme,
      themeMode: _themeMode,
      child: MaterialApp(
        title: 'Quizify - Interactive Quiz App',
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        // Tema terang
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.white,
        ),
        // Tema gelap — akan dilengkapi di commit 22
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        ),
        home: const HomePage(),
      ),
    );
  }
}

/// InheritedWidget sederhana untuk menyebarkan QuizState
/// ke seluruh widget tree tanpa package tambahan.
class QuizStateProvider extends InheritedWidget {
  final QuizState quizState;
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  const QuizStateProvider({
    super.key,
    required this.quizState,
    required this.toggleTheme,
    required this.themeMode,
    required super.child,
  });

  /// Akses QuizStateProvider dari widget mana saja
  /// Contoh: QuizStateProvider.of(context).quizState
  static QuizStateProvider of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<QuizStateProvider>();
    assert(provider != null, 'QuizStateProvider tidak ditemukan di widget tree');
    return provider!;
  }

  /// Flutter memanggil ini untuk memutuskan apakah perlu rebuild
  @override
  bool updateShouldNotify(QuizStateProvider oldWidget) {
    return quizState != oldWidget.quizState ||
        themeMode != oldWidget.themeMode;
  }
}
