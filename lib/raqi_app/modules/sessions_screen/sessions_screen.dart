import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/models/sessions_model.dart';
import 'package:nafith/raqi_app/modules/teacher_profile/teacher_profile.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';

class SessionsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConditionalBuilder(
          condition: RaqiCubit.get(context).reversedSessions.length > 0,
          builder: (context) => Expanded(
            child: ListView.separated(
              itemBuilder: (context , index) => buildSessionItem(context, RaqiCubit.get(context).reversedSessions[index]),
              separatorBuilder: (context , index) => SizedBox(height: 10,),
              itemCount: RaqiCubit.get(context).reversedSessions.length,
            ),
          ),
          fallback: (context) => Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text('${getLang(context,"noSessions")}')),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSessionItem(context ,SessionsModel model){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              InkWell(
                onTap: (){
                  navigateTo(context, TeacherProfile(model.sessionId));
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: buttonsColor,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundImage: model.teacherImage == null ? NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/1024px-User-avatar.svg.png'): NetworkImage('${model.teacherImage}') ,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 5,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(model.dateTime,style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 12),),
              ),
              SizedBox(height: 5,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[500],
                              child: Icon(Icons.missed_video_call ,color: Colors.white,),
                              radius: 25,
                            ),
                            SizedBox(width: 15,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${getLang(context,"vSessions")}",style: TextStyle(fontSize: 16),),
                                Text("${model.duration} ${getLang(context,"min")}",style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),),
                              ],
                            ),
                            SizedBox(width: 35,)

                          ],
                        ),
                        SizedBox(height: 8,),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 220,
                            height: 35,
                            color: Colors.white,
                            child: TextButton(
                              clipBehavior: Clip.hardEdge,
                                onPressed: ()async{
                                  RaqiCubit.get(context).getTeacherThenCall(model.sessionId, context);
                                }, child: Text("${getLang(context,"callBack")}",style: TextStyle(color: Colors.black),),

                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
