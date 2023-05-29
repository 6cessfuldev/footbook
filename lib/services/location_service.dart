import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if(!isLocationEnabled){
      return '위치 서비스를 활성화해주세요';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if(checkedPermission == LocationPermission.denied){
      checkedPermission = await Geolocator.requestPermission();

      if(checkedPermission == LocationPermission.denied){
        return '위치 권한을 허용해주세요.';
      }
    }

    if(checkedPermission == LocationPermission.deniedForever){
      return '앱의 위치 권한을 설정에서 허가해주세요.';
    }

    return '위치 권한이 허가 되었습니다.';
  }

  static Future<Position> getCurrentLocation() async {
    String permissionResult = await checkPermission();

    if(permissionResult == '위치 권한이 허가 되었습니다.'){
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }else{
      return Future.error(permissionResult);
    }
  }
}
