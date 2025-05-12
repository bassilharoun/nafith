import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' as database;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;
import 'package:nafith/raqi_app/app_cubit/app_states.dart';
import 'package:nafith/raqi_app/models/call_model.dart';
import 'package:nafith/raqi_app/models/comment_model.dart';
import 'package:nafith/raqi_app/models/message_model.dart';
import 'package:nafith/raqi_app/models/notification_model.dart';
import 'package:nafith/raqi_app/models/raqi_user_model.dart';
import 'package:nafith/raqi_app/models/reservation_model.dart';
import 'package:nafith/raqi_app/models/sessions_model.dart';
import 'package:nafith/raqi_app/modules/followers/followers_screen.dart';
import 'package:nafith/raqi_app/modules/home/home_screen.dart';
import 'package:nafith/raqi_app/modules/my_reservation/my_reservation_screen.dart';
import 'package:nafith/raqi_app/modules/sessions_screen/sessions_screen.dart';
import 'package:nafith/raqi_app/modules/teachersScreens/earning_teacher_screen.dart';
import 'package:nafith/raqi_app/modules/teachersScreens/home_teacher_screen.dart';
import 'package:nafith/raqi_app/modules/teachersScreens/messages_teacher_screen.dart';
import 'package:nafith/raqi_app/modules/teachers_screen/teachers_screen.dart';
import 'package:nafith/raqi_app/paytaps/presentation/payment/payment_screen.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';
import 'package:nafith/raqi_app/shared/components/constants.dart';
import 'package:nafith/utils/call_utils.dart';

class RaqiCubit extends Cubit<RaqiStates> {
  RaqiCubit() : super(RaqiInitialStates());

