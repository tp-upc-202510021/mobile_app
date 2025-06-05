import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:mobile_app/features/authentication/presentation/screens/login_screen.dart';
import 'package:mobile_app/features/home/presentation/screens/home_screen.dart';
import 'package:mobile_app/features/profile/presentation/profile_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _currentIndex = 0;

  final List<int> _tabHistory = [0];

  final _navigatorKeys = List.generate(3, (_) => GlobalKey<NavigatorState>());

  late final List<Widget> _tabs = [
    _buildTabNavigator(_navigatorKeys[0], const HomeScreen()),
    _buildTabNavigator(
      _navigatorKeys[1],
      const _DummyScreen(title: '🔍 Search'),
    ),
    _buildTabNavigator(_navigatorKeys[2], const ProfileScreen()),
  ];

  static Widget _buildTabNavigator(
    GlobalKey<NavigatorState> key,
    Widget child,
  ) {
    return Navigator(
      key: key,
      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => child),
    );
  }

  void _onTabChanged(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
        _tabHistory.removeWhere((i) => i == index);
        _tabHistory.add(index);
      });
    }
  }

  FBottomNavigationBarItem buildNavItem({
    required IconData iconData,
    required String label,
    required int itemIndex,
    required int currentIndex,
  }) {
    final isSelected = currentIndex == itemIndex;
    final color = isSelected ? Colors.blueAccent : Colors.grey;

    return FBottomNavigationBarItem(
      icon: Icon(iconData, color: color),
      label: Text(label, style: TextStyle(color: color)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.isAuthenticated != current.isAuthenticated,
      listener: (context, state) {
        if (!state.isAuthenticated) {
          // Navegar a login limpiando todo el stack
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) async {
          final currentNavigator = _navigatorKeys[_currentIndex].currentState!;
          if (currentNavigator.canPop()) {
            currentNavigator.pop();
          } else if (_tabHistory.length > 1) {
            _tabHistory.removeLast();
            final previousTab = _tabHistory.last;
            setState(() {
              _currentIndex = previousTab;
            });
          } else {
            SystemNavigator.pop();
          }
        },
        child: FScaffold(
          footer: FBottomNavigationBar(
            index: _currentIndex,
            onChange: _onTabChanged,
            children: [
              buildNavItem(
                iconData: FIcons.house,
                label: 'Menu',
                itemIndex: 0,
                currentIndex: _currentIndex,
              ),
              buildNavItem(
                iconData: FIcons.search,
                label: 'Buscar',
                itemIndex: 1,
                currentIndex: _currentIndex,
              ),
              buildNavItem(
                iconData: FIcons.user,
                label: 'Perfil',
                itemIndex: 2,
                currentIndex: _currentIndex,
              ),
            ],
          ),
          child: IndexedStack(index: _currentIndex, children: _tabs),
        ),
      ),
    );
  }
}

class _DummyScreen extends StatelessWidget {
  final String title;
  const _DummyScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: Center(child: Text(title, style: const TextStyle(fontSize: 24))),
    );
  }
}
