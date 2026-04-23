class DuaItem {
  final String id;
  final String category;
  final String title;
  final String arabicText;
  final String transliteration;
  final String englishMeaning;
  final String urduMeaning;
  final String source;
  final String reference;
  final String authenticity;
  final String occasion;
  bool isFavorite;
  int viewCount;

  DuaItem({
    required this.id,
    required this.category,
    required this.title,
    required this.arabicText,
    required this.transliteration,
    required this.englishMeaning,
    required this.urduMeaning,
    required this.source,
    required this.reference,
    required this.authenticity,
    required this.occasion,
    this.isFavorite = false,
    this.viewCount = 0,
  });

  factory DuaItem.fromJson(Map<String, dynamic> json) {
    return DuaItem(
      id: json['dua_id'] ?? '',
      category: json['category'] ?? 'General',
      title: json['title'] ?? '',
      arabicText: json['arabic_text'] ?? '',
      transliteration: json['transliteration'] ?? '',
      englishMeaning: json['english_meaning'] ?? '',
      urduMeaning: json['urdu_meaning'] ?? '',
      source: json['source'] ?? '',
      reference: json['reference'] ?? '',
      authenticity: json['authenticity'] ?? '',
      occasion: json['occasion'] ?? '',
    );
  }
}
