import 'package:equatable/equatable.dart';

/// Cinema entity representing a movie theater
class Cinema extends Equatable {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? logoUrl;
  final List<String>? facilities;

  const Cinema({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.logoUrl,
    this.facilities,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        latitude,
        longitude,
        logoUrl,
        facilities,
      ];

  /// Calculate distance from user location (simplified)
  double distanceFrom(double userLat, double userLon) {
    // Simplified distance calculation (not accurate, just for demo)
    final latDiff = latitude - userLat;
    final lonDiff = longitude - userLon;
    return (latDiff * latDiff + lonDiff * lonDiff) * 111; // Rough km estimation
  }

  @override
  String toString() => 'Cinema(id: $id, name: $name)';
}
