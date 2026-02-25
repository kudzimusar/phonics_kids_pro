import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'src/auth/screens/auth_gate.dart';
import 'src/auth/screens/payment_success_screen.dart';
import 'src/auth/screens/payment_cancel_screen.dart';
import 'src/learning/textbook/textbook_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'src/core/config/app_config.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> initializeApp(Environment env) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  AppConfig.init(env);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Stripe
  try {
    final stripeKey = AppConfig.instance.stripePublishableKey;
    if (stripeKey.isNotEmpty && !stripeKey.contains('placeholder')) {
      Stripe.publishableKey = stripeKey;
    } else {
      debugPrint('Stripe Publishable Key not configured in AppConfig.');
    }
  } catch (e) {
    debugPrint('Error initializing Stripe: $e');
  }
}

void main() async {
  await initializeApp(Environment.dev);
  runApp(const PhonicsKidsProApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/textbook', // Temporary for testing
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthGate(),
    ),
    GoRoute(
      path: '/textbook',
      builder: (context, state) => const TextbookScreen(),
    ),
    GoRoute(
      path: '/payment-success',
      builder: (context, state) => const PaymentSuccessScreen(),
    ),
    GoRoute(
      path: '/payment-cancel',
      builder: (context, state) => const PaymentCancelScreen(),
    ),
  ],
);

class PhonicsKidsProApp extends StatelessWidget {
  const PhonicsKidsProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Phonics Kids Pro - Read Before Four',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

