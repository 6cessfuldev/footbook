import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footbook/widgets/help_tab.dart';
import 'package:footbook/widgets/mission_tab.dart';
import 'package:geolocator/geolocator.dart';

import '../models/user.dart' as player;
import '../widgets/friends_tab.dart';
import '../widgets/history_tab.dart';
import '../widgets/map_tab.dart';

class PlayPage extends StatefulWidget {
  final List<player.User> selectedFriends;

  PlayPage({Key? key, required this.selectedFriends}) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> with TickerProviderStateMixin {
  TabController? _tabController;
  late Position _position;
  late StreamSubscription<Position> _positionSubscription;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    Geolocator.requestPermission();
    _getPosition();

    // 5초마다 위치 정보를 업로드합니다.
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (_position != null) {
        _uploadPosition(_position);
      }
    });
  }

  void _getPosition() async {
    // 위치 정보를 가져옵니다.
    _positionSubscription = Geolocator.getPositionStream(
            locationSettings: LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10,
            ),
    ).listen((position) {
      setState(() {
        _position = position;
      });
    });
  }

  // 사용자 위치 정보를 firestore에 업로드
  Future<void> _uploadPosition(Position position) async {
    //fireAuth에서 사용자 가져오기
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    double latitude = position.latitude;
    double longitude = position.longitude;

    //위치 정보를 firestore에 업로드
    await _db.collection('users').doc(user!.uid).set({
      'latitude': latitude,
      'longitude': longitude,
    }, SetOptions(merge: true));
  }


  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
    _positionSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.grey,
        title: Text('Play Page', style: TextStyle(color: Colors.grey)),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TabBar(
                indicatorColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                labelColor: Colors.white,
                controller: _tabController,
                onTap: (index) {
                  setState(() {
                    _tabController!.index = index;
                  });

                },
                tabs: [
                  Tab(
                    icon: Icon(Icons.history_edu),
                  ),
                  Tab(
                    icon: Icon(Icons.map_outlined),
                  ),
                  Tab(
                    icon: Icon(Icons.people_alt_outlined),
                  ),
                  Tab(
                    icon: Icon(Icons.history_outlined),
                  ),
                  Tab(
                    icon: Icon(Icons.help_outline),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: renderTabBarChildren(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  renderTabBarChildren() {
    return [
      MissionTab(),
      MapTab(),
      FriendsTab(),
      HistoryTab(),
      HelpTab(),
    ];
  }
}
