/// P6-2: central image-cache policy.
///
/// Without `memCacheWidth/Height`, `cached_network_image` decodes full-res
/// files (often 2000px+) just to paint a 44px avatar or 130px grid tile.
/// That spikes memory and janks low-end scroll. These buckets keep decoded
/// sizes close to paint sizes (times ~3x for devicePixelRatio).
abstract final class ImageCacheSizes {
  /// Avatars 28–72px painted → 144px decode covers 3x screens.
  static const int avatar = 144;

  /// Small previews: activity 44px, collection 44px, bottom-nav 28px.
  static const int preview = 144;

  /// Explore / profile 3-col grid tiles (~130px wide).
  static const int grid = 400;

  /// Threads card inline image (~250px wide).
  static const int card = 600;

  /// Full-width feed post / story viewer.
  static const int feed = 1080;
}
