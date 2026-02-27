import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateController.text = '${now.month}/${now.day}/${now.year}';
    
    // Auto-fill from Firebase Auth profile if available!
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
      _nameController.text = user.displayName!;
    } else {
      _nameController.text = 'Student Name'; // Default placeholder
    }
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
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
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
        // Responsive Wrapper ensures the cert ALWAYS looks identical
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: FittedBox(
              fit: BoxFit.contain, // Guarantee layout holds firm ratio and doesn't clutter
              child: RepaintBoundary(
                key: _globalKey,
                // Fixed master width representing the 'canvas'.
                child: Container(
                  width: 2000,
                  height: 2000, // Make it square to match the generated background image perfectly
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Base 4K Image Render
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/certificate_bg.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      
                      // Certificate Texts Overlay Layer
                      Positioned(
                        top: 500,
                        bottom: 0,
                        left: 200,
                        right: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // 1. Completion Moniker
                            Text(
                              'C E R T I F I C A T E  O F  C O M P L E T I O N',
                              style: GoogleFonts.montserrat(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 8,
                                color: darkBlue,
                              ),
                            ),
                            const SizedBox(height: 60),
            
                            // 2. Award Intro
                            Text(
                              'THE FOLLOWING AWARD IS GIVEN TO',
                              style: GoogleFonts.montserrat(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 6,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 100),
            
                            // 3. Name Input
                            SizedBox(
                              width: 1400,
                              child: TextField(
                                controller: _nameController,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.greatVibes(
                                  fontSize: 180,
                                  color: darkBlue,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(height: 60),
            
                            // 4. Description Lettrage
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 120),
                              child: Text(
                                'This certificate is given for successfully finishing Level 1 of the Phonics Kids Pro Module and proved that he/she has mastered Phonics at this level. Great Job!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  height: 1.6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 220),
                            
                            // 5. Signature and Date Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Signature
                                Column(
                                  children: [
                                    Text(
                                      'SKM Publishers CEO',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                        color: darkBlue,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(width: 400), // Middle gap for the seal on the bg
                                
                                // Date
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    controller: _dateController,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 28,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 180),
                            
                            // 6. Contact Row
                            Text(
                              'www.phonicskidspro.com   |   info@phonicskidspro.com',
                              style: GoogleFonts.montserrat(
                                fontSize: 22,
                                color: Colors.grey.shade700,
                                letterSpacing: 2,
                              ),
                            ),

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
        
        // Export Action Bar
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: ElevatedButton.icon(
            onPressed: _exportCertificate,
            icon: const Icon(Icons.download, size: 28),
            label: const Text(
              'Download Certificate',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: darkBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }
}
