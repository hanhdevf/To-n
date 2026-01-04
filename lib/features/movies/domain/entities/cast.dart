import 'package:equatable/equatable.dart';

class Cast extends Equatable {
  final int id;
  final String name;
  final String originalName;
  final String? profilePath;
  final String? character;

  const Cast({
    required this.id,
    required this.name,
    required this.originalName,
    this.profilePath,
    this.character,
  });

  String? get fullProfilePath {
    if (profilePath == null) return null;
    return 'https://image.tmdb.org/t/p/w200$profilePath';
  }

  @override
  List<Object?> get props => [id, name, originalName, profilePath, character];
}
