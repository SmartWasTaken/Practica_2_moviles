import 'package:flutter/material.dart';
import '../../core/constants/enums.dart';
import '../../data/providers/word_provider.dart';
import '../routes/custom_page_route.dart';
import 'settings_screen.dart';

class InGameMenuScreen extends StatelessWidget {
  const InGameMenuScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pausa'),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'GamePocket',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Reanudar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'GamePocket',
                ),
              ),
              onPressed: () async {
                final newDifficulty = await Navigator.of(context).push<Difficulty?>(
                  FadePageRoute(
                    page: const SettingsScreen(isInGameMode: true),
                  ),
                );
                if (newDifficulty != null && context.mounted) {
                  Navigator.of(context).pop(newDifficulty);
                }
              },
              child: const Text('Ajustes'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'GamePocket',
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Salir al menú'),
                    content: const Text('¿Estás seguro? Perderás el progreso de la partida actual.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          Navigator.of(context).pop('exit');
                        },
                        child: const Text('Aceptar',
                          style: TextStyle(fontFamily: 'GamePocket'),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Salir al menú Principal'),
            ),
          ],
        ),
      ),
    );
  }
}