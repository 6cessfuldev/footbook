import 'package:cloud_firestore/cloud_firestore.dart';

class StoryInfo {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final Timestamp createdAt;
  final String authorId;

  StoryInfo({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.authorId,
    required this.tags,
  });

//factory fromFirestore
  factory StoryInfo.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return StoryInfo(
      title: data?['title'] ?? '',
      description: data?['description'] ?? '',
      imageUrl: data?['imageUrl'] ?? '',
      createdAt: data?['createdAt'] ?? '',
      tags: List<String>.from(data?['tags'] ?? []),
      authorId: data?['authorId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if(title != null) 'title': title,
      if(description != null) 'description': description,
      if(imageUrl != null) 'imageUrl': imageUrl,
      if(tags != null) 'tags': tags,
      if(createdAt != null) 'createdAt': createdAt,
      if(authorId != null) 'authorId': authorId,
    };
  }

  factory StoryInfo.fromMap(Map<String, dynamic> map) {
    return StoryInfo(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: map['createdAt'] ?? '',
      authorId: map['authorId'] ?? '',
    );
  }
}
