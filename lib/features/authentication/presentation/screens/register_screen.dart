import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/authentication/presentation/cubit/register_cubit.dart';
import 'package:mobile_app/features/authentication/repositories/auth_repository.dart';
import 'package:mobile_app/features/authentication/services/auth_service.dart';
import 'package:mobile_app/features/initial_assesstment/presentation/screens/quiz_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  bool _preferenceIsLoans = false;
  bool _preferenceIsInvestments = false;

  String? _preferenceError;

  late RegisterCubit _registerCubit;

  @override
  void initState() {
    super.initState();
    final authService = AuthService();
    final authRepository = AuthRepository(authService);
    _registerCubit = RegisterCubit(authRepository);
  }

  @override
  void dispose() {
    _registerCubit.close();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final ageText = _ageController.text.trim();
    final age = int.tryParse(ageText);
    final preference = _preferenceIsLoans ? 'loans' : 'investments';

    print(name);
    print('♻️ email: $email');
    print(password);
    print(confirmPassword);
    print(age);
    print(preference);

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

    setState(() {
      _preferenceError = null;
    });

    // Llama al cubit para registrar
    _registerCubit.register(
      name: name,
      email: email,
      password: password,
      age: age,
      preference: preference,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _registerCubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Registrarse')),
        body: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!)));
            }
            if (state.user != null) {
              // Registro exitoso, navega al quiz
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      QuizScreen(preference: state.user!.preference ?? 'loans'),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
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
                        if (_preferenceIsLoans)
                          _preferenceIsInvestments = false;
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
                        if (_preferenceIsInvestments)
                          _preferenceIsLoans = false;
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
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      return FButton(
                        onPress: state.loading ? null : _onRegisterPressed,
                        child: state.loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Crear cuenta'),
                      );
                    },
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
                          Navigator.pop(context);
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
        ),
      ),
    );
  }
}
