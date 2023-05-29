import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footbook/models/shortrip.dart';
import 'package:footbook/screens/shortrip_screen_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/location_service.dart';

class MiniGameListPage extends StatefulWidget {
  const MiniGameListPage({super.key});

  @override
  State<MiniGameListPage> createState() => _MiniGameListPageState();
}

class _MiniGameListPageState extends State<MiniGameListPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
          SliverList(
              delegate: SliverChildListDelegate(
                [
                  GestureDetector(
                    child: Image.asset('assets/image/hideandseek.jpg'),
                    onTap: () {
                      //dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('알리'),
                            content: Text('알리'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('닫기'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  ),
                  GestureDetector(
                      child: Image.asset('assets/image/alley.jpg'),
                      onTap: () {
                        //dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('알리'),
                              content: Text('알리'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('닫기'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                  ),
                  GestureDetector(
                      child: Image.asset('assets/image/alley.jpg'),
                      onTap: () {
                        //dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('알리'),
                              content: Text('알리'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('닫기'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                  ),GestureDetector(
                    child: Image.asset('assets/image/alley.jpg'),
                    onTap: () {
                      //dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('알리'),
                            content: Text('알리'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('닫기'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                ),

                ]
              )
          )
          
          
        ], // slivers
      ),
    );
  }
}
