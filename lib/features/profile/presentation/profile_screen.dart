import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/authentication/presentation/cubit/auth_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: Row(
          children: [
            const SizedBox(width: 10, height: 35),
            const Text(
              'Mi Perfil',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                FAvatar(
                  image: const NetworkImage('https://example.com/profile.jpg'),
                  fallback: const Text('A'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Usuario',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => print('Editar perfil'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Estadísticas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(value: '2:30', label: 'Horas aprendidas'),
                _StatItem(value: '20', label: 'Logros'),
              ],
            ),
            const Spacer(),

            // Navegación dentro de un marco gris
            Container(
              height: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                border: Border.all(color: const Color(0xFFDDDDDD)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FButton(
                    onPress: () => print('Ir a Opciones'),
                    child: _NavItem(title: 'Opciones'),
                  ),
                  const SizedBox(height: 15),
                  FButton(
                    onPress: () => print('Ir a Logros'),
                    child: _NavItem(title: 'Logros'),
                  ),
                  const SizedBox(height: 15),
                  FButton(
                    onPress: () => print('Ir a Amigos'),
                    child: _NavItem(title: 'Amigos'),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Mi cuenta
            Container(
              height: 160, // Ajusta según cuánto espacio quieras
              width: 400,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFFDDDDDD)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ), // puedes ajustar el valor
                    child: Text(
                      'Mi cuenta',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => print('Cambiar a otra cuenta'),
                    child: const Text(
                      'Cambiar a otra cuenta',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),

                  TextButton(
                    onPressed: () async {
                      print('Cerrar sesión');
                      await context.read<AuthCubit>().logout();
                    },
                    child: const Text(
                      'Cerrar sesión',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;

  const _NavItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        const Icon(Icons.arrow_forward_ios, size: 16),
      ],
    );
  }
}
