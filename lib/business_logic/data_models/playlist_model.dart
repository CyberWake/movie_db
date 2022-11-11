import 'package:cloud_firestore/cloud_firestore.dart';

class PlaylistInfo {
  final String id;
  final String name;
  final String owner;
  final bool visibility;
  final List<String> movies;

  PlaylistInfo({
    required this.id,
    required this.name,
    required this.owner,
    required this.visibility,
    required this.movies,
  });

  factory PlaylistInfo.fromDocumentSnapshot(DocumentSnapshot snap) {
    final json = snap.data() as Map<String, dynamic>;
    return PlaylistInfo(
      id: snap.id,
      name: json['name'],
      owner: json['owner'],
      visibility: json['visibility'] as bool,
      movies: json['movies'] == null
          ? []
          : (json['movies'] as List).map((e) => e.toString()).toList(),
    );
  }
}
