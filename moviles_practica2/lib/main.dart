import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'core/services/sound_manager.dart';
import 'presentation/screens/main_menu_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await SoundManager.instance.init();
  // SoundManager.instance.playMusic();

  runApp(const WordleApp());
}

class WordleApp extends StatefulWidget {
  const WordleApp({super.key});

  @override
  State<WordleApp> createState() => _WordleAppState();
}

class _WordleAppState extends State<WordleApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      SoundManager.instance.pauseMusic();
    } else if (state == AppLifecycleState.resumed) {
      SoundManager.instance.resumeMusic();
    }
  }

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