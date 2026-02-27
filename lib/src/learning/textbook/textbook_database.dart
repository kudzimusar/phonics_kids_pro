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
    // A21
    {
      'id': 'page-24',
      'type': 'activity',
      'activityLabel': 'A21',
      'title': 'Defining Digraphs',
      'layout': 'lesson-reference',
      'teacherNotes': 'Key digraphs to know: consonant digraphs (sh, ch, th, wh, ph, gh, kn, wr, ng) and vowel digraphs (ai, ee, oo, ea, oa, oi, ue). Each makes ONE sound.',
      'content': [
        {
          'type': 'lesson-text',
          'paragraphs': [
            "A digraph is a group of multiple letters that work together to make one single sound! The letters can be consonants or vowels. Trace some examples.",
          ],
        },
        {
          'type': 'digraph-example-grid',
          'entries': [
            {'word': 'Wheel', 'digraph': 'wh', 'imageId': 'wheel'},
            {'word': 'Photo', 'digraph': 'ph', 'imageId': 'photo'},
            {'word': 'Shell', 'digraph': 'sh', 'imageId': 'shell'},
            {'word': 'Cheese', 'digraph': 'ch', 'imageId': 'cheese'},
            {'word': 'Path', 'digraph': 'th', 'imageId': 'path'},
            {'word': 'Ghost', 'digraph': 'gh', 'imageId': 'ghost'},
            {'word': 'Knight', 'digraph': 'kn', 'imageId': 'knight'},
            {'word': 'Wing', 'digraph': 'ng', 'imageId': 'wing'},
            {'word': 'Write', 'digraph': 'wr', 'imageId': 'write'},
            {'word': 'Nail', 'digraph': 'ai', 'imageId': 'nail'},
            {'word': 'Feet', 'digraph': 'ee', 'imageId': 'feet'},
            {'word': 'Glue', 'digraph': 'ue', 'imageId': 'glue'},
            {'word': 'Book', 'digraph': 'oo', 'imageId': 'book'},
            {'word': 'Leaf', 'digraph': 'ea', 'imageId': 'leaf'},
            {'word': 'Soap', 'digraph': 'oa', 'imageId': 'soap'},
            {'word': 'Coins', 'digraph': 'oi', 'imageId': 'coins'},
          ]
        }
      ]
    },
    // A22
    {
      'id': 'page-25',
      'type': 'activity',
      'activityLabel': 'A22',
      'title': 'Spot A Digraph',
      'layout': 'identify-underline',
      'teacherNotes': 'Students identify digraphs within words. Chick has TWO digraphs: ch and ck. Practice finding digraphs at beginning, middle, and end of words.',
      'answerKey': 'A22: bath, cash, beach, pick',
      'content': [
        {
          'type': 'example-box',
          'imageId': 'chick',
          'text': "There are two digraphs in chick!",
          'explanation': "The c and h come together to make one /ch/ sound, while the c and k combine to make a /k/ sound."
        },
        {
          'type': 'instruction',
          'text': "Which of these words has a digraph in it? Underline the digraph."
        },
        {
          'type': 'word-list-activity',
          'sets': [
            {'words': ["try", "sad", "met", "bath", "core"], 'answers': ["bath"]},
            {'words': ["cash", "man", "lid", "bun", "rods"], 'answers': ["cash"]},
            {'words': ["harp", "beach", "fly", "make", "bar"], 'answers': ["beach"]},
            {'words': ["color", "baby", "tip", "ways", "pick"], 'answers': ["pick"]}
          ]
        }
      ]
    },
    // A23
    {
      'id': 'page-26',
      'type': 'activity',
      'activityLabel': 'A23',
      'title': 'Trigraphs',
      'layout': 'lesson-with-find-activity',
      'teacherNotes': 'Trigraphs: tch (catch, match, watch), igh (light, bright, night), dge (bridge, fridge, edge), eau (beauty, bureau). These three-letter combinations make ONE sound.',
      'answerKey': 'A23: bright, high, bureau, fridge, match, beautiful',
      'content': [
        {
          'type': 'lesson-text',
          'paragraphs': [
            "Sometimes, three letters make one sound. These are a bit harder to use and not as common as digraphs. Say each word out loud, and notice how the trigraph makes just one sound."
          ]
        },
        {
          'type': 'trigraph-examples',
          'entries': [
            {'word': "Watch", 'trigraph': "tch", 'imageId': "watch"},
            {'word': "Beauty", 'trigraph': "eau", 'imageId': "beauty"},
            {'word': "Light", 'trigraph': "igh", 'imageId': "light"},
            {'word': "Bridge", 'trigraph': "dge", 'imageId': "bridge"}
          ]
        },
        {
          'type': 'instruction',
          'text': "Find the Trigraphs"
        },
        {
          'type': 'sentence-find',
          'sentences': [
            {'text': "The sun is bright when it is high in the sky.", 'answers': ["bright", "high"]},
            {'text': "I put my clothes back in the bureau and my food back in the fridge.", 'answers': ["bureau", "fridge"]},
            {'text': "Today we match, and we look beautiful.", 'answers': ["match", "beautiful"]}
          ]
        }
      ]
    },
    // A24
    {
      'id': 'page-27',
      'type': 'activity',
      'activityLabel': 'A24',
      'title': 'Sh Or Ch?',
      'layout': 'circle-and-fill',
      'teacherNotes': 'Sh vs Ch: /sh/ is a hissing sound (snake), /ch/ is a choo-choo sound. Have students feel the difference in their mouth. Both are common digraphs in English.',
      'answerKey': 'A24: sheep=sh, cheese=ch, cherry=ch, fish=sh // chalk, shell, chair, ships',
      'content': [
        {
          'type': 'lesson-text',
          'paragraphs': [
            "The digraphs sh and ch sound similar. For each image, say its name and circle the correct digraph."
          ]
        },
        {
          'type': 'circle-digraph',
          'entries': [
            {'imageId': "sheep", 'choices': ["sh", "ch"], 'answer': "sh", 'word': "sheep"},
            {'imageId': "cheese", 'choices': ["sh", "ch"], 'answer': "ch", 'word': "cheese"},
            {'imageId': "cherries", 'choices': ["sh", "ch"], 'answer': "ch", 'word': "cherry"},
            {'imageId': "fish", 'choices': ["sh", "ch"], 'answer': "sh", 'word': "fish"}
          ]
        },
        {
          'type': 'instruction',
          'text': "Write in 'sh' or 'ch' to finish each word!"
        },
        {
          'type': 'fill-in-digraph',
          'entries': [
            {'imageId': "chalk", 'partial': "__alk", 'answer': "ch", 'word': "chalk"},
            {'imageId': "shell", 'partial': "__ell", 'answer': "sh", 'word': "shell"},
            {'imageId': "chair", 'partial': "__air", 'answer': "ch", 'word': "chair"},
            {'imageId': "ship", 'partial': "__ips", 'answer': "sh", 'word': "ships"}
          ]
        }
      ]
    },
    // A25
    {
      'id': 'page-28',
      'type': 'activity',
      'activityLabel': 'A25',
      'title': 'The Two Th Sounds',
      'layout': 'lesson-with-sort',
      'teacherNotes': 'Hard TH (voiced): they, the, this, that, there, father, mother. Soft TH (unvoiced): bath, math, moth, path, thorn, birthday. Put hand on throat — voiced TH vibrates.',
      'answerKey': 'A25 Hard th: they, father, this, there | Soft th: bath, math, thorn, birthday',
      'content': [
        {
          'type': 'lesson-text',
          'paragraphs': [
            "The digraph 'th' makes two sounds, one hard and one soft. See if you can tell them apart!"
          ]
        },
        {
          'type': 'comparison-table-vertical',
          'rows': [
            {'label': "Hard Th Sound", 'example': "Mother", 'imageId': "mother", 'explanation': "Voiced /th/ — tongue between teeth, voice on"},
            {'label': "Soft Th Sound", 'example': "Moth", 'imageId': "moth", 'explanation': "Unvoiced /th/ — tongue between teeth, voice off"}
          ]
        },
        {
          'type': 'instruction',
          'text': "Sort These Words:"
        },
        {
          'type': 'two-column-sort',
          'leftLabel': 'Hard Th',
          'rightLabel': 'Soft Th',
          'options': ["bath", "they", "father", "math", "thorn", "this", "birthday", "there"]
        }
      ]
    },
    // A26
    {
      'id': 'page-29',
      'type': 'activity',
      'activityLabel': 'A26',
      'title': 'Find The Clusters!',
      'subtitle': "Read these sentences and circle or underline all the digraphs and trigraphs.",
      'layout': 'sentence-find',
      'teacherNotes': 'Real sentences help students see digraphs in context. This bridges from isolated practice to reading. Circle all instances — some sentences have multiple digraphs.',
      'answerKey': 'A26: birthday(th), month(th) | eight(igh) | There(th), chocolate(ch), cherries(ch)',
      'content': [
        {
          'type': 'example-box',
          'imageId': 'ship',
          'text': "On a ship, you can knit warm sweaters, watch for whales, or use a knife to carve wood.",
          'note': "Underlined: ship, knit, sweaters, watch, whales, knife, wood",
          'answers': ["ship", "knit", "sweaters", "watch", "whales", "knife", "wood"]
        },
        {
          'type': 'sentence-find-numbered',
          'sentences': [
            {'number': 1, 'imageId': 'calendar', 'text': "My birthday is in a month!", 'answers': ["birthday", "month"]},
            {'number': 2, 'imageId': 'cake', 'text': "I am going to be eight.", 'answers': ["eight"]},
            {'number': 3, 'imageId': 'ice_cream', 'text': "There will be chocolate ice cream with cherries.", 'answers': ["There", "chocolate", "cherries"]}
          ]
        }
      ]
    },
    // A27
    {
      'id': 'page-30',
      'type': 'activity',
      'activityLabel': 'A27',
      'title': 'Shooting Stars',
      'subtitle': "Fill in the digraph or trigraph to finish the word.",
      'layout': 'fill-in-star',
      'teacherNotes': 'Students complete words using the four digraph/trigraph options in the word bank. Bright = igh, Catch = tch, Wish = sh, Blue = ue.',
      'answerKey': 'A27: Blue, Wish, Bright, Catch',
      'content': [
        {
          'type': 'word-bank-box',
          'words': ["igh", "ue", "sh", "tch"]
        },
        {
          'type': 'star-fill-activity',
          'entries': [
            {'partial': "Bl", 'answer': "ue", 'word': "Blue"},
            {'partial': "Wi", 'answer': "sh", 'word': "Wish"},
            {'partial': "Br", 'answer': "igh", 'word': "Bright"},
            {'partial': "Ca", 'answer': "tch", 'word': "Catch"}
          ]
        }
      ]
    },
    // A28
    {
      'id': 'page-31',
      'type': 'activity',
      'activityLabel': 'A28',
      'title': 'What Are Consonant Blends?',
      'layout': 'lesson-with-spot',
      'teacherNotes': 'Unlike digraphs (2 letters = 1 sound), consonant blends have 2 letters that each keep their own sound (b-l, s-t, f-r).',
      'content': [
        {
          'type': 'lesson-text',
          'paragraphs': [
            "In a consonant blend, multiple consonants work together to form part of a word.",
            "We've already learned about digraphs, like 'sh' and 'th,' which can bring multiple consonants together to make one sound.",
            "A consonant blend is different because each letter makes its own sound.",
            "Read the words below out loud, a few times so you can hear the difference.",
            "In chew there are only two sounds, /ch/ and /oo/, because it is made up of digraphs! Repeat the word and see how 'c' and 'h' become 'ch'.",
            "In flew there are three sounds, /f/, /l/, and /oo/! 'Ew' is still a digraph, but 'f' and 'l' each make their own sounds. This is how you can tell it is a consonant blend."
          ]
        },
        {
          'type': 'instruction',
          'text': "Spot The Blends"
        },
        {
          'type': 'sentence-find-numbered',
          'sentences': [
            {'number': 0, 'imageId': 'bubbles', 'text': "I can get clean.", 'answers': ["clean"]},
            {'number': 1, 'imageId': 'scarf', 'text': "Today I wore a scarf and a shirt with stripes.", 'answers': ["scarf", "stripes"]},
            {'number': 2, 'imageId': 'frog', 'text': "I love frogs, but not snakes.", 'answers': ["frogs", "snakes"]},
            {'number': 3, 'imageId': 'slide', 'text': "I like to play! I slide, climb trees, and splash around.", 'answers': ["play", "slide", "climb", "trees", "splash"]}
          ]
        }
      ]
    },
    // A29
    {
      'id': 'page-32',
      'type': 'activity',
      'activityLabel': 'A29',
      'title': 'Practicing Consonant Blends',
      'layout': 'reference-trace-grid',
      'teacherNotes': 'Reference page for consonant blends. Students trace the blend in each word. Organized by blend family: bl/br, cl/cr, dr/fr, gl/gr, pl/pr, sl/sm, sp/st/str/spl.',
      'content': [
        {
          'type': 'instruction',
          'text': "Practice some common blends!"
        },
        {
          'type': 'blend-example-grid',
          'columns': 4,
          'entries': [
            {'word': "Block", 'blend': "bl", 'imageId': "blocks"},
            {'word': "Branch", 'blend': "br", 'imageId': "branch"},
            {'word': "Clam", 'blend': "cl", 'imageId': "clam"},
            {'word': "Crow", 'blend': "cr", 'imageId': "crow"},
            {'word': "Dragon", 'blend': "dr", 'imageId': "dragon"},
            {'word': "Fruit", 'blend': "fr", 'imageId': "fruit"},
            {'word': "Glitter", 'blend': "gl", 'imageId': "glitter"},
            {'word': "Grapes", 'blend': "gr", 'imageId': "grapes"},
            {'word': "Plane", 'blend': "pl", 'imageId': "plane"},
            {'word': "Pretzel", 'blend': "pr", 'imageId': "pretzel"},
            {'word': "Slug", 'blend': "sl", 'imageId': "slug"},
            {'word': "Smoke", 'blend': "sm", 'imageId': "smoke"},
            {'word': "Space", 'blend': "sp", 'imageId': "space"},
            {'word': "Stove", 'blend': "st", 'imageId': "stove"},
            {'word': "Strong", 'blend': "str", 'imageId': "strong"},
            {'word': "Splash", 'blend': "spl", 'imageId': "splash"}
          ]
        }
      ]
    },
    // A30
    {
      'id': 'page-33',
      'type': 'activity',
      'activityLabel': 'A30',
      'title': 'A Blend Or A Digraph?',
      'layout': 'identify-sort',
      'teacherNotes': 'Critical distinction: BLEND = each letter makes its own sound (br, gr, sl, dr, tw, pl, scr). DIGRAPH = letters combined into ONE sound (ch, sh, th, wh, ph).',
      'content': [
        {
          'type': 'instruction',
          'text': "Sound out each word! Now look just at the underlined cluster — does it make one sound, or does each letter in the group make its own sound?"
        },
        {
          'type': 'identify-grid',
          'columns': 3,
          'entries': [
            {'word': "brag", 'underlined': "br", 'imageId': "brag", 'answer': "blend"},
            {'word': "chips", 'underlined': "ch", 'imageId': "chips", 'answer': "digraph"},
            {'word': "scrape", 'underlined': "scr", 'imageId': "scrape", 'answer': "blend"},
            {'word': "shave", 'underlined': "sh", 'imageId': "shave", 'answer': "digraph"},
            {'word': "grip", 'underlined': "gr", 'imageId': "grip", 'answer': "blend"},
            {'word': "thump", 'underlined': "th", 'imageId': "thump", 'answer': "digraph"},
            {'word': "slide", 'underlined': "sl", 'imageId': "slide2", 'answer': "blend"},
            {'word': "drove", 'underlined': "dr", 'imageId': "car", 'answer': "blend"},
            {'word': "when", 'underlined': "wh", 'imageId': "clock", 'answer': "digraph"},
            {'word': "phone", 'underlined': "ph", 'imageId': "phone", 'answer': "digraph"},
            {'word': "twig", 'underlined': "tw", 'imageId': "twig", 'answer': "blend"},
            {'word': "plate", 'underlined': "pl", 'imageId': "plate", 'answer': "blend"}
          ]
        }
      ]
    },
    // A31
    {
      'id': 'page-34',
      'type': 'activity',
      'activityLabel': 'A31',
      'title': 'Pick A Balloon',
      'layout': 'balloon-choice',
      'teacherNotes': 'Students must sound out the complete word using each blend option to determine which one makes a real word. Encourage students to try both options aloud.',
      'content': [
        {
          'type': 'instruction',
          'text': "Each of these balloon bunches is missing a consonant blend! Color in the right balloon to finish the word."
        },
        {
          'type': 'balloon-activity',
          'rows': [
            {
              'blendChoices': ["fl", "sh"],
              'endingBalloons': ["i", "n", "g"],
              'answer': "fl",
              'word': "fling"
            },
            {
              'blendChoices': ["tw", "dr"],
              'endingBalloons': ["a", "g", "o", "n"],
              'answer': "dr",
              'word': "dragon"
            },
            {
              'blendChoices': ["scr", "pr"],
              'endingBalloons': ["i", "m", "e"],
              'answer': "pr",
              'word': "prime"
            },
            {
              'blendChoices': ["cl", "tr"],
              'endingBalloons': ["a", "v", "e", "l"],
              'answer': "tr",
              'word': "travel"
            },
            {
              'blendChoices': ["st", "sp"],
              'endingBalloons': ["o", "r", "k"],
              'answer': "st",
              'word': "stork"
            }
          ]
        }
      ]
    },
    // A32
    {
      'id': 'page-35',
      'type': 'activity',
      'activityLabel': 'A32',
      'title': 'Consonant Blend Band-Aids',
      'layout': 'matching-connect',
      'teacherNotes': 'The "broken words" metaphor is engaging. Students repair words by matching the correct blend. Emphasize that the blend must sound natural when combined with the fragment.',
      'answerKey': 'A32: skunk, wasp, slab, sheep, ugly, fruit',
      'content': [
        {
          'type': 'instruction',
          'text': "Oh no! These words are broken. Use the right band-aid to fix them."
        },
        {
          'type': 'bandaid-matching',
          'blends': ["sk", "sl", "fr", "gl", "cr", "sp"],
          'fragments': [
            {'partial': "unk", 'answer': "sk", 'word': "skunk"},
            {'partial': "wa_", 'answer': "sp", 'word': "wasp"},
            {'partial': "ab", 'answer': "sl", 'word': "slab"},
            {'partial': "eep", 'answer': "sl", 'word': "sheep"},
            {'partial': "u_y", 'answer': "gl", 'word': "ugly"},
            {'partial': "uit", 'answer': "fr", 'word': "fruit"}
          ]
        }
      ]
    },
    // A33
    {
      'id': 'page-36',
      'type': 'activity',
      'activityLabel': 'A33',
      'title': 'Finish The Word',
      'layout': 'picture-fill-in',
      'teacherNotes': 'Students identify the consonant blend needed from the image. Encourage them to say the word aloud first, isolate the first two sounds, then write the blend.',
      'content': [
        {
          'type': 'instruction',
          'text': "Fill in the consonant blend."
        },
        {
          'type': 'picture-blend-fill',
          'columns': 3,
          'entries': [
            {'imageId': "gloves", 'partial': "__ove", 'answer': "gl", 'word': "glove"},
            {'imageId': "sled", 'partial': "__ed", 'answer': "sl", 'word': "sled"},
            {'imageId': "clam2", 'partial': "__am", 'answer': "cl", 'word': "clam"},
            {'imageId': "table", 'partial': "ta__e", 'answer': "bl", 'word': "table"},
            {'imageId': "brain", 'partial': "__ain", 'answer': "br", 'word': "brain"},
            {'imageId': "agree", 'partial': "a__ee", 'answer': "gr", 'word': "agree"},
            {'imageId': "flower2", 'partial': "__ower", 'answer': "fl", 'word': "flower"},
            {'imageId': "snail", 'partial': "__ail", 'answer': "sn", 'word': "snail"},
            {'imageId': "sparkle", 'partial': "__inkle", 'answer': "tw", 'word': "twinkle"}
          ]
        }
      ]
    },
    // A34
    {
      'id': 'page-37',
      'type': 'activity',
      'activityLabel': 'A34',
      'title': 'Defining Diphthongs',
      'layout': 'lesson-with-examples',
      'teacherNotes': 'Diphthongs are vowel glides — your mouth moves from one position to another within one syllable. Key diphthongs: oi/oy, ou/ow, oo (two sounds), aw/au, ew.',
      'content': [
        {
          'type': 'lesson-text',
          'paragraphs': [
            "Sometimes, two vowels next to each other work together to make a diphthong. A diphthong is just one syllable! It starts with one vowel sound, and moves into another.",
            'Look at the word "boy." The sound made by "oy" starts as a long /o/ sound, but moves into a long /ee/ sound. Say the words "boy" and "join" aloud, and hear the same sound! Those are examples of the same diphthong spelled two different ways, "oy" and "oi."',
            "Read through the examples below aloud, and try to identify which short and long vowels are being voiced in each underlined diphthong, even when spelled differently."
          ]
        },
        {
          'type': 'sentence-table',
          'rows': [
            {
              'text': "The author wrote a book on law.",
              'imageId': "book2",
              'diphthongs': ["aw", "oo"]
            },
            {
              'text': "The cow makes a loud moo.",
              'imageId': "cow",
              'diphthongs': ["ow", "oo"]
            },
            {
              'text': "Now we can go to my house.",
              'imageId': "house2",
              'diphthongs': ["ow", "ou"]
            }
          ]
        },
        {
          'type': 'rule-box',
          'text': 'Speaking of moos, the diphthong "oo" can make two different sounds out of the same spelling! Read the sentence aloud and notice the difference between the sounds.'
        },
        {
          'type': 'example-sentence',
          'text': "I put my foot into the boot.",
          'imageId': "boot"
        }
      ]
    },
    // A35
    {
      'id': 'page-38',
      'type': 'activity',
      'activityLabel': 'A35',
      'title': 'Diphthong Tracing',
      'layout': 'tracing-table',
      'teacherNotes': 'Students trace each diphthong to reinforce the spelling pattern. Note the aw/au pair (same sound), oi/oy pair (same sound), ou/ow pair (same sound), and oo (single spelling, two sounds).',
      'content': [
        {
          'type': 'instruction',
          'text': "Trace the diphthongs."
        },
        {
          'type': 'diphthong-trace-table',
          'columns': 2,
          'rows': [
            {'word': "straw", 'diphthong': "aw", 'imageId': "straw"},
            {'word': "applause", 'diphthong': "au", 'imageId': "applause"},
            {'word': "stew", 'diphthong': "ew", 'imageId': "stew"},
            {'word': "kazoo", 'diphthong': "oo", 'imageId': "kazoo"},
            {'word': "coin", 'diphthong': "oi", 'imageId': "coin"},
            {'word': "joy", 'diphthong': "oy", 'imageId': "joy"},
            {'word': "plow", 'diphthong': "ow", 'imageId': "plow"},
            {'word': "cloud", 'diphthong': "ou", 'imageId': "cloud"}
          ]
        }
      ]
    },
    // A36
    {
      'id': 'page-39',
      'type': 'activity',
      'activityLabel': 'A36',
      'title': 'Find the Diphthongs',
      'subtitle': 'Read through these sentences and mark all the diphthongs you can find.',
      'layout': 'sentence-find-grid',
      'teacherNotes': 'Context practice for diphthongs. Multiple diphthongs per sentence.',
      'content': [
        {
          'type': 'example-sentence',
          'text': 'Last August I saw a clown.',
          'diphthongsMarked': ['au (August)', 'aw (saw)', 'ow (clown)'],
        },
        {
          'type': 'sentence-find-grid',
          'columns': 2,
          'sentences': [
            {
              'imageId': 'owl',
              'text': 'I have a toy owl.',
              'answers': ['oy (toy)', 'ow (owl)'],
              'highlight': ['toy', 'owl'],
            },
            {
              'imageId': 'stew',
              'text': 'I will boil some stew for dinner.',
              'answers': ['oi (boil)', 'ew (stew)'],
              'highlight': ['boil', 'stew'],
            },
            {
              'imageId': 'fountain',
              'text': 'The noise of the fountain is soothing.',
              'answers': ['oi (noise)', 'ou (fountain)', 'oo (soothing)'],
              'highlight': ['noise', 'fountain', 'soothing'],
            },
            {
              'imageId': 'bowling',
              'text': 'I enjoy bowling! My mother taught me how to play.',
              'answers': ['oy (enjoy)', 'ow (bowling)', 'ow (how)'],
              'highlight': ['enjoy', 'bowling', 'how'],
            },
          ],
        },
      ],
    },
    // A37
    {
      'id': 'page-40',
      'type': 'activity',
      'activityLabel': 'A37',
      'title': 'Broken Hearts',
      'subtitle': 'Link the incomplete word to its missing diphthong!',
      'layout': 'broken-heart-match',
      'teacherNotes': 'Matching activity connecting diphthong spelling patterns to words with missing vowels.',
      'content': [
        {
          'type': 'heart-matching',
          'leftSide': ['ou', 'oo', 'aw', 'ow'],
          'rightSide': [
            {'partial': 'r_m', 'answer': 'oo', 'word': 'room'},
            {'partial': 'h_k', 'answer': 'oo', 'word': 'hook'},
            {'partial': 's_r', 'answer': 'aw', 'word': 'saw'},
            {'partial': 'gr_', 'answer': 'ow', 'word': 'grow'},
          ],
        },
      ],
    },
    // A38
    {
      'id': 'page-41',
      'type': 'activity',
      'activityLabel': 'A38',
      'title': 'Build the Word',
      'subtitle': 'Write in the diphthong to finish the word!',
      'layout': 'block-build',
      'teacherNotes': 'Building block metaphor reinforces that diphthongs are the core vowel block holding the word together.',
      'content': [
        {
          'type': 'lego-block-activity',
          'groups': [
            {'given': ['c'], 'given2': [], 'imageId': 'cow', 'answer': 'ow', 'word': 'cow'},
            {'given': ['ar'], 'given2': ['nd'], 'imageId': 'recycle', 'answer': 'ou', 'word': 'around'},
            {'given': ['fl'], 'given2': ['er'], 'imageId': 'flower', 'answer': 'ow', 'word': 'flower'},
            {'given': ['sw'], 'given2': ['p'], 'imageId': 'bird', 'answer': 'oo', 'word': 'swoop'},
            {'given': ['cr'], 'given2': ['l'], 'imageId': 'bear', 'answer': 'aw', 'word': 'crawl'},
          ],
        },
      ],
    },
    // A39
    {
      'id': 'page-42',
      'type': 'activity',
      'activityLabel': 'A39',
      'title': 'Hello! My name is...',
      'subtitle': 'Name each picture with a diphthong word.',
      'layout': 'dual-activity',
      'teacherNotes': 'Students name pictures and solve riddles. All answers contain diphthongs.',
      'content': [
        {
          'type': 'picture-name-grid',
          'columns': 2,
          'entries': [
            {'imageId': 'paw', 'blanks': 3, 'answer': 'paw'},
            {'imageId': 'toy', 'blanks': 3, 'answer': 'toy'},
            {'imageId': 'soup', 'blanks': 4, 'answer': 'soup'},
            {'imageId': 'foot', 'blanks': 4, 'answer': 'foot'},
          ],
        },
        {
          'type': 'section-divider',
          'label': 'Diphthong Guessing Game',
        },
        {
          'type': 'riddle-fill',
          'instruction': 'Write in the word (with a diphthong) that answers each clue.',
          'riddles': [
            {'clue': "If you're really happy, you might jump for ___ ___ ___!", 'answer': 'joy'},
            {'clue': "Someone might say 'shhh' if you make too much ___ ___ ___ ___.", 'answer': 'noise'},
            {'clue': "Before you swallow food, you have to ___ ___ ___ ___ it.", 'answer': 'chew'},
            {'clue': "One way to make art is to ___ ___ ___ ___ a picture with crayons.", 'answer': 'draw'},
          ],
        },
      ],
    },
    // A40
    {
      'id': 'page-43',
      'type': 'activity',
      'activityLabel': 'A40',
      'title': 'How To Put A Word Together',
      'subtitle': "Let's apply some letters!",
      'layout': 'glued-sounds-intro',
      'teacherNotes': 'Glued sounds (welded sounds): am, an, ang, ing, ong, ung, ank, ink, onk, unk, all.',
      'content': [
        {
          'type': 'glued-sounds-grid',
          'columns': 2,
          'entries': [
            {'word': 'mall', 'gluedSound': 'all', 'imageId': 'mall'},
            {'word': 'fan', 'gluedSound': 'an', 'imageId': 'fan'},
            {'word': 'jam', 'gluedSound': 'am', 'imageId': 'jam'},
            {'word': 'bang', 'gluedSound': 'ang', 'imageId': 'explosion'},
            {'word': 'swing', 'gluedSound': 'ing', 'imageId': 'swing'},
            {'word': 'long', 'gluedSound': 'ong', 'imageId': 'snake'},
            {'word': 'lung', 'gluedSound': 'ung', 'imageId': 'lungs'},
            {'word': 'bank', 'gluedSound': 'ank', 'imageId': 'bank'},
            {'word': 'wink', 'gluedSound': 'ink', 'imageId': 'wink'},
            {'word': 'monk', 'gluedSound': 'onk', 'imageId': 'monk'},
          ],
        },
      ],
    },
    // A41
    {
      'id': 'page-44',
      'type': 'activity',
      'activityLabel': 'A41',
      'title': 'Glued Sounds Color Sort',
      'layout': 'color-sort-grid',
      'teacherNotes': 'Glued sound sorting activity. Students color-code words by their glued sound ending.',
      'content': [
        {
          'type': 'color-code-key',
          'codes': [
            {'label': 'am', 'color': 'Red'},
            {'label': 'an', 'color': 'Blue'},
            {'label': 'ink', 'color': 'Green'},
            {'label': 'unk', 'color': 'Purple'},
          ],
        },
        {
          'type': 'word-color-sort-grid',
          'columns': 4,
          'words': [
            {'word': 'hand', 'gluedSound': 'an', 'answer': 'Blue'},
            {'word': 'think', 'gluedSound': 'ink', 'answer': 'Green'},
            {'word': 'sink', 'gluedSound': 'ink', 'answer': 'Green'},
            {'word': 'stand', 'gluedSound': 'an', 'answer': 'Blue'},
            {'word': 'trunk', 'gluedSound': 'unk', 'answer': 'Purple'},
            {'word': 'camera', 'gluedSound': 'am', 'answer': 'Red'},
            {'word': 'skunk', 'gluedSound': 'unk', 'answer': 'Purple'},
            {'word': 'champ', 'gluedSound': 'am', 'answer': 'Red'},
            {'word': 'can', 'gluedSound': 'an', 'answer': 'Blue'},
            {'word': 'brand', 'gluedSound': 'an', 'answer': 'Blue'},
            {'word': 'man', 'gluedSound': 'an', 'answer': 'Blue'},
            {'word': 'wink', 'gluedSound': 'ink', 'answer': 'Green'},
            {'word': 'fancy', 'gluedSound': 'an', 'answer': 'Blue'},
            {'word': 'flunk', 'gluedSound': 'unk', 'answer': 'Purple'},
            {'word': 'bunk', 'gluedSound': 'unk', 'answer': 'Purple'},
            {'word': 'lamp', 'gluedSound': 'am', 'answer': 'Red'},
            {'word': 'sunk', 'gluedSound': 'unk', 'answer': 'Purple'},
            {'word': 'ham', 'gluedSound': 'am', 'answer': 'Red'},
            {'word': 'ramp', 'gluedSound': 'am', 'answer': 'Red'},
            {'word': 'land', 'gluedSound': 'an', 'answer': 'Blue'},
            {'word': 'blink', 'gluedSound': 'ink', 'answer': 'Green'},
            {'word': 'pink', 'gluedSound': 'ink', 'answer': 'Green'},
            {'word': 'tan', 'gluedSound': 'an', 'answer': 'Blue'},
            {'word': 'chunk', 'gluedSound': 'unk', 'answer': 'Purple'},
          ],
        },
        {
          'type': 'free-response-section',
          'instruction': 'Use your colors to write another word for each sound:',
          'prompts': ['am', 'ink', 'an', 'unk'],
        },
      ],
    },
    // A42
    {
      'id': 'page-45',
      'type': 'activity',
      'activityLabel': 'A42',
      'title': 'What Is A Prefix?',
      'layout': 'lesson-with-activity',
      'teacherNotes': 'Key prefixes: re- (again), un- (not), dis- (not/opposite), non- (not), mis- (wrongly).',
      'content': [
        {
          'type': 'lesson-text',
          'paragraphs': [
            "A prefix is a group of letters that gets added on to the beginning of a word. They change the meaning of the word you add them to, which is called the root word.",
          ],
        },
        {
          'type': 'example-box',
          'imageId1': 'thumbsup',
          'imageId2': 'thumbsdown',
          'text': "Let's look at the verb 'like.' The opposite of 'like' is 'dislike.' It contains the whole word 'like,' but it means something totally different! This is because the prefix 'dis' is negative.",
          'note': "'dis' is a negative prefix",
        },
        {
          'type': 'word-examples',
          'instruction': 'Here are some examples of words that have prefixes:',
          'words': [
            {'word': 'redo', 'prefix': 're'},
            {'word': 'misbehave', 'prefix': 'mis'},
            {'word': 'unlock', 'prefix': 'un'},
          ],
        },
        {
          'type': 'strip-prefix',
          'instruction': 'Take the prefix off of some of these words, and see what you are left with:',
          'entries': [
            {'word': 'reread', 'root': 'read', 'prefix': 're'},
            {'word': 'unhappy', 'root': 'happy', 'prefix': 'un'},
            {'word': 'nonstick', 'root': 'stick', 'prefix': 'non'},
            {'word': 'inequality', 'root': 'equality', 'prefix': 'in'},
          ],
        },
      ],
    },
    // A43
    {
      'id': 'page-46',
      'type': 'activity',
      'activityLabel': 'A43',
      'title': 'Change It Up!',
      'subtitle': 'Write each word with the prefix provided and read its new definition.',
      'layout': 'prefix-build',
      'teacherNotes': 'Students combine prefixes with root words. The definition is given so students understand the meaning change.',
      'content': [
        {
          'type': 'prefix-equation',
          'entries': [
            {'prefix': 'pre', 'root': 'cooked', 'definition': 'cooked in advance.', 'answer': 'precooked'},
            {'prefix': 'pre', 'root': 'judged', 'definition': 'judged in advance.', 'answer': 'prejudged'},
            {'prefix': 'tri', 'root': 'angle', 'definition': 'three angles.', 'answer': 'triangle'},
            {'prefix': 'non', 'root': 'fiction', 'definition': 'not fiction.', 'answer': 'nonfiction'},
            {'prefix': 'over', 'root': 'eat', 'definition': 'eat too much.', 'answer': 'overeat'},
          ],
        },
      ],
    },
    // A44
    {
      'id': 'page-47',
      'type': 'activity',
      'activityLabel': 'A44',
      'title': 'All The Nots',
      'subtitle': 'Underline the parts of these words that act as negative prefixes!',
      'layout': 'underline-activity',
      'teacherNotes': 'Five not-prefixes: un-, im-, in-, non-, mis-.',
      'content': [
        {
          'type': 'example-box',
          'word': 'irregular',
          'explanation': 'Means "not regular." When you take away the prefix, you get "regular!"',
        },
        {
          'type': 'word-grid-underline',
          'columns': 3,
          'entries': [
            {'word': 'unusual', 'prefix': 'un'},
            {'word': 'impossible', 'prefix': 'im'},
            {'word': 'injustice', 'prefix': 'in'},
            {'word': 'nonsense', 'prefix': 'non'},
            {'word': 'misunderstand', 'prefix': 'mis'},
            {'word': 'unhappy', 'prefix': 'un'},
            {'word': 'mistake', 'prefix': 'mis'},
            {'word': 'nonfiction', 'prefix': 'non'},
            {'word': 'informal', 'prefix': 'in'},
          ],
        },
        {
          'type': 'free-response-section',
          'instruction': 'Rewrite all of the prefixes you found:',
          'prompts': ['un', 'im', 'in', 'non', 'mis'],
        },
      ],
    },
    // A45
    {
      'id': 'page-48',
      'type': 'activity',
      'activityLabel': 'A45',
      'title': 'Reread It',
      'layout': 'prefix-fill',
      'teacherNotes': 'The re- prefix means "again." Examples: rerun, rebuild, reopen, refill, reuse.',
      'content': [
        {
          'type': 'lesson-text',
          'paragraphs': [
            'Re- is a prefix that means "again," and sometimes means "over and over." Add re- to each root word to fit the definition provided.',
          ],
        },
        {
          'type': 'example-with-answer',
          'definition': 'To wind again.',
          'answer': 'rewind',
        },
        {
          'type': 'fill-in-blanks',
          'entries': [
            {'definition': 'To play again.', 'answer': 'replay'},
            {'definition': 'To do again.', 'answer': 'redo'},
            {'definition': 'To search over and over.', 'answer': 'research'},
            {'definition': 'To tie again.', 'answer': 'retie'},
            {'definition': 'To tell again.', 'answer': 'retell'},
          ],
        },
        {
          'type': 'open-ended-prompt',
          'text': 'What are some other things you can do over and over again? Try coming up with verbs and adding re- to the beginning. Is it a word you have heard before?',
        },
      ],
    },
    // A46
    {
      'id': 'page-49',
      'type': 'activity',
      'activityLabel': 'A46',
      'title': 'What Is A Suffix?',
      'layout': 'lesson-with-activity',
      'teacherNotes': 'Key suffixes: -s/-es (plural), -ing, -ed, -er, -est, -ful, -less, -ly, -able, -tion.',
      'content': [
        {
          'type': 'lesson-text',
          'paragraphs': [
            "A suffix is a group of letters that gets added on to the end of a word. They change the meaning of the root word, just like a prefix.",
          ],
        },
        {
          'type': 'example-box',
          'imageId1': 'fox',
          'imageId2': 'foxes',
          'text': "Let's look at the verb 'fox.' If you have more than one fox, that's 'foxes.' It contains the word 'fox,' but it means something new! This is because the suffix 'es' makes something plural (more than one).",
          'note': "'es' makes the word plural",
        },
        {
          'type': 'word-examples',
          'instruction': 'Here are some examples of words that have suffixes:',
          'words': [
            {'word': 'jumping', 'suffix': 'ing'},
            {'word': 'louder', 'suffix': 'er'},
            {'word': 'played', 'suffix': 'ed'},
          ],
        },
        {
          'type': 'strip-suffix',
          'instruction': 'Take the suffix off of some of these words, and see what you are left with:',
          'entries': [
            {'word': 'helpful', 'root': 'help', 'suffix': 'ful'},
            {'word': 'slowly', 'root': 'slow', 'suffix': 'ly'},
            {'word': 'bravest', 'root': 'brave', 'suffix': 'st'},
            {'word': 'sizeable', 'root': 'size', 'suffix': 'able'},
          ],
        },
      ],
    },
    // A47
    {
      'id': 'page-50',
      'type': 'activity',
      'activityLabel': 'A47',
      'title': 'New Words!',
      'subtitle': 'Write each word with the suffix provided and read its new definition.',
      'layout': 'suffix-build',
      'teacherNotes': 'Students combine root words with suffixes.',
      'content': [
        {
          'type': 'suffix-equation',
          'entries': [
            {'root': 'box', 'suffix': 'es', 'definition': 'more than one box.', 'answer': 'boxes'},
            {'root': 'cold', 'suffix': 'est', 'definition': 'the most cold.', 'answer': 'coldest'},
            {'root': 'point', 'suffix': 'ed', 'definition': 'pointing in the past tense.', 'answer': 'pointed'},
            {'root': 'fear', 'suffix': 'less', 'definition': 'without fear.', 'answer': 'fearless'},
            {'root': 'meaning', 'suffix': 'ful', 'definition': 'full of meaning.', 'answer': 'meaningful'},
          ],
        },
      ],
    },
  ];
}
