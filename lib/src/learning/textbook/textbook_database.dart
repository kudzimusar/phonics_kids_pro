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
      'content': [
        {
          'type': 'lesson-text',
          'paragraphs': [
            'The letter c usually makes a hard /k/ sound, as in the word "cake." Sometimes, it makes a soft /s/ sound, as in the word "slice."',
          ]
        },
        {
          'type': 'instruction',
          'text': "Read these words aloud and sort them!",
        },
        {
          'type': 'two-column-sort',
          'leftLabel': 'Hard C',
          'rightLabel': 'Soft C',
          'options': ["cane", "icy", "mice", "cash", "cent", "fact"],
        },
        {
          'type': 'lesson-text',
          'paragraphs': [
            "Do you see a pattern? That's right, c makes a soft /s/ sound when the letter after it is an i, y, or e. In \"slice,\" the letter after c is an e, so it is soft.",
          ]
        },
        {
          'type': 'instruction',
          'text': "Name each of these pictures—is the c hard or soft?",
        },
        {
          'type': 'image-write-in-list',
          'items': [
            {'icon': 'cat', 'blanks': 2, 'answer': 'hard'},
            {'icon': 'happy', 'blanks': 4, 'answer': 'soft'},
            {'icon': 'pencil', 'blanks': 4, 'answer': 'soft'},
          ]
        }
      ]
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
    // A16
    {
      'id': 'page-19',
      'type': 'activity',
      'activityLabel': 'A16',
      'title': 'The Long Or Short Of It',
      'layout': 'lesson-with-sort',
      'teacherNotes': 'Focus: does the vowel say its name (long) or a different sound (short)?',
      'content': [
        {
          'type': 'lesson-text',
          'paragraphs': [
            "Let's look at the difference between Long and Short vowels. Read the boxed examples aloud.",
          ]
        },
        {
          'type': 'two-column-sort',
          'leftLabel': 'Long Vowel',
          'rightLabel': 'Short Vowel',
          'options': ['silo', 'fed', 'made', 'sand', 'she', 'tin', 'set', 'halo', 'bit']
        }
      ]
    },
    // A17
    {
      'id': 'page-20',
      'type': 'activity',
      'activityLabel': 'A17',
      'title': 'More Vowel Fishing',
      'layout': 'color-by-code',
      'teacherNotes': 'Extension of A16. Now covering O and U vowels plus Y as a vowel sound.',
      'content': [
        {
          'type': 'color-code-key',
          'codes': [
            {'label': 'Long O', 'color': 'red'},
            {'label': 'Short O', 'color': 'orange'},
            {'label': 'Long U', 'color': 'green'},
            {'label': 'Short U', 'color': 'yellow'},
            {'label': 'Y As E', 'color': 'blue'},
            {'label': 'Y As I', 'color': 'purple'},
          ]
        },
        {
          'type': 'fish-color-activity',
          'fish': [
            {'word': 'mop', 'answer': 'orange'},
            {'word': 'lady', 'answer': 'blue'},
            {'word': 'fun', 'answer': 'yellow'},
            {'word': 'music', 'answer': 'green'},
            {'word': 'sum', 'answer': 'yellow'},
            {'word': 'city', 'answer': 'blue'},
            {'word': 'told', 'answer': 'red'},
            {'word': 'pry', 'answer': 'purple'},
          ]
        }
      ]
    },
    // A18
    {
      'id': 'page-21',
      'type': 'activity',
      'activityLabel': 'A18',
      'title': 'Bossy R',
      'layout': 'lesson-with-circle-activity',
      'teacherNotes': 'R-controlled vowels. The R changes the vowel\'s sound entirely.',
      'content': [
        {
          'type': 'lesson-text',
          'paragraphs': [
            "As you've seen, vowels are often affected by the other letters around them. One thing that can change a vowel's sound is a bossy R! When a vowel is followed by the letter r, the vowel makes a new sound."
          ],
        },
        {
          'type': 'instruction',
          'text': "Read these word pairs aloud and note the difference.",
        },
        {
          'type': 'comparison-table',
          'rows': [
            {
              'pair': ["cold", "cord"],
              'imageDesc1': "Robot", 'imageId1': "robot",
              'imageDesc2': "Cord", 'imageId2': "rope",
            },
            {
              'pair': ["stamp", "star"],
              'imageDesc1': "Stamp", 'imageId1': "stamp", // Uses stamp emoji
              'imageDesc2': "Star", 'imageId2': "star",
            },
            {
              'pair': ["bun", "burn"],
              'imageDesc1': "Bun roll", 'imageId1': "bread", // Use bread emoji
              'imageDesc2': "Fire", 'imageId2': "fire",
            },
          ]
        },
        {
          'type': 'instruction',
          'text': "Circle the words with a bossy r.",
        },
        {
          'type': 'word-circle-grid',
          'words': [
            {'word': 'make', 'answer': false},
            {'word': 'ruler', 'answer': true},
            {'word': 'purple', 'answer': true},
            {'word': 'rain', 'answer': false},
            {'word': 'alarm', 'answer': true},
            {'word': 'rope', 'answer': false},
            {'word': 'chair', 'answer': true},
            {'word': 'puppy', 'answer': false},
            {'word': 'girl', 'answer': true},
            {'word': 'leapt', 'answer': false},
            {'word': 'sport', 'answer': true},
            {'word': 'car', 'answer': true},
          ]
        }
      ]
    },
    // A19
    {
      'id': 'page-22',
      'type': 'activity',
      'activityLabel': 'A19',
      'title': 'Missing Bossy R',
      'layout': 'fill-in-activity',
      'teacherNotes': 'Filling in the missing bossy R sounds.',
      'content': [
        {
          'type': 'picture-fill-in-grid',
          'entries': [
            {'imageDesc': 'Bird', 'imageId': 'bird', 'partial': 'b__d', 'answer': 'ir'},
            {'imageDesc': 'Yarn', 'imageId': 'yarn', 'partial': 'y__n', 'answer': 'ar'},
            {'imageDesc': 'Storm', 'imageId': 'storm', 'partial': 'st__m', 'answer': 'or'},
            {'imageDesc': 'Earth', 'imageId': 'earth', 'partial': '__th', 'answer': 'ear'},
            {'imageDesc': 'Fork', 'imageId': 'fork', 'partial': 'f__k', 'answer': 'or'},
            {'imageDesc': 'Corn', 'imageId': 'corn', 'partial': 'c__n', 'answer': 'or'},
            {'imageDesc': 'Chair', 'imageId': 'chair', 'partial': 'cha__', 'answer': 'ir'},
            {'imageDesc': 'Bear', 'imageId': 'bear', 'partial': 'be__', 'answer': 'ar'},
            {'imageDesc': 'Purse', 'imageId': 'purse', 'partial': 'p__se', 'answer': 'ur'},
          ]
        }
      ]
    },
    // A20
    {
      'id': 'page-23',
      'type': 'activity',
      'activityLabel': 'A20',
      'title': 'Use Your CVCs',
      'layout': 'dual-activity',
      'teacherNotes': 'Combined picture write and riddle answering.',
      'content': [
        {
          'type': 'cvc-picture-write',
          'entries': [
            {'imageDesc': 'Hat', 'imageId': 'hat', 'partial': '_ _ _', 'answer': 'hat'},
            {'imageDesc': 'Sun', 'imageId': 'sun', 'partial': '_ _ _', 'answer': 'sun'},
            {'imageDesc': 'Bag', 'imageId': 'bag', 'partial': '_ _ _', 'answer': 'bag'},
          ]
        },
        {
          'type': 'riddle-cvc',
          'riddles': [
            {'clue': 'Rectangular storage container:', 'answer': 'box'},
            {'clue': 'A glass you drink out of:', 'answer': 'cup'},
            {'clue': 'The number that comes after nine:', 'answer': 'ten'},
            {'clue': 'Flying mammal that likes caves:', 'answer': 'bat'},
            {'clue': 'The opposite of lose:', 'answer': 'win'},
          ]
        }
      ]
    },
  ];
}
