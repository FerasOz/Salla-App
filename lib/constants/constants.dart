import 'package:shop_app/screens/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/helper/cache_helper.dart';

void SIGNOUT(context){
  CacheHelper.removeData(key: 'token').then((value) {
    if(value){
      navigateAndFinish(context, LoginScreen());
    }
  });
}

String? token ;
String? uId ;