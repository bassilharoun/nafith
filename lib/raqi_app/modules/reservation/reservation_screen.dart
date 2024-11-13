import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/app_cubit/app_states.dart';
import 'package:nafith/raqi_app/models/reservation_model.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';

class ReservationScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var model = RaqiCubit.get(context).teacherModel;
        return BlocConsumer<RaqiCubit, RaqiStates>(
          listener: (context, state){},
          builder:(context, state){
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                child: Icon(CupertinoIcons.calendar_badge_plus),
                onPressed: (){
                  _showDialog(context);

                },
              ),
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
                    Text(model.name),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConditionalBuilder(
                  condition: RaqiCubit.get(context).reverseReserved.length > 0,
                  builder: (context) => ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context , index) => buildReservedItem(context, RaqiCubit.get(context).reverseReserved[index]),
                    separatorBuilder: (context , index) => SizedBox(height: 10,),
                    itemCount: RaqiCubit.get(context).reverseReserved.length,
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
                  // navigateTo(context, TeacherProfile(model.sessionId));
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: buttonsColor,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundImage: model.studentImage == null ? NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/1024px-User-avatar.svg.png'): NetworkImage('${model.studentImage}') ,
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
                padding: const EdgeInsets.all(8.0),
                child: Text("${model.studentName} ${getLang(context,"reservedThis")}",style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,fontSize: 14)),
              ),
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
                                    Text("${model.duration} ${getLang(context,"min")}",style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("${model.duration} ${getLang(context,"from")}"),
                                    Text(model.from,style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("${model.duration} ${getLang(context,"to")}"),
                                    Text(model.to,style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12),),
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