import 'package:flutter/material.dart';

class CreatStoryStepPage extends StatefulWidget {
  const CreatStoryStepPage({Key? key}) : super(key: key);

  @override
  State<CreatStoryStepPage> createState() => _CreatStoryStepPageState();
}

class _CreatStoryStepPageState extends State<CreatStoryStepPage> {
  List<String> _steps = [''];

  void _addStep() {
    setState(() {
      _steps.add('');
    });
  }

  void _updateStep(int index, String value) {
    setState(() {
      _steps[index] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('단계 추가 및 수정')),
      body: ListView.builder(
        itemCount: _steps.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: TextFormField(
                  initialValue: _steps[index],
                  onChanged: (value) {
                    _updateStep(index, value);
                  },
                  decoration: InputDecoration(
                    labelText: '단계 ${index + 1} 텍스트',
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStep,
        child: Icon(Icons.add),
      ),
    );
  }
}
