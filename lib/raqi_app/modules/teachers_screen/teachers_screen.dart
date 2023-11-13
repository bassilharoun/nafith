import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/app_cubit/app_states.dart';
import 'package:nafith/raqi_app/models/raqi_user_model.dart';
import 'package:nafith/raqi_app/modules/chat/chat_details_screen.dart';
import 'package:nafith/raqi_app/modules/teacher_profile/teacher_profile.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';
import 'package:nafith/utils/call_utils.dart';

class TeachersScreen extends StatelessWidget {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RaqiCubit , RaqiStates>(
      listener: (context , state) {},
      builder: (context , state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: defaultTxtForm(
                onChanged: (value){
                  RaqiCubit.get(context).searchTeacher(value);
                },
                validate: (String? value) {
                  if(value!.isEmpty){
                    return "${getLang(context,"whoRUSearch")}";
                  }
                  return null ;
                },
                controller: searchController,
                type: TextInputType.text,
                label: "${getLang(context,"findT")}",
                prefix: Icons.search,
              ),
            ),

            Expanded(
              child: ConditionalBuilder(
                condition: RaqiCubit.get(context).searchedTeacher.length > 0,
                builder:  (context) => ConditionalBuilder(
                  condition: RaqiCubit.get(context).searchedTeacher.length > 0,
                  builder: (context) => ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context , index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildTeacherItem(RaqiCubit.get(context).searchedTeacher[index] , context),
                      ),
                      separatorBuilder: (context , index) => myDivider(),
                      itemCount: RaqiCubit.get(context).searchedTeacher.length
                  ),
                  fallback: (context) => Center(child: CircularProgressIndicator(color: buttonsColor,),),
                ),
                fallback: (context) => ConditionalBuilder(
                  condition: RaqiCubit.get(context).teachers.length > 0,
                  builder: (context) => ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context , index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildTeacherItem(RaqiCubit.get(context).teachers[index] , context),
                      ),
                      separatorBuilder: (context , index) => myDivider(),
                      itemCount: RaqiCubit.get(context).teachers.length
                  ),
                  fallback: (context) => Center(child: CircularProgressIndicator(color: buttonsColor,),),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

Widget buildTeacherItem(UserModel model , context) {
  return  InkWell(
    onTap: (){
      navigateTo(context, TeacherProfile(model.uId));
    },
    child: Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  backgroundImage: model.image == null ? NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/1024px-User-avatar.svg.png'): NetworkImage('${model.image}'),
                ),
                Row(
                  children: [
                    Icon(Icons.star , color: Colors.amber,),
                    model.rate == null ? Text("0.0", style: TextStyle(fontSize: 18),)
                        : Text("${model.rate.toStringAsFixed(1)}", style: TextStyle(fontSize: 18),),
                  ],
                )
              ],
            ),
            SizedBox(width: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${model.name}' , style: TextStyle(fontSize: 18),),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Icon(Icons.person_outline,color: buttonsColor,),
                    Text('${model.gender}',style: TextStyle(fontSize: 16),)
                  ],
                ),
                SizedBox(height: 5,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    color: buttonsColor,
                    width: 150,
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          color: Colors.white,
                          width: 150,
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(model.bio,style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              children: [
                InkWell(
                    onTap: (){
                      if(int.parse(RaqiCubit.get(context).userModel!.minutes) > 0){
                        CallUtils.dial(
                            from: RaqiCubit.get(context).userModel,
                            to: model,
                            context: context
                        );
                      }
                      else if(int.parse(RaqiCubit.get(context).fatherMins) > 0){
                        CallUtils.dial(
                            from: RaqiCubit.get(context).userModel,
                            to: model,
                            context: context
                        );
                      }
                      else{
                        showToast(text: "You do not have minutes, please recharge and try again", state: ToastStates.ERROR);
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: buttonsColor,
                      child: Icon(Icons.video_camera_front_rounded , color: Colors.white,),)),
                SizedBox(height: 5,),
                InkWell(child: CircleAvatar(
                  backgroundColor: buttonsColor,
                  child: Icon(Icons.message , color: Colors.white,),),
                  onTap: (){
                    navigateTo(context, ChatDetailsScreen(teacherModel: model));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

