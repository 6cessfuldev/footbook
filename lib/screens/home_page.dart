import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:footbook/screens/splash_screen_page.dart';
import 'package:footbook/widgets/create_bottom_sheet.dart';
import 'package:rive/rive.dart';
import 'friends_page.dart';
import 'main_page.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:footbook/screens/mini_game_list_page.dart';

class HomePage extends StatefulWidget {
  final String? uploadMessage;

  const HomePage({Key? key, this.uploadMessage}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.uploadMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.uploadMessage!),
        ));
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller,
                    children: renderChildren(),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: renderNavigationBar(),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  SafeArea renderNavigationBar() {
    return SafeArea(
      child: Container(
        height: 60,
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: 
              //darkblue
              Color(0xFFFFFFFF).withOpacity(0.9),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: IconButton(
                iconSize: 40,
                padding: EdgeInsets.all(3),
                icon: Icon(CupertinoIcons.compass, color: controller!.index == 0 ? Color(0xFF000080) : Colors.lightBlueAccent,),
                onPressed: () {
                  controller!.animateTo(0);
                },
              ),
            ),
            Expanded(
              child: IconButton(
                iconSize: 36,
                padding: EdgeInsets.all(3),
                icon: Icon(CupertinoIcons.map_pin_ellipse, color: controller!.index == 1 ? Color(0xFF000080) : Colors.lightBlueAccent),
                onPressed: () {
                  controller!.animateTo(1);
                },
              ),
            ),
            Expanded(
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(CupertinoIcons.add_circled_solid, color: Colors.lightBlueAccent, size: 50,),
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.lightBlueAccent[100],
                    context: context,
                    builder: (context) {
                      return const CreateBottomSheet();
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: IconButton(
                padding: EdgeInsets.all(3),
                icon: Icon(CupertinoIcons.person_3, color: controller!.index == 2 ? Color(0xFF000080) : Colors.lightBlueAccent, size: 50,),
                onPressed: () {
                  controller!.animateTo(2);
                },
              ),
            ),
            Expanded(
              child: IconButton(
                padding: EdgeInsets.all(3),
                icon: Icon(CupertinoIcons.memories, color: controller!.index == 3 ? Color(0xFF000080) : Colors.lightBlueAccent, size: 50,),
                onPressed: () {
                  controller!.animateTo(3);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> renderChildren() {
    return [
      const MainPage(),
      MiniGameListPage(),
      FriendsPage(),
      Container(
        decoration: const BoxDecoration(
            color: Color(0xFFE8E8CC)
        ),
        child: const SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Image(
                image: AssetImage("assets/image/alley.jpg"),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            ],
          ),
        ),
      ),
    ];
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그인 정보'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('이름: 육성민님'),
              // 여기에 다른 로그인 정보를 추가할 수 있습니다.
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // 로그아웃 로직 작성
                await FirebaseAuth.instance.signOut();
                // 로그아웃 후 화면 전환
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SplashScreenPage(),
                  ),
                );
              },
              child: Text('로그아웃'),
            ),
            TextButton(
              onPressed: () {
                // 다이얼로그 닫기
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

}