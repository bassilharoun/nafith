
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/models/call_model.dart';
import 'package:nafith/raqi_app/modules/call/pickup/pickup_screen.dart';

class PickupLayout extends StatelessWidget {
  dynamic scaffold ;
  PickupLayout({
    this.scaffold
});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: RaqiCubit.get(context).callStream(uid: RaqiCubit.get(context).userModel!.uId),
      builder: (context , snapshot){
        if(snapshot.hasData && snapshot.data!.data() != null){
          dynamic snap = snapshot.data!.data ;
          Call call = Call.fromMap(snapshot.data!.data() as Map<String , dynamic>);

          if(!call.hasDialled){
            return PickupScreen(call: call);
          }
          return scaffold ;

        }
        return scaffold ;
      },
    );
  }
}
