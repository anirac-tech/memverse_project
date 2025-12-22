import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/common/widgets/memverse_app_bar.dart';
import 'package:memverse/src/constants/feature_flags.dart';
import 'package:memverse/src/features/verse/presentation/providers/verse_providers.dart';
import 'package:memverse/src/features/verse_text_quiz/widgets/quiz_rating_widget.dart';

class VerseTextQuizScreen extends ConsumerStatefulWidget {
  const VerseTextQuizScreen({super.key});

  @override
  ConsumerState<VerseTextQuizScreen> createState() => _VerseTextQuizScreenState();
}

class _VerseTextQuizScreenState extends ConsumerState<VerseTextQuizScreen> {
  bool _showFullVerse = false;

  String _toMnemonic(String text) {
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          final firstAlphaIndex = word.indexOf(RegExp('[a-zA-Z]'));
          if (firstAlphaIndex == -1) return word; // No letters

          final sb = StringBuffer();
          sb.write(word.substring(0, firstAlphaIndex)); // Pre-letter punctuation
          sb.write(word[firstAlphaIndex]); // The letter

          // Append any non-letters after the first letter
          for (var i = firstAlphaIndex + 1; i < word.length; i++) {
            if (!RegExp('[a-zA-Z]').hasMatch(word[i])) {
              sb.write(word[i]);
            }
          }
          return sb.toString();
        })
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    const colorGreen = Color(0xFF80BC00);
    const colorLightGreen = Color(0xFFC8F780);
    const colorBg = Color(0xFFF8FFF0);
    const colorHintBg = Color(0xFFF1FDE9);
    const colorYellow = Color(0xFFFFF7CD);
    const refLight = colorLightGreen;
    final cardRadius = BorderRadius.circular(14);

    final versesAsync = ref.watch(versesProvider);

    return Scaffold(
      backgroundColor: colorBg,
      appBar: const MemverseAppBar(suffix: 'Verse'),
      body: versesAsync.when(
        data: (verses) {
          if (verses.isEmpty) {
            return const Center(child: Text('No verses found.'));
          }

          final currentVerse = verses.first;
          final mnemonics = _toMnemonic(currentVerse.text);
          final verseRef = '${currentVerse.reference} [${currentVerse.translation}]';

          // Simple logic to show first few words as hint
          final words = currentVerse.text.split(' ');
          final hintText = words.take(6).join(' ') + (words.length > 6 ? '...' : '');

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: cardRadius,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.07),
                        blurRadius: 14,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                        decoration: BoxDecoration(
                          color: colorHintBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.green.shade100, width: 1.1),
                        ),
                        child: Text(
                          _showFullVerse ? currentVerse.text : hintText,
                          style: const TextStyle(color: Colors.black87, fontSize: 17),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: colorLightGreen.withOpacity(.20),
                          borderRadius: cardRadius,
                          border: Border.all(color: colorGreen.withOpacity(0.11)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  verseRef,
                                  style: const TextStyle(
                                    color: colorGreen,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        _showFullVerse ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.grey.shade500,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _showFullVerse = !_showFullVerse;
                                        });
                                      },
                                    ),
                                    if (FeatureFlags.addVerseIsReady) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: colorGreen,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.add, color: Colors.white),
                                          onPressed: () {},
                                          iconSize: 22,
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: colorYellow,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.amber.shade100),
                              ),
                              padding: const EdgeInsets.fromLTRB(11, 10, 6, 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      mnemonics,
                                      style: const TextStyle(
                                        fontFamily: 'RobotoMono',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.brown,
                                        fontSize: 16.5,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.cancel, color: Colors.orange, size: 20),
                                    onPressed: () {},
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            TextField(
                              style: const TextStyle(fontSize: 17),
                              decoration: InputDecoration(
                                hintText: 'Type the verse here...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: colorGreen, width: 1.2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 14,
                                ),
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            if (FeatureFlags.ratingsIsReady) const QuizRatingWidget(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 34),
                      if (verses.length > 1) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: colorHintBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorGreen.withOpacity(0.07)),
                          ),
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.eco_rounded, color: colorGreen, size: 22),
                                  SizedBox(width: 7),
                                  Text(
                                    'Upcoming Verses',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 11),
                              ...verses
                                  .skip(1)
                                  .take(3)
                                  .map(
                                    (verse) => Container(
                                      decoration: BoxDecoration(
                                        color: refLight,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.bookmark, color: Colors.green, size: 18),
                                          const SizedBox(width: 6),
                                          Text(
                                            verse.reference,
                                            style: const TextStyle(fontSize: 15.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
