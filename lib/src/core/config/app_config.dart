enum Environment { dev, prod }

class AppConfig {
  final Environment environment;
  final String stripePublishableKey;
  final String firebaseFunctionsBaseUrl;
  final String vertexAiModelName;

  AppConfig({
    required this.environment,
    required this.stripePublishableKey,
    required this.firebaseFunctionsBaseUrl,
    required this.vertexAiModelName,
  });

  static AppConfig? _instance;

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception('AppConfig not initialised. Call AppConfig.init() first.');
    }
    return _instance!;
  }

  static void init(Environment env) {
    if (env == Environment.dev) {
      _instance = AppConfig(
        environment: Environment.dev,
        // Stripe Test Key - Retrieved via Stripe Dashboard
        stripePublishableKey: 'pk_test_51T4AsGEYx2bZawxu2MCOLsmG4XQvlkg3RIRNsPPg1IXzJ1O39NqcK5laz5A13b3hPAzDwSxGqZWzVa9uFOZDWCwT00htCh2DuV', 
        firebaseFunctionsBaseUrl: 'http://127.0.0.1:5001/phonics-kids-pro/us-central1',
        vertexAiModelName: 'gemini-1.5-flash',
      );
    } else {
      _instance = AppConfig(
        environment: Environment.prod,
        // ACTION REQUIRED: Replace 'pk_live_placeholder' with your actual Stripe Live Publishable Key
        stripePublishableKey: 'pk_live_placeholder', 
        firebaseFunctionsBaseUrl: 'https://us-central1-phonics-kids-pro.cloudfunctions.net',
        vertexAiModelName: 'gemini-1.5-flash',
      );

      if (_instance!.stripePublishableKey == 'pk_live_placeholder') {
        print('⚠️ WARNING: Stripe Live Key is still a placeholder. Payments will not work in production.');
      }
    }
  }
}
