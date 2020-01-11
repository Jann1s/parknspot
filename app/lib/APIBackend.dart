import 'package:cloud_functions/cloud_functions.dart';

class APIBackend {

  Future<bool> isUserLocationSet() async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'isLocationSet'
    );

    try{
      HttpsCallableResult resp = await callable.call();
      
      if(resp.data['Code'] == 100){
        return resp.data['Result'] as bool;
      }else{
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
}