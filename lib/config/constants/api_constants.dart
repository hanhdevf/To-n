/// TMDB API Configuration
class TmdbApiConstants {
  TmdbApiConstants._(); // Private constructor to prevent instantiation

  static const String apiKey = '0003e1a90d543ef8c203d0f341c685f2';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/';

  // Image Sizes
  static const String posterSizeW185 = 'w185';
  static const String posterSizeW342 = 'w342';
  static const String posterSizeW500 = 'w500';
  static const String posterSizeOriginal = 'original';

  static const String backdropSizeW300 = 'w300';
  static const String backdropSizeW780 = 'w780';
  static const String backdropSizeW1280 = 'w1280';
  static const String backdropSizeOriginal = 'original';

  static const String profileSizeW185 = 'w185';
  static const String profileSizeH632 = 'h632';
  static const String profileSizeOriginal = 'original';

  // API Endpoints
  static const String nowPlaying = '/movie/now_playing';
  static const String upcoming = '/movie/upcoming';
  static const String topRated = '/movie/top_rated';
  static const String popular = '/movie/popular';
  static const String movieDetails = '/movie/{movie_id}';
  static const String movieCredits = '/movie/{movie_id}/credits';
  static const String movieVideos = '/movie/{movie_id}/videos';
  static const String search = '/search/movie';

  // Helper methods
  static String getPosterUrl(String? path, {String size = posterSizeW500}) {
    if (path == null || path.isEmpty) return '';
    return '$imageBaseUrl$size$path';
  }

  static String getBackdropUrl(String? path, {String size = backdropSizeW780}) {
    if (path == null || path.isEmpty) return '';
    return '$imageBaseUrl$size$path';
  }

  static String getProfileUrl(String? path, {String size = profileSizeW185}) {
    if (path == null || path.isEmpty) return '';
    return '$imageBaseUrl$size$path';
  }
}
