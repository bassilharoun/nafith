import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/app_cubit/app_states.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';
import 'package:nafith/raqi_app/shared/components/constants.dart';

class EditProfileScreen extends StatelessWidget {

  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RaqiCubit , RaqiStates>(
      listener: (context , state) {},
      builder: (context , state) {
        var userModel = RaqiCubit.get(context).userModel;
        nameController.text = userModel!.name ;
        bioController.text = userModel.bio == null ? " " : userModel.bio   ;
        emailController.text = userModel.email ;
        return Container(
         color: textColor,
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: defaultAppBar(
                context: context,
                title: "${getLang(context,"editProfile")}",
                actions: [
                  if(userModel.type == "student")
                    Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: defaultTextButton(function: (){
                      RaqiCubit.get(context).updateUser(name: nameController.text,
                          email: emailController.text,
                          bio: bioController.text,
                          type: RaqiCubit.get(context).userModel!.type,
                          gender: RaqiCubit.get(context).userModel!.gender
                      );

                    }, text: "${getLang(context,"submit")}" , color: Colors.white),
                  )
                ]
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  if(state is RaqiUserUpdateLoadingState)
                    LinearProgressIndicator(
                    color: lightColor,
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 150,
                    child: Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            backgroundImage: NetworkImage(RaqiCubit.get(context).userModel!.image),
                          ),
                          IconButton(onPressed: (){
                            RaqiCubit.get(context).getProfileImage();
                          },
                              icon: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.camera_alt_outlined,color: textColor,size: 20,)
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 800,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(35) , topRight: Radius.circular(35)),
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0 , horizontal: 30),
                          child: Column(
                            children: [
                              if(userModel.type == "teacher")...[
                                Text("${getLang(context,"toEdit")}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),
                                SizedBox(height: 15,)
                              ],
                              defaultTxtForm(
                                  controller: nameController,
                                  type: TextInputType.name,
                                  validate: (value){
                                    if(value!.isEmpty){
                                      return "${getLang(context,"nameQ")}";
                                    }
                                    return null ;
                                  },
                                  label: "${getLang(context,"name")}",
                                  prefix: Icons.person,
                                  isClickable: userModel.type == "teacher" ? false : true,
                                  inputTextColor: userModel.type == "teacher" ? Colors.grey : Colors.black,

                              ),
                              SizedBox(height: 15,),
                              defaultTxtForm(
                                controller: bioController,
                                type: TextInputType.text,
                                validate: (value){},
                                label: "${getLang(context,"bio")}",
                                prefix: Icons.info_outline,
                                isClickable: userModel.type == "teacher" ? false : true,
                                inputTextColor: userModel.type == "teacher" ? Colors.grey : Colors.black,

                              ),
                              SizedBox(height: 15,),
                              defaultTxtForm(
                                controller: emailController,
                                type: TextInputType.emailAddress,
                                validate: (value){},
                                label: "${getLang(context,"email")}",
                                prefix: Icons.email_outlined,
                                isClickable: userModel.type == "teacher" ? false : true,
                                inputTextColor: userModel.type == "teacher" ? Colors.grey : Colors.black,

                              ),
                              SizedBox(height: 25,),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  height: 40,
                                  color: Colors.red[100],
                                  child: defaultTextButton(
                                    function: (){
                                      _showDialog(context);
                                      },
                                    text: "${getLang(context,"delete")}",
                                    color: Colors.red
                                  ),
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ) ,
          ),
        ) ;
      },
    );
  }
  _showDialog(BuildContext contex)
  {
    BlurryDelete  alert = BlurryDelete();

    showDialog(
      context: contex,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
