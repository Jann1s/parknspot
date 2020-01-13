import 'package:flutter/foundation.dart';
import 'package:parknspot/view/Map.dart';
import 'package:cloud_functions/cloud_functions.dart';
class MapController {
  MyMapState _myMapState;

  MapController(MyMapState myMapState){
    _myMapState = myMapState;
  }

  Future<bool> getParkingLocations(num latitude, num longitude, int radius) async{
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'getParkingLocations'
    );
    try {
      HttpsCallableResult resp = await callable.call(<String,dynamic>{
        'radius' : radius,
        'latitude': latitude,
        'longitude': longitude
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
}
