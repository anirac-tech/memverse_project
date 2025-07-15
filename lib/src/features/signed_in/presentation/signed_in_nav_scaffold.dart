import 'package:flutter/material.dart';
import 'package:memverse/src/features/ref_quiz/memverse_page.dart';
import 'package:memverse/src/features/verse_text_quiz/widgets/verse_text_quiz_screen.dart';

class SignedInNavScaffold extends StatefulWidget {
  const SignedInNavScaffold({super.key});

  @override
  State<SignedInNavScaffold> createState() => _SignedInNavScaffoldState();
}

class _SignedInNavScaffoldState extends State<SignedInNavScaffold> {
  int _selectedIndex = 1;

  final List<Widget> _tabs = [
    const _HomeTab(),
    const VerseTextQuizScreen(),
    const MemversePage(),
    const _SettingsTab(),
  ];

  //TODO(neiljaywarner)
  // no magic strings or colors or number, fatarrow, useState not setState, no stateful widgert etc.

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Verse'),
    BottomNavigationBarItem(icon: Icon(Icons.bookmarks_outlined), label: 'Ref'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    const navBg = Color(0xFFF8FFF0);
    const navGreen = Color(0xFF80BC00);
    const navGray = Color(0xFF767676);
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: navGreen,
        unselectedItemColor: navGray,
        selectedFontSize: 13,
        unselectedFontSize: 12.2,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.05),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, letterSpacing: 0.04),
        backgroundColor: navBg,
        iconSize: 28,
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) => const Center(
    child: Text(
      'Home',
      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
      textAlign: TextAlign.center,
    ),
  );
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) => const Center(child: Text('Settings'));
}
