import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nafith/raqi_app/modules/login/cubit/states.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';
import 'package:nafith/raqi_app/shared/components/constants.dart';

var cre;
class RaqiLoginCubit extends Cubit<RaqiLoginStates>{
  RaqiLoginCubit() : super(RaqiLoginInitialState());

  static RaqiLoginCubit get(context) => BlocProvider.of(context);

  int check = 0 ;
  void loginSuccess(){
    check = 1 ;
    emit(RaqiLoginSuccessState());
  }
  void changeCountry(){
    emit(RaqiChangeCountrySuccessState());
  }


//   void userLogin({
//     required String email ,
//     required String password
// }){
//     emit(RaqiLoginLoadingState());
//
//     FirebaseAuth.instance.signInWithEmailAndPassword(email: email,
//         password: password
//     ).then((value) {
//       print(value.user!.email);
//       print(value.user!.uid);
//       //uId = value.user!.uid;
//       emit(RaqiLoginSuccessState(value.user!.uid));
//     }).catchError((error){
//       emit(RaqiLoginErrorState(error.toString()));
//     });
//   }

  IconData suffix = Icons.visibility_outlined ;
  bool isPassword = true ;

  void changePasswordVisibility(){
    isPassword = !isPassword ;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;
    emit(RaqiChangePasswordVisibilityState());
  }

  dynamic verificationCode ;
  verifyPhone(
      String phone,
      context

      )async{
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential)async{
          cre = credential ;
          await FirebaseAuth.instance.signInWithCredential(credential)
              .then((value) {
            if(value.user != null){
              print('Logged in Doooooooone');
              print(verificationCode);
              print(value.user!.uid);
              uId = value.user!.uid;
              RaqiLoginCubit.get(context).loginSuccess();
            }
          });
        },
        verificationFailed: (FirebaseAuthException e){
          print(e.message);
        },
        codeSent: (String? verificationID , int? resendToken){
          verificationCode = verificationID ;
        },
        codeAutoRetrievalTimeout: (String verificationID){
          verificationCode = verificationID ;
        },
        timeout: Duration(seconds: 120)
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
    cre = credential ;
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      bool isExist = false ;
      FirebaseFirestore.instance.collection("students").get().then((val) {
        val.docs.forEach((element) {
          print("---------${element.id}--------------!!!!!!!!!");
          if(element.id == value.user!.uid){
            isExist = true ;
          }
        });
      }).then((smsm){
        if(value.user != null && isExist == true){
          print('pass to home');
          print(value.user!.uid);
          uId = value.user!.uid;
          RaqiLoginCubit.get(context).loginSuccess();
        }
        else{
          showToast(text: "User not Found Please Signup !", state: ToastStates.ERROR);
        }
      });

    });
  }



}