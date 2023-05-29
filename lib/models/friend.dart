import 'package:cloud_firestore/cloud_firestore.dart';

class Friend {
  final String? id;
  final String name;
  final String email;

  Friend({
    //not required member id
    this.id,
    required this.name,
    required this.email,
  });

  factory Friend.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Friend(
      id: data!['id'],
      name: data!['name'],
      email: data['email'],
    );
  }

  //tofirestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
    };
  }

  //fromMap
  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }
}