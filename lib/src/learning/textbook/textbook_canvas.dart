import 'package:flutter/material.dart';
import 'dart:async';
import 'textbook_database.dart';
import 'components/teacher_overlay.dart';
import 'components/label_tag.dart';
import 'components/text_block.dart';
import 'components/phonics_box.dart';
import 'components/phonic_fox_narrator.dart';
import 'components/vowel_consonant_word.dart';
import 'components/vector_graphic.dart';
import 'components/vector_graphic.dart';
import 'components/vector_graphic.dart';
import 'components/tracing_card.dart';
import 'components/daisy_chain.dart';
import 'components/vector_graphic.dart';
import 'components/tracing_card.dart';
import 'components/daisy_chain.dart';
import 'components/charm_bracelet.dart';
import 'components/multi_fill_in_card.dart';
import 'components/two_column_sort.dart';
import 'components/color_code_activity.dart';
import 'components/vowel_comparison_table.dart';
import 'components/identify_sort.dart';
import 'components/image_write_in.dart';
import 'components/interactive_vowel_stack.dart';
import 'components/train_fill_in.dart';
import 'components/color_by_code_fishing.dart';
import 'components/word_circle_grid.dart';
import 'components/bossy_r_comparison_table.dart';
import 'components/picture_fill_in_grid.dart';
import 'components/riddle_cvc.dart';
import 'components/letter_drop_target.dart';
import 'components/letter_bank.dart';
import 'components/hint_overlay.dart';
import 'components/pronunciation_button.dart';
import 'components/particle_reward.dart';
import 'components/digraph_example_grid.dart';
import 'components/word_selection_list.dart';
import 'components/example_box.dart';
import 'components/trigraph_examples.dart';
import 'components/sentence_find.dart';
import 'components/circle_choice_grid.dart';
import 'components/comparison_table_vertical.dart';
import 'components/star_fill_activity.dart';
import 'utils/responsive_helper.dart';

class TextbookCanvas extends StatefulWidget {
  final bool teacherModeActive;
  final String? initialPageId;

  const TextbookCanvas({
    Key? key,
    required this.teacherModeActive,
    this.initialPageId,
  }) : super(key: key);

  @override
  State<TextbookCanvas> createState() => _TextbookCanvasState();
}

