import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String author;
  final String? avatarPath;
  final double? rating;
  final String content;
  final String createdAt;

  const Review({
    required this.id,
    required this.author,
    this.avatarPath,
    this.rating,
    required this.content,
    required this.createdAt,
  });

  String? get fullAvatarPath {
    if (avatarPath == null) return null;
    if (avatarPath!.startsWith('http')) return avatarPath;
    if (avatarPath!.startsWith('/')) {
      return 'https://image.tmdb.org/t/p/w200$avatarPath';
    }
    return avatarPath;
  }

  @override
  List<Object?> get props =>
      [id, author, avatarPath, rating, content, createdAt];
}
