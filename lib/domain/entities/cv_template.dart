import 'package:equatable/equatable.dart';

class CVTemplate extends Equatable {
  final String id;
  final String name;
  final String description;
  final String thumbnailPath; // e.g., 'assets/templates/modern.png'
  final bool isPremium;
  final List<String> tags; // e.g., ['Simple', 'Tech', 'Creative']

  const CVTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailPath,
    this.isPremium = false,
    this.tags = const [],
  });

  @override
  List<Object?> get props => [id, name, description, thumbnailPath, isPremium, tags];
}
