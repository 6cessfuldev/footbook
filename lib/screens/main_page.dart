import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footbook/models/storyinfo.dart';
import 'package:footbook/screens/team_build_page.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}
//Story 클래스 리스트에 담아서 스토리들을 불러온다.
class _MainPageState extends State<MainPage> {
  List<StoryInfo> _stories = [];

  Future<List<StoryInfo>> _getStoryInfo() async {

    List<StoryInfo> storyInfos = [];
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('stories')
          .get();
      final List<QueryDocumentSnapshot> docs = await snapshot.docs;
      if (docs.isNotEmpty) {
        print("===========================docSnap이 있긴 하냐===========================");
        print(docs.length);
        final it = docs.iterator;
        while (it.moveNext()) {
          final doc = it.current;
          final storyInfo = StoryInfo(
            title: doc['title'],
            description: doc['description'],
            imageUrl: doc['imageUrl'],
            tags: List<String>.from(doc['tags']),
            createdAt: doc['created_at'],
            authorId: doc['author'],
          );
          storyInfos.add(storyInfo);
          print("===========================shortripInfo===========================");
        }
      }
    } catch (error) {
      print(error);
    }
    return storyInfos;
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
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: Colors.lightBlueAccent),
              ),
            ],
          ),
          FutureBuilder(
            future: _getStoryInfo(),
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
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => TeamBuildPage())
                                          );
                                        },
                                        child: Text('팀구성하기')
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
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.lightBlueAccent,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          snapshot.data[index].description,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        //태그를 여러 박스 형태로
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.lightBlueAccent,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                snapshot.data[index].tags[0],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.lightBlueAccent,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                snapshot.data[index].tags[1],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Text(
                                        //   snapshot.data[index].tags.toString(),
                                        //   style: TextStyle(
                                        //     fontSize: 15,
                                        //   ),
                                        // ),
                                        // SizedBox(height: 10),
                                        // Text(
                                        //   DateFormat('yyyy-MM-dd').format(snapshot.data[index].createdAt.toDate()) as String,
                                        //   style: TextStyle(
                                        //     fontSize: 15,
                                        //   ),
                                        // ),
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
