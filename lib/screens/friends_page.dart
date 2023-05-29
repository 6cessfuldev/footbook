import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footbook/services/friend_service.dart';

import '../models/user.dart';
import '../models/friend.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<Friend> _friends = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  Future<List<Friend>> _getFriendsInfo() async {

    List<Friend> friends = [];


    return friends;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'FootBook',
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            floating: true,
            snap: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: Colors.lightBlueAccent),
              ),
              //add button
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('친구 추가'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '이름',
                                ),
                                controller: _nameController,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'email',
                                ),
                                controller: _emailController,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('취소')
                            ),
                            TextButton(
                                onPressed: () async {
                                  //validate
                                  if (_nameController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('이름을 입력하세요')));
                                    return;
                                  }
                                  if(_emailController.text.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('전화번호를 입력하세요')));
                                    return;
                                  }
                                  //add friend to firestore
                                  User user = User(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                  );

                                  await FriendService.addFriend(user);

                                  Navigator.pop(context);
                                },
                                child: Text('추가')
                            ),
                          ],
                        );
                      }
                  );
                },
                icon: const Icon(Icons.add, color: Colors.lightBlueAccent),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: Colors.lightBlueAccent),
              ),
            ],
          ),
          FutureBuilder(
            future: _getFriendsInfo(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }else if(snapshot.hasError){
                return SliverFillRemaining(
                  child: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }else{
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(snapshot.data[index].title),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(snapshot.data[index].description),
                                        Text('참여 인원 수 : 2명'),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('참여하기')
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('취소')
                                      ),
                                    ],
                                  );
                                }
                            );
                          },
                          child:SizedBox(
                            height: 200,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(snapshot.data[index].imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data[index].title,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          snapshot.data[index].description,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          snapshot.data[index].tags.toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                      );
                    },
                    childCount: snapshot.data.length,
                  ),
                );
              } // else
            },
          ),
        ],
      ),
    );
  }
}


