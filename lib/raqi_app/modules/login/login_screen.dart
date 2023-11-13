import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/layout/raqi_layout.dart';
import 'package:nafith/raqi_app/modules/login/cubit/cubit.dart';
import 'package:nafith/raqi_app/modules/login/cubit/states.dart';
import 'package:nafith/raqi_app/modules/otp/otp_login_screen.dart';
import 'package:nafith/raqi_app/modules/signup/sign_up.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';
import 'package:nafith/raqi_app/shared/components/constants.dart';
import 'package:nafith/raqi_app/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  String? country ;

  var formKey = GlobalKey<FormState>();

  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>RaqiLoginCubit(),
      child: BlocConsumer<RaqiLoginCubit , RaqiLoginStates>(
        listener: (context , state) {
          if(state is RaqiLoginErrorState){
            // showToast(text: state.error,
            //     state: ToastStates.ERROR
            // );
          }
          if(state is RaqiLoginSuccessState){
            RaqiCubit.get(context).getUserData();
            CacheHelper.saveData(
                key: 'uId',
                value: uId).then((value) {
              navigateAndFinish(context, RaqiLayout());
            });
          }
        },
        builder: (context , state) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${getLang(context,"login")}",
                          style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: textColor
                          ),
                        ),
                        SizedBox(height: 10,),
                        Center(child: Container(
                            height: 300,
                            width: 300,
                            child: Image(image: AssetImage('assets/images/loginimg.png')))),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${getLang(context,"lets")}",
                          style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),

                        SizedBox(height: 30,),
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value){
                            if(value!.isEmpty){
                              return "${getLang(context,"phoneQ")}";
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "${getLang(context,"phone")}",
                            prefixIcon: country == null ? GestureDetector(
                                child: Icon(Icons.arrow_drop_down_sharp), onTap: (){
                              pickCountry(context);
                            },) : GestureDetector(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('+${country}'),
                                  ],
                                ),onTap: (){
                                  pickCountry(context);
                            },),
                          ),

                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ConditionalBuilder(
                          condition: state is! RaqiLoginLoadingState,
                          builder: (context) => defaultButton(
                              function: (){
                                if(formKey.currentState!.validate()){
                                  var phone = country != null ? "+${country}${phoneController.text}" : "${phoneController.text}";
                                  bool exist = false ;

                                  FirebaseFirestore.instance.collection('students').get().then((value) {
                                    value.docs.forEach((element) {
                                      if(element.data()['phone'] == phone){
                                        exist = true ;
                                      }
                                    });
                                    print("-------------------------------");

                                  }).then((value) {
                                    FirebaseFirestore.instance.collection('teachers').get().then((value) {
                                      value.docs.forEach((element) {
                                        if(element.data()['phone'] == phone){
                                          exist = true ;
                                        }
                                      });
                                      print("-------------------------------");

                                    }).then((value) {
                                      if(exist == true){
                                        navigateTo(context,country != null ? OtpLoginScreen("+${country}${phoneController.text}") : OtpLoginScreen("${phoneController.text}"));
                                      }
                                      else if(exist == false){
                                        showToast(text: "phone number not exist!", state: ToastStates.ERROR);
                                      }

                                    });

                                  });



                                }
                              },
                              text: "${getLang(context,"loginB")}"
                          ),
                          fallback: (context) => Center(child: CircularProgressIndicator(color: buttonsColor,)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${getLang(context,"orLW")}",
                              style: TextStyle(fontSize: 16),
                            ),

                          ],
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  RaqiLoginCubit.get(context).googleLogin(context);
                                },
                                child: Container(
                                  height: 60,
                                  width: double.infinity,
                                  child: Card(
                                    elevation: 8,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset('assets/images/google.jpg'),
                                    ),),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${getLang(context,"dontHave")}",
                              style: TextStyle(fontSize: 16),
                            ),
                            defaultTextButton(function: (){
                               navigateTo(context , SignupScreen(0));
                            }, text: "${getLang(context,"signup")}"),

                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ) ;
        },
      ),
    );
  }
  pickCountry(context){
    showCountryPicker(
      context: context,
      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country _country) {
        country = _country.phoneCode ;
        print('${getLang(context,"signup")} ${_country.phoneCode}');
        RaqiLoginCubit.get(context).changeCountry();
      },
    );
  }
}
