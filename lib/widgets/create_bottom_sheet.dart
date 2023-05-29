import 'package:flutter/material.dart';
import 'package:footbook/screens/create_short_page.dart';
import 'package:footbook/screens/create_story_page.dart';

class CreateBottomSheet extends StatelessWidget {
  const CreateBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height / 6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateShortPage()),
                  );

                },
                child: Text('짧은 글', style: TextStyle(color: Colors.white, fontSize: 25, ),)
            ),
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateStoryPage()),
                  );
                },
                child: Text('긴 글', style: TextStyle(color: Colors.white, fontSize: 25, ),)
            ),
          ],
        ),
      )
    );
  }
}
