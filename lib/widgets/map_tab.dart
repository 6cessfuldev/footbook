import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:footbook/models/user.dart' as player;
import 'package:firebase_auth/firebase_auth.dart';

class MapTab extends StatefulWidget {
  const MapTab({Key? key}) : super(key: key);

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  User? user = FirebaseAuth.instance.currentUser!;
  List<player.User> friends = [];
  late StreamSubscription<QuerySnapshot> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('friends')
        .snapshots()
        .listen((snapshot) {
      final List<player.User> friends = snapshot.docs
          .map((documentSnapshot) => player.User.fromMap(documentSnapshot.data() as Map<String, dynamic>))
          .toList();

      setState(() {
        this.friends = friends;
      });
    });
  }

  // 친구 목록을 가져오는 함수
  Future<void> _getFriends() async {
    // fireAuth에서 사용자 가져오기
    if(user == null){
      user = FirebaseAuth.instance.currentUser!;
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('friends')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          // 친구 목록을 Friend 객체로 변환
          player.User friend = player.User(
            name: doc['name'],
            email: doc['email'],
          );
          // 친구 목록에 추가
          friends.add(friend);
        });
        // 친구 목록을 화면에 출력
        setState(() {
          friends = friends;
        });
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //google map
          SizedBox(
            height: MediaQuery.of(context).size.height-139,
            child: GoogleMap(
              markers: {
                Marker(
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                  markerId: const MarkerId('marker_1'),
                  position: const LatLng(37.42796133580664, -122.085749655962),
                  infoWindow: InfoWindow(
                    title: '나',
                    anchor: const Offset(0.5, 0),
                  ),
                  visible: true,
                ),
                Marker(
                  markerId: const MarkerId('marker_2'),
                  position: const LatLng(37.42796133580664, -122.095749655562),
                  infoWindow: const InfoWindow(
                    title: 'Marker 2',
                    snippet: 'This is a snippet',
                  ),
                  visible: true,
                ),
              },
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                  target: LatLng(37.42796133580664, -122.085749655962),
                  zoom: 14),
            ),
          )
        ],
      ),
    );
  }
}
