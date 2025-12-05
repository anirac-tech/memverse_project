# Reference Quiz — Engineering Questions & Notes

Engineering considerations and open questions for the Reference Quiz implementation.

1. `hideReference` wiring
   - Current: `VerseCard` accepts `hideReference` boolean; `QuestionSection` passes `true`.
   - Question: Should `hideReference` be driven by a provider or passed from `memverse_page.dart`? A provider allows toggling at runtime and easier testing.
   - Suggestion: Add a `refQuizModeProvider` (simple StateProvider<bool>) if we want runtime toggling.

2. Layout & clipping
   - Current fix: `QuestionSection` uses a `ConstrainedBox` with `maxHeight = MediaQuery.of(context).size.height * 0.6` and `VerseCard` lets the text size naturally.
   - Note: This avoids clipped verses while preventing the verse card from consuming the entire screen.
   - Edge-case: For extremely long verses, consider making the verse card vertically scrollable or showing a "expand" control.

3. Feedback & reveal logic
   - Current: `memverse_page.dart` shows the expected reference in helper/snack feedback. If we change this, update analytics calls (`trackVerseIncorrect`, `trackVerseNearlyCorrect`, `trackVerseCorrect`) to avoid leaking correct answers to logs (privacy/cheating concerns).

4. Tests and determinism
   - Update widget and integration tests to assert the reference is hidden in `ref_quiz` flows.
   - Maestro flows that take screenshots should know whether the reference is visible.

5. Accessibility & semantics
   - Ensure verse card has a semantic label like `Semantics(label: 'verse_text', child: ...)` and the input field has `labelText` and keys for tests.

6. Performance
   - Large lists of verses are fetched by `verseListProvider`. Ensure we don't rebuild heavy widgets unnecessarily when toggling `hideReference`. Keep `VerseCard` stateless and small.

7. Config flags
   - Consider adding dart-define or remote config flags for: `REF_REVEAL_ATTEMPTS`, `REF_PROGRESS_POLICY` (advance always vs require correct), and `REF_INPUT_AUTOCOMPLETE`.

8. API/Analytics
   - Track events when reveal is used, when user gets it correct, and attempt counts per verse. Ensure analytics service can be overridden in tests.


Files touched in this PR
- `lib/src/features/ref_quiz/widgets/verse_card.dart` (added `hideReference`)
- `lib/src/features/ref_quiz/widgets/question_section.dart` (pass `hideReference` and use dynamic maxHeight)


Next engineering tasks (if you want me to proceed)
- Add `refQuizModeProvider` to allow runtime toggling of hide/show reference
- Implement reveal-after-N-attempts logic and an optional "Reveal" control
- Add semantic labels and keys for testing and accessibility
- Add tests asserting hidden reference and correct feedback behaviour

Tell me which of the next engineering tasks you want me to implement and I will proceed.