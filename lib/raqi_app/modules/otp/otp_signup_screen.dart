import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/layout/raqi_layout.dart';
import 'package:nafith/raqi_app/modules/signup/cubit/cubit.dart';
import 'package:nafith/raqi_app/modules/signup/cubit/states.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';
import 'package:nafith/raqi_app/shared/components/constants.dart';
import 'package:nafith/raqi_app/shared/network/local/cache_helper.dart';

class OtpScreen extends StatelessWidget {

  var pinController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  final String phone ;
  final String name ;
  final String email ;
  final String type ;
  final String gender ;
  final String bio ;
  OtpScreen(this.phone , this.name , this.email , this.type , this.gender, this.bio);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RaqiSignupCubit(),
      child: BlocConsumer<RaqiSignupCubit , RaqiSignupStates>(
        listener:(context , state){
          if(state is RaqiSignupSuccessState){
            pinController.text = RaqiSignupCubit.get(context).verificationCode;
            RaqiCubit.get(context).getUserData();
            CacheHelper.saveData(
                key: 'uId',
                value: uId).then((value) {
              navigateAndFinish(context, RaqiLayout());
            });
          }
        } ,
        builder:(context , state){
          RaqiSignupCubit.get(context).verifyPhone(phone, email, name, gender, type,bio,RaqiCubit.get(context).myCountryName,RaqiCubit.get(context).myCountryCode, context);
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
                                  PhoneAuthProvider.credential(
                                      verificationId: RaqiSignupCubit.get(context).verificationCode,
                                      smsCode: pinController.text)
                              ).then((value) {
                                if(value.user != null){
                                  print('pass to home');
                                  print(value.user!.uid);
                                  RaqiSignupCubit.get(context).userCreate(
                                      email: email,
                                      name: name,
                                      phone: phone,
                                      uId: value.user!.uid,
                                      gender: gender,
                                      type: type,
                                      bio: bio,
                                      myCountryName: RaqiCubit.get(context).myCountryName,
                                      myCountryCode: RaqiCubit.get(context).myCountryCode
                                  );
                                  uId = value.user!.uid;
                                  RaqiSignupCubit.get(context).signupSuccess();

                                }
                              });
                              }catch(e){
                                FocusScope.of(context).unfocus();
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

