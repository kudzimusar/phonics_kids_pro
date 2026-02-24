import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../core/config/app_config.dart';

class PaymentGateway {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// initiateSubscription - Handles the client-side flow for Stripe payments.
  /// 1. Calls the Cloud Function to get a PaymentIntent client secret.
  /// 2. Initializes the Stripe Payment Sheet.
  /// 3. Presents the Payment Sheet to the user.
  Future<void> initiateSubscription({required String email, required String tierId}) async {
    try {
      // 1. Call the Cloud Function
      // In production, Firebase Functions points to the live project automatically.
      // In dev, we can point to the emulator:
      // if (AppConfig.instance.environment == Environment.dev) {
      //    _functions.useFunctionsEmulator('127.0.0.1', 5001);
      // }
      
      HttpsCallable callable = _functions.httpsCallable('createStripePaymentIntent');
      final result = await callable.call({
        'email': email,
        'tierId': tierId // e.g., 'pro_monthly'
      });

      final String? clientSecret = result.data['clientSecret'];
      
      if (clientSecret == null) {
        throw Exception("Failed to retrieve client secret from backend.");
      }

      // 2. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Phonics Kids Pro',
          // Note: In a production app, the backend should also return 
          // a customer ID and ephemeral key if you want to save cards.
          allowsDelayedPaymentMethods: true,
          style: ThemeMode.light,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFF42A5F5),
            ),
          ),
        ),
      );

      // 3. Display the payment sheet
      await Stripe.instance.presentPaymentSheet();
      
      debugPrint("Stripe Payment Sheet closed. Check Firestore for subscription status.");
      
    } catch (e) {
      if (e is StripeException) {
        debugPrint("Error from Stripe SDK (Client-Side): ${e.error.localizedMessage}");
        if (e.error.code == FailureCode.Failed) {
           debugPrint("TIP: Ensure your Stripe Publishable Key is correctly set in AppConfig.dart and initialized in main.dart");
        }
      } else if (e is FirebaseFunctionsException) {
        debugPrint("Error from Cloud Functions (Backend): [${e.code}] ${e.message}");
        debugPrint("TIP: Ensure your Stripe Secret Key is set in Firebase/Emulator config.");
      } else {
        debugPrint("Unforeseen error in PaymentGateway: $e");
      }
      rethrow;
    }
  }
}
