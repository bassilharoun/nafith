import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqi/raqi_app/app_cubit/app_cubit.dart';
import 'package:raqi/raqi_app/app_cubit/app_states.dart';
import 'package:raqi/raqi_app/models/reservation_model.dart';
import 'package:raqi/raqi_app/modules/teacher_profile/teacher_profile.dart';
import 'package:raqi/raqi_app/shared/colors.dart';
import 'package:raqi/raqi_app/shared/components/applocale.dart';
import 'package:raqi/raqi_app/shared/components/components.dart';

class MyReservationScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var model = RaqiCubit.get(context).userModel;
        return BlocConsumer<RaqiCubit, RaqiStates>(
          listener: (context, state){},
          builder:(context, state){
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: buttonsColor,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            backgroundImage: NetworkImage(model!.image) ,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10,),
                    Text("${getLang(context,"myReserve")}"),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConditionalBuilder(
                  condition: RaqiCubit.get(context).myReverseReserved.length > 0,
                  builder: (context) => ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context , index) => buildReservedItem(context, RaqiCubit.get(context).myReverseReserved[index]),
                    separatorBuilder: (context , index) => SizedBox(height: 10,),
                    itemCount: RaqiCubit.get(context).myReverseReserved.length,
                  ),
                  fallback: (context) => Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text('${getLang(context,"noReserved")}')),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } ,
        );



  }

  Widget buildReservedItem(context ,ReservationModel model){
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
                  if(RaqiCubit.get(context).userModel!.type == "student"){
                    navigateTo(context, TeacherProfile(model.teacherId));
                  }
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: buttonsColor,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundImage: RaqiCubit.get(context).userModel!.type == "student" ? NetworkImage('${model.teacherImage}') : NetworkImage('${model.studentImage}'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 5,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(RaqiCubit.get(context).userModel!.type == "student")...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${getLang(context,"reservedWith")} ${model.teacherName}: ",style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.bold,fontSize: 14)),
                ),
              ],
              if(RaqiCubit.get(context).userModel!.type == "teacher")...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${model.studentName} ${getLang(context,"reservedThis")}",style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.bold,fontSize: 14)),
                ),
              ],
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
                              backgroundColor: Colors.green,
                              child: Icon(Icons.bookmark_added ,color: Colors.white,),
                              radius: 25,
                            ),
                            SizedBox(width: 15,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${getLang(context,"reservedSession")}",style: TextStyle(fontSize: 16),),
                                Row(
                                  children: [
                                    Text("${getLang(context,"duration")}"),
                                    Text("${model.duration} Min",style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("${getLang(context,"from")}"),
                                    Text(model.from,style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 12),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("${getLang(context,"to")}"),
                                    Text(model.to,style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 12),),
                                  ],
                                ),

                              ],

                            ),
                            SizedBox(width: 35,)

                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(child: SizedBox(width: 5,)),
          Expanded(child: IconButton(onPressed: (){
            RaqiCubit.get(context).deleteStudentReserve(model);
          }, icon: Icon(Icons.delete_sweep,color: Colors.red))),
          Expanded(child: SizedBox(width: 5,)),
        ],
      ),
    );
  }






  _showDialog(BuildContext contex)
  {
    BlurryCal  alert = BlurryCal();

    showDialog(
      context: contex,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}