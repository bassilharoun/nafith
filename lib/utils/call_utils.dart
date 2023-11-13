import 'dart:math';

import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/models/call_model.dart';
import 'package:nafith/raqi_app/models/raqi_user_model.dart';
import 'package:nafith/raqi_app/shared/components/constants.dart';

import '../raqi_app/modules/call/video/video_call.dart';
import '../raqi_app/shared/components/components.dart';

class CallUtils{
  static dial({
    UserModel? from ,
    UserModel? to ,
    context
})async{
    Call call = Call(
      callerId: from!.uId,
      callerName: from.name,
      callerPic: from.image??'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/1024px-User-avatar.svg.png',
      receiverId: to!.uId,
      receiverName: to.name,
      receiverPic: to.image,
      channelId: Random().nextInt(1000).toString()
    );
    bool callMade = await RaqiCubit.get(context).makecall(call);
    call.hasDialled = true ;

    if(callMade){
      whoIcallModel = to;
      RaqiCubit.get(context).sendNotification("اتصال وارد", "${from.name}...يتصل بك", to.deviceToken, "call", from.uId);
      RaqiCubit.get(context).saveNotification("call","اتصال وارد", "${from.name}...حاول الاتصال بك", from.uId);
      navigateTo(context, CallPage(call: call, channelId: call.callerId,));
    }
  }
}