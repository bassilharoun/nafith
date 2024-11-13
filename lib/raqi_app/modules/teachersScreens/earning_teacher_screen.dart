import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/app_cubit/app_states.dart';
import 'package:nafith/raqi_app/models/sessions_model.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';

class EarningScreen extends StatelessWidget {
  const EarningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RaqiCubit, RaqiStates>(
      listener: (context, state){},
      builder: (context, state){
        return Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Total earning Mins : ",style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20),),
              CircleAvatar(child: Text("${RaqiCubit.get(context).sumMinutes}",style: TextStyle(fontSize: 24, color: Colors.white),),backgroundColor: buttonsColor,),
            ],),
          ),
          ConditionalBuilder(
            condition: RaqiCubit.get(context).reversedSessions.length > 0,
            builder: (context) => Expanded(
              child: ListView.separated(
                itemBuilder: (context , index) => buildEarningItem(context, RaqiCubit.get(context).reversedSessions[index]),
                separatorBuilder: (context , index) => SizedBox(height: 10,),
                itemCount: RaqiCubit.get(context).reversedSessions.length,
              ),
            ),
            fallback: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${getLang(context,"noSessions")}'),
              ],
            ),
          ),
        ],);
      }
    );
  }

  Widget buildEarningItem(context ,SessionsModel model){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(model.dateTime,style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12),),
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
                          radius: 28,
                          backgroundColor: buttonsColor,
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            backgroundImage: NetworkImage('${model.studentImage}') ,
                          ),
                        ),
                        SizedBox(width: 15,),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text("${getLang(context,"vSessions")}",style: TextStyle(fontSize: 16),),
                                  Text("${model.studentName}",style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),),
                                ],
                              ),
                              Spacer(),
                              Text("${model.duration} ${getLang(context,"min")}",style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),),
                            ],
                          ),
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
    );
  }
}
