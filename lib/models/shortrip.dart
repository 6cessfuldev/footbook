import 'package:cloud_firestore/cloud_firestore.dart';

class Shortrip {
  final String title;
  final List<String> tags;
  final String content;
  final String reward;
  final String authorId;
  final double destinationLatitude;
  final double destinationLongitude;
  final int? distance;

  Shortrip({
    required this.title,
    required this.tags,
    required this.content,
    required this.reward,
    required this.authorId,
    required this.destinationLatitude,
    required this.destinationLongitude,
    this.distance,

  });

  factory Shortrip.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Shortrip(
      title: data?['title'] ?? '',
      tags: data?['tags'] is Iterable ? List.from(data?['tags']) : [],
      content: data?['content'] ?? '',
      reward: data?['reward'] ?? 0,
      authorId: data?['authorId'] ?? '',
      destinationLatitude: data?['destination_latitude'] ?? 0.0,
      destinationLongitude: data?['destination_longitude'] ?? 0.0,
      distance: data?['distance'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if(title != null) 'title': title,
      if(tags != null) 'tags': tags,
      if(content != null) 'content': content,
      if(reward != null) 'reward': reward,
      if(authorId != null) 'authorId': authorId,
      if(destinationLatitude != null) 'destination_latitude': destinationLatitude,
      if(destinationLongitude != null) 'destination_longitude': destinationLongitude,
      if(distance != null) 'distance': distance,
    };
  }

  factory Shortrip.fromMap(Map<String, dynamic> map) {
    return Shortrip(
      title: map['title'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      content: map['content'] ?? '',
      destinationLatitude: map['destination_latitude'] ?? 0.0,
      destinationLongitude: map['destination_longitude'] ?? 0.0,
      reward: map['reward'] ?? 0,
      authorId: map['author_id'] ?? '',
      distance: map['distance'] ?? 0,
    );
  }


}