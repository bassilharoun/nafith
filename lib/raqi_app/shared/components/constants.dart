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

const double defaultPadding = 16.0;
const double defaultBorderRadious = 12.0;
const Duration defaultDuration = Duration(milliseconds: 300);


const productDemoImg1 = "https://www.albayan.ae/assets/archives//images/2021/12/11/4321362.JPG";
const productDemoImg2 = "https://dlil-saudi.com/user_images/news/17-09-24-348050118.webp";
const productDemoImg3 = "https://www.organicnationeg.com/cdn/shop/files/Olive-Oil-Gold-250ml.jpg?v=1701948694";
const productDemoImg4 = "https://mcprod.hyperone.com.eg/media/catalog/product/cache/8d4e6327d79fd11192282459179cc69e/6/2/6221024992605_650g-n23-.jpg";
const productDemoImg5 = "https://media.zid.store/9e2147cf-003a-4a7e-97cb-02e7fc34782d/e58acbfc-5457-43f0-94af-fc4ce385efa5.jpg";
const productDemoImg6 = "https://cloudinary.images-iherb.com/image/upload/f_auto,q_auto:eco/images/smt/smt21306/y/10.jpg";
