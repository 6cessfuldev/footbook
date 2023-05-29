import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'login_page.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
  }

  void _playBackgroundMusic() async {
    _audioPlayer = AudioPlayer();
    _audioPlayer.setSourceAsset('audio/bgm.mp3');
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.setVolume(0.5);
    await _audioPlayer.resume();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 96),
            Text(
              "FootBook",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 80,fontWeight: FontWeight.bold,color: Colors.lightBlueAccent,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.deepPurple,
                      offset: Offset(4.0, 4.0),
                    ),
                  ],
                ),
            ),
            Text(
              '당신의 세상에서',
              style: TextStyle(fontSize: 24, color: Colors.deepPurple, fontWeight: FontWeight.w500, shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.white,
                  offset: Offset(4.0, 4.0),
                ),
              ],
              ),
            ),
            Text(
              '새로운 이야기를 만나세요!',
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w500, shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.deepPurple,
                  offset: Offset(4.0, 4.0),
                ),
              ],
              ),
            ),
            SizedBox(height: 64),
            ElevatedButton(
              onPressed: () {
                showGeneralDialog(
                  transitionDuration: Duration(milliseconds: 600),
                  transitionBuilder: (context, animation, secondaryAnimation, child) {
                    Tween<Offset> tween;
                    tween = Tween(begin: Offset(0, -1), end: Offset.zero);
                    return SlideTransition(
                      position: tween.animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
                      child: child,
                    );
                  },
                  barrierDismissible: true,
                  barrierLabel: "Sign In",
                  context: context,
                  pageBuilder: (context, _, __) => Center(
                    child: Container(
                      height: 620,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        //opacity: 0.8

                      ),
                      child: LoginPage(),

                    ),
                  ),
                );
              },
              child: Text('시작하기', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 60),
                backgroundColor: Colors.lightBlueAccent,
                textStyle: TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                elevation: 30,
                shadowColor: Colors.white,
              ),
            ),
            Offstage(
              offstage: true,
              child: LoginPage(),
            )
          ],
        ),
      ),
    );
  }
}
