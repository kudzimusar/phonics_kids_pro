import '../models/phonics_lesson.dart';

class LessonRepository {
  static final List<PhonicsLesson> allLessons = [
    PhonicsLesson(
      id: 'A1',
      title: 'Sounding Out Words',
      targetWord: 'tap',
      letters: ['t', 'a', 'p'],
      imagePath: 'assets/images/tap.png', // Placeholder
      description: 'Learn how to put the sounds together to make the word tap.',
      isPremium: false,
    ),
    PhonicsLesson(
      id: 'A2',
      title: 'How To Put A Word Together',
      targetWord: 'cat',
      letters: ['c', 'a', 't'],
      imagePath: 'assets/images/cat.png',
      description: 'Connect the sounds c, a, and t to make cat!',
      isPremium: false,
    ),
    PhonicsLesson(
      id: 'A3',
      title: 'Rhyming Fun',
      targetWord: 'hat',
      letters: ['h', 'a', 't'],
      imagePath: 'assets/images/hat.png', // Placeholder
      description: 'Find the rhymes and sound out hat.',
      isPremium: true,
    ),
    // ... more lessons to be added
  ];

  static PhonicsLesson getLessonById(String id) {
    return allLessons.firstWhere((l) => l.id == id,
        orElse: () => allLessons.first);
  }
}
