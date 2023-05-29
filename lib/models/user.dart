import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  bool? checked; //for checkbox
  double? latitude;
  double? longitude;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.checked = false,
    this.latitude,
    this.longitude,
  });

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return User(
      id: data!['id'],
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }

  //tofirestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  //fromMap
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}