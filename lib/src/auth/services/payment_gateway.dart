import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/config/app_config.dart';

class PaymentGateway {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// initiateSubscription - Handles the client-side flow for Stripe payments.
  /// 1. Calls the Cloud Function to get a PaymentIntent client secret.
  /// 2. Initializes the Stripe Payment Sheet.
  /// 3. Presents the Payment Sheet to the user.
  Future<void> initiateSubscription({required String email, required String tierId}) async {
    try {
      HttpsCallableResult result = await _functions.httpsCallable('createStripePaymentIntent').call({
        'email': email,
        'tierId': tierId
      });

      final String? clientSecret = result.data['clientSecret'];
      if (clientSecret == null) {
        throw Exception("Failed to retrieve client secret from backend.");
      }

      if (kIsWeb) {
        debugPrint("Initiating Stripe Checkout Session for Web...");
        HttpsCallableResult checkoutResult = await _functions.httpsCallable('createStripeCheckoutSession').call({
          'email': email,
          'tierId': tierId,
          'successUrl': 'http://localhost:8081/#/payment-success',
          'cancelUrl': 'http://localhost:8081/#/payment-cancel',
        });

        final String? checkoutUrl = checkoutResult.data['url'];
        if (checkoutUrl != null) {
          debugPrint("Redirecting to Stripe Checkout: $checkoutUrl");
          // Use url_launcher to open the checkout page
          final Uri url = Uri.parse(checkoutUrl);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            throw Exception("Could not launch checkout URL: $checkoutUrl");
          }
        } else {
          throw Exception("Failed to retrieve checkout URL from backend.");
        }
      } else {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'Phonics Kids Pro',
            allowsDelayedPaymentMethods: true,
            style: ThemeMode.light,
          ),
        );
        await Stripe.instance.presentPaymentSheet();
      }
      
    } catch (e) {
      if (e is StripeException) {
        debugPrint("Error from Stripe SDK (Client-Side): ${e.error.localizedMessage}");
      } else if (e is FirebaseFunctionsException) {
        debugPrint("Error from Cloud Functions (Backend): [${e.code}] ${e.message}");
      } else {
        debugPrint("Unforeseen error in PaymentGateway: $e");
      }
      rethrow;
    }
  }
}
