import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/models/call_model.dart';
import 'package:nafith/raqi_app/modules/call/agora_config.dart';
import 'package:nafith/raqi_app/shared/components/constants.dart';

class CallPage extends StatefulWidget {
  final String channelId;
  final Call call;
  const CallPage({
    Key? key,
    required this.channelId,
    required this.call,
  }) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  var commentController = TextEditingController();
  AgoraClient? client;
  String baseUrl = 'https://nafith-app.herokuapp.com';
  @override
  void initState() {
    super.initState();
    RaqiCubit.get(context).startCallTime();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );
    initAgora();
  }
  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null
          ? const CircularProgressIndicator()
          : SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(client: client!),
            AgoraVideoButtons(
              client: client!,
              disconnectButtonChild: InkWell(
                onTap: ()async{
                  await client!.engine.leaveChannel();
                  whoIcallId = widget.call.receiverId;
                  whoIcallName = widget.call.receiverName;
                  whoIcallPic = widget.call.receiverPic;
                  Navigator.pop(context);
                  RaqiCubit.get(context).endCallTime();
                  RaqiCubit.get(context).saveSession(teacherName: widget.call.receiverName, teacherImage: widget.call.receiverPic
                      , dateTime: RaqiCubit.get(context).startCallDate, duration: RaqiCubit.get(context).diffInMinutes.toString() , teacherId: widget.call.receiverId
                  ,studentName: widget.call.callerName, studentImage: RaqiCubit.get(context).userModel!.image, studentId: widget.call.callerId
                  );
                  RaqiCubit.get(context).endCall(widget.call , context);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                      Icons.call_end,
                    color: Colors.white,
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
