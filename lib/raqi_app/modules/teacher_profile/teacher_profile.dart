import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/app_cubit/app_states.dart';
import 'package:nafith/raqi_app/models/comment_model.dart';
import 'package:nafith/raqi_app/modules/chat/chat_details_screen.dart';
import 'package:nafith/raqi_app/modules/reservation/reservation_screen.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';
import 'package:nafith/utils/call_utils.dart';

class TeacherProfile extends StatelessWidget {

  dynamic teacherId ;
  var commentController = TextEditingController();
  TeacherProfile(this.teacherId);

  @override
  Widget build(BuildContext context) {
    RaqiCubit.get(context).getTeacher(teacherId);
    RaqiCubit.get(context).getComments(teacherId);
    RaqiCubit.get(context).getRates(teacherId);
    print(RaqiCubit.get(context).comments);
    return BlocConsumer<RaqiCubit , RaqiStates>(
      listener: (context , state) {} ,
      builder: (context , state) {
        var model = RaqiCubit.get(context).teacherModel;
        return ConditionalBuilder(
          condition: RaqiCubit.get(context).teacherModel != null,
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(model!.name),
              actions: [
                IconButton(onPressed: (){
                  RaqiCubit.get(context).getReserved(model.uId);
                  navigateTo(context, ReservationScreen());
                }, icon: Icon(CupertinoIcons.calendar_badge_plus,color: buttonsColor,))
              ],
            ),
            body: Column(
              children: [
                Container(
                  height: 170,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image:  AssetImage('assets/images/cover.jpg') ,
                                    fit: BoxFit.cover

                                )
                            ),
                          ),
                        ),
                        alignment: AlignmentDirectional.topCenter,
                      ),
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: buttonsColor,
                            child: CircleAvatar(
                              radius: 46,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              backgroundImage: NetworkImage('${model.image}') ,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(model.name,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 24
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text("(${model.bio})",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star , color: Colors.amber,),
                    RaqiCubit.get(context).totalRate.isNaN ? Text("0.0", style: TextStyle(fontSize: 18),)
                        : Text("${RaqiCubit.get(context).totalRate.toStringAsFixed(1)}", style: TextStyle(fontSize: 18),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(child: CircleAvatar(
                      backgroundColor: buttonsColor,
                      child: Icon(Icons.message , color: Colors.white,),),
                      onTap: (){
                        navigateTo(context, ChatDetailsScreen(teacherModel: model));
                      },
                    ),
                    SizedBox(width: 15,),
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

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: myDivider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                      child: Text("${getLang(context,"comments")}", style: TextStyle(fontSize: 20),),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                ConditionalBuilder(
                  condition: RaqiCubit.get(context).comments.length > 0,
                  builder: (context) => Expanded(
                    child: ListView.separated(
                      itemBuilder: (context , index) => buildCommentItem(context, RaqiCubit.get(context).comments[index]),
                      separatorBuilder: (context , index) => SizedBox(height: 5,),
                      itemCount: RaqiCubit.get(context).comments.length,
                    ),
                  ),
                  fallback: (context) => Center(child: Text('${getLang(context,"noComments")}'),),
                ),

              ],
            ),
          ),
          fallback: (context) => Scaffold(body: Center(child: CircularProgressIndicator(color: buttonsColor,),)),
        );
      } ,
    );
  }

}

Widget buildCommentItem(context ,CommentModel model){
  return Card(
    color: Theme.of(context).scaffoldBackgroundColor,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 8,
    margin: EdgeInsets.symmetric(horizontal: 10),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                  child: Image.network(
                      model.senderImage,
                    fit: BoxFit.cover,
                  ),
                radius: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.senderName,style: TextStyle(fontSize: 16),),
                  Text(model.dateTime,style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 10),)
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(model.rate == 1)...[
                    Icon(Icons.star , color: Colors.amber,),
                  ]
                  else if(model.rate == 2)...[
                    Icon(Icons.star , color: Colors.amber,),
                    Icon(Icons.star , color: Colors.amber,),
                  ]

                  else if(model.rate == 3)...[
                    Icon(Icons.star , color: Colors.amber,),
                    Icon(Icons.star , color: Colors.amber,),
                    Icon(Icons.star , color: Colors.amber,),
                  ]

                  else if(model.rate == 4)...[
                        Icon(Icons.star , color: Colors.amber,),
                        Icon(Icons.star , color: Colors.amber,),
                        Icon(Icons.star , color: Colors.amber,),
                        Icon(Icons.star , color: Colors.amber,),
                  ]

                  else if(model.rate == 5)...[
                          Icon(Icons.star , color: Colors.amber,),
                          Icon(Icons.star , color: Colors.amber,),
                          Icon(Icons.star , color: Colors.amber,),
                          Icon(Icons.star , color: Colors.amber,),
                          Icon(Icons.star , color: Colors.amber,),
                        ]
                ],
              ),
              SizedBox(width: 15,)



            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(model.text),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

