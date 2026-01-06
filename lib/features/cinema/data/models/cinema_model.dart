import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galaxymob/features/cinema/domain/entities/cinema.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cinema_model.g.dart';

/// Firestore data model for Cinema
@JsonSerializable()
class CinemaModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  final List<String>? facilities;

  const CinemaModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.logoUrl,
    this.facilities,
  });

  /// Convert from Firestore document
  factory CinemaModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('Cinema document is null');
    }

    // Handle GeoPoint if Firestore stores location as GeoPoint
    final location = data['location'] as GeoPoint?;

    return CinemaModel(
      id: snapshot.id,
      name: data['name'] as String,
      address: data['address'] as String,
      latitude: location?.latitude ?? data['latitude'] as double,
      longitude: location?.longitude ?? data['longitude'] as double,
      logoUrl: data['logo_url'] as String?,
      facilities: (data['facilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'address': address,
      'location': GeoPoint(latitude, longitude),
      'latitude': latitude,
      'longitude': longitude,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (facilities != null) 'facilities': facilities,
    };
  }

  /// Convert from JSON
  factory CinemaModel.fromJson(Map<String, dynamic> json) =>
      _$CinemaModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$CinemaModelToJson(this);

  /// Convert to domain entity
  Cinema toEntity() {
    return Cinema(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      logoUrl: logoUrl,
      facilities: facilities,
    );
  }

  /// Create from domain entity
  factory CinemaModel.fromEntity(Cinema cinema) {
    return CinemaModel(
      id: cinema.id,
      name: cinema.name,
      address: cinema.address,
      latitude: cinema.latitude,
      longitude: cinema.longitude,
      logoUrl: cinema.logoUrl,
      facilities: cinema.facilities,
    );
  }
}
