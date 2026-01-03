import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/exceptions.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';
import 'package:galaxymob/features/movies/domain/repositories/movie_repository.dart';

/// Implementation of MovieRepository
class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Movie>>> getNowPlaying({int page = 1}) async {
    try {
      final movieModels = await remoteDataSource.getNowPlaying(page: page);
      final movies = movieModels.map((model) => model.toEntity()).toList();
      return Right(movies);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getPopular({int page = 1}) async {
    try {
      final movieModels = await remoteDataSource.getPopular(page: page);
      final movies = movieModels.map((model) => model.toEntity()).toList();
      return Right(movies);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getUpcoming({int page = 1}) async {
    try {
      final movieModels = await remoteDataSource.getUpcoming(page: page);
      final movies = movieModels.map((model) => model.toEntity()).toList();
      return Right(movies);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getTopRated({int page = 1}) async {
    try {
      final movieModels = await remoteDataSource.getTopRated(page: page);
      final movies = movieModels.map((model) => model.toEntity()).toList();
      return Right(movies);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getTrending({int page = 1}) async {
    try {
      final movieModels = await remoteDataSource.getTrending(page: page);
      final movies = movieModels.map((model) => model.toEntity()).toList();
      return Right(movies);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetails(int movieId) async {
    try {
      final movieModel = await remoteDataSource.getMovieDetails(movieId);
      return Right(movieModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    try {
      final movieModels = await remoteDataSource.searchMovies(
        query: query,
        page: page,
      );
      final movies = movieModels.map((model) => model.toEntity()).toList();
      return Right(movies);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
