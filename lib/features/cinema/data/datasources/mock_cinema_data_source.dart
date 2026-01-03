import 'package:galaxymob/features/cinema/domain/entities/cinema.dart';
import 'package:galaxymob/features/cinema/domain/entities/showtime.dart';

/// Mock data source for cinemas and showtimes
class MockCinemaDataSource {
  /// Mock list of cinemas in Hanoi
  List<Cinema> getMockCinemas() {
    return [
      const Cinema(
        id: 'cgv-royal-city',
        name: 'CGV Royal City',
        address: '72A Nguyễn Trãi, Thanh Xuân, Hà Nội',
        latitude: 21.0010,
        longitude: 105.8141,
        facilities: ['3D', 'IMAX', '4DX', 'Dolby Atmos', 'VIP Lounge'],
      ),
      const Cinema(
        id: 'lotte-cinema-tay-ho',
        name: 'Lotte Cinema Tây Hồ',
        address: '31 Đường  Xuân La, Tây Hồ, Hà Nội',
        latitude: 21.0665,
        longitude: 105.8065,
        facilities: ['3D', 'Premium Seats', 'Couple Seats'],
      ),
      const Cinema(
        id: 'galaxy-nguyen-du',
        name: 'Galaxy Nguyễn Du',
        address: '22 Nguyễn Du, Hai Bà Trưng, Hà Nội',
        latitude: 21.0199,
        longitude: 105.8492,
        facilities: ['3D', 'Dolby 7.1', 'VIP Rooms'],
      ),
      const Cinema(
        id: 'bhd-vincom-times-city',
        name: 'BHD Star Vincom Times City',
        address: '458 Minh Khai, Hai Bà Trưng, Hà Nội',
        latitude: 20.9966,
        longitude: 105.8665,
        facilities: ['3D', 'Gold Class', 'IMAX'],
      ),
      const Cinema(
        id: 'platinum-cau-giay',
        name: 'Platinum Cầu Giấy',
        address: '210 Trần Duy Hưng, Cầu Giấy, Hà Nội',
        latitude: 21.0138,
        longitude: 105.7943,
        facilities: ['3D', 'Luxury Recliners', 'Dolby Atmos'],
      ),
    ];
  }

  /// Generate mock showtimes for a movie at a cinema
  List<Showtime> generateShowtimes({
    required String cinemaId,
    required int movieId,
    required DateTime date,
  }) {
    // Generate showtimes for the day: 9:00, 12:00, 15:00, 18:00, 21:00
    final baseTimes = [9, 12, 15, 18, 21];

    return baseTimes.map((hour) {
      final showtime = DateTime(date.year, date.month, date.day, hour, 0);
      return Showtime(
        id: '$cinemaId-$movieId-${date.day}-$hour',
        cinemaId: cinemaId,
        movieId: movieId,
        dateTime: showtime,
        price: _getPriceForTime(hour),
        screenName: 'Screen ${(baseTimes.indexOf(hour) % 3) + 1}',
        availableSeats: _getRandomSeats(),
        totalSeats: 120,
      );
    }).toList();
  }

  /// Get showtimes for all cinemas for a specific movie and date
  Map<String, List<Showtime>> getAllShowtimes({
    required int movieId,
    required DateTime date,
  }) {
    final cinemas = getMockCinemas();
    final Map<String, List<Showtime>> showtimesByCinema = {};

    for (final cinema in cinemas) {
      showtimesByCinema[cinema.id] = generateShowtimes(
        cinemaId: cinema.id,
        movieId: movieId,
        date: date,
      );
    }

    return showtimesByCinema;
  }

  // Helper: Price varies by time (peak hours more expensive)
  double _getPriceForTime(int hour) {
    if (hour >= 18 && hour <= 21) {
      return 120000; // Peak hours
    } else if (hour >= 12 && hour < 18) {
      return 100000; // Afternoon
    } else {
      return 80000; // Morning
    }
  }

  // Helper: Random available seats
  int _getRandomSeats() {
    return 40 + (DateTime.now().millisecond % 60);
  }
}
