class TextbookDatabase {
  static const Map<String, dynamic> metadata = {
    'title': 'Phonics Kids Pro',
    'subtitle': 'Read By Age Four',
    'series': 'Phonics Kids Pro - Read By Age Four',
    'publisher': 'SKM Publishers',
    'author': 'Shadreck Kudzanai Musarurwa',
    'totalPages': 115,
    'totalActivities': 51,
  };

  static const List<Map<String, dynamic>> curriculumSections = [
    {'id': 'section-A', 'label': 'Section A', 'title': 'Foundations', 'pages': [3, 50], 'color': '#4A90D9'},
    {'id': 'section-B', 'label': 'Section B', 'title': 'Reading Practice', 'pages': [51, 90], 'color': '#E67E22'},
    {'id': 'section-C', 'label': 'Section C', 'title': 'Advanced Phonics', 'pages': [91, 109], 'color': '#27AE60'},
    {'id': 'answer-key', 'label': 'Answer Key', 'title': 'Activities Answer Key', 'pages': [110, 115], 'color': '#8E44AD'},
  ];

  static const List<Map<String, dynamic>> pages = [
    // COVER
    {
      'id': 'cover',
      'type': 'cover',
      'title': 'Phonics Kids Pro',
      'subtitle': 'Read By Age Four',
      'author': 'Shadreck Kudzanai Musarurwa',
      'publisher': 'SKM Publishers',
      'layout': 'cover',
    },
    // WELCOME
    {
      'id': 'welcome',
      'type': 'welcome',
      'title': 'Welcome!',
      'layout': 'welcome',
    },
    // A1
    {
      'id': 'page-3',
      'type': 'activity',
      'activityLabel': 'A1',
      'title': 'ABC Phonics',
      'layout': 'alphabet-grid',
      'teacherNotes': 'This is the reference alphabet chart. Students can use it throughout the workbook.',
    },
    // A2
    {
      'id': 'page-4',
      'type': 'activity',
      'activityLabel': 'A2',
      'title': 'How To Put A Word Together',
      'subtitle': "Let's apply some letters!",
      'layout': 'lesson-with-examples',
      'teacherNotes': 'Demonstrate how individual letter sounds blend together to form words. trace CAST',
    },
    // A3
    {
      'id': 'page-5',
      'type': 'activity',
      'activityLabel': 'A3',
      'title': 'Consonants and Vowels',
      'layout': 'lesson-with-activity',
      'teacherNotes': 'Key concept: vowels = a, e, i, o, u (and sometimes y). Physical demonstration of mouth position is very effective here.',
    },
    // A4
    {
      'id': 'page-6',
      'type': 'activity',
      'activityLabel': 'A4',
      'title': 'Consonants Double Up',
      'layout': 'lesson-with-table-and-activity',
      'teacherNotes': "Double consonants appear most often with: ll, rr, ss, mm, ff, tt, gg, pp. The sound doesn't change.",
      'answerKey': 'spill, carry, fuss, comment, puff // ball, dress, silly, mitt, fluffy, summer',
    },
    // A5
    {
      'id': 'page-7',
      'type': 'activity',
      'activityLabel': 'A5',
      'title': 'Complete The Word',
      'subtitle': 'Trace the consonant with the right beginning or ending sound!',
      'layout': 'tracing-grid',
      'teacherNotes': 'Emphasize both beginning and ending sounds.',
      'answerKey': 'Cat, Dog, Pig, Green, Farm, Feet',
    },
    // A6
    {
      'id': 'page-8',
      'type': 'activity',
      'activityLabel': 'A6',
      'title': 'Chaining Daisies',
      'subtitle': 'Choose the right flower from the field to start or finish a chain!',
      'layout': 'matching-game',
      'teacherNotes': 'Students pick the correct flower letter to complete each word chain.',
      'answerKey': 'Bus, Ham, Fox, Jam, Pail',
    },
    // A7
    {
      'id': 'page-9',
      'type': 'activity',
      'activityLabel': 'A7',
      'title': 'Charm Bracelet',
      'subtitle': 'Write in the beginning or ending sound to name the charm!',
      'layout': 'write-in-activity',
      'teacherNotes': 'The chain metaphor helps children visualize how letters connect to make words.',
      'answerKey': 'Gift, Bird, Boat, Flag, Girl',
    },
    // A8
    {
      'id': 'page-10',
      'type': 'activity',
      'activityLabel': 'A8',
      'title': 'Consonant Fill-in',
      'subtitle': "Use the letters and sounds you've learned to finish naming the pictures.",
      'layout': 'fill-in-list',
      'teacherNotes': 'Work through each word syllable by syllable.',
      'answerKey': 'Tree, Flower, Moose, Umbrella, Octopus, Rainbow, Watermelon',
    },
    // A9
    {
      'id': 'page-12',
      'type': 'activity',
      'activityLabel': 'A9',
      'title': 'Changing C',
      'layout': 'lesson-with-sort',
      'teacherNotes': 'The hard/soft C rule: before i, e, y → soft /s/. Before a, o, u, consonants → hard /k/.',
      'answerKey': 'cat = hard; face = soft; pencil = soft',
    },
    // A10
    {
      'id': 'page-13',
      'type': 'activity',
      'activityLabel': 'A10',
      'title': 'G Goes Either Way',
      'layout': 'lesson-with-color-sort',
      'teacherNotes': 'Same rule as C! Before e, i, y → soft sound. Gate (hard), gym (soft), gem (soft). Visual ladybug coloring makes this memorable.',
      'answerKey': 'gym=red, gate=black, gem=red, rag=black, giant=red, age=red',
    },
    // A11
    {
      'id': 'page-14',
      'type': 'activity',
      'activityLabel': 'A11',
      'title': 'Long and Short Vowels',
      'subtitle': 'Vowels (A, E, I, O, U) can make more than one sound! Trace some examples:',
      'layout': 'two-column-table',
      'teacherNotes': "Short vowels: apple, egg... Long vowels: acorn, hero... The long vowel 'says its name.'",
    },
    // A12
    {
      'id': 'page-15',
      'type': 'activity',
      'activityLabel': 'A12',
      'title': 'Why Is Y Special?',
      'layout': 'identify-sort',
      'teacherNotes': 'Y as consonant: makes /y/ sound at word start. Y as vowel: makes long /e/ sound or long /i/ sound at end of words.',
      'answerKey': 'lawyer=vowel, yellow=consonant, bicycle=vowel, happy=vowel, monkey=vowel, year=consonant',
    },
    // A13
    {
      'id': 'page-16',
      'type': 'activity',
      'activityLabel': 'A13',
      'title': 'Y Is A Thief',
      'layout': 'y-is-a-thief-sort', // custom layout handler in canvas
      'teacherNotes': 'Pattern: 1-syllable words ending in Y → long /i/ (fly, dry, fry). Multi-syllable words ending in Y → long /e/ (baby, candy, puppy).',
      'answerKey': 'Long E: pretty, windy... | Long I: rely, fly...',
    },
    // A14
    {
      'id': 'page-17',
      'type': 'activity',
      'activityLabel': 'A14',
      'title': 'Color My Vowel',
      'subtitle': 'Color the letter that completes the word.',
      'layout': 'color-choice-grid',
      'teacherNotes': 'Students identify which vowel completes each word. Encourage sounding out each option.',
      'answerKey': 'bath, mug, wing, fish, shell, frog, map, tulip, bugs',
    },
    // A15
    {
      'id': 'page-18',
      'type': 'activity',
      'activityLabel': 'A15',
      'title': 'Hop On The Train',
      'layout': 'train-fill-in',
      'teacherNotes': 'CVC blending with missing vowels.',
    },
    // A16 / A17
    {
      'id': 'page-19',
      'type': 'activity',
      'activityLabel': 'A16-A17',
      'title': 'Vowel Fishing',
      'layout': 'color-by-code',
      'teacherNotes': 'Identifying vowel sounds based on color codes.',
      'content': [
        {
          'type': 'color-code-key',
          'codes': [
            {'label': 'Short a', 'color': 'red'},
            {'label': 'Short e', 'color': 'orange'},
            {'label': 'Short i', 'color': 'yellow'},
            {'label': 'Short o', 'color': 'green'},
            {'label': 'Short u', 'color': 'blue'},
          ]
        },
        {
          'type': 'fish-color-activity',
          'fish': [
            {'word': 'cat', 'answer': 'red'},
            {'word': 'bed', 'answer': 'orange'},
            {'word': 'pig', 'answer': 'yellow'},
            {'word': 'log', 'answer': 'green'},
            {'word': 'sun', 'answer': 'blue'},
            {'word': 'hat', 'answer': 'red'},
          ]
        }
      ]
    },
    // A18
    {
      'id': 'page-20',
      'type': 'activity',
      'activityLabel': 'A18',
      'title': 'Bossy R',
      'layout': 'lesson-with-circle-activity',
      'teacherNotes': 'Identifying bossy R words.',
      'content': [
        {
          'type': 'word-circle-grid',
          'words': [
            {'word': 'car', 'answer': true},
            {'word': 'cat', 'answer': false},
            {'word': 'bird', 'answer': true},
            {'word': 'bat', 'answer': false},
            {'word': 'fork', 'answer': true},
            {'word': 'box', 'answer': false},
            {'word': 'hurt', 'answer': true},
            {'word': 'hut', 'answer': false},
          ]
        }
      ]
    },
    // A19
    {
      'id': 'page-21',
      'type': 'activity',
      'activityLabel': 'A19',
      'title': 'Missing Bossy R',
      'layout': 'fill-in-activity',
      'teacherNotes': 'Filling in the missing bossy R sounds.',
      'content': [
        {
          'type': 'picture-fill-in-grid',
          'entries': [
            {'imageDesc': 'Car', 'imageId': 'car', 'partial': 'c__', 'answer': 'ar'},
            {'imageDesc': 'Fern', 'imageId': 'plant', 'partial': 'f__n', 'answer': 'er'},
            {'imageDesc': 'Bird', 'imageId': 'bird', 'partial': 'b__d', 'answer': 'ir'},
            {'imageDesc': 'Fork', 'imageId': 'spit', 'partial': 'f__k', 'answer': 'or'},
            {'imageDesc': 'Hurt', 'imageId': 'bandaid', 'partial': 'h__t', 'answer': 'ur'},
          ]
        }
      ]
    },
    // A20
    {
      'id': 'page-22',
      'type': 'activity',
      'activityLabel': 'A20',
      'title': 'Use Your CVCs',
      'layout': 'dual-activity',
      'teacherNotes': 'Combined picture write and riddle answering.',
      'content': [
        {
          'type': 'cvc-picture-write',
          'entries': [
            {'imageDesc': 'Crab', 'imageId': 'crab', 'partial': 'c_a_b', 'answer': 'crab'},
            {'imageDesc': 'Frog', 'imageId': 'frog', 'partial': 'f_o_g', 'answer': 'frog'},
            {'imageDesc': 'Plum', 'imageId': 'plum', 'partial': 'p_u_m', 'answer': 'plum'},
          ]
        },
        {
          'type': 'riddle-cvc',
          'riddles': [
            {'clue': 'I have a shell and claws. I hop sideways.', 'answer': 'crab'},
            {'clue': 'I say ribbit. I jump high.', 'answer': 'frog'},
            {'clue': 'I am a purple fruit.', 'answer': 'plum'},
          ]
        }
      ]
    },
  ];
}
