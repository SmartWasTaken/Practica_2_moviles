import 'dart:io';
import 'package:flutter/material.dart';
// ANTES (Incorrecto): import 'package:sqflite_ffi/sqflite_ffi.dart';
// AHORA (Correcto):
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'presentation/screens/main_menu_screen.dart';

Future<void> main() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const WordleApp());
}

class WordleApp extends StatelessWidget {
  const WordleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle Game',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0xFF121213),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.transparent,
        ),
      ),
      home: const MainMenuScreen(),
    );
  }
}