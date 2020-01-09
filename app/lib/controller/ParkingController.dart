import 'package:parknspot/view/Parking.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:convert';

class ParkingController {
  ParkingState _parkingState;

  ParkingController(ParkingState parkingState){
    _parkingState  = parkingState;
  }

  Future<bool> setAvailability(int availability, double lat, double lon) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'setAvailability'
    );

    try{
      HttpsCallableResult resp = await callable.call(<String, dynamic>{
        'availability' : availability,
        'lat' : lat,
        'lon' : lon
      });
      
      if(resp.data['Code'] == 100){
        return true;
      }else{
        print('code != 100');
        return false;
      }
    }on CloudFunctionsException catch(e){
      print('CloudFunctionsException');
      print(e);
      return false;
    }catch(e){
      print('Generic exception');
      print(e);
      return false;
    }
  }

  void setLocation(){

  }

  void unsetLocation(){

  }
}