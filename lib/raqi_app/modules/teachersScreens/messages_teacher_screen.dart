import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/app_cubit/app_states.dart';
import 'package:nafith/raqi_app/models/raqi_user_model.dart';
import 'package:nafith/raqi_app/modules/chat/chat_details_screen.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';
import 'package:nafith/raqi_app/styles/Iconly-Broken_icons.dart';

class MessagesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RaqiCubit , RaqiStates>(
      listener: (context , state){},
      builder: (context , state){
        return ConditionalBuilder(
            condition: RaqiCubit.get(context).teacherStudents.length > 0,
            builder: (context) => ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context , index) => buildChatItem(RaqiCubit.get(context).teacherStudents[index] , context),
                separatorBuilder: (context , index) => myDivider(),
                itemCount: RaqiCubit.get(context).teacherStudents.length
            ),
            fallback: (Context) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconly_Broken.Close_Square,size: 100, color: Colors.grey,) , Text('${getLang(context,"noChats")}' , style: TextStyle(fontSize: 50 , color: Colors.grey),)],)),
          );

      },
    );
  }
}

Widget buildChatItem(UserModel model , context) => InkWell(
  onTap: (){
    navigateTo(context, ChatDetailsScreen(teacherModel: model,));
  },
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 25,
          backgroundImage: model.image == null ? NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/1024px-User-avatar.svg.png'): NetworkImage('${model.image}') ,
        ),
        SizedBox(width: 15,),
        Row(
          children: [
            Text('${model.name}' , style: TextStyle(fontSize: 18),),
            SizedBox(width: 5,),
          ],
        ),
      ],
    ),
  ),
);

