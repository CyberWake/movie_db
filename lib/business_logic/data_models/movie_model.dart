import 'package:cloud_firestore/cloud_firestore.dart';

class MovieInfo {
  final String id;
  final String name;
  final bool isPublic;
  final String owner;

  MovieInfo({this.id = '',required this.owner, required this.name, required this.isPublic});

  factory MovieInfo.fromDocumentSnapshot(DocumentSnapshot snap) {
    final json = snap.data() as Map<String, dynamic>;
    return MovieInfo(
      owner: json['owner'].toString(),
      name: json['name'].toString(),
      isPublic: json['isPublic'] as bool? ?? false,
      id: snap.id,
    );
  }
}
