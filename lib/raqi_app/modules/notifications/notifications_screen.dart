import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/app_cubit/app_states.dart';
import 'package:nafith/raqi_app/models/notification_model.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';

class NotificationsScreen extends StatelessWidget {

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
                      child: Icon(Icons.notifications,color: Colors.white,)
                    ),
                  ],
                ),
                SizedBox(width: 10,),
                Text("${getLang(context,"notifications")}"),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConditionalBuilder(
              condition: RaqiCubit.get(context).reversedNotifications.length > 0,
              builder: (context) => ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context , index) => buildNotificationItem(context, RaqiCubit.get(context).reversedNotifications[index]),
                separatorBuilder: (context , index) => myDivider(),
                itemCount: RaqiCubit.get(context).reversedNotifications.length,
              ),
              fallback: (context) => Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Icon(Icons.notifications_off_outlined,size: 50,color: Colors.grey,)),
                  ],
                ),
              ),
            ),
          ),
        );
      } ,
    );



  }

  Widget buildNotificationItem(context ,NotificationModel model){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: NetworkImage(model.senderImage),
                ),
                CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[200],
                        child: whichIcon(model)
                    )

              ],
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.senderName,style: TextStyle(color: buttonsColor,fontWeight: FontWeight.bold),),
                  Text(model.body),
                  Text(model.dateTime.toString(),style: TextStyle(color: Colors.grey),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Icon whichIcon(NotificationModel model){
  Icon icon = Icon(Icons.notifications_active_outlined);
  if(model.notificationType == "rate"){
    icon = Icon(Icons.star_border,color: Colors.grey[700],size: 20,);
  }

  if(model.notificationType == "reserve"){
    icon = Icon(Icons.calendar_month_outlined,color: Colors.grey[700],size: 20,);
  }

  if(model.notificationType == "call"){
    icon = Icon(Icons.call,color: Colors.grey[700],size: 20,);
  }

  if(model.notificationType == "chat"){
    icon = Icon(Icons.chat_outlined,color: Colors.grey[700],size: 20,);
  }

  if(model.notificationType == "admin"){
    icon = Icon(Icons.admin_panel_settings_outlined,color: Colors.grey[700],size: 20,);
  }

  return icon ;

}