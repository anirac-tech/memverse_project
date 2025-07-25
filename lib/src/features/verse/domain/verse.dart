class Verse {
  const Verse({required this.reference, required this.text, this.translation = 'NIV'});
  final String reference;
  final String text;
  final String translation;
}
