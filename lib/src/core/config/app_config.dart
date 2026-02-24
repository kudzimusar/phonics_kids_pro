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
        // TODO: Replace with your Stripe Publishable Key from the Stripe Dashboard
        stripePublishableKey: 'pk_test_51T4AssIgqb2aRNSrkAd6OELLLEdgtHvC6Y80q25oq9D1nCgTQDURjZsfAXW4YrrUigvekaI55A56Kdy5mg8U4OSV00yUmbno5N', 
        firebaseFunctionsBaseUrl: 'http://127.0.0.1:5001/phonics-kids-pro/us-central1',
        vertexAiModelName: 'gemini-1.5-flash',
      );
    } else {
      _instance = AppConfig(
        environment: Environment.prod,
        // TODO: Replace with your Stripe Live Publishable Key
        stripePublishableKey: 'pk_live_placeholder', 
        firebaseFunctionsBaseUrl: 'https://us-central1-phonics-kids-pro.cloudfunctions.net',
        vertexAiModelName: 'gemini-1.5-flash',
      );
    }
  }
}
