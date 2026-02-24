import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachingService {
  static final DefaultCacheManager _cacheManager = DefaultCacheManager();

  /// preCacheAsset - Downloads and caches a remote asset for offline use.
  Future<void> preCacheAsset(String url) async {
    try {
      await _cacheManager.downloadFile(url);
    } catch (e) {
      print('Error caching asset: $e');
    }
  }

  /// getFile - Returns the cached file if available.
  Future<FileInfo?> getFile(String url) async {
    return await _cacheManager.getFileFromCache(url);
  }
}
