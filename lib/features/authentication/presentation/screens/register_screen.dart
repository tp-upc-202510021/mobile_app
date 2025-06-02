import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/initial_assesstment/presentation/screens/assesstment_intro_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _onRegisterPressed() {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      print('Las contraseñas no coinciden');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const IntroScreen()),
    );
    // Aquí iría la lógica de registro
    print('Nombre: $name');
    print('Email: $email');
    print('Contraseña: $password');
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
              'Registrarse',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            FTextField(
              controller: _nameController,
              label: const Text('Nombre completo'),
              hint: 'Juan Pérez',
            ),
            const SizedBox(height: 16),

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
            const SizedBox(height: 16),

            FTextField(
              controller: _confirmPasswordController,
              label: const Text('Confirmar contraseña'),
              hint: '••••••••',
              obscureText: true,
            ),
            const SizedBox(height: 24),

            FButton(
              onPress: _onRegisterPressed,
              child: const Text('Crear cuenta'),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿Ya tienes cuenta? ',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Vuelve al login
                  },
                  child: const Text(
                    'Inicia sesión',
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
