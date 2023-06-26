import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:raqi/raqi_app/models/raqi_user_model.dart';
import 'package:raqi/raqi_app/modules/signup/cubit/states.dart';
import 'package:raqi/raqi_app/shared/components/components.dart';
import 'package:raqi/raqi_app/shared/components/constants.dart';

class RaqiSignupCubit extends Cubit<RaqiSignupStates>{
  RaqiSignupCubit() : super(RaqiSignupInitialState());

  static RaqiSignupCubit get(context) => BlocProvider.of(context);

  void signupSuccess(){
    emit(RaqiSignupSuccessState());
  }

  void changeCountry(){
    emit(RaqiChangeCountrySuccessState());
  }

  changeCheckBox(){
    emit(RaqiChangeCheckBoxSignupState());
  }
  changeRadio(){
    emit(RaqiChangeRadioSignupState());
  }



//   void userSignup({
//     required String email ,
//     required String name ,
//     required String phone ,
//     required String password
// }){
//     emit(RaqiSignupLoadingState());
//     FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password
//     ).then((value) {
//       print(value.user!.email);
//       print(value.user!.uid);
//       userCreate(
//           email: email,
//           name: name,
//           phone: phone,
//           uId: value.user!.uid);
//       // uId = value.user!.uid;
//     }).catchError((error){
//       emit(RaqiSignupErrorState(error));
//     });
//   }

  void userCreate ({
    required String email ,
    required String? name ,
    String? phone ,
    required String uId ,
    required String gender ,
    required String type,
    required String bio,
    required String myCountryName,
    required String myCountryCode,
})async{

    String? deviceToken = await FirebaseMessaging.instance.getToken();
    print(deviceToken);

    UserModel model = UserModel(
      name: name ,
      bio: bio,
      email: email ,
      minutes: "6",
      phone: phone ,
      uId: uId ,
      gender: gender,
      type: type,
      image: gender == "male" ? "https://i.pinimg.com/564x/6e/e4/09/6ee4094c7b1c71dd38bafb564777663e.jpg" :  "https://i.pinimg.com/originals/fa/b8/78/fab878307b38ae9c45efdedea9e20fe8.jpg",
      deviceToken: deviceToken,
      myCountryName: myCountryName,
      myCountryCode: myCountryCode,
    );
      if(type == 'student'){
        FirebaseFirestore.instance
            .collection('students')
            .doc(uId)
            .set(model.toMap())
            .then((value) async{
          await FirebaseMessaging.instance.subscribeToTopic('students');
          emit(RaqiCreateUserSuccessState());
        }).catchError((error){
          emit(RaqiCreateUserErrorState(error.toString()));
        });
      }
      if(type == 'teacher'){
        FirebaseFirestore.instance
            .collection('teachers')
            .doc(uId)
            .set(model.toMap())
            .then((value) async{
          await FirebaseMessaging.instance.subscribeToTopic('teachers');
          emit(RaqiCreateUserSuccessState());
        }).catchError((error){
          emit(RaqiCreateUserErrorState(error.toString()));
        });
      }

  }

  IconData suffix = Icons.visibility_outlined ;
  bool isPassword = true ;

  void changePasswordVisibility(){
    isPassword = !isPassword ;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;
   emit(RaqiChangePasswordVisibilitySignupState());
  }

  dynamic verificationCode ;
  verifyPhone(
      String phone,
      String email,
      String name,
      String gender,
      String type,
      String bio,
      String myCountryName,
      String myCountryCode,
      context,

      )async{
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential)async{
        await FirebaseAuth.instance.signInWithCredential(credential)
            .then((value) {
          if(value.user != null){
            print('Logged in Doooooooone');
            print(verificationCode);
            print(value.user!.uid);
            RaqiSignupCubit.get(context).userCreate(
                email: email,
                name: name,
                phone: phone,
                uId: value.user!.uid,
                gender: gender,
                type: type,
                bio: bio,
                myCountryName: myCountryName,
                myCountryCode: myCountryCode
            );
            uId = value.user!.uid;
            RaqiSignupCubit.get(context).signupSuccess();
          }
        });
        emit(RaqiVerfiyPhoneSuccessState());
        },
        verificationFailed: (FirebaseAuthException e){
          print(e.message);
        },
        codeSent: (String verificationID , int? resendToken){
          verificationCode = verificationID ;
        },
        codeAutoRetrievalTimeout: (String verificationID){
          verificationCode = verificationID ;
        },
      timeout: Duration(seconds: 90)
    );
  }

  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user ;
  GoogleSignInAccount get user => _user!;

  Future googleLogin(
      context,
      ) async {
    print("----------------------0----------------------------");
    final googleUser = await googleSignIn.signIn();
    if(googleUser == null) return;
    _user = googleUser;
    print("----------------------1----------------------------");
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      print("---------${value.user!.uid}--------------!!!!!!!!!");
      bool isExist = false ;
      FirebaseFirestore.instance.collection("students").get().then((val) {
        val.docs.forEach((element) {
          print("---------${element.id}--------------!!!!!!!!!");
          if(element.id == value.user!.uid){
            isExist = true ;
          }
        });
      }).then((smsm) {
        if(value.user != null && isExist == false){
          print('Logged in Doooooooone');
          print(value.user!.uid);
          RaqiSignupCubit.get(context).userCreate(
            email: googleUser.email,
            name: googleUser.displayName,
            uId: value.user!.uid,
            gender: "",
            type: "student",
            bio: "لا يوجد وصف",
            myCountryName: googleUser.serverAuthCode!,
            myCountryCode: googleUser.serverAuthCode!
          );
          uId = value.user!.uid;
          RaqiSignupCubit.get(context).signupSuccess();
          print("----------------------2----------------------------");
        }else{
          showToast(text: "already Exist !", state: ToastStates.ERROR);
        }
      });

    });
  }
 //1508
  String? dropdownvalue = "رقية عامة" ;

  var items = [
    "رقية عامة",
    "رقية السحر",
    "رقية العين",
    "مستفيد",
  ];

  changeDropdown(String? newValue){
    dropdownvalue = newValue;
    emit(RaqiChangeDropdown());
  }


}