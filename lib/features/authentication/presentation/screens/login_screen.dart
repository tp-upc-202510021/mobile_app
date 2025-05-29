import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onLoginPressed() {
    final email = _emailController.text;
    final password = _passwordController.text;

    // lógica de validación, autenticación, etc.
    print('Email: $email');
    print('Password: $password');
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Iniciar Sesión',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            FTextField(
              controller: _emailController,
              label: const Text('Correo electrónico'),
              hint: 'ejemplo@correo.com',
            ),

            const SizedBox(height: 16),

            FTextField(
              controller: _passwordController,
              label: const Text('Contraseña'),
              hint: '••••••••',
              obscureText: true,
            ),

            const SizedBox(height: 8),

            // Olvidaste tu contraseña?
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // lógica para recuperar contraseña
                  print('Olvidaste tu contraseña?');
                },
                child: const Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),

            const SizedBox(height: 65),

            FButton(
              onPress: _onLoginPressed,
              child: const Text('Iniciar sesión'),
            ),

            const SizedBox(height: 1),

            // No tienes cuenta? Regístrate
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¿No tienes cuenta? ',
                  style: TextStyle(color: Color(0xFF888888)),
                ),
                TextButton(
                  onPressed: () {
                    // Navegar a la pantalla de registro
                    print('Ir a registrarse');
                  },
                  child: const Text(
                    'Regístrate',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
