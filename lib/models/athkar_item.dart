/// A single dhikr item as returned live from the Athkar source - text is
/// never written by the app itself, only ever fetched from the source.
class AthkarItem {
  const AthkarItem({
    required this.text,
    required this.reference,
    required this.repeatCount,
  });

  final String text;
  final String reference;
  final int repeatCount;
}
