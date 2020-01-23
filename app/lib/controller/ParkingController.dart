import 'package:parknspot/view/Parking.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:geolocator/geolocator.dart';

class ParkingController {
  ParkingState _parkingState;

  ParkingController(ParkingState parkingState){
    _parkingState  = parkingState;
  }

  Future<bool> setAvailability(int availability) async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'setAvailability'
    );
    
    try{
      HttpsCallableResult resp = await callable.call(<String, dynamic>{
        'availability' : availability,
        'lat' : position.latitude,
        'lon' : position.longitude
      });
      
      if(resp.data['Code'] == 100){
        return true;
      }else{
        print('code != 100');
        return false;
      }
    }on CloudFunctionsException catch(e){
      print('CloudFunctionsException');
      print(e.code);
      print(e.details);
      print(e.message);
      return false;
    }catch(e){
      print('Generic exception');
      print(e);
      return false;
    }
  }

  Future<bool> setLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'setLocation'
    );

    try {
      HttpsCallableResult resp = await callable.call(<String, dynamic>{
        'lat' : position.latitude,
        'lon' : position.longitude
      });

      if(resp.data['Code'] == 100){
        return true;
      }else{
        print('code != 100');
        return false;
      }
    }on CloudFunctionsException catch (e) {
      print('CloudFunctionsException');
      print(e);
      return false;
    }catch(e){
      print('Generic exception');
      print(e);
      return false;
    }
  }

  Future<bool> unsetLocation() async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'unSetLocation'
    );

    try {
      HttpsCallableResult resp = await callable.call();

      if(resp.data['Code'] == 100){
        return true;
      }else{
        print('code != 100');
        return false;
      }
    }on CloudFunctionsException catch (e) {
      print('CloudFunctionsException');
      print(e);
      return false;
    }catch(e){
      print('Generic exception');
      print(e);
      return false;
    }
  }

  Future<Position> getUserLocation() async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'getUserLocation'
    );

    try {
      HttpsCallableResult resp = await callable.call();

      if(resp.data['Code'] == 100){
        return Position(latitude: resp.data['Data']['_latitude'], longitude: resp.data['Data']['_longitude']);
      }else{
        print('code != 100');
        return null;
      }
    }on CloudFunctionsException catch (e) {
      print('CloudFunctionsException');
      print(e);
      return null;
    }catch(e){
      print('Generic exception');
      print(e);
      return null;
    }
  }
}