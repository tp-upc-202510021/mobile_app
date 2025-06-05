import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              FIcons.sparkles, // O el icono que prefieras del paquete forui
              size: 80,
              color: Colors.blueAccent,
            ),
            SizedBox(height: 20),
            Text(
              'Cargando...',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
