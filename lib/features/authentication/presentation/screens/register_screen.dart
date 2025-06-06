import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/initial_assesstment/presentation/screens/quiz_screen.dart';

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
  final _ageController = TextEditingController();

  bool _preferenceIsLoans = false;
  bool _preferenceIsInvestments = false;

  String? _preferenceError;

  void _onRegisterPressed() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final ageText = _ageController.text.trim();
    final age = int.tryParse(ageText);
    // Navega o muestra algo luego de registro, por ejemplo:
    Navigator.push(context, MaterialPageRoute(builder: (_) => QuizScreen()));
    setState(() {
      _preferenceError = null;
    });

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        age == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos correctamente'),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    if (!_preferenceIsLoans && !_preferenceIsInvestments) {
      setState(() {
        _preferenceError = 'Por favor, selecciona una preferencia';
      });
      return;
    }

    final preference = _preferenceIsLoans ? 'loans' : 'investments';

    // Aquí iría la llamada para registrar usando la info:
    print('Registrando...');
    print('Nombre: $name');
    print('Email: $email');
    print('Edad: $age');
    print('Contraseña: $password');
    print('Preferencia: $preference');
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
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
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              FTextField(
                controller: _ageController,
                label: const Text('Edad'),
                hint: '25',
                keyboardType: TextInputType.number,
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

              FRadio(
                label: const Text('Préstamos'),
                description: const Text(
                  'Recibir recomendaciones sobre préstamos.',
                ),
                value: _preferenceIsLoans,
                onChange: (value) {
                  setState(() {
                    _preferenceIsLoans = value;
                    if (_preferenceIsLoans) _preferenceIsInvestments = false;
                    _preferenceError = null;
                  });
                },
                enabled: true,
              ),

              FRadio(
                label: const Text('Inversiones'),
                description: const Text(
                  'Recibir recomendaciones sobre inversiones.',
                ),
                value: _preferenceIsInvestments,
                onChange: (value) {
                  setState(() {
                    _preferenceIsInvestments = value;
                    if (_preferenceIsInvestments) _preferenceIsLoans = false;
                    _preferenceError = null;
                  });
                },
                enabled: true,
              ),

              if (_preferenceError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _preferenceError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
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
      ),
    );
  }
}
