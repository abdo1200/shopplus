/// Shared network settings for the future real ShopPlus API.
final class NetworkConfig {
  const NetworkConfig({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 10),
    this.headers = const <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  });

  /// Default production-like API configuration for ShopPlus.
  factory NetworkConfig.shopPlus() {
    return const NetworkConfig(baseUrl: 'https://api.shopplus.com');
  }

  final String baseUrl;
  final Duration timeout;
  final Map<String, String> headers;
}