  static RaqiCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  Future<void> getUserData() async {
    print("getUserData Started");
    emit(RaqiGetUserLoadingState());
    await FirebaseFirestore.instance
        .collection('students')
        .doc(uId)
        .get()
        .then((value) {
      if (value.exists) {
        print(value.data());
        userModel = UserModel.fromJson(value.data());
        if (state is RaqiGetUserSuccessState) {
          FirebaseFirestore.instance
              .collection("students")
              .doc(userModel!.uId)
              .update({'deviceToken': '$deviceToken'});

          print("Changed------------------");
        }
        getSessions("students");
        getFather();
        emit(RaqiGetUserSuccessState());
      } else {
        FirebaseFirestore.instance
            .collection('teachers')
            .doc(uId)
            .get()
            .then((value) {
          print(value.data());
          userModel = UserModel.fromJson(value.data());
          if (state is RaqiGetUserSuccessState) {
            FirebaseFirestore.instance
                .collection("teachers")
                .doc(userModel!.uId)
                .update({'deviceToken': '$deviceToken'});

            print("Changed------------------");
          }
          getSessions("teachers");
          getTotalMinutes();
          emit(RaqiGetUserSuccessState());
        });
      }
    }).catchError((error) {
      print(error.toString());
      emit(RaqiGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    HomeScreen(),
    TeachersScreen(),
    SessionsScreen(),
    FollowersScreen(),
    PaymentScreen(),
  ];

  BuildContext? contex;
  void changeBottomNav(int index) {
    currentIndex = index;
    // if (currentIndex == 1) {
    //   getTeachers();
    // }
    if (currentIndex == 2) {
      getSessions("students");
    }
    // if (currentIndex == 4) {
    //   getUserData();
    // }
    // if (currentIndex == 3) {
    //   getMyFollowers();
    // }
    emit(RaqiChangeBottomNavBarState());
  }

  List<Widget> screensTeacher = [
    HomeTeacherScreen(),
    MessagesScreen(),
    MyReservationScreen(),
    EarningScreen(),
  ];

  List<String> titlesTeacher = [
    'Nafith',
    'Messages',
    'reservation',
    'Earning',
  ];

  void changeBottomNavTeacher(int index) {
    currentIndex = index;
    if (currentIndex == 1) {
      getTeacherStudents();
    }
    if (currentIndex == 3) {
      getSessions("teachers");
      getTotalMinutes();
    }
    if (currentIndex == 2) {
      getMyReserved("teachers");
    }
    emit(RaqiChangeBottomNavBarState());
  }

  List<UserModel> teachers = [];
  Future<void> getTeachers() async {
    print(userModel!.name.toString().split(" ").first);
    print(userModel!.name.toString().split(" ").first);
    print("+++++++++++++++++++++++++++++++++++++++++++++");
    teachers = [];
    await FirebaseFirestore.instance.collection('teachers').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] != userModel!.uId &&
            element.data()['gender'] == userModel!.gender)
          teachers.add(UserModel.fromJson(element.data()));
      });
      print(teachers);
      emit(RaqiGetAllTeachersSuccessState());
    }).catchError((error) {
      emit(RaqiGetAllTeachersErrorState(error.toString()));
    });
  }

  List<UserModel> studentTeachers = [];
  void getStudentTeachers() {
    studentTeachers = [];
    FirebaseFirestore.instance
        .collection('students')
        .doc(userModel!.uId)
        .collection("chats")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        studentTeachers.add(UserModel.fromJson(element.data()));
      });
      emit(RaqiGetAllStudentTeachersSuccessState());
    }).catchError((error) {
      emit(RaqiGetAllStudentTeachersErrorState(error.toString()));
    });
  }

  List<UserModel> teacherStudents = [];
  void getTeacherStudents() {
    teacherStudents = [];
    FirebaseFirestore.instance
        .collection('teachers')
        .doc(userModel!.uId)
        .collection("chats")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        teacherStudents.add(UserModel.fromJson(element.data()));
      });
      emit(RaqiGetAllStudentTeachersSuccessState());
    }).catchError((error) {
      emit(RaqiGetAllStudentTeachersErrorState(error.toString()));
    });
  }

  List<UserModel> students = [];
  void getStudents() {
    students = [];
    FirebaseFirestore.instance.collection('students').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] != userModel!.uId)
          students.add(UserModel.fromJson(element.data()));
      });
      emit(RaqiGetAllTeachersSuccessState());
    }).catchError((error) {
      emit(RaqiGetAllTeachersErrorState(error.toString()));
    });
  }

  UserModel? teacherModel;
  void getTeacher(String teacherId) {
    emit(RaqiGetTeacherLoadingState());
    FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .get()
        .then((value) {
      print(value.data());
      teacherModel = UserModel.fromJson(value.data());
      emit(RaqiGetTeacherSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(RaqiGetTeacherErrorState());
    });
  }

  void getTeacherThenCall(String teacherId, context) {
    emit(RaqiGetTeacherLoadingState());
    FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .get()
        .then((value) {
      print(value.data());
      teacherModel = UserModel.fromJson(value.data());
      if (int.parse(RaqiCubit.get(context).userModel!.minutes) > 0) {
        CallUtils.dial(
            from: RaqiCubit.get(context).userModel,
            to: RaqiCubit.get(context).teacherModel,
            context: context);
      } else if (int.parse(RaqiCubit.get(context).fatherMins) > 0) {
        CallUtils.dial(
            from: RaqiCubit.get(context).userModel,
            to: RaqiCubit.get(context).teacherModel,
            context: context);
        showToast(
            text: "call using affiliate minutes", state: ToastStates.ERROR);
      } else {
        showToast(
            text: "You do not have minutes, please recharge and try again",
            state: ToastStates.ERROR);
      }
      emit(RaqiGetTeacherSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(RaqiGetTeacherErrorState());
    });
  }

  void studentSendMessage(
      {required String receiverId,
      required String dateTime,
      required String text,
      required UserModel receiverModel}) {
    MessageModel model = MessageModel(
      text: text,
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
    );

    FirebaseFirestore.instance
        .collection('students')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('students')
          .doc(userModel!.uId)
          .collection('chats')
          .doc(receiverId)
          .set(receiverModel.toMap())
          .then((value) {})
          .catchError((error) {});

      emit(RaqiSendMessageSuccessState());
    }).catchError((error) {
      emit(RaqiSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('teachers')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('teachers')
          .doc(receiverId)
          .collection('chats')
          .doc(userModel!.uId)
          .set(userModel!.toMap())
          .then((value) {})
          .catchError((error) {});

      emit(RaqiSendMessageSuccessState());
    }).catchError((error) {
      emit(RaqiSendMessageErrorState());
    });
  }

  void teacherSendMessage(
      {required String receiverId,
      required String dateTime,
      required String text,
      required UserModel receiverModel}) {
    MessageModel model = MessageModel(
        text: text,
        senderId: userModel!.uId,
        receiverId: receiverId,
        dateTime: dateTime);

    FirebaseFirestore.instance
        .collection('teachers')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('teachers')
          .doc(userModel!.uId)
          .collection('chats')
          .doc(receiverId)
          .set(receiverModel.toMap())
          .then((value) {})
          .catchError((error) {});

      emit(RaqiSendMessageSuccessState());
    }).catchError((error) {
      emit(RaqiSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('students')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('students')
          .doc(receiverId)
          .collection('chats')
          .doc(userModel!.uId)
          .set(userModel!.toMap())
          .then((value) {})
          .catchError((error) {});

      emit(RaqiSendMessageSuccessState());
    }).catchError((error) {
      emit(RaqiSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getStudentMessages({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('students')
        .doc(userModel!.uId)
        .collection("chats")
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(RaqiGetMessagesSuccessState());
    });
  }

  void getTeacherMessages({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('teachers')
        .doc(userModel!.uId)
        .collection("chats")
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(RaqiGetMessagesSuccessState());
    });
  }

  void updateUser(
      {required String name,
      required String email,
      required String bio,
      required String type,
      required String gender,
      String? image,
      String? cover}) {
    emit(RaqiUserUpdateLoadingState());
    UserModel model = UserModel(
        name: name,
        email: email,
        phone: userModel!.phone,
        image: image ?? userModel!.image,
        uId: userModel!.uId,
        bio: bio,
        minutes: userModel!.minutes,
        gender: gender,
        type: type,
        rate: userModel!.rate,
        deviceToken: userModel!.deviceToken);
    FirebaseFirestore.instance
        .collection('students')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(RaqiUserUpdateErrorState());
    });
  }

  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection('call');

  Future<bool> makecall(Call call) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);
      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall(Call call, context) async {
    try {
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      RaqiCubit.get(context).endCallTime();
      emit(RaqiEndCallSuccess());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<DocumentSnapshot> callStream({String? uid}) =>
      callCollection.doc(uid).snapshots();

  void commentOnTeacher({
    required String teacherId,
    required String dateTime,
    required String text,
    required int rate,
  }) {
    CommentModel model = CommentModel(
      text: text,
      senderId: userModel!.uId,
      postId: teacherId,
      dateTime: dateTime,
      senderName: userModel!.name,
      senderImage: userModel!.image,
      rate: rate,
    );
    emit(RaqiCommentLoadingState());
    getRates(teacherId);
    FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('comments')
        .add(model.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection("teachers")
          .doc(teacherId)
          .update({'rate': totalRate});
      emit(RaqiCommentSuccessState());
    }).catchError((error) {
      emit(RaqiCommentErrorState());
    });
  }

  List<CommentModel> comments = [];
  void getComments(teacherId) {
    emit(RaqiGetCommentsLoadingState());
    FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection("comments")
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      comments = [];
      event.docs.forEach((element) {
        comments.add(CommentModel.fromJson(element.data()));
      });
      emit(RaqiGetCommentsSuccessState());
    });
  }

  void emitRate() {
    emit(RaqiEmitRate());
  }

  List<int> ratesTeacher = [];
  int sumRates = 0;
  double totalRate = 0;
  void getRates(teacherId) {
    ratesTeacher = [];
    sumRates = 0;
    totalRate = 0;
    FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('comments')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        ratesTeacher.add(element.data()['rate']);
      });
      print(ratesTeacher);
      print("-------------------------------");
      for (int i = 0; i < ratesTeacher.length; i++) {
        sumRates = sumRates + ratesTeacher[i];
      }
      print(sumRates);
      print("-------------------------------");
      totalRate = sumRates / ratesTeacher.length;
      print(totalRate);
    });
  }

  //Calculate Minutes for student
  dynamic startCallDate;
  dynamic dt1;
  void startCallTime() {
    startCallDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
    dt1 = DateTime.parse(startCallDate);
    print(dt1);
  }

  dynamic endCallDate;
  dynamic dt2;
  dynamic callDuration;
  dynamic diffInMinutes;
  void endCallTime() {
    endCallDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
    DateTime dt2 = DateTime.parse(endCallDate);
    Duration diff = dt2.difference(dt1);
    print(dt2);
    diffInMinutes = diff.inMinutes;
    print(diff.inMinutes);
    print("==========================================");
    if (int.parse(userModel!.minutes) > 0) {
      var oldMin = int.parse(userModel!.minutes);
      var totalMin = oldMin - diff.inMinutes;
      FirebaseFirestore.instance
          .collection("students")
          .doc(userModel!.uId)
          .update({'minutes': '$totalMin'});
    } else if (int.parse(fatherMins) > 0) {
      var oldMin = int.parse(fatherMins);
      var totalMin = oldMin - diff.inMinutes;
      FirebaseFirestore.instance
          .collection("students")
          .doc(father!.uId)
          .update({'minutes': '$totalMin'});
    }
  }

  void saveSession({
    required String teacherName,
    required String teacherImage,
    required String dateTime,
    required String duration,
    required String teacherId,
    required String studentId,
    required String studentImage,
    required String studentName,
  }) {
    SessionsModel model = SessionsModel(
      teacherName: teacherName,
      teacherImage: teacherImage,
      sessionId: teacherId,
      dateTime: dateTime,
      duration: duration,
      studentImage: studentImage,
      studentName: studentName,
      studentId: studentId,
    );
    emit(RaqiSaveSessionLoadingState());
    if (int.parse(duration) > 0) {
      // save session to student
      FirebaseFirestore.instance
          .collection('students')
          .doc(userModel!.uId)
          .collection('sessions')
          .add(model.toMap())
          .then((value) {
        // save session to teacher
        FirebaseFirestore.instance
            .collection('teachers')
            .doc(teacherId)
            .collection('sessions')
            .add(model.toMap());
        emit(RaqiEndCallSuccess());
      }).catchError((error) {
        emit(RaqiSaveSessionErrorState());
      });
    }
  }

  List<SessionsModel> sessions = [];
  List<SessionsModel> reversedSessions = [];
  void getSessions(String type) {
    emit(RaqiGetSessionsLoadingState());
    FirebaseFirestore.instance
        .collection(type)
        .doc(userModel!.uId)
        .collection("sessions")
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      sessions = [];
      reversedSessions = [];
      event.docs.forEach((element) {
        sessions.add(SessionsModel.fromJson(element.data()));
      });
      reversedSessions = sessions.reversed.toList();
      emit(RaqiGetSessionsSuccessState());
    });
  }

  List<UserModel> searchedTeacher = [];
  void searchTeacher(String search) {
    searchedTeacher = [];
    for (int i = 0; i < teachers.length; i++) {
      if (teachers[i].name.contains(search)) {
        searchedTeacher.add(teachers[i]);
      }
    }
    emit(RaqiGetSearchSuccessState());
  }

  bool isLoading = false;
  void loadBook() {
    isLoading = true;
    emit(RaqiLoadBook());
  }

  dynamic profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      uploadProfileImage();
      //emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(RaqiProfileImagePickedErrorState());
    }
  }

  void uploadProfileImage() {
    var changedImage = userModel!.image;
    emit(RaqiUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(
            name: userModel!.name,
            bio: userModel!.bio,
            image: value,
            email: userModel!.email,
            type: userModel!.type,
            gender: userModel!.gender);
        firebase_storage.FirebaseStorage.instance
            .refFromURL(changedImage)
            .delete();
      }).catchError((error) {
        emit(RaqiUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(RaqiUploadProfileImageErrorState());
    });
  }

  List<int> teacherMinutes = [];
  int sumMinutes = 0;
  void getTotalMinutes() async {
    teacherMinutes = [];
    sumMinutes = 0;
    print(sumMinutes);
    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(userModel!.uId)
        .collection('sessions')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        teacherMinutes.add(int.parse(element.data()['duration']));
      });
      print(teacherMinutes);
      print(teacherMinutes.length);
      print("-------------------------------");
      for (int i = 0; i < teacherMinutes.length; i++) {
        sumMinutes = sumMinutes + teacherMinutes[i];
      }
      print(sumMinutes);
      print("-------------------------------");
      emit(RaqiGetTotalMins());
    });
  }

  contactUs(String text) {
    FirebaseFirestore.instance.collection('contacts').doc(userModel!.uId).set({
      "sender": "${userModel!.name}",
      "email": "${userModel!.email}",
      "dateTime": DateTime.now(),
      "content": text,
    }).then((value) {
      emit(RaqiSendContactSuccessState());
    }).catchError((error) {
      emit(RaqiSendContactErrorState());
    });
  }

  T? mapGetter<T>(Map map, String path, T defaultValue) {
    List<String> keys = path.split('.');
    String key = keys[0];

    if (!map.containsKey(key)) {
      return defaultValue;
    }

    if (keys.length == 1) {
      return map[key] as T;
    }

    return mapGetter(map[keys.removeAt(0)], keys.join('.'), defaultValue);
  }

  var payment = {};
  String minEarning = "";
  database.DatabaseReference ref =
      database.FirebaseDatabase.instance.ref("payment");
  readData() async {
    ref.onChildAdded.forEach((element) {
      payment = jsonDecode(jsonEncode(element.snapshot.value))
          as Map<String, dynamic>;
      // print(payment["obj"]["payment_key_claims"]["amount_cents"] as int);
      if (payment["obj"]["data"]["message"] as String == "Approved") {
        if (payment["obj"]["payment_key_claims"]["amount_cents"] as int ==
            28000) {
          minEarning = "1680";
        }
        if (payment["obj"]["payment_key_claims"]["amount_cents"] as int ==
            50000) {
          minEarning = "3360";
        }
        if (payment["obj"]["payment_key_claims"]["amount_cents"] as int ==
            8000) {
          minEarning = "420";
        }
        print("--------------------");
        print(minEarning);
        FirebaseFirestore.instance
            .collection("students")
            .doc(payment["obj"]["payment_key_claims"]["billing_data"]["state"]
                as String)
            .update({'minutes': minEarning});
        //delete it
        database.FirebaseDatabase.instance
            .ref("payment/${element.snapshot.key}")
            .remove();
        print("++++++++++++++++++++++++++");
        print("deleted with adding");
      } else {
        database.FirebaseDatabase.instance
            .ref("payment/${element.snapshot.key}")
            .remove();
        print("deleted without adding");
      }
    });
  }

  deleteUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser!.delete().then((value) {
        if (RaqiCubit.get(context).userModel?.name != null) {
          if (userModel!.type == "student") {
            FirebaseFirestore.instance
                .collection("students")
                .doc(userModel!.uId)
                .delete();
          }
          if (userModel!.type == "teacher") {
            FirebaseFirestore.instance
                .collection("teachers")
                .doc(userModel!.uId)
                .delete();
          }
          signOut(Navigator.of(scaffoldKey.currentContext!));
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        showToast(
            text: "${getLang(scaffoldKey.currentContext!, "deleteM")}",
            state: ToastStates.ERROR);
      }
    }
  }

  var from, to;
  bool willReserve = true;

  willReverseFun() {
    for (int i = 0; i < alreadyReservedList.length; i++) {
      if (from.millisecondsSinceEpoch == alreadyReservedList[i]!["FTS"] ||
          (alreadyReservedList[i]!["FTS"] < from.millisecondsSinceEpoch &&
              from.millisecondsSinceEpoch < alreadyReservedList[i]!["LTS"]) ||
          (alreadyReservedList[i]!["FTS"] < to.millisecondsSinceEpoch &&
              to.millisecondsSinceEpoch < alreadyReservedList[i]!["LTS"]) ||
          (from.millisecondsSinceEpoch < alreadyReservedList[i]!["FTS"] &&
              alreadyReservedList[i]!["FTS"] < to.millisecondsSinceEpoch)) {
        willReserve = false;
      }
    }
  }

  void reserve(
    teacherId,
    teacherName,
    teacherImage,
  ) {
    ReservationModel model = ReservationModel(
        FTS: from.millisecondsSinceEpoch,
        LTS: to.millisecondsSinceEpoch,
        from: DateFormat('yyyy-MM-dd – kk:mm').format(from).toString(),
        to: DateFormat('yyyy-MM-dd – kk:mm').format(to).toString(),
        studentImage: userModel!.image,
        studentName: userModel!.name,
        studentId: userModel!.uId,
        teacherId: teacherId,
        teacherName: teacherName,
        teacherImage: teacherImage,
        duration: to.difference(from).inMinutes);
    willReverseFun();
    if (willReserve == true) {
      emit(RaqiReserveLoadingState());
      FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId)
          .collection('reserved')
          .doc("${from.millisecondsSinceEpoch}")
          .set(model.toMap())
          .then((value) {
        FirebaseFirestore.instance
            .collection('students')
            .doc(userModel!.uId)
            .collection('reserved')
            .doc("${from.millisecondsSinceEpoch}")
            .set(model.toMap())
            .then((value) {
          from = null;
          to = null;
          willReserve = true;
        });
        emit(RaqiReserveSuccess());
        showToast(text: "Reserved!", state: ToastStates.SUCCESS);
      }).catchError((error) {
        print(error.toString());
        emit(RaqiReserveErrorState());
      });
    } else {
      showToast(
          text: "This session already Reversed!", state: ToastStates.ERROR);
      from = null;
      to = null;
      willReserve = true;
    }
  }

  List<ReservationModel> reserved = [];
  List<ReservationModel> reverseReserved = [];

  Map<String, dynamic>? alreadyReserved;
  List<Map<String, dynamic>?> alreadyReservedList = [];

  void getReserved(teacherId) {
    emit(RaqiGetReservedLoadingState());
    FirebaseFirestore.instance
        .collection("teachers")
        .doc(teacherId)
        .collection("reserved")
        .orderBy('FTS')
        .snapshots()
        .listen((event) {
      reserved = [];
      reverseReserved = [];
      event.docs.forEach((element) {
        reserved.add(ReservationModel.fromJson(element.data()));
        alreadyReserved = {
          "FTS": element.data()['FTS'],
          "LTS": element.data()['LTS']
        };
        alreadyReservedList.add(alreadyReserved);
      });
      print(alreadyReservedList);
      reverseReserved = reserved.reversed.toList();
      emit(RaqiGetReservedSuccessState());
    });
  }

  List<ReservationModel> myReserved = [];
  List<ReservationModel> myReverseReserved = [];
  void getMyReserved(String type) {
    emit(RaqiGetReservedLoadingState());
    FirebaseFirestore.instance
        .collection(type)
        .doc(userModel!.uId)
        .collection("reserved")
        .orderBy('FTS')
        .snapshots()
        .listen((event) {
      myReserved = [];
      myReverseReserved = [];
      event.docs.forEach((element) {
        myReserved.add(ReservationModel.fromJson(element.data()));
      });
      myReverseReserved = myReserved.reversed.toList();
      emit(RaqiGetReservedSuccessState());
    });
  }

  deleteStudentReserve(ReservationModel model) {
    FirebaseFirestore.instance
        .collection("students")
        .doc(userModel!.uId)
        .collection("reserved")
        .doc("${model.FTS}")
        .delete();
    FirebaseFirestore.instance
        .collection("teachers")
        .doc(model.teacherId)
        .collection("reserved")
        .doc("${model.FTS}")
        .delete();
    showToast(text: "Reserved Session Deleted!", state: ToastStates.SUCCESS);
  }

  sendNotification(
      String title, String body, String token, String type, String uId) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': 'title',
      'type': type,
      'uId': uId
    };

    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAxuSqD8g:APA91bFzOEkz-bGdq4nNmyX9RIepZ2z7AiMeBSJrJ08JFjEv9I4FoqDiDbzASksZqyE6WuAUWLbiR-naeAz3rKuCHXPdWtB8nw5w1oSGhWaxl-_-Gr-pomU1iiFgaMEEcBjQtK5ckVDU'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{'title': title, 'body': body},
                'priority': 'high',
                'data': data,
                'to': '$token'
              }));

      if (response.statusCode == 200) {
        print("notification is sent");
      } else {
        print("something wrong in notification sending");
      }
    } catch (e) {}
  }

  void saveNotification(
    String notificationType,
    String title,
    String body,
    String receiverId,
  ) {
    NotificationModel model = NotificationModel(
      senderName: userModel!.name,
      senderImage: userModel!.image,
      notificationType: notificationType,
      title: title,
      body: body,
      dateTime: DateTime.now().toString(),
    );
    emit(RaqiSaveNotificationLoadingState());
    if (userModel!.type == "teacher") {
      FirebaseFirestore.instance
          .collection('students')
          .doc(receiverId)
          .collection('notifications')
          .add(model.toMap())
          .then((value) {
        emit(RaqiSaveNotificationSuccessState());
      }).catchError((error) {
        emit(RaqiSaveNotificationErrorState());
      });
    }

    if (userModel!.type == "student") {
      FirebaseFirestore.instance
          .collection('teachers')
          .doc(receiverId)
          .collection('notifications')
          .add(model.toMap())
          .then((value) {
        emit(RaqiSaveNotificationSuccessState());
      }).catchError((error) {
        emit(RaqiSaveNotificationErrorState());
      });
    }
  }

  List<NotificationModel> notifications = [];
  List<NotificationModel> reversedNotifications = [];
  void getNotifications() {
    emit(RaqiGetNotificationsLoadingState());

    if (userModel!.type == "student") {
      FirebaseFirestore.instance
          .collection("students")
          .doc(userModel!.uId)
          .collection("notifications")
          .orderBy('dateTime')
          .snapshots()
          .listen((event) {
        notifications = [];
        reversedNotifications = [];
        event.docs.forEach((element) {
          notifications.add(NotificationModel.fromJson(element.data()));
        });
        reversedNotifications = notifications.reversed.toList();
        emit(RaqiGetNotificationsSuccessState());
      });
    }

    if (userModel!.type == "teacher") {
      FirebaseFirestore.instance
          .collection("teachers")
          .doc(userModel!.uId)
          .collection("notifications")
          .orderBy('dateTime')
          .snapshots()
          .listen((event) {
        notifications = [];
        reversedNotifications = [];
        event.docs.forEach((element) {
          notifications.add(NotificationModel.fromJson(element.data()));
        });
        reversedNotifications = notifications.reversed.toList();
        emit(RaqiGetNotificationsSuccessState());
      });
    }
  }

  dynamic myCountryName;
  dynamic myCountryCode;

  bool followerAvailable = false;
  UserModel? follower;
  Future<void> getFollower(dynamic phone, BuildContext context) async {
    emit(getFollowerLoadingState());

    // Check if the phone number belongs to the current user
    if (userModel?.phone == phone) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("لا يمكنك إضافة نفسك كتابع"),
          duration: Duration(seconds: 3),
        ),
      );
      emit(getFollowerErorrState());
      return; // Exit early
    }

    await FirebaseFirestore.instance
        .collection('students')
        .where('phone', isEqualTo: phone) // Filter by phone number
        .limit(1) // Limit results to 1 document
        .get()
        .then((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        // If a matching document is found
        var element = snapshot.docs.first;
        followerAvailable = true;
        follower = UserModel.fromJson(element.data());

        // Proceed with adding the follower document
        await FirebaseFirestore.instance
            .collection('students')
            .doc(userModel!.uId)
            .collection('sons')
            .doc(follower!.uId)
            .set(follower!.toMap())
            .then((value) async {
          await FirebaseFirestore.instance
              .collection("students")
              .doc(follower!.uId)
              .update({'ejazat': '${userModel!.uId}'}).then((value) {
            Navigator.pop(context);
            getMyFollowers();
            showToast(
                text: "تمت اضافة ${follower!.name} بنجاح",
                state: ToastStates.SUCCESS);
            emit(getFollowerSuccessState());
            follower = null;
            followerAvailable = false;
          });
        }).catchError((error) {
          // Handle set operation error if needed
          emit(getFollowerErorrState());
        });
      } else {
        // No document found
        showToast(text: "مستخدم غير متوفر!", state: ToastStates.ERROR);
        emit(getFollowerErorrState());
      }
    }).catchError((error) {
      // Handle query error if needed
      emit(getFollowerErorrState());
    });
  }

  List<UserModel> myFollowers = [];
  Future<void> getMyFollowers() async {
    myFollowers = [];
    await FirebaseFirestore.instance
        .collection('students')
        .doc(userModel!.uId)
        .collection("sons")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        myFollowers.add(UserModel.fromJson(element.data()));
      });
      emit(getMyFollowersSuccessState());
    }).catchError((error) {
      emit(getMyFollowersErorrState());
    });
  }

  deleteFollower(followerId) {
    FirebaseFirestore.instance
        .collection("students")
        .doc(userModel!.uId)
        .collection("sons")
        .doc("${followerId}")
        .delete();
    FirebaseFirestore.instance
        .collection("students")
        .doc("${followerId}")
        .update({'ejazat': null}).then((value) {
      getMyFollowers();
      showToast(text: "تمت ازاله التابع بنجاح", state: ToastStates.SUCCESS);
    });
  }

  UserModel? father;
  String fatherMins = "0";
  getFather() {
    if (userModel!.ejazat != null) {
      FirebaseFirestore.instance
          .collection("students")
          .doc(userModel!.ejazat)
          .get()
          .then((value) {
        father = UserModel.fromJson(value.data());
        fatherMins = father!.minutes;
      });
    }
  }
}
