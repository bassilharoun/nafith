import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/app_cubit/app_states.dart';
import 'package:nafith/raqi_app/models/message_model.dart';
import 'package:nafith/raqi_app/models/raqi_user_model.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';


class ChatDetailsScreen extends StatelessWidget {

  UserModel? teacherModel ;
  ChatDetailsScreen({this.teacherModel});

  var chatMessageController = TextEditingController() ;
  var scrollController = ScrollController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if(RaqiCubit.get(context).userModel!.type  == 'teacher'){
      RaqiCubit.get(context).getTeacherMessages(receiverId: teacherModel!.uId);
    }else{
      RaqiCubit.get(context).getStudentMessages(receiverId: teacherModel!.uId);
    }
    return Builder(builder: (BuildContext context){
      return  BlocConsumer<RaqiCubit , RaqiStates>(
        listener: (context , state){
          if(state is RaqiGetMessagesSuccessState && RaqiCubit.get(context).messages.length > 0){
            SchedulerBinding.instance.addPostFrameCallback((_) {
              scrollController.jumpTo(scrollController.position.maxScrollExtent);
            });
          }
          if(state is RaqiSendMessageSuccessState){
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          }
        } ,
        builder: (context , state){
          return Scaffold(
            appBar: AppBar(
              elevation: 5,
              titleSpacing: 0,
              title: Row(children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  backgroundImage: teacherModel!.image == null ? NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/1024px-User-avatar.svg.png'): NetworkImage(teacherModel!.image),
                ),
                SizedBox(width: 15,),
                Text(teacherModel!.name , style: TextStyle(fontSize: 18),),
                SizedBox(width: 5,),
              ],),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ConditionalBuilder(
                          condition: RaqiCubit.get(context).messages.length > 0,
                          builder:(context) => ListView.separated(
                              controller: scrollController,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context , index){
                                var message = RaqiCubit.get(context).messages[index];
                                if(RaqiCubit.get(context).userModel!.uId == message.senderId)
                                  return buildMyMessage(message);

                                return buildMessage(message);
                              },
                              separatorBuilder: (context , index) => SizedBox(height: 5,),
                              itemCount: RaqiCubit.get(context).messages.length
                          ) ,
                          fallback: (context) => Center(child: Text("${getLang(context,"noMessages")}"),),
                        ),
                      ),
                    ),
                    Row(children: [
                      Expanded(child:
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1
                            ),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            validator: (value){
                              if(value!.isEmpty){
                                return 'What you will say !' ;
                              }
                            },
                            controller: chatMessageController,
                            decoration: InputDecoration(
                                hintText: "${getLang(context,"whatUWillSay")}",
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none
                            ),
                          ),
                        ),
                      ),),
                      SizedBox(width: 5,),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50) , color: buttonsColor,),
                        child: MaterialButton(
                          onPressed: (){
                            if(formKey.currentState!.validate()){
                              if(RaqiCubit.get(context).userModel!.type == 'teacher'){
                                RaqiCubit.get(context).teacherSendMessage(
                                    receiverId: teacherModel!.uId,
                                    dateTime: DateTime.now().toString(),
                                    text: chatMessageController.text,
                                    receiverModel: teacherModel!
                                );
                              }else{
                                RaqiCubit.get(context).studentSendMessage(
                                    receiverId: teacherModel!.uId,
                                    dateTime: DateTime.now().toString(),
                                    text: chatMessageController.text,
                                    receiverModel: teacherModel!

                                );
                              }
                              RaqiCubit.get(context).sendNotification("${RaqiCubit.get(context).userModel!.name}", chatMessageController.text, teacherModel!.deviceToken,"chat","${RaqiCubit.get(context).userModel!.uId}");
                              if(RaqiCubit.get(context).userModel == "student"){
                                FirebaseFirestore.instance
                                    .collection('students')
                                    .doc(RaqiCubit.get(context).userModel!.uId)
                                    .collection('chats')
                                    .doc(teacherModel!.uId)
                                    .set(teacherModel!.toMap())
                                    .then((value) async{
                                  FirebaseFirestore.instance
                                      .collection('teachers')
                                      .doc(teacherModel!.uId)
                                      .collection('chats')
                                      .doc(RaqiCubit.get(context).userModel!.uId)
                                      .set(RaqiCubit.get(context).userModel!.toMap())
                                      .then((value) async{

                                  }).catchError((error){});
                                }).catchError((error){});
                              }




                              chatMessageController.text = '';
                              scrollController.jumpTo(scrollController.position.maxScrollExtent);
                            }
                          },
                          minWidth: 1,
                          child: Icon(Icons.send , color: Colors.white,),
                        ),
                      )
                    ],)
                  ],
                ),
              ),
            )
          );
        } ,
      );
    });
  }

  Widget buildMyMessage(MessageModel model) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
          color: buttonsColor,
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10),
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),

          )
      ),
      padding: EdgeInsets.symmetric(
          vertical: 5 ,
          horizontal: 10
      ),
      child: Text(
        model.text,
        style: TextStyle(color: Colors.white),

      ),
    ),
  );
  Widget buildMessage(MessageModel model) =>  Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(10),
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),

          )
      ),
      padding: EdgeInsets.symmetric(
          vertical: 5 ,
          horizontal: 10
      ),
      child: Text(
        model.text,
        style: TextStyle(color: Colors.black),

      ),
    ),
  );
}
