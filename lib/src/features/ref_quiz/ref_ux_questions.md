# Reference Quiz — UX Questions

These are UX questions and suggested decisions for the Reference Quiz feature. Use these to guide design and product discussions.

1. Reveal-after-submit behavior
   - Current: the app shows the expected reference in feedback on incorrect answers (`notQuiteRight(expectedReference)`).
   - Question: Should the correct reference ever be revealed automatically? If so, when (immediately on submit, after N attempts, or via an explicit "Reveal answer" button)?
   - Suggestion: Add a "Reveal after 3 attempts" option and a configurable setting in user preferences.

2. Feedback wording
   - Current: snackbars show localized messages with the expected reference.
   - Question: Do we prefer to show more subtle feedback (e.g., "Close — check the book name") rather than the full correct answer?
   - Suggestion: Provide three feedback levels: Silent (no reveal), Partial (show which part is wrong), Full (reveal expected reference).

3. Input affordance
   - Current: plain TextField with helper text and format guidance.
   - Question: Should we provide input suggestions/autocomplete for book names (e.g., "John / Jn") to reduce typing friction? Should keyboard auto-capitalize?
   - Suggestion: Add an optional book-name autocomplete overlay and set keyboard configuration to use sentence-case.

4. Accessibility
   - Ensure the verse text is presented as selectable/readable text and that the reference input has appropriate labels and focus management for screen readers.
   - Add semantic labels to the verse card and input field keys for UI tests and accessibility.

5. Reveal mechanics in tests (Maestro/Patrol)
   - Tests currently rely on `AUTOSIGNIN=true` flows. If we add reveal delays or attempt counters, tests need deterministic hooks (e.g., `--dart-define=REF_REVEAL_ATTEMPTS=3`).

6. Visual layout
   - Current: verse card sits above input form. The reference is hidden in quiz mode.
   - Question: Should the input be visually attached to the verse (inline) or remain below as an independent form?
   - Suggestion: Keep input below the verse for clarity; consider a subtle divider and hint text.
      - Implementation note: the verse container currently uses a dynamic maxHeight set to 60% of the screen height
         (controlled by `MediaQuery.of(context).size.height * 0.6`) so that long verses are shown fully where possible
         without taking the entire screen. This is important to avoid vertical clipping of verse text.

7. Scoring & progression
   - Current: on submit, the app advances to the next verse after a short delay. Incorrect answers still show the expected reference.
   - Question: Should progression require a correct answer, or should we always advance after feedback? Should we track attempt count per verse?
   - Suggestion: Keep current behavior (advance after feedback) but record attempt metrics; make progression policy configurable in settings.


# Files to update when decisions are made
- `lib/src/features/ref_quiz/widgets/verse_reference_form.dart` (feedback wording / reveal)
- `lib/src/features/ref_quiz/widgets/verse_card.dart` (semantic labels)
- `lib/src/features/ref_quiz/memverse_page.dart` (reveal logic / attempt counters)
- `maestro/` flows and tests (update test hooks)


---

Please review these UX questions and tell me which decisions you'd like enforced in the UI behavior; I will then implement the chosen options.