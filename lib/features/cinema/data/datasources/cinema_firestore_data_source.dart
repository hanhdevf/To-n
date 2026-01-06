import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galaxymob/features/cinema/data/models/cinema_model.dart';
import 'package:galaxymob/features/cinema/data/models/showtime_model.dart';

/// Firestore data source for cinemas and showtimes
class CinemaFirestoreDataSource {
  final FirebaseFirestore _firestore;

  CinemaFirestoreDataSource(this._firestore);

  /// Get all cinemas
  Future<List<CinemaModel>> getCinemas() async {
    try {
      final snapshot = await _firestore.collection('cinemas').get();
      return snapshot.docs
          .map((doc) => CinemaModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch cinemas: $e');
    }
  }

  /// Get showtime by ID
  Future<ShowtimeModel> getShowtime(String showtimeId) async {
    try {
      final doc =
          await _firestore.collection('showtimes').doc(showtimeId).get();
      if (!doc.exists) {
        throw Exception('Showtime not found');
      }
      return ShowtimeModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch showtime: $e');
    }
  }

  /// Get showtimes for a movie on a specific date
  Future<Map<String, List<ShowtimeModel>>> getShowtimes({
    required int movieId,
    required DateTime date,
  }) async {
    try {
      // Get start and end of day
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await _firestore
          .collection('showtimes')
          .where('movie_id', isEqualTo: movieId)
          .where('start_time',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('start_time', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      final showtimes =
          snapshot.docs.map((doc) => ShowtimeModel.fromFirestore(doc)).toList();

      // Group by cinema
      final Map<String, List<ShowtimeModel>> groupedShowtimes = {};
      for (final showtime in showtimes) {
        if (!groupedShowtimes.containsKey(showtime.cinemaId)) {
          groupedShowtimes[showtime.cinemaId] = [];
        }
        groupedShowtimes[showtime.cinemaId]!.add(showtime);
      }

      return groupedShowtimes;
    } catch (e) {
      throw Exception('Failed to fetch showtimes: $e');
    }
  }

  /// Add a cinema (for seeding)
  Future<void> addCinema(CinemaModel cinema) async {
    try {
      await _firestore
          .collection('cinemas')
          .doc(cinema.id)
          .set(cinema.toFirestore());
    } catch (e) {
      throw Exception('Failed to add cinema: $e');
    }
  }

  /// Add a showtime (for seeding)
  Future<String> addShowtime(ShowtimeModel showtime) async {
    try {
      final docRef =
          await _firestore.collection('showtimes').add(showtime.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add showtime: $e');
    }
  }

  /// Delete all cinemas (for re-seeding)
  Future<void> clearCinemas() async {
    try {
      final snapshot = await _firestore.collection('cinemas').get();
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to clear cinemas: $e');
    }
  }

  /// Delete all showtimes (for re-seeding)
  Future<void> clearShowtimes() async {
    try {
      final snapshot = await _firestore.collection('showtimes').get();
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to clear showtimes: $e');
    }
  }
}
