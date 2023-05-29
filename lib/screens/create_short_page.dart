import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footbook/screens/home_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import '../services/location_service.dart';

class CreateShortPage extends StatefulWidget {
  const CreateShortPage({Key? key}) : super(key: key);

  @override
  State<CreateShortPage> createState() => CreateShortPageState();
}

class CreateShortPageState extends State<CreateShortPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  late TextEditingController _titleController;
  late TextEditingController _tagController;
  late TextEditingController _contentController;
  late TextEditingController _rewardController;
  List<String> _tags = [];

  Completer<GoogleMapController> _googleMapController = Completer();
  LatLng _destinationLatLng = LatLng(37.5665, 126.9780);

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _tagController = TextEditingController();
    _contentController = TextEditingController();
    _rewardController = TextEditingController();
    _initializeDestinationLatLng();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tagController.dispose();
    _contentController.dispose();
    _rewardController.dispose();
    super.dispose();
  }

  Future<void> _initializeDestinationLatLng() async {
    try {
      final position = await LocationService.getCurrentLocation();
      setState(() {
        _destinationLatLng = LatLng(position.latitude, position.longitude);
      });
      _gotoSpecificPosition(_destinationLatLng);
    } catch (error) {
      // 위치 정보를 가져올 수 없는 경우에 대한 예외 처리
      print(error);
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // 현재 로그인한 사용자의 uid를 가져오기
      final User? user = FirebaseAuth.instance.currentUser;
      final userId = user!.uid;

      // Firestore 데이터베이스에 데이터 추가
      await FirebaseFirestore.instance.collection('shorts').doc('shortripInfo').set({
        'title': _titleController.text,
        'tags': _tags,
        'content': _contentController.text,
        'destination_latitude': _destinationLatLng.latitude,
        'destination_longitude': _destinationLatLng.longitude,
        'reward': _rewardController.text,
        'author_id': userId, // 작성자 id 추가
      });

      // 폼 초기화 및 상태 초기화
      _formKey.currentState!.reset();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const HomePage(
              uploadMessage: 'Shortrip이 성공적으로 업로드되었습니다.',
            )
        )
      );
    }
  }


  void _saveTemperaly() {
    print('임시저장');
  }

  Widget _getCustomPin(){
    return Center(
      child: Container(
        width: 100,
        child: Lottie.asset("asset/image/pin.json"),
      ),
    );
  }

  Future _gotoSpecificPosition(LatLng position) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 17.5
        )
      )
    );
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shortrip 제작'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveTemperaly,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepTapped: (int index) {
            setState(() {
              _currentStep = index;
            });
          },
          onStepContinue: () {
            setState(() {
              if (_currentStep < 4) {
                _currentStep += 1;
              } else {
                _submitForm();
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (_currentStep > 0) {
                _currentStep -= 1;
              } else {
                Navigator.pop(context);
              }
            });
          },
          steps: [
            Step(
              title: Text('제목'),
              content: TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '제목을 입력하세요',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력해주세요';
                  }
                  return null;
                }
              ),
              isActive: _currentStep == 0,
            ),
            Step(
              title: Text('태그'),
              content: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _tagController,
                          decoration: InputDecoration(
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
                  _buildTags(_tags)
                ],
              ),
              isActive: _currentStep == 1,
            ),
            Step(
              title: Text('컨텐츠'),
              content: TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: '컨텐츠를 입력하세요',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '컨텐츠를 입력해주세요';
                  }
                  return null;
                },
              ),
              isActive: _currentStep == 2,
            ),
            Step(
              title: Text('목적지'),
              content: SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: _destinationLatLng,
                        zoom: 18,
                      ),
                      onTap: (position){
                        _gotoSpecificPosition(LatLng(position.latitude, position.longitude));
                        _destinationLatLng = position;
                      },
                      onCameraIdle: (){

                      },
                      onCameraMove: (cameraPosition){

                      },
                      onMapCreated: (GoogleMapController controller){
                        if(!_googleMapController.isCompleted){
                          _googleMapController.complete(controller);
                        }
                      },
                    ),
                    _getCustomPin(),
                    Positioned(
                      right: 6,
                      top: 6,
                      height: 40,
                      width: 40,
                      child: FloatingActionButton(
                        backgroundColor: Colors.grey[200],
                        onPressed: _initializeDestinationLatLng,
                        child: Icon(Icons.my_location_outlined),
                      ),
                    )
                  ],
                ),
              ),
              isActive: _currentStep == 3,
            ),
            Step(
              title: Text('보상'),
              content: TextFormField(
                controller: _rewardController,
                decoration: InputDecoration(
                  hintText: '보상을 입력하세요',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '보상을 입력해주세요';
                  }
                  return null;
                },
              ),
              isActive: _currentStep == 4,
            ),
          ],
        ),
      ),
    );
  }
}
