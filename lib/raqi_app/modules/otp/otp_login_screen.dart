import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/layout/raqi_layout.dart';
import 'package:nafith/raqi_app/modules/login/cubit/cubit.dart';
import 'package:nafith/raqi_app/modules/login/cubit/states.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';
import 'package:nafith/raqi_app/shared/components/constants.dart';
import 'package:nafith/raqi_app/shared/network/local/cache_helper.dart';

class OtpLoginScreen extends StatelessWidget {

  var pinController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  final String phone ;
  OtpLoginScreen(this.phone);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RaqiLoginCubit(),
      child: BlocConsumer<RaqiLoginCubit , RaqiLoginStates>(
        listener:(context , state){
          if(state is RaqiLoginSuccessState){
            pinController.text = RaqiLoginCubit.get(context).verificationCode;
            RaqiCubit.get(context).getUserData();
            CacheHelper.saveData(
                key: 'uId',
                value: uId).then((value) {
              navigateAndFinish(context, RaqiLayout());
            });

          }
        } ,
        builder:(context , state){
          RaqiLoginCubit.get(context).verifyPhone(phone , context);
          return Scaffold(
            appBar: AppBar(title: Text("${getLang(context,"otpV")}"),),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  children: [
                    Image.asset('assets/images/otp.png',height: 250,),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${getLang(context,"codeSentTo")}" , style: TextStyle(fontSize: 20),),
                        Text('${phone}' , style: TextStyle(fontSize: 24,color: textColor),)
                      ],
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          defaultTxtForm(
                              controller: pinController,
                              type: TextInputType.number,
                              validate: (val){
                                if(val!.isEmpty){
                                  return "";
                                }
                              },
                              label: "OTP"
                          ),
                          SizedBox(height: 15,),
                          defaultButton(function: (){
                            if(formKey.currentState!.validate()){
                              try{FirebaseAuth.instance.signInWithCredential(
                                  PhoneAuthProvider.credential(verificationId: RaqiLoginCubit.get(context).verificationCode, smsCode: pinController.text)
                              ).then((value) {
                                FirebaseFirestore.instance.collection("students").get().then((val) {
                                  val.docs.forEach((element) {
                                    if(element.id == value.user!.uid){
                                        print('pass to home');
                                        print(value.user!.uid);
                                        uId = value.user!.uid;
                                        RaqiLoginCubit.get(context).loginSuccess();
                                    }


                                  });

                                  // if(check == 0){
                                  //   RaqiCubit.get(context).deleteUser(context);
                                  //   navigateTo(context, SignupScreen(1));
                                  // }

                                });
                                if(RaqiLoginCubit.get(context).check == 0){
                                  FirebaseFirestore.instance.collection("teachers").get().then((val) {
                                    val.docs.forEach((element) {
                                      if(element.id == value.user!.uid){
                                        print('pass to home');
                                        print(value.user!.uid);
                                        uId = value.user!.uid;
                                        RaqiLoginCubit.get(context).loginSuccess();
                                      }

                                    });

                                  });
                                }


                              });
                              }catch(e){
                                print('invalid otp');
                              }
                            }
                          }, text: "CHECK"),
                        ],),
                      ),
                    ),


                  ],
                ),
              ),
            ),
          );
        } ,
      ),
    );
  }
}


