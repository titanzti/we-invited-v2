/// Application-wide constants
class AppConstants {
  AppConstants._();

  // Map defaults
  static const double defaultLatitude = 13.7563; // Bangkok
  static const double defaultLongitude = 100.5018; // Bangkok
  
  // Scroll thresholds
  static const double loadMoreThreshold = 300.0; // pixels from bottom
  
  // Search debounce
  static const int searchDebounceMs = 400;
  
  // Animation durations
  static const int fastAnimationMs = 200;
  static const int normalAnimationMs = 300;
  static const int slowAnimationMs = 500;
  
  // Pagination
  static const int defaultPageSize = 15;
  
  // Image upload
  static const int maxImageWidth = 1200;
  static const int imageQuality = 85;
  
  // Save debounce for notification prefs
  static const int saveDebounceMs = 300;
}
