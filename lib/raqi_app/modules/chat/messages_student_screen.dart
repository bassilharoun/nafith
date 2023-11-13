import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/app_cubit/app_states.dart';
import 'package:nafith/raqi_app/models/raqi_user_model.dart';
import 'package:nafith/raqi_app/modules/chat/chat_details_screen.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';
import 'package:nafith/raqi_app/styles/Iconly-Broken_icons.dart';

class MessagesScreenStudent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RaqiCubit , RaqiStates>(
      listener: (context , state){},
      builder: (context , state){
        return ConditionalBuilder(
            condition: RaqiCubit.get(context).studentTeachers.length > 0,
            builder: (context) => Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(title: Text("${getLang(context,"chats")}"),),
              body: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context , index) => buildChatItem(RaqiCubit.get(context).studentTeachers[index] , context),
                  separatorBuilder: (context , index) => myDivider(),
                  itemCount: RaqiCubit.get(context).studentTeachers.length
              ),
            ),
            fallback: (Context) => Scaffold(
              appBar: AppBar(
                title: Text("${getLang(context,"chats")}"),
              ),
              body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconly_Broken.Close_Square,size: 100, color: Colors.grey,) , Text('No Chats !' , style: TextStyle(fontSize: 50 , color: Colors.grey),)],)),
            ),
          );

      },
    );
  }
}

Widget buildChatItem(UserModel? model , context) => InkWell(
  onTap: (){
    navigateTo(context, ChatDetailsScreen(teacherModel: model,));
  },
  child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                backgroundImage:  NetworkImage('${model!.image}') ,
              ),
              SizedBox(width: 15,),
              Expanded(
                child: Row(
                  children: [
                    Text('${model.name}' , style: TextStyle(fontSize: 18),),
                    SizedBox(width: 5,),
                    Spacer(),
                    Icon(CupertinoIcons.chat_bubble_2,color: buttonsColor,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);

