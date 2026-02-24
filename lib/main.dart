import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/auth/screens/auth_gate.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'src/core/config/app_config.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Minimal fallback for standard 'flutter run'
  try {
    AppConfig.instance;
  } catch (_) {
    AppConfig.init(Environment.dev);
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Stripe
  try {
    final stripeKey = AppConfig.instance.stripePublishableKey;
    if (stripeKey.isNotEmpty && !stripeKey.contains('placeholder')) {
      if (kIsWeb || !kIsWeb) { // Always set it if we have it
        Stripe.publishableKey = stripeKey;
      }
    } else {
      debugPrint('Stripe Publishable Key not configured in AppConfig.');
    }
  } catch (e) {
    debugPrint('Error initializing Stripe: $e');
  }

  runApp(const PhonicsKidsProApp());
}

class PhonicsKidsProApp extends StatelessWidget {
  const PhonicsKidsProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phonics Kids Pro - Read Before Four',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

