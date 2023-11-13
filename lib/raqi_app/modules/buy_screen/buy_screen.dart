import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/modules/payment/cubit/cubit.dart';
import 'package:nafith/raqi_app/modules/payment/cubit/states.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';

import '../../shared/colors.dart';

class BuyScreen extends StatelessWidget {
  var couponController = TextEditingController();
  double price = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentCubit(),
      child: BlocConsumer<PaymentCubit , PaymobStates>(
        listener: (context , state){

        } ,
        builder: (context , state){
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("${getLang(context,"hello")}" ,style: TextStyle(fontSize: 24),),
                      Spacer(),
                      Row(
                        children: [
                          Icon(Icons.timer,color: buttonsColor),
                          SizedBox(width: 5,),
                          Text("${RaqiCubit.get(context).userModel!.minutes}",style: TextStyle(fontSize: 20),),
                          Text("${getLang(context,"min")}",style: TextStyle(fontSize: 20 , color: Colors.grey),)
                        ],
                      )
                    ],
                  ),
                  Text("${RaqiCubit.get(context).userModel!.name}," ,style: TextStyle(fontSize: 24),),
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      Expanded(
                        child: defaultTxtForm(
                            controller: couponController,
                            type: TextInputType.text,
                            validate: (val){},
                            label: "${getLang(context,"coupon")}"
                        ),
                      ),
                      SizedBox(width: 10,),
                      InkWell(
                        onTap: (){
                          PaymentCubit.get(context).getCoupon(couponController.text);
                          couponController.text = "";
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.green,
                          child: Icon(CupertinoIcons.check_mark_circled, color: Colors.white,),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30,),

                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: defaultButton(function: (){
                          if(PaymentCubit.get(context).pakka == 1){
                            if(PaymentCubit.get(context).dis == 0){
                              price = 10;
                            }
                            else{
                              price = 10 - (10*(PaymentCubit.get(context).dis/100));
                            }

                          }
                          if(PaymentCubit.get(context).pakka == 2){
                            if(PaymentCubit.get(context).dis == 0){
                              price = 35 ;
                            }
                            else{
                              price = 35 - (35*(PaymentCubit.get(context).dis/100));
                            }
                          }
                          if(PaymentCubit.get(context).pakka == 3){
                            if(PaymentCubit.get(context).dis == 0){
                              price = 70 ;
                            }
                            else{
                              price = 70 - (70*(PaymentCubit.get(context).dis/100));
                            }

                          }
                          PaymentCubit.get(context).getFirstToken(price.toInt()*8, RaqiCubit.get(context).userModel!.name.toString().split(" ").first, RaqiCubit.get(context).userModel!.name.toString().split(" ").last, RaqiCubit.get(context).userModel!.email, RaqiCubit.get(context).userModel!.phone,context);

                        }, text: "${getLang(context,"buy")}",background: buttonsColor,),
                      ),
                    ],
                  )
                ],
              ),

            ),
          ) ;
        } ,
      ),
    );
  }
}
