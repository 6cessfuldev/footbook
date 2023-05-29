import 'package:flutter/material.dart';

class HelpTab extends StatefulWidget {
  const HelpTab({Key? key}) : super(key: key);

  @override
  State<HelpTab> createState() => _HelpTabState();
}

class _HelpTabState extends State<HelpTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Help Tab',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
