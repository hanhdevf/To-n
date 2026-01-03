import 'package:equatable/equatable.dart';

/// Seat types
enum SeatType {
  regular,
  vip,
  couple,
}

/// Seat status
enum SeatStatus {
  available,
  selected,
  booked,
}

/// Seat entity representing a cinema seat
class Seat extends Equatable {
  final String id;
  final String row;
  final int number;
  final SeatType type;
  final SeatStatus status;
  final double price;

  const Seat({
    required this.id,
    required this.row,
    required this.number,
    required this.type,
    required this.status,
    required this.price,
  });

  @override
  List<Object?> get props => [id, row, number, type, status, price];

  /// Copy with method for status changes
  Seat copyWith({
    SeatStatus? status,
  }) {
    return Seat(
      id: id,
      row: row,
      number: number,
      type: type,
      status: status ?? this.status,
      price: price,
    );
  }

  /// Get display name (e.g., "A1", "B5")
  String get displayName => '$row$number';

  @override
  String toString() => 'Seat($displayName, $type, $status)';
}
