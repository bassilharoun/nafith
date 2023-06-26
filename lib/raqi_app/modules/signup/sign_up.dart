import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqi/raqi_app/app_cubit/app_cubit.dart';
import 'package:raqi/raqi_app/layout/raqi_layout.dart';
import 'package:raqi/raqi_app/modules/otp/otp_signup_screen.dart';
import 'package:raqi/raqi_app/modules/signup/cubit/cubit.dart';
import 'package:raqi/raqi_app/modules/signup/cubit/states.dart';
import 'package:raqi/raqi_app/modules/terms_screen/terms_screen.dart';
import 'package:raqi/raqi_app/shared/colors.dart';
import 'package:raqi/raqi_app/shared/components/applocale.dart';
import 'package:raqi/raqi_app/shared/components/components.dart';
import 'package:raqi/raqi_app/shared/components/constants.dart';
import 'package:raqi/raqi_app/shared/network/local/cache_helper.dart';

class SignupScreen extends StatelessWidget {
  int i ;
  SignupScreen(this.i);

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var type = 'student';
  bool isChecked = false ;
  bool agreeTerms = false ;
  String gender = 'male';

  String? country ;


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RaqiSignupCubit(),
      child: BlocConsumer<RaqiSignupCubit , RaqiSignupStates>(
        listener:(context , state) {
          if(state is RaqiSignupSuccessState){
            RaqiCubit.get(context).getUserData();
            CacheHelper.saveData(
                key: 'uId',
                value: uId).then((value) {
              navigateAndFinish(context, RaqiLayout());
            });
          }
        } ,
        builder:(context , state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(i == 1)
                          Container(
                          height: 50,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${getLang(context,"noAcc")}",style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          color: Colors.red[400],
                        ),
                        Text(
                        "${getLang(context,"signup")}",
                          style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: textColor
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "${getLang(context,"registerTB")}",
                          style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(height: 30,),
                        defaultTxtForm(
                            controller: nameController,
                            type: TextInputType.name,
                            validate: (value){
                              if(value!.isEmpty){
                                return "${getLang(context,"nameQ")}";
                              }

                            },
                            label: "${getLang(context,"name")}",
                            prefix: Icons.person
                        ),
                        SizedBox(height: 15,),
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
                        SizedBox(height: 15,),
                        defaultTxtForm(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (value){
                              if(value!.isEmpty){
                                return "${getLang(context,"emailQ")}";
                              }

                            },
                            label: "${getLang(context,"email")}",
                            prefix: Icons.email_outlined
                        ),
                        SizedBox(height: 15,),
                        if(type == "teacher")...[
                          Container(
                            width: double.infinity,
                            child: DecoratedBox(decoration: BoxDecoration(
                                color:Colors.white, //background color of dropdown button
                                border: Border.all(color: buttonsColor, width:3), //border of dropdown button
                                borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
                                boxShadow: <BoxShadow>[ //apply shadow on Dropdown button
                                  BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                                      blurRadius: 5) //blur radius of shadow
                                ]
                            ),
                              child: Center(
                                child: DropdownButton(
                                    value: RaqiSignupCubit.get(context).dropdownvalue,
                                    items: RaqiSignupCubit.get(context).items.map((e) {
                                      return DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue){
                                      RaqiSignupCubit.get(context).changeDropdown(newValue);
                                    }
                                ),
                              ),
                            ),
                          ),
                        ],
                        if(type == "student")...[
                          defaultTxtForm(
                              controller: bioController,
                              type: TextInputType.text,
                              validate: (value){
                                if(value!.isEmpty){
                                  return "${getLang(context,"bioQ")}";
                                }

                              },
                              label: "${getLang(context,"bio")}",
                              prefix: Icons.short_text
                          ),
                        ],
                      Row(children: [
                        Expanded(
                          child: RadioListTile(
                            activeColor: buttonsColor,
                              title: Text("${getLang(context,"male")}"),
                              value: "male",
                              groupValue: gender,
                              onChanged: (value){
                                gender = value.toString() ;
                                print(gender);
                                RaqiSignupCubit.get(context).changeRadio();
                              }
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            activeColor: buttonsColor,
                              title: Text("${getLang(context,"female")}"),
                              value: "female",
                              groupValue: gender,
                              onChanged: (value){
                                gender = value.toString() ;
                                print(gender);
                                RaqiSignupCubit.get(context).changeRadio();
                              }
                          ),
                        ),
                      ],),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: buttonsColor,
                                  value: isChecked,
                                  onChanged: (value){
                                    if(value!){
                                      type = 'teacher';
                                    }
                                    if(!value){
                                      type = 'student';
                                    }
                                    RaqiSignupCubit.get(context).changeCheckBox();
                                    print(type);
                                    isChecked = !isChecked ;
                                  }
                              ),
                              Text("${getLang(context,"amTeacher")}")
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Row(
                            children: [
                              Checkbox(
                                  activeColor: buttonsColor,
                                  value: agreeTerms,
                                  onChanged: (value){
                                    agreeTerms = !agreeTerms ;
                                    RaqiSignupCubit.get(context).changeCheckBox();
                                    print(agreeTerms);
                                  }
                              ),
                              Text("${getLang(context,"agreeTo")}"),
                              TextButton(onPressed: (){
                                navigateTo(context, TermsScreen());
                              }, child: Text("${getLang(context,"terms")}",style: TextStyle(color: Colors.blue),))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ConditionalBuilder(
                          condition: state is! RaqiSignupLoadingState,
                          builder: (context) => defaultButton(
                              function: (){
                                if(agreeTerms){
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
                                        if(exist == false){
                                          navigateTo(context, OtpScreen(
                                              country != null ? "+${country}${phoneController.text}" : "${phoneController.text}",
                                              nameController.text,
                                              emailController.text,
                                              type,
                                              gender,
                                              type == "student" ? bioController.text : RaqiSignupCubit.get(context).dropdownvalue!
                                          ));
                                        }
                                        else if(exist == true){
                                          showToast(text: "phone number already exist!", state: ToastStates.ERROR);
                                        }

                                      });

                                    });




                                  }
                                }
                                else{
                                  showToast(text: "${getLang(context,"must")}", state: ToastStates.WARNING);
                                }
                              },
                              text: "${getLang(context,"signupB")}"
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
                              "${getLang(context,"orSignup")}",
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
                                  RaqiSignupCubit.get(context).googleLogin(context);
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } ,
      ),
    );
  }
  pickCountry(context){
    showCountryPicker(
      context: context,
      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country _country) {
        RaqiCubit.get(context).myCountryName = _country.name;
        RaqiCubit.get(context).myCountryCode = _country.countryCode;
        country = _country.phoneCode ;
        print('Select country: ${_country.phoneCode}');
        RaqiSignupCubit.get(context).changeCountry();
      },
    );
  }


}
