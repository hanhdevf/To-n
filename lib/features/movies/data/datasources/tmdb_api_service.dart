import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:galaxymob/config/constants/api_constants.dart';
import 'package:galaxymob/features/movies/data/models/movie_response_model.dart';
import 'package:galaxymob/features/movies/data/models/genre_response_model.dart';
import 'package:galaxymob/features/movies/data/models/movie_model.dart';

part 'tmdb_api_service.g.dart';

@RestApi(baseUrl: TmdbApiConstants.baseUrl)
abstract class TmdbApiService {
  factory TmdbApiService(Dio dio, {String baseUrl}) = _TmdbApiService;

  @GET('/movie/now_playing')
  Future<HttpResponse<MovieResponseModel>> getNowPlaying({
    @Query('api_key') String apiKey = TmdbApiConstants.apiKey,
    @Query('language') String language = 'en-US',
    @Query('page') int page = 1,
  });

  @GET('/movie/popular')
  Future<HttpResponse<MovieResponseModel>> getPopular({
    @Query('api_key') String apiKey = TmdbApiConstants.apiKey,
    @Query('language') String language = 'en-US',
    @Query('page') int page = 1,
  });

  @GET('/movie/upcoming')
  Future<HttpResponse<MovieResponseModel>> getUpcoming({
    @Query('api_key') String apiKey = TmdbApiConstants.apiKey,
    @Query('language') String language = 'en-US',
    @Query('page') int page = 1,
  });

  @GET('/movie/top_rated')
  Future<HttpResponse<MovieResponseModel>> getTopRated({
    @Query('api_key') String apiKey = TmdbApiConstants.apiKey,
    @Query('language') String language = 'en-US',
    @Query('page') int page = 1,
  });

  @GET('/trending/movie/week')
  Future<HttpResponse<MovieResponseModel>> getTrending({
    @Query('api_key') String apiKey = TmdbApiConstants.apiKey,
    @Query('language') String language = 'en-US',
    @Query('page') int page = 1,
  });

  @GET('/genre/movie/list')
  Future<HttpResponse<GenreResponseModel>> getGenres({
    @Query('api_key') String apiKey = TmdbApiConstants.apiKey,
    @Query('language') String language = 'en-US',
  });

  @GET('/movie/{movie_id}')
  Future<HttpResponse<MovieModel>> getMovieDetails({
    @Path('movie_id') required int movieId,
    @Query('api_key') String apiKey = TmdbApiConstants.apiKey,
    @Query('language') String language = 'en-US',
  });

  @GET('/search/movie')
  Future<HttpResponse<MovieResponseModel>> searchMovies({
    @Query('api_key') String apiKey = TmdbApiConstants.apiKey,
    @Query('query') required String query,
    @Query('language') String language = 'en-US',
    @Query('page') int page = 1,
  });
}
