import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/home/presentation/screens/home_screen.dart';

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
    _buildTabNavigator(
      _navigatorKeys[2],
      const _DummyScreen(title: '🔍 Perfil'),
    ),
  ];

  Widget _buildTabNavigator(GlobalKey<NavigatorState> key, Widget child) {
    return Navigator(
      key: key,
      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => child),
    );
  }

  void _onTabChanged(int index) {
    print('Tapped tab $index');
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
        _tabHistory.removeWhere((i) => i == index);
        _tabHistory.add(index);
      });
      print('Tab history: $_tabHistory');
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        print('Back button pressed on tab $_currentIndex');
        final currentNavigator = _navigatorKeys[_currentIndex].currentState!;
        if (currentNavigator.canPop()) {
          print('Popping navigator stack of tab $_currentIndex');
          currentNavigator.pop();
        } else if (_tabHistory.length > 1) {
          _tabHistory.removeLast();
          final previousTab = _tabHistory.last;
          print('Switching to previous tab $previousTab');
          setState(() {
            _currentIndex = previousTab;
          });
        } else {
          print(
            'No more navigation back possible, exiting app if system allows',
          );
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
    );
  }
}

// Las otras tabs simples (Home, Search, Perfil)
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
