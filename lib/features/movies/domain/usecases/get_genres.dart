import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/movies/domain/entities/genre.dart';
import 'package:galaxymob/features/movies/domain/repositories/genre_repository.dart';

class GetGenres implements UseCase<List<Genre>, NoParams> {
  final GenreRepository repository;

  GetGenres(this.repository);

  @override
  Future<Either<Failure, List<Genre>>> call(NoParams params) async {
    return await repository.getGenres();
  }
}
