import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:memverse/l10n/l10n.dart';
import 'package:memverse/src/features/home/home_tab.dart';
import 'package:memverse/src/features/ref_quiz/memverse_page.dart';
import 'package:memverse/src/features/settings/settings_tab.dart';
import 'package:memverse/src/features/verse_text_quiz/widgets/verse_text_quiz_screen.dart';

const _tabs = <Widget>[HomeTab(), VerseTextQuizScreen(), MemversePage(), SettingsTab()];

class SignedInNavScaffold extends HookWidget {
  const SignedInNavScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(1);
    final l10n = context.l10n;
    final navItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: const Icon(Icons.home), label: l10n.home),
      BottomNavigationBarItem(icon: const Icon(Icons.menu_book_rounded), label: l10n.verse),
      BottomNavigationBarItem(icon: const Icon(Icons.bookmarks_outlined), label: l10n.ref),
      BottomNavigationBarItem(icon: const Icon(Icons.settings), label: l10n.settings),
    ];
    return Scaffold(
      body: IndexedStack(index: selectedIndex.value, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        items: navItems,
        currentIndex: selectedIndex.value,
        onTap: (index) => selectedIndex.value = index,
      ),
    );
  }
}
