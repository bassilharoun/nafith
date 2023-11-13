import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/models/raqi_user_model.dart';
import 'package:nafith/raqi_app/modules/login/login_screen.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';
import 'package:nafith/raqi_app/shared/network/local/cache_helper.dart';

void signOut(context){
  CacheHelper.removeData(key: 'uId').then((value) {
    if(value){
      uId = '';
      RaqiCubit.get(context).userModel = UserModel.fromJson({});
      navigateAndFinish(context, LoginScreen());
    }
  });
}
Locale myLocale = window.locale;
dynamic uId = '' ;
dynamic deviceToken = '' ;
dynamic whoIcallId = '' ;
UserModel? whoIcallModel ;
dynamic whoIcallName = '' ;
dynamic whoIcallPic = '' ;

String PaymobApiKey = 'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SndjbTltYVd4bFgzQnJJam8xTlRBMk16VXNJbTVoYldVaU9pSnBibWwwYVdGc0lpd2lZMnhoYzNNaU9pSk5aWEpqYUdGdWRDSjkuXzhsdk5rLXNGR2FkcHc5TlpSVGxmSmVEUm9wLWFHajREa3kxdkM0T3F3bGJHS3NBcklLVEtmSFZxREduUDNuYXFGY2Z0TFJnd3BuemFxci0yR3U4cUE=' ;
String PaymobToken = '' ;
String PaymobOrderId = '' ;
String PaymobFinalToken = '' ;
String IntegrationIDCard = '2888080' ;
String RefCode = '' ;


final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();