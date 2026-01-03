import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:galaxymob/core/error/failures.dart';

import 'package:galaxymob/features/movies/data/datasources/tmdb_api_service.dart';
import 'package:galaxymob/features/movies/data/models/genre_model.dart';
import 'package:galaxymob/features/movies/domain/entities/genre.dart';
import 'package:galaxymob/features/movies/domain/repositories/genre_repository.dart';

class GenreRepositoryImpl implements GenreRepository {
  final TmdbApiService apiService;

  GenreRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, List<Genre>>> getGenres() async {
    try {
      final response = await apiService.getGenres();

      if (response.response.statusCode == 200) {
        final genres =
            response.data.genres.map((model) => model.toEntity()).toList();
        return Right(genres);
      } else {
        return Left(ServerFailure('Failed to fetch genres'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unknown Dio Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
