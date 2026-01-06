import 'package:galaxymob/features/cinema/data/datasources/cinema_firestore_data_source.dart';
import 'package:galaxymob/features/cinema/data/datasources/mock_cinema_data_source.dart';
import 'package:galaxymob/features/cinema/data/models/cinema_model.dart';
import 'package:galaxymob/features/cinema/data/models/showtime_model.dart';

/// Service to seed initial cinema and showtime data to Firestore
class FirestoreSeedingService {
  final CinemaFirestoreDataSource _firestoreDataSource;
  final MockCinemaDataSource _mockDataSource;

  FirestoreSeedingService({
    required CinemaFirestoreDataSource firestoreDataSource,
    required MockCinemaDataSource mockDataSource,
  })  : _firestoreDataSource = firestoreDataSource,
        _mockDataSource = mockDataSource;

  /// Seed cinemas from mock data
  Future<void> seedCinemas() async {
    print('🌱 Seeding cinemas...');

    final mockCinemas = _mockDataSource.getMockCinemas();

    for (final cinema in mockCinemas) {
      final cinemaModel = CinemaModel.fromEntity(cinema);
      await _firestoreDataSource.addCinema(cinemaModel);
      print('  ✅ Added cinema: ${cinema.name}');
    }

    print('✅ Cinemas seeded successfully!');
  }

  /// Seed showtimes for a specific movie (minimal: only 2 cinemas, 3 days)
  Future<void> seedShowtimesForMovie({
    required int movieId,
    int daysAhead = 3, // Reduced from 7 to 3 days
  }) async {
    print('🌱 Seeding showtimes for movie $movieId...');

    final allCinemas = _mockDataSource.getMockCinemas();
    // Only use first 2 cinemas to reduce data
    final cinemas = allCinemas.take(2).toList();
    final now = DateTime.now();

    int totalShowtimes = 0;

    for (int dayOffset = 0; dayOffset < daysAhead; dayOffset++) {
      final date = now.add(Duration(days: dayOffset));

      for (final cinema in cinemas) {
        final showtimes = _mockDataSource.generateShowtimes(
          cinemaId: cinema.id,
          movieId: movieId,
          date: date,
        );

        // Only create 3 showtimes per day (9:00, 15:00, 21:00)
        final limitedShowtimes = showtimes.where((s) {
          final hour = s.dateTime.hour;
          return hour == 9 || hour == 15 || hour == 21;
        }).toList();

        for (final showtime in limitedShowtimes) {
          final showtimeModel = ShowtimeModel(
            id: '', // Will be auto-generated
            cinemaId: showtime.cinemaId,
            movieId: showtime.movieId,
            startTime: showtime.dateTime,
            price: showtime.price,
            screenName: showtime.screenName,
            bookedSeats: [], // Initially empty
            totalSeats: showtime.totalSeats,
            layoutType: 'standard_120',
          );

          await _firestoreDataSource.addShowtime(showtimeModel);
          totalShowtimes++;
        }
      }
    }

    print('✅ Seeded $totalShowtimes showtimes!');
  }

  /// Clear all data (for re-seeding)
  Future<void> clearAllData() async {
    print('🗑️ Clearing all data...');
    await _firestoreDataSource.clearCinemas();
    await _firestoreDataSource.clearShowtimes();
    print('✅ All data cleared!');
  }

  /// Full seeding process: clear + seed cinemas + seed showtimes for popular movies
  Future<void> seedInitialData() async {
    try {
      await clearAllData();
      await seedCinemas();

      // Seed showtimes for only 2 popular movies (reduced data)
      final popularMovieIds = [
        83533, // Avatar: Fire and Ash
        558449, // Gladiator II
      ];

      for (final movieId in popularMovieIds) {
        await seedShowtimesForMovie(movieId: movieId, daysAhead: 3);
      }

      print('🎉 Initial data seeding completed!');
    } catch (e) {
      print('❌ Seeding failed: $e');
      rethrow;
    }
  }
}
