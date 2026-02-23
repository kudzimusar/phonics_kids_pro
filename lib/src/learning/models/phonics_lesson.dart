class PhonicsLesson {
  final String id;
  final String title;
  final String targetWord;
  final List<String> letters;
  final String imagePath;
  final String description;
  final bool isPremium;

  PhonicsLesson({
    required this.id,
    required this.title,
    required this.targetWord,
    required this.letters,
    required this.imagePath,
    required this.description,
    this.isPremium = false,
  });
}
