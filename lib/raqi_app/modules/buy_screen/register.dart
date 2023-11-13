import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/modules/payment/cubit/cubit.dart';
import 'package:nafith/raqi_app/modules/payment/cubit/states.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var firstnameController = TextEditingController();
  var lastnameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  double price;
  RegisterScreen(this.price);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentCubit(),
      child: BlocConsumer<PaymentCubit , PaymobStates>(
        listener: (context , state){
          // if(state is PaymentRequestTokenSuccessState){
          //   navigateTo(context, VisaCardScreen());
          // }
        },
        builder: (context , state){
          return Scaffold(
            appBar: AppBar(title: Text("${getLang(context,"payment")}"),),
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Image.asset("assets/images/payments.png",height: 200,))
                        ],),
                      SizedBox(height: 20,),
                      Text("${getLang(context,"youWillPay")} $price ${getLang(context,"cost")}",style: TextStyle(fontSize: 20),),
                      SizedBox(height: 20,),
                      defaultTxtForm(
                          controller: firstnameController,
                          type: TextInputType.name,
                          validate: (value){
                            if(value!.isEmpty){
                              return "${getLang(context,"nameQ")}";
                            }

                          },
                          label: "${getLang(context,"fName")}",
                          prefix: Icons.person
                      ),
                      SizedBox(height: 25,),
                      defaultTxtForm(
                          controller: lastnameController,
                          type: TextInputType.name,
                          validate: (value){
                            if(value!.isEmpty){
                              return "${getLang(context,"nameQ")}";
                            }

                          },
                          label: "${getLang(context,"lName")}",
                          prefix: Icons.person
                      ),
                      SizedBox(height: 15,),
                      defaultTxtForm(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: (value){
                            if(value!.isEmpty){
                              return "${getLang(context,"phoneQ")}";
                            }

                          },
                          label: "${getLang(context,"phone")}",
                          prefix: Icons.phone
                      ),
                      SizedBox(height: 15,),
                      defaultTxtForm(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (value){
                            if(value!.isEmpty){
                              return "${getLang(context,"emailQ")}";
                            }

                          },
                          label: "${getLang(context,"email")}",
                          prefix: Icons.email
                      ),
                      SizedBox(height: 15,),
                      defaultButton(function: (){
                        if(formKey.currentState!.validate()){
                          print((price*8).toString());
                          PaymentCubit.get(context).getFirstToken(price.toInt()*8, firstnameController.text, lastnameController.text, emailController.text, phoneController.text,context);

                        }
                      }, text: "${getLang(context,"pay")}"),
                    ],
                  ),
                ),
              ),
            ),
          ) ;
        },
      ),
    );
  }
}
