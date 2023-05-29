import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'create_story_step_page.dart';

class CreateStoryPage extends StatefulWidget {
  @override
  _CreateStoryPageState createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends State<CreateStoryPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late File? _image = null;
  final picker = ImagePicker();
  late TextEditingController _tagController;
  List<String> _tags = [];

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadImageToFirebase(File image) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("story_image/" + DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (error) {
      print(error);
      return "";
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _tagController = TextEditingController();
  }

  Widget _buildTags(List<String> tags) {
    return Wrap(
      spacing: 8,
      children: tags.map((tag) {
        return InputChip(
          label: Text(tag),
          onDeleted: () {
            setState(() {
              _tags.remove(tag);
            });
          },
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Create Story'),
      ),
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              GestureDetector(
                onTap: () {
                getImage();
                },
                child: Center(
                  child: _image == null
                  ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[200],
                    ),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Colors.black,
                    ),
                  )
                  : Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _image != null ? FileImage(_image!) : FileImage(File('')),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Title',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200],
                ),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Description',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200]
                ),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Tags',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.grey[200],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _tagController,
                        decoration: InputDecoration.collapsed(
                          hintText: '태그를 입력하세요',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        setState(() {
                          _tags.add(_tagController.text);
                          _tagController.clear();
                        });
                      },
                      child: Text('추가'),
                    )
                  ],
                ),
              ),
              _buildTags(_tags),
              SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    maximumSize: Size(200, 50),
                    minimumSize: Size(200, 50),
                    primary: Colors.grey[200],
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String imageUrl = await uploadImageToFirebase(_image!);
                      final user = FirebaseAuth.instance.currentUser;
                      // use firestore to save the story
                      final db = FirebaseFirestore.instance;
                      await db.collection('stories').add({
                        'title': _titleController.text,
                        'description': _descriptionController.text,
                        'imageUrl': imageUrl,
                        'tags': _tags,
                        'created_at': DateTime.now(),
                        'author': user!.uid,
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreatStoryStepPage()),
                      );
                    }
                  },
                  child: Text('Next', style: TextStyle(fontSize: 20.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}