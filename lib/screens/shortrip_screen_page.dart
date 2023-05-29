import 'package:flutter/material.dart';
import 'package:footbook/models/shortrip.dart';
import 'package:footbook/services/location_service.dart';
import 'package:footbook/widgets/fancy_title.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShortripScreenPage extends StatefulWidget {
  final Shortrip shortrip;

  const ShortripScreenPage({required this.shortrip});

  @override
  State<ShortripScreenPage> createState() => _ShortripScreenPageState();
}

class _ShortripScreenPageState extends State<ShortripScreenPage> {
  late LatLng? _userLocation;
  late LatLng? _destinationLocation = LatLng(
    widget.shortrip.destinationLatitude,
    widget.shortrip.destinationLongitude,
  );

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<int> _getLocation() async {
    try {
      Position position = await LocationService.getCurrentLocation();
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (error) {
      print(error);
    }
    return _calculateDistance();
  }

  int _calculateDistance() {
    if(_userLocation == null || _destinationLocation == null) return 1000000000;
    double distance = Geolocator.distanceBetween(
      _userLocation!.latitude,
      _userLocation!.longitude,
      _destinationLocation!.latitude,
      _destinationLocation!.longitude,
    );
    return distance.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FancyTitle(title: widget.shortrip.title),
                    SizedBox(height: 16),
                    Text(widget.shortrip.content),
                  ],
                ),
              ),
            ),
            Container(
              height: 200,
              width: double.infinity,
              child: Text('지도'),
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    await _getLocation();
                    if(_calculateDistance()>100) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('목적지까지 100m 이내로 다가와주세요'),
                        ),
                      );
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('도착 완료'),
                        ),
                      );
                    }
                  },
                  child: Text('도착 완료', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
            SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}
