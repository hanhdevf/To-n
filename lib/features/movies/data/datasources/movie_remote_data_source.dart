import 'package:dio/dio.dart';
import 'package:galaxymob/core/error/exceptions.dart';
import 'package:galaxymob/core/network/network_info.dart';
import 'package:galaxymob/features/movies/data/datasources/tmdb_api_service.dart';
import 'package:galaxymob/features/movies/data/models/credit_model.dart';
import 'package:galaxymob/features/movies/data/models/movie_model.dart';
import 'package:galaxymob/features/movies/data/models/review_model.dart';
import 'package:galaxymob/features/movies/data/models/movie_response_model.dart';
import 'package:retrofit/dio.dart';

/// Remote data source for movies using TMDB API
class MovieRemoteDataSource {
  final TmdbApiService apiService;
  final NetworkInfo networkInfo;

  static const int _maxRetries = 2;
  static const Duration _baseRetryDelay = Duration(milliseconds: 200);

  MovieRemoteDataSource(this.apiService, this.networkInfo);

  Future<T> _request<T>({
    required Future<HttpResponse<T>> Function() call,
    required String errorLabel,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkException('No internet connection');
    }

    DioException? lastDioError;
    for (var attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        final response = await call();
        final status = response.response.statusCode ?? 0;
        if (status >= 200 && status < 300) {
          return response.data;
        }
        throw ServerException('$errorLabel (status: $status)');
      } on DioException catch (e) {
        lastDioError = e;
        final shouldRetry = _isRetryable(e) && attempt < _maxRetries;
        if (shouldRetry) {
          await Future.delayed(
            Duration(
              milliseconds:
                  _baseRetryDelay.inMilliseconds * (attempt + 1),
            ),
          );
          continue;
        }
        throw ServerException(_mapDioError(e, fallback: errorLabel));
      }
    }

    throw ServerException(
      '$errorLabel: ${lastDioError?.message ?? 'Unknown error'}',
    );
  }

  bool _isRetryable(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        (e.response?.statusCode != null &&
            e.response!.statusCode! >= 500 &&
            e.response!.statusCode! < 600);
  }

  String _mapDioError(DioException e, {required String fallback}) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return '$fallback: request timed out';
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        return '$fallback (status: $status)';
      case DioExceptionType.cancel:
        return '$fallback: request cancelled';
      case DioExceptionType.unknown:
      default:
        return '$fallback: ${e.message}';
    }
  }

  Future<List<MovieModel>> getNowPlaying({int page = 1}) async {
    final data = await _request<MovieResponseModel>(
      call: () => apiService.getNowPlaying(page: page),
      errorLabel: 'Failed to fetch now playing movies',
    );
    return data.results;
  }

  Future<List<MovieModel>> getPopular({int page = 1}) async {
    final data = await _request<MovieResponseModel>(
      call: () => apiService.getPopular(page: page),
      errorLabel: 'Failed to fetch popular movies',
    );
    return data.results;
  }

  Future<List<MovieModel>> getUpcoming({int page = 1}) async {
    final data = await _request<MovieResponseModel>(
      call: () => apiService.getUpcoming(page: page),
      errorLabel: 'Failed to fetch upcoming movies',
    );
    return data.results;
  }

  Future<List<MovieModel>> getTopRated({int page = 1}) async {
    final data = await _request<MovieResponseModel>(
      call: () => apiService.getTopRated(page: page),
      errorLabel: 'Failed to fetch top rated movies',
    );
    return data.results;
  }

  Future<MovieModel> getMovieDetails(int movieId) async {
    return _request<MovieModel>(
      call: () => apiService.getMovieDetails(movieId: movieId),
      errorLabel: 'Failed to fetch movie details',
    );
  }

  Future<List<MovieModel>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    final data = await _request<MovieResponseModel>(
      call: () => apiService.searchMovies(
        query: query,
        page: page,
      ),
      errorLabel: 'Failed to search movies',
    );
    return data.results;
  }

  Future<List<MovieModel>> getTrending({int page = 1}) async {
    final data = await _request<MovieResponseModel>(
      call: () => apiService.getTrending(page: page),
      errorLabel: 'Failed to fetch trending movies',
    );
    return data.results;
  }

  Future<CreditsResponseModel> getMovieCredits(int movieId) async {
    return _request<CreditsResponseModel>(
      call: () => apiService.getMovieCredits(movieId: movieId),
      errorLabel: 'Failed to fetch movie credits',
    );
  }

  Future<ReviewsResponseModel> getMovieReviews(int movieId,
      {int page = 1}) async {
    return _request<ReviewsResponseModel>(
      call: () => apiService.getMovieReviews(movieId: movieId, page: page),
      errorLabel: 'Failed to fetch movie reviews',
    );
  }

  Future<List<MovieModel>> discoverMovies({
    int page = 1,
    String? withGenres,
    int? year,
    String? sortBy,
  }) async {
    final data = await _request<MovieResponseModel>(
      call: () => apiService.discoverMovies(
        page: page,
        withGenres: withGenres,
        year: year,
        sortBy: sortBy,
      ),
      errorLabel: 'Failed to discover movies',
    );
    return data.results;
  }
}
