import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/local_progress_service.dart';
import '../textbook/textbook_database.dart';
import 'web_downloader.dart';

class CertificatePage extends StatefulWidget {
  final Map<String, dynamic> pageData;

  const CertificatePage({Key? key, required this.pageData}) : super(key: key);

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  final GlobalKey _globalKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool _isBackgroundPrecached = false;
  int _clearedCount = 0;
  int _totalCount = TextbookDatabase.metadata['totalActivities'] as int? ?? 51;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateController.text = '${now.month}/${now.day}/${now.year}';
    
    // Fetch stats
    _loadStats();

    // Auto-fill from Firebase Auth profile if available!
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
      _nameController.text = user.displayName!;
    } else {
      _nameController.text = 'Student Name'; // Default placeholder
    }
  }

  void _loadStats() async {
    final service = LocalProgressService();
    final cleared = await service.getAllClearedActivities();
    if (mounted) {
      setState(() {
        _clearedCount = cleared.length;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/images/certificate_bg_hq.png'), context).then((_) {
      if (mounted) setState(() => _isBackgroundPrecached = true);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _exportCertificate() async {
    try {
      final RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // High pixelRatio ensures the 4K background and fonts export beautifully
      final ui.Image image = await boundary.toImage(pixelRatio: 3.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final List<int> pngBytes = byteData.buffer.asUint8List();
        final fileName = '${_nameController.text.replaceAll(' ', '_')}_Certificate.png';
        downloadImage(pngBytes, fileName);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Downloading highest quality Certificate...'),
              backgroundColor: Colors.indigo,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Export error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not download certificate.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF0F3A70);

    return Column(
      children: [
        // Ensure the certificate fills space but keeps its ratio
        Expanded(
          child: Center(
            child: FittedBox(
              fit: BoxFit.contain, 
              child: RepaintBoundary(
                key: _globalKey,
                // A4 Landscape Aspect Ratio (297:210 ≈ 1.414:1)
                child: Container(
                  width: 2000,
                  height: 1414, 
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: _isBackgroundPrecached 
                      ? const DecorationImage(
                          image: AssetImage('assets/images/certificate_bg_hq.png'),
                          fit: BoxFit.cover,
                        )
                      : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 50,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (!_isBackgroundPrecached)
                        const Center(child: CircularProgressIndicator()),
                      
                      // Certificate Texts Overlay Layer
                      Positioned(
                        top: 280, 
                        bottom: 0,
                        left: 200,
                        right: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'C E R T I F I C A T E  O F  C O M P L E T I O N',
                              style: GoogleFonts.montserrat(
                                fontSize: 44, 
                                fontWeight: FontWeight.bold,
                                letterSpacing: 8,
                                color: darkBlue,
                              ),
                            ),
                            const SizedBox(height: 50),
            
                            Text(
                              'THE FOLLOWING AWARD IS GIVEN TO',
                              style: GoogleFonts.montserrat(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 6,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 50),
            
                            SizedBox(
                              width: 1500,
                              child: TextField(
                                controller: _nameController,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.greatVibes(
                                  fontSize: 185,
                                  color: darkBlue,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(height: 35),
            
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 140),
                              child: Text(
                                'This certificate is given for successfully finishing Level 1 of the Phonics Kids Pro Module and proved that he/she has mastered Phonics at this level with a final score of $_clearedCount/$_totalCount (${(_clearedCount / _totalCount * 100).toStringAsFixed(1)}%). Great Job!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  height: 1.6,
                                ),
                              ),
                            ),
                            
                            const Spacer(),
                            
                            // Bottom Stats Layer
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Left Side: Sign
                                Column(
                                  children: [
                                    Text(
                                      'SKM Publishers CEO',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: darkBlue,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(width: 450, height: 2, color: darkBlue.withOpacity(0.4)),
                                    const SizedBox(height: 4),
                                    const Text('SIGNATURE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
                                  ],
                                ),
                                
                                const SizedBox(width: 450), // Gap for the SEAL in the middle of BG
                                
                                // Right Side: Date
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: TextField(
                                        controller: _dateController,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(width: 250, height: 2, color: darkBlue.withOpacity(0.4)),
                                    const SizedBox(height: 4),
                                    const Text('DATE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
                                  ],
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 100),
                            Text(
                              'www.phonicskidspro.com   |   info@phonicskidspro.com',
                              style: GoogleFonts.montserrat(
                                fontSize: 24,
                                color: Colors.grey.shade600,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        
        Container(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              const Text(
                'Enter name above and click button to save certificate',
                style: TextStyle(color: Colors.grey, fontSize: 14, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _exportCertificate,
                icon: const Icon(Icons.download, size: 28),
                label: const Text('Download Certificate', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
