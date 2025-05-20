import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:flutter/services.dart';

void main() {
  // Status bar-ı dəyişdirək
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Art Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PixelFont', // Bu fontu lazımdır aşağıda əlavə etmək
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF70A6), // Şirin çəhrayı
          primary: const Color(0xFFFF70A6),   // Şirin çəhrayı
          secondary: const Color(0xFF70D6FF), // Şirin mavi
          tertiary: const Color(0xFF9BEDB6),  // Şirin yaşıl
          background: const Color(0xFFFFF6F6), // Çox açıq çəhrayı
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF70A6),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF70A6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFFFB4D9), width: 2),
          ),
          elevation: 4,
          color: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