class _TextbookCanvasState extends State<TextbookCanvas> {
  int _currentPageIndex = 0;
  Timer? _hintTimer;
  bool _showHint = false;
  bool _showCelebration = false;
  final Set<String> _usedLetters = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialPageId != null) {
      final index = TextbookDatabase.pages.indexWhere((p) => p['id'] == widget.initialPageId);
      if (index != -1) {
        _currentPageIndex = index;
      }
    }
    _resetHintTimer();
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    super.dispose();
  }

  void _resetHintTimer() {
    _hintTimer?.cancel();
    setState(() => _showHint = false);

    // Get current page type to prevent hints on Cover/Welcome screens
    final currentPageLayout = TextbookDatabase.pages[_currentPageIndex]['layout'];
    if (currentPageLayout == 'cover' || currentPageLayout == 'welcome') {
      return;
    }

    _hintTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() => _showHint = true);
      }
    });
  }

  void _nextPage() {
    if (_currentPageIndex < TextbookDatabase.pages.length - 1) {
      setState(() {
        _currentPageIndex++;
        _usedLetters.clear();
      });
      _resetHintTimer();
    }
  }

  void _previousPage() {
    if (_currentPageIndex > 0) {
      setState(() {
        _currentPageIndex--;
        _usedLetters.clear();
      });
      _resetHintTimer();
    }
  }

  List<String> _getLetterBankForPage(Map<String, dynamic> page) {
    if (page['layout'] == 'lesson-with-table-and-activity') {
      return ['ll', 'ss', 'tt', 'ff', 'mm'];
    }
    if (page['layout'] == 'tracing-grid') {
      return ['c', 'g', 'n', 'm', 't']; // Lowercase to match drop target
    }
    if (page['layout'] == 'matching-game') {
      return ['b', 'm', 'x', 'l'];
    }
    if (page['layout'] == 'write-in-activity') {
      return ['t', 'd', 'a', 'g', 'l'];
    }
    if (page['layout'] == 'fill-in-list' || page['layout'] == 'color-choice-grid') {
      return ['r', 'l', 'M', 's', 'm', 'c', 'p', 'n', 'w', 'W', 't'];
    }
    if (page['layout'] == 'lesson-with-sort' || page['layout'] == 'lesson-with-color-sort' || page['layout'] == 'y-is-a-thief-sort') {
      return []; // Sorting activities have their own word banks
    }
    return [];
  }

  String _getHintForPage(Map<String, dynamic> page) {
    if (page['layout'] == 'lesson-with-table-and-activity') {
      return 'Look closely at the double letters!';
    }
    if (page['layout'] == 'tracing-grid') {
      return 'Trace the letter that matching the starting sound.';
    }
    if (page['layout'] == 'matching-game') {
      return 'Find the missing flower to complete the word chain.';
    }
    if (page['layout'] == 'write-in-activity') {
      return 'Say the word out loud to hear the missing sound.';
    }
    if (page['layout'] == 'fill-in-list') {
      return 'Use the picture to help you guess the missing sounds.';
    }
    if (page['layout'] == 'circle-and-fill') {
      return 'Say the word out loud. Does it start like a snake /sh/ or a train /ch/?';
    }
    if (page['layout'] == 'sentence-find' || page['layout'] == 'lesson-with-find-activity') {
      return 'Look for letters working together! Remember, some sounds need 2 or 3 letters.';
    }
    if (page['layout'] == 'fill-in-star') {
      return 'Use the letters from the word bank to finish the shooting stars!';
    }
    if (page['layout'] == 'lesson-with-spot') {
      return 'Remember, in a consonant blend, you can hear BOTH consonant sounds!';
    }
    return 'Try matching the first letter of the picture!';
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = TextbookDatabase.pages[_currentPageIndex];
    final letters = _getLetterBankForPage(currentPage);

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity == null) return;
            // Swipe left (negative velocity) -> Next Page
            if (details.primaryVelocity! < -300) {
              _nextPage();
            } 
            // Swipe right (positive velocity) -> Previous Page
            else if (details.primaryVelocity! > 300) {
              _previousPage();
            }
          },
          child: SelectionArea(
            focusNode: FocusNode(canRequestFocus: false),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                image: (currentPage['activityLabel']?.toString().contains('A15') ?? false)
                  ? const DecorationImage(
                      image: AssetImage('assets/images/nursery_wall_texture.png'),
                      fit: BoxFit.cover,
                      opacity: 0.5,
                    )
                  : null,
              ),
              child: Stack(
                children: [
                  // 1. The main content layer
                  _buildPageContent(currentPage, constraints),
                  
                  // 2. Navigation arrows overlay
                  _buildNavigationOverlay(),
  
                  // 3. Letter Bank at the bottom
                  if (letters.isNotEmpty)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: LetterBank(
                        letters: letters,
                        usedLetters: _usedLetters,
                      ),
                    ),
  
                  // 4. Hint System Overlay (Conditional)
                  if (_showHint)
                    HintOverlay(
                      hintText: _getHintForPage(currentPage),
                      onHintDismissed: () => setState(() => _showHint = false),
                    ),
  
                  // 5. Celebration Overlay
                  ParticleReward(
                    trigger: _showCelebration,
                    onComplete: () => setState(() => _showCelebration = false),
                  ),
  
                  // 6. Teacher Overlay (Conditional)
                  if (widget.teacherModeActive)
                    TeacherOverlay(
                      pageData: currentPage,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _triggerCelebration() {
    setState(() => _showCelebration = true);
  }

  Widget _buildPageContent(Map<String, dynamic> page, BoxConstraints constraints) {
    final bool isSpecialPage = page['layout'] == 'cover' || page['layout'] == 'welcome';

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsiveValue(
          context: context,
          mobile: 16.0,
          tablet: 32.0,
          desktop: 64.0,
        ), 
        vertical: 24.0
      ),
      child: Column(
        children: [
          if (!isSpecialPage) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (page['activityLabel'] != null)
                  LabelTag(label: page['activityLabel'] as String),
                const SizedBox(width: 16),
                if (page['title'] != null)
                  Expanded(
                    child: TextBlock(
                      text: page['title'] as String,
                      type: TextType.h1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (!ResponsiveHelper.isMobile(context))
                  const SizedBox(width: 80), // Balance the LabelTag on larger screens only
              ],
            ),
            if (page['subtitle'] != null) ...[
              const SizedBox(height: 8),
              TextBlock(
                text: page['subtitle'] as String,
                type: TextType.h2,
                textAlign: TextAlign.center,
                color: Colors.grey.shade600,
              ),
            ],
            const SizedBox(height: 24),
          ],
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: _getLetterBankForPage(page).isNotEmpty ? 120.0 : 0.0,
              ),
              child: _buildSpecificLayout(page, constraints),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificLayout(Map<String, dynamic> page, BoxConstraints constraints) {
    if (page['layout'] == 'alphabet-grid') {
      // Mock Data for A1 Alphabet Grid based on textbook-database.js
      final alphabet = [
        {'l': 'Aa', 'icon': 'apple', 'w': 'Apple'},
        {'l': 'Bb', 'icon': 'ball', 'w': 'Ball'},
        {'l': 'Cc', 'icon': 'cake', 'w': 'Cake'},
        {'l': 'Dd', 'icon': 'dinosaur', 'w': 'Dinosaur'},
        {'l': 'Ee', 'icon': 'egg', 'w': 'Egg'},
        {'l': 'Ff', 'icon': 'fire', 'w': 'Fire'},
        {'l': 'Gg', 'icon': 'gorilla', 'w': 'Gorilla'},
        {'l': 'Hh', 'icon': 'house', 'w': 'House'},
        {'l': 'Ii', 'icon': 'igloo', 'w': 'Igloo'},
        {'l': 'Jj', 'icon': 'jello', 'w': 'Jello'},
        {'l': 'Kk', 'icon': 'kite', 'w': 'Kite'},
        {'l': 'Ll', 'icon': 'lamp', 'w': 'Lamp'},
        {'l': 'Mm', 'icon': 'milk', 'w': 'Milk'},
        {'l': 'Nn', 'icon': 'night', 'w': 'Night'},
        {'l': 'Oo', 'icon': 'octopus', 'w': 'Octopus'},
        {'l': 'Pp', 'icon': 'piano', 'w': 'Piano'},
        {'l': 'Qq', 'icon': 'queen', 'w': 'Queen'},
        {'l': 'Rr', 'icon': 'rainbow', 'w': 'Rainbow'},
        {'l': 'Ss', 'icon': 'ship', 'w': 'Ship'},
        {'l': 'Tt', 'icon': 'tractor', 'w': 'Tractor'},
        {'l': 'Uu', 'icon': 'umbrella', 'w': 'Umbrella'},
        {'l': 'Vv', 'icon': 'van', 'w': 'Van'},
        {'l': 'Ww', 'icon': 'whale', 'w': 'Whale'},
        {'l': 'Xx', 'icon': 'box', 'w': 'Box'},
        {'l': 'Yy', 'icon': 'yogurt', 'w': 'Yogurt'},
        {'l': 'Zz', 'icon': 'zipper', 'w': 'Zipper'},
      ];

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveHelper.getResponsiveGridCount(context: context, mobile: 2, tablet: 4, desktop: 4), // Wider boxes
          childAspectRatio: 2.2, // Horizontal orientation
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: alphabet.length,
        itemBuilder: (context, index) {
          final item = alphabet[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blueGrey.shade200, width: 2),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: VectorGraphic(assetName: item['icon']!, size: 64),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['l']!,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'FredokaOne',
                        ),
                      ),
                      Text(
                        item['w']!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else if (page['layout'] == 'lesson-with-examples') {
      return Column(
        children: [
          const TextBlock(
            text: "Let's look at the word \"cast\" and trace its letters:",
            type: TextType.instruction,
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 16,
            children: [
              PhonicsBox(text: 'C', isDashed: true, textColor: Colors.indigo.shade300, borderColor: Colors.indigo.shade200, backgroundColor: Colors.indigo.shade50),
              PhonicsBox(text: 'A', isDashed: true, textColor: Colors.indigo.shade300, borderColor: Colors.indigo.shade200, backgroundColor: Colors.indigo.shade50),
              PhonicsBox(text: 'S', isDashed: true, textColor: Colors.indigo.shade300, borderColor: Colors.indigo.shade200, backgroundColor: Colors.indigo.shade50),
              PhonicsBox(text: 'T', isDashed: true, textColor: Colors.indigo.shade300, borderColor: Colors.indigo.shade200, backgroundColor: Colors.indigo.shade50),
              const SizedBox(width: 24),
              const Text("|", style: TextStyle(fontSize: 40, color: Colors.grey)),
              const SizedBox(width: 24),
              PhonicsBox(text: 'c', isDashed: true, textColor: Colors.indigo.shade300, borderColor: Colors.indigo.shade200, backgroundColor: Colors.indigo.shade50),
              PhonicsBox(text: 'a', isDashed: true, textColor: Colors.indigo.shade300, borderColor: Colors.indigo.shade200, backgroundColor: Colors.indigo.shade50),
              PhonicsBox(text: 's', isDashed: true, textColor: Colors.indigo.shade300, borderColor: Colors.indigo.shade200, backgroundColor: Colors.indigo.shade50),
              PhonicsBox(text: 't', isDashed: true, textColor: Colors.indigo.shade300, borderColor: Colors.indigo.shade200, backgroundColor: Colors.indigo.shade50),
            ],
          ),
          const SizedBox(height: 40),
          const TextBlock(
            text: "Sound out each of these letters:",
            type: TextType.instruction,
          ),
          const SizedBox(height: 16),
          // Sound Box Grid
          Expanded(
            child: GridView.count(
              crossAxisCount: ResponsiveHelper.getResponsiveGridCount(context: context, mobile: 1, tablet: 2, desktop: 2),
              childAspectRatio: 3.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildSoundRow('c', 'as in cot', 'cot'),
                _buildSoundRow('a', 'as in apple', 'apple'),
                _buildSoundRow('s', 'as in sand', 'sand'),
                _buildSoundRow('t', 'as in top', 'top'),
              ],
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'lesson-with-activity') {
      final words = ["plan", "run", "east", "bat", "hop", "long", "see", "mom"];
      final leftSide = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          TextBlock(
            text: "There are two kinds of letters in the alphabet. The letters a, e, i, o, u, and y are vowels. The other letters are consonants.",
            type: TextType.body,
          ),
          SizedBox(height: 16),
          PhonicFoxNarrator(
            text: "When you make a vowel noise, your mouth and vocal chords are wide open!",
            state: FoxState.openMouth,
          ),
          SizedBox(height: 16),
          TextBlock(
            text: "Go through the words below. Color the consonants in red and the vowels in blue. Try saying the words out loud!",
            type: TextType.instruction,
          ),
        ],
      );

      final rightSide = Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.amber.shade200, width: 2),
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveHelper.getResponsiveGridCount(context: context, mobile: 1, tablet: 2, desktop: 2),
            childAspectRatio: 2.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: words.length,
          itemBuilder: (context, index) {
            return VowelConsonantWord(word: words[index]);
          },
        ),
      );

      if (ResponsiveHelper.isMobile(context)) {
        return Column(
          children: [
            leftSide,
            const SizedBox(height: 24),
            Expanded(child: rightSide),
          ],
        );
      } else {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: leftSide),
            const SizedBox(width: 32),
            Expanded(flex: 1, child: rightSide),
          ],
        );
      }
    } else if (page['layout'] == 'lesson-with-table-and-activity') {
      return Column(
        children: [
          const TextBlock(
            text: "Sometimes, a word will have two copies of a consonant right next to each other, like in \"ball.\"",
            type: TextType.body,
          ),
          const SizedBox(height: 24),
          // Placeholder for the Table
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: Table(
              border: TableBorder(horizontalInside: BorderSide(color: Colors.grey.shade200, width: 1)),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.indigo.shade50),
                  children: const [
                    Padding(padding: EdgeInsets.all(12), child: Text("Type", style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(12), child: Text("Option 1", style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(12), child: Text("Option 2", style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(12), child: Text("Option 3", style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                _buildTableRow("Double L", ["llazy", "smille", "spill"], "spill"),
                _buildTableRow("Double R", ["carry", "hairry", "earr"], "carry"),
                _buildTableRow("Double S", ["eassy", "fuss", "ssame"], "fuss"),
                _buildTableRow("Double M", ["comment", "mmap", "aimm"], "comment"),
                _buildTableRow("Double F", ["ffire", "puff", "ffit"], "puff"),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const TextBlock(
            text: "Fill in the missing double letters",
            type: TextType.instruction,
          ),
          const SizedBox(height: 16),
          // Placeholder for Fill in Grid
          Expanded(
            child: GridView.count(
              crossAxisCount: ResponsiveHelper.getResponsiveGridCount(context: context, mobile: 2, tablet: 3, desktop: 3),
              childAspectRatio: 2.0,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildFillInCard("ba__", "ball", "ll"),
                _buildFillInCard("dre__", "dress", "ss"),
                _buildFillInCard("si__y", "silly", "ll"),
                _buildFillInCard("mi__", "mitt", "tt"),
                _buildFillInCard("flu__y", "fluffy", "ff"),
                _buildFillInCard("su__er", "summer", "mm"),
              ],
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'tracing-grid') {
      return Column(
        children: [
          const TextBlock(
            text: "Trace the consonant with the right beginning or ending sound!",
            type: TextType.instruction,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: ResponsiveHelper.getResponsiveGridCount(context: context, mobile: 2, tablet: 3, desktop: 3), // 3 Columns
              childAspectRatio: 0.65, // Taller cards
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              children: const [
                TracingCard(
                  icon: "cat",
                  partialWord: "at",
                  position: "beginning",
                  tracingOptions: ["c", "M"],
                ),
                TracingCard(
                  icon: "dog",
                  partialWord: "og",
                  position: "beginning",
                  tracingOptions: ["E", "D"], // Adjusted from reference image
                ),
                TracingCard(
                  icon: "pig",
                  partialWord: "ig",
                  position: "beginning",
                  tracingOptions: ["W", "P"],
                ),
                TracingCard(
                  icon: "flower", // Using plant/flower for green
                  partialWord: "Gree",
                  position: "end",
                  tracingOptions: ["g", "n"],
                ),
                TracingCard(
                  icon: "farm",
                  partialWord: "Far",
                  position: "end",
                  tracingOptions: ["h", "m"],
                ),
                TracingCard(
                  icon: "feet",
                  partialWord: "Fee",
                  position: "end",
                  tracingOptions: ["t", "V"],
                ),
              ],
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'matching-game') {
      return Column(
        children: [
          const TextBlock(
            text: "Choose the right flower from the field to start or finish a chain!",
            type: TextType.instruction,
          ),
          const SizedBox(height: 48),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              children: const [
                DaisyChainRow(icon: "bus", letters: ["B", "u", "?"], targetLetter: "s"),
                DaisyChainRow(icon: "ham", letters: ["?", "a", "m"], targetLetter: "h"),
                DaisyChainRow(icon: "fox", letters: ["F", "o", "?"], targetLetter: "x"),
                DaisyChainRow(icon: "jam", letters: ["?", "a", "m"], targetLetter: "j"),
                DaisyChainRow(icon: "pail", letters: ["P", "a", "i", "?"], targetLetter: "l"),
              ],
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'write-in-activity') {
      return Column(
        children: [
          const TextBlock(
            text: "Write in the beginning or ending sound to name the charm!",
            type: TextType.instruction,
          ),
          const SizedBox(height: 48),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              children: const [
                CharmBraceletRow(icon: "gift", letters: ["?", "i", "f", "t"], targetLetters: ["G"]),
                CharmBraceletRow(icon: "bird", letters: ["?", "i", "r", "?"], targetLetters: ["B", "d"]),
                CharmBraceletRow(icon: "flag", letters: ["?", "l", "a", "g"], targetLetters: ["F"]),
                CharmBraceletRow(icon: "girl", letters: ["G", "i", "r", "?"], targetLetters: ["l"]),
              ],
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'fill-in-list') {
      return Column(
        children: [
          const TextBlock(
            text: "Use the letters and sounds you've learned to finish naming the pictures.",
            type: TextType.instruction,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                MultiFillInCard(icon: "tree", word: "T_ree", targetLetters: ["r"]),
                SizedBox(height: 16),
                MultiFillInCard(icon: "flower", word: "F_owe_", targetLetters: ["l", "r"]),
                SizedBox(height: 16),
                MultiFillInCard(icon: "moose", word: "_oo_e", targetLetters: ["M", "s"]),
                SizedBox(height: 16),
                MultiFillInCard(icon: "umbrella", word: "U_b_ella", targetLetters: ["m", "r"]),
                SizedBox(height: 16),
                MultiFillInCard(icon: "octopus", word: "O_to_u_", targetLetters: ["c", "p", "s"]),
                SizedBox(height: 16),
                MultiFillInCard(icon: "rainbow", word: "_ai_bo_", targetLetters: ["R", "n", "w"]),
                SizedBox(height: 16),
                MultiFillInCard(icon: "watermelon", word: "_a_er_e_on", targetLetters: ["W", "t", "m", "l"]),
              ],
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'lesson-with-sort') {
      final contentList = page['content'] as List<dynamic>? ?? [];
      
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final block in contentList) ...[
                    if (block['type'] == 'lesson-text')
                      for (final para in block['paragraphs']) ...[
                        TextBlock(text: para, type: TextType.rule),
                        const SizedBox(height: 16),
                      ],
                    if (block['type'] == 'instruction') ...[
                      TextBlock(text: block['text'], type: TextType.instruction),
                      const SizedBox(height: 24),
                    ],
                    if (block['type'] == 'comparison-table-vertical') ...[
                      ComparisonTableVertical(
                        rows: List<Map<String, dynamic>>.from(block['rows']),
                      ),
                      const SizedBox(height: 32),
                    ],
                    if (block['type'] == 'two-column-sort') ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blueGrey.shade800, width: 2),
                        ),
                        child: TwoColumnSort(
                          leftLabel: block['leftLabel'] ?? 'Left',
                          rightLabel: block['rightLabel'] ?? 'Right',
                          leftAnswers: List<String>.from(block['options']?.where((o) {
                            if (block['leftLabel'].contains('Hard Th')) {
                              return ['they', 'father', 'this', 'there'].contains(o);
                            } else if (block['leftLabel'].contains('Hard')) {
                              return ['cane', 'cash', 'fact'].contains(o);
                            } else {
                              return ['silo', 'made', 'she', 'halo'].contains(o);
                            }
                          }) ?? []),
                          rightAnswers: List<String>.from(block['options']?.where((o) {
                            if (block['leftLabel'].contains('Hard Th')) {
                              return ['bath', 'math', 'thorn', 'birthday'].contains(o);
                            } else if (block['leftLabel'].contains('Hard')) {
                              return ['icy', 'mice', 'cent'].contains(o);
                            } else {
                              return ['fed', 'sand', 'tin', 'set', 'bit'].contains(o);
                            }
                          }) ?? []),
                          wordBank: List<String>.from(block['options'] ?? []),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                    if (block['type'] == 'image-write-in-list') ...[
                      ImageWriteInList(
                        items: List<Map<String, dynamic>>.from(block['items']),
                      ),
                      const SizedBox(height: 60),
                    ]
                  ]
                ],
              ),
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'lesson-with-color-sort') {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TextBlock(
                    text: "Like the letter c, the letter g has two sounds: one hard /g/ sound, as in \"grass,\" and a soft /j/ sound, as in \"giraffe.\" G makes its soft sound if the letter that comes after it is e, i, or y, just like c does!",
                    type: TextType.rule,
                  ),
                  const SizedBox(height: 24),
                  // Color Key Box
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.blueGrey.shade800, width: 2),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text("Soft G = ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'FredokaOne', color: Colors.blueGrey.shade900)),
                          const Text("Red", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'FredokaOne', color: Colors.red)),
                          const SizedBox(width: 32),
                          Text("Hard G = ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'FredokaOne', color: Colors.blueGrey.shade900)),
                          const Text("Black", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'FredokaOne', color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Ladybugs Grid
                  SizedBox(
                    height: ResponsiveHelper.isMobile(context) ? 350 : 500, // Responsive height for GridView inside ScrollView
                    child: const ColorCodeActivity(
                      items: [
                        {'word': 'gym', 'answer': 'red'},
                        {'word': 'gate', 'answer': 'black'},
                        {'word': 'gem', 'answer': 'red'},
                        {'word': 'rag', 'answer': 'black'},
                        {'word': 'giant', 'answer': 'red'},
                        {'word': 'age', 'answer': 'red'},
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'two-column-table') {
      return Column(
        children: [
          const TextBlock(
            text: "Vowels (A, E, I, O, U) can make more than one sound! Trace some examples:",
            type: TextType.instruction,
          ),
          const SizedBox(height: 32),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: VowelComparisonTable(
                rows: [
                  {'vowel': 'Aa', 'shortWord': 'Apple', 'shortIcon': 'apple', 'longWord': 'Acorn', 'longIcon': 'acorn', 'vowelChar': 'a'},
                  {'vowel': 'Ee', 'shortWord': 'Egg', 'shortIcon': 'egg', 'longWord': 'Hero', 'longIcon': 'hero_cape', 'vowelChar': 'e'},
                  {'vowel': 'Ii', 'shortWord': 'Whistle', 'shortIcon': 'whistle', 'longWord': 'Bike', 'longIcon': 'bicycle', 'vowelChar': 'i'},
                  {'vowel': 'Oo', 'shortWord': 'Frog', 'shortIcon': 'frog', 'longWord': 'Joke', 'longIcon': 'clown', 'vowelChar': 'o'},
                  {'vowel': 'Uu', 'shortWord': 'Duck', 'shortIcon': 'duck', 'longWord': 'Glue', 'longIcon': 'glue', 'vowelChar': 'u'},
                ],
              ),
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'identify-sort') {
      return Column(
        children: [
          const TextBlock(
            text: "Sometimes, the letter Y is a consonant. Other times, it's a vowel and it can have two vowel sounds!",
            type: TextType.rule,
          ),
          const SizedBox(height: 32),
          const Expanded(
            child: IdentifySort(
              items: [
                {'word': 'yes', 'emoji': '👍', 'answer': 'consonant'},
                {'word': 'baby', 'emoji': '👶', 'answer': 'vowel'},
                {'word': 'lawyer', 'emoji': '⚖️', 'answer': 'vowel'},
                {'word': 'yellow', 'emoji': '☀️', 'answer': 'consonant'},
                {'word': 'bicycle', 'emoji': '🚲', 'answer': 'vowel'},
                {'word': 'happy', 'emoji': '😄', 'answer': 'vowel'},
                {'word': 'monkey', 'emoji': '🐒', 'answer': 'vowel'},
                {'word': 'year', 'emoji': '🗓️', 'answer': 'consonant'},
              ],
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'y-is-a-thief-sort') {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TextBlock(
                    text: "When Y is a vowel, it can steal the sound of either I or E! Y can be a long e, as in baby, or a long i, as in shy. Sort the words.",
                    type: TextType.rule,
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blueGrey.shade800, width: 2),
                    ),
                    child: const TwoColumnSort(
                      leftLabel: "Long E Sound",
                      rightLabel: "Long I Sound",
                      leftAnswers: ["pretty", "windy", "candy", "puppy", "lazy", "kitty"],
                      rightAnswers: ["rely", "fly", "dry", "fry", "apply", "cycle"],
                      wordBank: ["rely", "pretty", "fly", "dry", "windy", "fry", "candy", "puppy", "apply", "cycle", "lazy", "kitty"],
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'color-choice-grid') {
      return Column(
        children: [
          const TextBlock(
            text: "Color the letter that completes the word. The first one is done for you.",
            type: TextType.instruction,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: ResponsiveHelper.getResponsiveGridCount(context: context, mobile: 1, tablet: 2, desktop: 2),
              childAspectRatio: ResponsiveHelper.isMobile(context) ? 3.0 : 2.0,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                InteractiveVowelStack(wordPart1: "c", wordPart2: "w", choices: ["a", "o", "u"], answer: "o", isSolved: true),
                InteractiveVowelStack(wordPart1: "b", wordPart2: "th", choices: ["e", "a", "i"], answer: "a"),
                InteractiveVowelStack(wordPart1: "m", wordPart2: "g", choices: ["u", "o", "a"], answer: "u"),
                InteractiveVowelStack(wordPart1: "f", wordPart2: "sh", choices: ["e", "i", "a"], answer: "i"),
                InteractiveVowelStack(wordPart1: "fr", wordPart2: "g", choices: ["o", "e", "u"], answer: "o"),
                InteractiveVowelStack(wordPart1: "s", wordPart2: "ck", choices: ["i", "o", "u"], answer: "o"),
              ],
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'train-fill-in') {
      return Column(
        children: [
          const TextBlock(
            text: "Write in the vowel to complete the CVC word and get the train moving!",
            type: TextType.instruction,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: TrainFillIn(
              onComplete: _triggerCelebration,
              trains: const [
                {'imageDesc': 'Cap / hat', 'imageId': 'hat', 'letters': ['C', '?', 'P'], 'answer': 'a', 'word': 'cap'},
                {'imageDesc': 'Log / wood', 'imageId': 'log', 'letters': ['L', '?', 'G'], 'answer': 'o', 'word': 'log'},
                {'imageDesc': 'Sun', 'imageId': 'sun', 'letters': ['S', '?', 'N'], 'answer': 'u', 'word': 'sun'},
                {'imageDesc': 'Lips / mouth', 'imageId': 'mouth', 'letters': ['L', '?', 'P'], 'answer': 'i', 'word': 'lip'},
                {'imageDesc': 'Bed', 'imageId': 'bed', 'letters': ['B', '?', 'D'], 'answer': 'e', 'word': 'bed'},
              ],
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'color-by-code') {
      List<Map<String, String>> codes = [];
      List<Map<String, String>> fish = [];

      try {
        final contentList = page['content'] as List<dynamic>;
        
        final keyBlock = contentList.firstWhere((e) => e['type'] == 'color-code-key', orElse: () => null);
        if (keyBlock != null) {
          codes = (keyBlock['codes'] as List<dynamic>).map((c) => {
            'label': c['label'] as String,
            'color': c['color'] as String,
          }).toList();
        }

        final fishBlock = contentList.firstWhere((e) => e['type'] == 'fish-color-activity', orElse: () => null);
        if (fishBlock != null) {
          fish = (fishBlock['fish'] as List<dynamic>).map((f) => {
            'word': f['word'] as String,
            'answer': f['answer'] as String,
          }).toList();
        }
      } catch (e) {
        // Fallback for parsing errors
      }

      return Column(
        children: [
          const TextBlock(
            text: "Look at the color key. Tap a color, then tap the fish that makes that vowel sound!",
            type: TextType.instruction,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ColorByCodeFishing(
              codes: codes,
              fish: fish,
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'lesson-with-circle-activity') {
      final contentList = page['content'] as List<dynamic>? ?? [];

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final block in contentList) ...[
                    if (block['type'] == 'lesson-text')
                      for (final para in block['paragraphs']) ...[
                        TextBlock(text: para, type: TextType.rule),
                        const SizedBox(height: 16),
                      ],
                    if (block['type'] == 'instruction') ...[
                      TextBlock(text: block['text'], type: TextType.instruction),
                      const SizedBox(height: 16),
                    ],
                    if (block['type'] == 'comparison-table') ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: BossyRComparisonTable(
                          rows: List<Map<String, dynamic>>.from(block['rows']),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (block['type'] == 'word-circle-grid') ...[
                      WordCircleGrid(
                        words: List<Map<String, dynamic>>.from(block['words']),
                      ),
                      const SizedBox(height: 60), // Bottom padding buffer
                    ]
                  ]
                ],
              ),
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'fill-in-activity') {
      List<Map<String, dynamic>> entries = [];
      try {
        final contentList = page['content'] as List<dynamic>;
        final gridBlock = contentList.firstWhere((e) => e['type'] == 'picture-fill-in-grid', orElse: () => null);
        if (gridBlock != null) {
          entries = List<Map<String, dynamic>>.from(gridBlock['entries']);
        }
      } catch (e) {
        // Fallback
      }

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  const TextBlock(
                    text: "Look at the picture and fill in the missing bossy r sound (ar, er, ir, or, ur)!",
                    type: TextType.instruction,
                  ),
                  const SizedBox(height: 32),
                  PictureFillInGrid(
                    entries: entries,
                    columns: ResponsiveHelper.getResponsiveGridCount(context: context, mobile: 1, tablet: 2, desktop: 3),
                  ),
                  const SizedBox(height: 60), // Scroll buffer
                ],
              ),
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'dual-activity') {
      List<Map<String, dynamic>> gridEntries = [];
      List<Map<String, dynamic>> riddles = [];

      try {
        final contentList = page['content'] as List<dynamic>;
        
        final gridBlock = contentList.firstWhere((e) => e['type'] == 'cvc-picture-write', orElse: () => null);
        if (gridBlock != null) {
          gridEntries = List<Map<String, dynamic>>.from(gridBlock['entries']);
        }

        final riddleBlock = contentList.firstWhere((e) => e['type'] == 'riddle-cvc', orElse: () => null);
        if (riddleBlock != null) {
          riddles = List<Map<String, dynamic>>.from(riddleBlock['riddles']);
        }
      } catch (e) {
        // Fallback
      }

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TextBlock(
                    text: "A. Write the CVC word that matches the picture.",
                    type: TextType.instruction,
                  ),
                  const SizedBox(height: 16),
                  PictureFillInGrid(
                    entries: gridEntries,
                    columns: ResponsiveHelper.getResponsiveGridCount(context: context, mobile: 1, tablet: 2, desktop: 3),
                  ),
                  const SizedBox(height: 32),
                  const TextBlock(
                    text: "B. Use the CVC words from part A to answer the riddles.",
                    type: TextType.instruction,
                  ),
                  const SizedBox(height: 16),
                  RiddleCvc(
                    riddles: riddles,
                  ),
                  const SizedBox(height: 60), // Scroll Buffer
                ],
              ),
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'tracing-grid') {
      return Column(
        children: [
          const TextBlock(
            text: "Trace the consonant with the right beginning or ending sound!",
            type: TextType.instruction,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: ResponsiveHelper.getResponsiveGridCount(context: context, mobile: 1, tablet: 2, desktop: 2),
              childAspectRatio: ResponsiveHelper.isMobile(context) ? 3.5 : 2.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildFillInCard("_ at", "cat", "C"),
                _buildFillInCard("D o _", "dog", "g"),
                _buildFillInCard("P i _", "pig", "g"),
                _buildFillInCard("G r e e _", "green", "n"),
                _buildFillInCard("F a r _", "farm", "m"),
                _buildFillInCard("F e e _", "feet", "t"),
              ],
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'matching-game') {
      return Column(
        children: [
          const TextBlock(
            text: "Choose the right flower from the field to start or finish a chain!",
            type: TextType.instruction,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: ResponsiveHelper.getResponsiveGridCount(context: context, mobile: 1, tablet: 2, desktop: 2),
              childAspectRatio: ResponsiveHelper.isMobile(context) ? 4.0 : 3.0,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildFillInCard("_ u s", "🚌", "B"),
                _buildFillInCard("H a _", "🍖", "m"),
                _buildFillInCard("F o _", "🦊", "x"),
                _buildFillInCard("J a _", "🍓", "m"),
                _buildFillInCard("P a i _", "🪣", "l"),
              ],
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'write-in-activity') {
      return Column(
        children: [
          const TextBlock(
            text: "Write in the beginning or ending sound to name the charm!",
            type: TextType.instruction,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: ResponsiveHelper.getResponsiveGridCount(context: context, mobile: 1, tablet: 2, desktop: 2),
              childAspectRatio: ResponsiveHelper.isMobile(context) ? 4.0 : 3.0,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildFillInCard("G i f _", "🎁", "t"),
                _buildFillInCard("B i r _", "🐦", "d"),
                _buildFillInCard("B o _ t", "⛵", "a"),
                _buildFillInCard("F l a _", "🚩", "g"),
                _buildFillInCard("G i r _", "👧", "l"),
              ],
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'fill-in-list') {
      return Column(
        children: [
          const TextBlock(
            text: "Use the letters and sounds you've learned to finish naming the pictures.",
            type: TextType.instruction,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: ResponsiveHelper.getResponsiveGridCount(context: context, mobile: 1, tablet: 3, desktop: 3),
              childAspectRatio: ResponsiveHelper.isMobile(context) ? 3.0 : 2.0,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildFillInCard("Tr e _", "🌲", "e"),
                _buildFillInCard("F l o w _ r", "🌺", "e"),
                _buildFillInCard("M o _ s e", "🦌", "o"),
                _buildFillInCard("U m b r _ l l a", "☂️", "e"),
                _buildFillInCard("O c t o p _ s", "🐙", "u"),
                _buildFillInCard("R a i n b _ w", "🌈", "o"),
                _buildFillInCard("W a _ e r m e l o n", "🍉", "t"),
              ],
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'cover') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextBlock(
            text: page['title'] ?? 'Phonics Kids Pro',
            type: TextType.h1,
            color: Colors.indigo.shade800,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextBlock(
            text: page['subtitle'] ?? 'Read By Age Four',
            type: TextType.instruction,
            color: Colors.orange.shade700,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 64),
          const VectorGraphic(assetName: 'fox', size: 160),
          const SizedBox(height: 64),
          TextBlock(
            text: 'By ${page['author'] ?? 'Shadreck Kudzanai Musarurwa'}',
            type: TextType.h2,
            color: Colors.blueGrey.shade800,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          TextBlock(
            text: 'Published by ${page['publisher'] ?? 'SKM Publishers'}',
            type: TextType.body,
            color: Colors.blueGrey.shade600,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else if (page['layout'] == 'welcome') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextBlock(
            text: page['title'] ?? 'Welcome!',
            type: TextType.h1,
            color: Colors.orange.shade600,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          const VectorGraphic(assetName: 'star', size: 120),
          const SizedBox(height: 48),
          const TextBlock(
            text: "Let's learn how to read together! Swipe or use the arrows to begin.",
            type: TextType.h2,
            color: Colors.indigo,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else if (page['layout'] == 'lesson-reference') {
      final contentList = page['content'] as List<dynamic>? ?? [];

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final block in contentList) ...[
                    if (block['type'] == 'lesson-text')
                      for (final para in block['paragraphs']) ...[
                        TextBlock(text: para, type: TextType.rule),
                        const SizedBox(height: 16),
                      ],
                    if (block['type'] == 'digraph-example-grid') ...[
                      const SizedBox(height: 16),
                      DigraphExampleGrid(
                        entries: List<Map<String, dynamic>>.from(block['entries']),
                        columns: block['columns'] ?? 4,
                      ),
                      const SizedBox(height: 60), // Scroll buffer
                    ]
                  ]
                ],
              ),
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'identify-underline') {
      final contentList = page['content'] as List<dynamic>? ?? [];

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final block in contentList) ...[
                    if (block['type'] == 'example-box') ...[
                      ExampleBox(
                        imageId: block['imageId'] as String,
                        text: block['text'] as String,
                        explanation: block['explanation'] as String?,
                      ),
                      const SizedBox(height: 32),
                    ],
                    if (block['type'] == 'instruction') ...[
                      TextBlock(text: block['text'], type: TextType.instruction),
                      const SizedBox(height: 24),
                    ],
                    if (block['type'] == 'word-list-activity') ...[
                      WordSelectionList(
                        sets: List<Map<String, dynamic>>.from(block['sets']),
                      ),
                      const SizedBox(height: 60),
                    ]
                  ]
                ],
              ),
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'lesson-with-find-activity') {
      final contentList = page['content'] as List<dynamic>? ?? [];

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final block in contentList) ...[
                    if (block['type'] == 'lesson-text')
                      for (final para in block['paragraphs']) ...[
                        TextBlock(text: para, type: TextType.rule),
                        const SizedBox(height: 16),
                      ],
                    if (block['type'] == 'trigraph-examples') ...[
                      TrigraphExamples(
                        entries: List<Map<String, dynamic>>.from(block['entries']),
                      ),
                      const SizedBox(height: 32),
                    ],
                    if (block['type'] == 'example-with-answer') ...[
                      ExampleBox(
                        imageId: 'fox', // Fallback Fox since A23 doesn't specify image
                        text: block['example'] ?? "",
                        explanation: "Answer: ${block['demonstrationAnswer']}",
                      ),
                      const SizedBox(height: 32),
                    ],
                    if (block['type'] == 'instruction') ...[
                      TextBlock(text: block['text'], type: TextType.instruction),
                      const SizedBox(height: 24),
                    ],
                    if (block['type'] == 'sentence-find') ...[
                      SentenceFind(
                        sentences: List<Map<String, dynamic>>.from(block['sentences']),
                      ),
                      const SizedBox(height: 60),
                    ]
                  ]
                ],
              ),
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'circle-and-fill') {
      final contentList = page['content'] as List<dynamic>? ?? [];

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final block in contentList) ...[
                    if (block['type'] == 'lesson-text')
                      for (final para in block['paragraphs']) ...[
                        TextBlock(text: para, type: TextType.rule),
                        const SizedBox(height: 16),
                      ],
                    if (block['type'] == 'circle-digraph') ...[
                      CircleChoiceGrid(
                        entries: List<Map<String, dynamic>>.from(block['entries']),
                        columns: block['columns'] ?? 2,
                      ),
                      const SizedBox(height: 32),
                    ],
                    if (block['type'] == 'instruction') ...[
                      TextBlock(text: block['text'], type: TextType.instruction),
                      const SizedBox(height: 24),
                    ],
                    if (block['type'] == 'fill-in-digraph') ...[
                      PictureFillInGrid(
                        entries: List<Map<String, dynamic>>.from(block['entries']),
                        columns: block['columns'] ?? 2,
                      ),
                      const SizedBox(height: 60),
                    ]
                  ]
                ],
              ),
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'sentence-find') {
      final contentList = page['content'] as List<dynamic>? ?? [];

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final block in contentList) ...[
                    if (block['type'] == 'example-box') ...[
                      ExampleBox(
                        imageId: block['imageId'] as String,
                        text: block['text'] as String,
                        explanation: block['note'] as String?,
                        answers: block.containsKey('answers') ? List<String>.from(block['answers']) : null,
                      ),
                      const SizedBox(height: 32),
                    ],
                    if (block['type'] == 'sentence-find-numbered') ...[
                      SentenceFind(
                        sentences: List<Map<String, dynamic>>.from(block['sentences']),
                        numbered: true,
                      ),
                      const SizedBox(height: 60),
                    ]
                  ]
                ],
              ),
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'fill-in-star') {
      final contentList = page['content'] as List<dynamic>? ?? [];

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final block in contentList) ...[
                    if (block['type'] == 'word-bank-box') ...[
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blueGrey.shade300, width: 2),
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 48,
                          runSpacing: 16,
                          children: (block['words'] as List<dynamic>).map((word) {
                            return Text(
                              word as String,
                              style: const TextStyle(
                                fontFamily: 'FredokaOne',
                                fontSize: 40,
                                color: Colors.indigo,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                    if (block['type'] == 'star-fill-activity') ...[
                      StarFillActivity(
                        entries: List<Map<String, dynamic>>.from(block['entries']),
                      ),
                      const SizedBox(height: 60),
                    ]
                  ]
                ],
              ),
            ),
          ),
        ],
      );
    } else if (page['layout'] == 'lesson-with-spot') {
      final contentList = page['content'] as List<dynamic>? ?? [];

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final block in contentList) ...[
                    if (block['type'] == 'lesson-text')
                      for (final para in block['paragraphs']) ...[
                        TextBlock(text: para, type: TextType.rule),
                        const SizedBox(height: 16),
                      ],
                    if (block['type'] == 'example-box') ...[
                      ExampleBox(
                        imageId: block['imageId'] ?? 'fox',
                        text: block['text'] as String,
                        explanation: block['note'] as String?,
                      ),
                      const SizedBox(height: 32),
                    ]
                  ]
                ],
              ),
            ),
          ),
        ],
      );
    }
    
    // Default Fallback
    return Center(
      child: TextBlock(
        text: 'Canvas Layout: ${page['layout']}\nTo be implemented.',
        type: TextType.body,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSoundRow(String letter, String example, String icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.shade200, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.indigo.shade800,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'FredokaOne',
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              example,
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          VectorGraphic(assetName: icon, size: 42),
          const SizedBox(width: 16),
          PronunciationButton(targetWord: letter),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String type, List<String> options, String answer) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        for (final opt in options)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: opt == answer ? Colors.green.shade100 : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                opt,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: opt == answer ? FontWeight.bold : FontWeight.normal,
                  color: opt == answer ? Colors.green.shade800 : Colors.grey.shade700,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFillInCard(String partial, String icon, String answer) {
    // Parse the partial string to find placeholders (e.g. "_" or "__")
    List<Widget> wordParts = [];
    final RegExp exp = RegExp(r'(__|_+)');
    final matches = exp.allMatches(partial);
    int lastEnd = 0;

    for (final match in matches) {
      if (match.start > lastEnd) {
        wordParts.add(Text(
          partial.substring(lastEnd, match.start),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'FredokaOne',
          ),
        ));
      }
      wordParts.add(LetterDropTarget(
        correctLetter: answer,
        onDropResult: (success, letter) { // Now accepts the letter string
          if (success) {
            setState(() {
              _usedLetters.add(letter);
            });
          }
        },
      ));
      lastEnd = match.end;
    }
    if (lastEnd < partial.length) {
      wordParts.add(Text(
        partial.substring(lastEnd),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'FredokaOne',
        ),
      ));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VectorGraphic(assetName: icon, size: 48),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            children: wordParts,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationOverlay() {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPageIndex > 0)
            _navButton(Icons.arrow_back_ios_new_rounded, _previousPage)
          else
            const SizedBox(width: 80),
            
          if (_currentPageIndex < TextbookDatabase.pages.length - 1)
            _navButton(Icons.arrow_forward_ios_rounded, _nextPage)
          else
            const SizedBox(width: 80),
        ],
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        color: Colors.indigo.withOpacity(0.1),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Icon(icon, size: 40, color: Colors.indigo),
          ),
        ),
      ),
    );
  }
}
