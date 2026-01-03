import 'package:galaxymob/core/error/exceptions.dart';
import 'package:galaxymob/features/movies/data/datasources/tmdb_api_service.dart';
import 'package:galaxymob/features/movies/data/models/movie_model.dart';

/// Remote data source for movies using TMDB API
class MovieRemoteDataSource {
  final TmdbApiService apiService;

  MovieRemoteDataSource(this.apiService);

  Future<List<MovieModel>> getNowPlaying({int page = 1}) async {
    try {
      final response = await apiService.getNowPlaying(page: page);

      if (response.response.statusCode == 200) {
        return response.data.results;
      } else {
        throw ServerException('Failed to fetch now playing movies');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<MovieModel>> getPopular({int page = 1}) async {
    try {
      final response = await apiService.getPopular(page: page);

      if (response.response.statusCode == 200) {
        return response.data.results;
      } else {
        throw ServerException('Failed to fetch popular movies');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<MovieModel>> getUpcoming({int page = 1}) async {
    try {
      final response = await apiService.getUpcoming(page: page);

      if (response.response.statusCode == 200) {
        return response.data.results;
      } else {
        throw ServerException('Failed to fetch upcoming movies');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<MovieModel>> getTopRated({int page = 1}) async {
    try {
      final response = await apiService.getTopRated(page: page);

      if (response.response.statusCode == 200) {
        return response.data.results;
      } else {
        throw ServerException('Failed to fetch top rated movies');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      final response = await apiService.getMovieDetails(movieId: movieId);

      if (response.response.statusCode == 200) {
        return response.data;
      } else {
        throw ServerException('Failed to fetch movie details');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<MovieModel>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    try {
      final response = await apiService.searchMovies(
        query: query,
        page: page,
      );

      if (response.response.statusCode == 200) {
        return response.data.results;
      } else {
        throw ServerException('Failed to search movies');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<MovieModel>> getTrending({int page = 1}) async {
    try {
      final response = await apiService.getTrending(page: page);

      if (response.response.statusCode == 200) {
        return response.data.results;
      } else {
        throw ServerException('Failed to fetch trending movies');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
