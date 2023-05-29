import 'package:flutter/material.dart';

Widget SocialLoginButton(String path, VoidCallback onTap) {
  return Card(
    elevation: 18.0,
    shape: const CircleBorder(),
    clipBehavior: Clip.antiAlias,
    child: Ink.image(
      image: AssetImage('assets/icon/$path.png'),
      width: 50,
      height: 50,
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(35.0),
        ),
        onTap: onTap,
      ),
    ),
  );
}