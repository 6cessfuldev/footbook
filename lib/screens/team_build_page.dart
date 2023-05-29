import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footbook/models/user.dart' as player;
import 'package:footbook/screens/play_page.dart';


class TeamBuildPage extends StatefulWidget {
  const TeamBuildPage({Key? key}) : super(key: key);

  @override
  State<TeamBuildPage> createState() => _TeamBuildPageState();
}

class _TeamBuildPageState extends State<TeamBuildPage> {
  List<player.User> friends = [];
  List<player.User> selectedFriends = [];

  @override
  void initState() {
    super.initState();
    _getFriends();
  }

  Future<User> getUser() async {
    //fireAuth에서 사용자 가져오기
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user!;
  }

  Future<void> _getFriends() async {
    // fireAuth에서 사용자 가져오기
    getUser().then((user) {
      // fireStore에서 사용자의 친구 목록 가져오기
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('팀 빌드'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayPage(selectedFriends: selectedFriends),
                ),
              );
            },
            icon: Icon(Icons.play_circle_fill, size: 30, color: Colors.lightBlueAccent),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
            selectedTileColor: Colors.grey[200],
            title: Text(friends[index].name!),
            value: friends[index].checked,
            onChanged: (bool? value) {
              setState(() {
                friends[index].checked = value!;
                if(value) {
                  selectedFriends.add(friends[index]);
                } else {
                  selectedFriends.remove(friends[index]);
                }
              });
            },
          );
        },
      ),
    );
  }


}
