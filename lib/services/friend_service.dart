import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footbook/models/friend.dart';
import 'package:footbook/models/user.dart' as player;

//freind service by firestore
class FriendService {

  static Future<List<player.User>> getFriendsInfo() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser!.uid;

    List<player.User> friends = [];

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('friends')
          .get();
      final List<QueryDocumentSnapshot> docs = await snapshot.docs;
      if (docs.isNotEmpty) {
        final it = docs.iterator;
        while (it.moveNext()) {
          final doc = it.current;
          final friendInfo = player.User(
            name: doc['name'],
            phone: doc['phone'],
            email: doc['email'],
          );
          friends.add(friendInfo);
        }
      }
    } catch (error) {
      print(error);
    }

    return friends;
  }

  static Future<void> addFriend(player.User friend) async {

    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser!.uid;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('friends')
          .doc(friend.id)
          .set({
        'email': friend.email,
        'name': friend.name,
      });

    } catch (error) {
      print(error);
    }
  }
}
