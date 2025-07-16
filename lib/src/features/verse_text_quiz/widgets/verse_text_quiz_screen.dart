import 'package:flutter/material.dart';
import 'package:memverse/src/common/widgets/memverse_app_bar.dart';

class VerseTextQuizScreen extends StatelessWidget {
  const VerseTextQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const colorGreen = Color(0xFF80BC00);
    const colorLightGreen = Color(0xFFC8F780);
    const colorBg = Color(0xFFF8FFF0);
    const colorHintBg = Color(0xFFF1FDE9);
    const colorYellow = Color(0xFFFFF7CD);
    const mnemonics = 'B t f o t S i l, j, p, p, k, g, f.';
    const verseRef = 'Gal 5:22 [NIV]';
    const refLight = colorLightGreen;
    final cardRadius = BorderRadius.circular(14);

    return Scaffold(
      backgroundColor: colorBg,
      appBar: MemverseAppBar(suffix: 'Verse'),
      body: Padding(
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
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.black87, fontSize: 17),
                        children: [
                          TextSpan(
                            text: 'But the fruit of the Spirit ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '.. love,',
                            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
                          ),
                        ],
                      ),
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
                            const Text(
                              verseRef,
                              style: TextStyle(
                                color: colorGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.visibility_outlined, color: Colors.grey.shade500),
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
                              const Expanded(
                                child: Text(
                                  mnemonics,
                                  style: TextStyle(
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
                            hintText: 'But the fruit of the Spirit it love...',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            6,
                            (i) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: CircleAvatar(
                                backgroundColor: i == 2
                                    ? colorGreen.withOpacity(0.15)
                                    : Colors.white,
                                radius: 22,
                                child: i < 5
                                    ? Text(
                                        '${i + 1}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: i == 2 ? FontWeight.bold : FontWeight.normal,
                                          color: i == 2 ? colorGreen : Colors.grey.shade600,
                                        ),
                                      )
                                    : const Icon(Icons.info_outline, color: colorGreen, size: 22),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 34),
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
                        Container(
                          decoration: BoxDecoration(
                            color: refLight,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: const Row(
                            children: [
                              Icon(Icons.bookmark, color: Colors.green, size: 18),
                              SizedBox(width: 6),
                              Text('Gal 5:22', style: TextStyle(fontSize: 15.5)),
                            ],
                          ),
                        ),
                        const Row(
                          children: [
                            Icon(Icons.bookmark_border, color: Colors.grey, size: 18),
                            SizedBox(width: 6),
                            Text('Col 1:17', style: TextStyle(fontSize: 15.5, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
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
