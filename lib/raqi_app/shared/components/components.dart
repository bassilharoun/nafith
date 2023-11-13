import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as datetime;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/layout/raqi_layout.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/constants.dart';
import 'package:nafith/raqi_app/styles/Iconly-Broken_icons.dart';

void navigateTo(context , widget) => Navigator.push(context,
    MaterialPageRoute(builder:  (context) => widget)) ;

void navigateAndFinish(context , widget) => Navigator.pushAndRemoveUntil(context,
    MaterialPageRoute(builder:  (context) => widget),
    (route) => false
) ;


Widget defaultTxtForm({
  required TextEditingController controller ,
  required TextInputType type ,
  Function(String)? onSubmit ,
  VoidCallback? onTap ,
  Function(String)? onChanged ,
  required String? Function(String?)? validate ,
  required String label ,
  IconData? prefix ,
  IconData? suffix = null ,
  bool isPassword = false,
  bool isClickable = true ,
  VoidCallback? onSuffixPressed ,
  VoidCallback? onPrefixPressed ,
  Color prefixColor = buttonsColor,
  Color inputTextColor = Colors.black,
  int maxLines = 1

}) => TextFormField(
  style: TextStyle(color: inputTextColor),
  validator: validate,
  maxLines: maxLines,
  obscureText: isPassword,
  controller: controller,
  decoration: InputDecoration(
      labelText: label,
      prefixIcon: GestureDetector(child: Icon(prefix , color: prefixColor,),onTap: onPrefixPressed,),
      suffixIcon: GestureDetector(
        child: Icon(suffix),
        onTap: onSuffixPressed,
      ),
      border: OutlineInputBorder()
  ),
  keyboardType: type,
  enabled: isClickable,
  onFieldSubmitted: onSubmit,
  onChanged: onChanged,
  onTap: onTap,

) ;


Widget defaultButton({
  double width = double.infinity ,
  double height = 50 ,
  Color background = buttonsColor ,
  Color textColor = Colors.white ,
  required VoidCallback function ,
  required String text ,
  bool isUpperCase = true,


}) => Container(
  width: width,
  child: MaterialButton(
    height: height,
    onPressed: function,
    child: Text(isUpperCase ? text.toUpperCase() : text,
      style: TextStyle(color: textColor),),
  ),
  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
    color: background,
  ),
);

Widget defaultTextButton({
  required VoidCallback function,
  required String text,
  Color color = buttonsColor ,

}) => TextButton(onPressed: function
    ,child: Text(
        text.toUpperCase(),
        style: TextStyle(color: color , fontSize: 16),
    ));

void showToast({
  required String text ,
  required ToastStates state ,
}) => Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastStates{SUCCESS , ERROR , WARNING}
Color? chooseToastColor(ToastStates state){
  Color? color ;
  switch(state){
    case ToastStates.SUCCESS:
      color = buttonsColor;
      break;
    case ToastStates.ERROR:
      color = Colors.redAccent;
      break;
    case ToastStates.WARNING:
      color = Colors.yellow;
      break;
  }
  return color ;

}

Widget myDivider() => Container(
  width: double.infinity,
  height: 1,
  color: Colors.grey[300],
);

PreferredSizeWidget? defaultAppBar({
  required BuildContext context ,
  dynamic title ,
  List<Widget>? actions,
  Color color = textColor,
  Color titleColor = Colors.white,

}) => AppBar(
  backgroundColor: color,
  leading: IconButton(
    color: titleColor,
    onPressed: (){
      Navigator.pop(context);
    },
    icon: Icon(Iconly_Broken.Arrow___Left_2),
  ),
  title: Text(title, style: TextStyle(color: titleColor),),
  titleSpacing: 0,
  actions: actions,
);

var commentKey = GlobalKey<FormState>();


class BlurryDialog extends StatefulWidget {
  int n ;
  BlurryDialog(this.n);

  @override
  State<BlurryDialog> createState() => _BlurryDialogState(n);
}


class _BlurryDialogState extends State<BlurryDialog> {
  int n ;
  _BlurryDialogState(this.n);
  @override
  Widget build(BuildContext context) {
  return n == 1 ? BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child:  StatefulBuilder(
        builder: (context, setState){
          return AlertDialog(
            title: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.grey,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(whoIcallPic,
                    fit: BoxFit.cover
                ),
              ),

            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${getLang(context,"howTCall")}"),
                Text("${getLang(context,"rate")} $whoIcallName"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          rate = 1 ;
                          print(rate);
                        });
                        RaqiCubit.get(context).emitRate();
                      },
                      child: Icon(Icons.star , color: rate >= 1 ? Colors.amber : Colors.grey ,size: 40,),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          rate = 2 ;
                          print(rate);
                        });
                      },
                      child: Icon(Icons.star , color: rate >= 2 ? Colors.amber : Colors.grey,size: 40,),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          rate = 3 ;
                          print(rate);
                        });
                      },
                      child: Icon(Icons.star , color: rate >= 3 ? Colors.amber : Colors.grey,size: 40,),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          rate = 4 ;
                          print(rate);
                        });
                      },
                      child: Icon(Icons.star , color: rate >= 4 ? Colors.amber : Colors.grey,size: 40,),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          rate = 5 ;
                          print(rate);
                        });
                      },
                      child: Icon(Icons.star , color: rate >= 5 ? Colors.amber : Colors.grey,size: 40,),
                    )
                  ],),
                SizedBox(height: 15,),
                Form(
                  key: commentKey,
                  child: defaultTxtForm(controller: commentController, type: TextInputType.text, validate: (value){
                    if(value!.isEmpty){
                      return "${getLang(context,"commentQ")}";
                    }
                  }, label: "${getLang(context,"comment")}"),
                )
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("${getLang(context,"comment")}" ,style: TextStyle(color: Colors.blue),),
                onPressed: () {
                  if(commentKey.currentState!.validate()){
                    RaqiCubit.get(context).commentOnTeacher(teacherId: whoIcallId, dateTime: now.toString(), text: commentController.text,rate: rate);
                    RaqiCubit.get(context).sendNotification("تقييم جديد!", "تهانينا ${RaqiCubit.get(context).userModel!.name} قد قيمك ", whoIcallModel!.deviceToken, "rate", RaqiCubit.get(context).userModel!.uId);
                    RaqiCubit.get(context).saveNotification("rate", "تقييم جديد!", "تهانينا ${RaqiCubit.get(context).userModel!.name} قد قيمك ",whoIcallModel!.uId);
                    Navigator.of(context).pop();
                }
                },
              ),
              new TextButton(
                child: Text("${getLang(context,"cancel")}"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      )) : BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child:  StatefulBuilder(
        builder: (context, setState){
          return AlertDialog(
            title: Text("${getLang(context,"contactUs")}"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                defaultTxtForm(
                    controller: emailContactController,
                    type: TextInputType.text,
                    validate: (val){},
                    label: "${getLang(context,"email")}",
                    isClickable: false,
                    inputTextColor: Colors.grey
                ),
                SizedBox(height: 10,),
                defaultTxtForm(
                    controller: nameContactController,
                    type: TextInputType.text,
                    validate: (val){},
                    label: "${getLang(context,"name")}",
                    isClickable: false,
                    inputTextColor: Colors.grey
                ),
                SizedBox(height: 10,),
                Form(
                  key: commentKey,
                  child: defaultTxtForm(maxLines: 4,controller: messageContactController, type: TextInputType.text, validate: (value){
                    if(value!.isEmpty){
                      return "${getLang(context,"whatUWillSay")}";
                    }
                  }, label: "${getLang(context,"message")}"),
                )
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("${getLang(context,"send")}" ,style: TextStyle(color: Colors.blue),),
                onPressed: () {
                  if(commentKey.currentState!.validate()){
                    RaqiCubit.get(context).contactUs(messageContactController.text);
                    Navigator.pop(context);
                  }
                },
              ),
              new TextButton(
                child: Text("${getLang(context,"cancel")}"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ));
}
}

class BlurryDelete extends StatefulWidget {
  @override
  State<BlurryDelete> createState() => BlurryDialogState();
}


class BlurryDialogState extends State<BlurryDelete> {
  BlurryDialogState();
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child:  StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              title: Icon(Icons.warning,color: Colors.red,size: 40,),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                 Text("${getLang(context,"deleteWarning")}")
                ],
              ),
              actions: <Widget>[
                new TextButton(
                  child: new Text("${getLang(context,"del")}" ,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                  onPressed: () {
                      RaqiCubit.get(context).deleteUser(context);
                      Navigator.of(scaffoldKey.currentContext!).pop();

                  },
                ),
                new TextButton(
                  child: Text("${getLang(context,"cancel")}"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ));
  }
}

class BlurryAdd extends StatefulWidget {
  @override
  State<BlurryAdd> createState() => BlurryDialogStateAdd();
}


class BlurryDialogStateAdd extends State<BlurryAdd> {
  String? country ;

  var formKey = GlobalKey<FormState>();

  var phoneController = TextEditingController();

  BlurryDialogStateAdd();
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child:  StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              title: Icon(Icons.person_add_alt_outlined,color: buttonsColor,size: 40,),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${getLang(context,"addHisPhone")}"),
                  SizedBox(height: 15,),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value){
                      if(value!.isEmpty){
                        return "${getLang(context,"phoneQ")}";
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "${getLang(context,"phone")}",
                      prefixIcon: country == null ? GestureDetector(
                        child: Icon(Icons.arrow_drop_down_sharp), onTap: (){
                        pickCountry(context);
                      },) : GestureDetector(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('+${country}'),
                          ],
                        ),onTap: (){
                        pickCountry(context);
                      },),
                    ),

                  ),
                ],
              ),
              actions: <Widget>[
                new TextButton(
                  child: new Text("${getLang(context,"add")}" ,style: TextStyle(color: buttonsColor,fontWeight: FontWeight.bold),),
                  onPressed: () {
                    RaqiCubit.get(context).getFollower(country != null ? "+${country}${phoneController.text}" : "${phoneController.text}", context);
                  },
                ),
                new TextButton(
                  child: Text("${getLang(context,"cancel")}"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ));
  }
  pickCountry(context){
    showCountryPicker(
      context: context,
      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country _country) {
        setState(() {
          country = _country.phoneCode ;
          print('${getLang(context,"signup")} ${_country.phoneCode}');
        });

      },
    );
  }
}

class BlurryCal extends StatefulWidget {
  @override
  State<BlurryCal> createState() => BlurryDialogState3();
}


class BlurryDialogState3 extends State<BlurryCal> {
  BlurryDialogState3();
  @override
  Widget build(BuildContext context) {
    var from = "--";
    var to = "--";
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child:  StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              title: Icon(Icons.calendar_today_outlined,size: 40,),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${getLang(context,"pleaseSession")}"),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Text("${getLang(context,"from")}"),
                      Text(from,style: TextStyle(color: buttonsColor)),
                      Spacer(),
                      IconButton(onPressed: (){
                        datetime.DatePicker.showDateTimePicker(
                            context,
                            minTime: DateTime.now().add(Duration(hours: 1)),
                            maxTime: DateTime.now().add(Duration(days: 7))
                        ).then((value) {
                          setState(() {
                            from = DateFormat('yyyy-MM-dd – kk:mm').format(value!).toString();
                            RaqiCubit.get(context).from = value ;
                          });
                        });
                      }, icon: Icon(Icons.calendar_month_outlined,color: buttonsColor,))
                    ],
                  ),
                  SizedBox(height: 15,),
                  if(RaqiCubit.get(context).from != null)
                    Row(
                    children: [
                      Text("${getLang(context,"to")} "),
                      Text(to,style: TextStyle(color: buttonsColor)),
                      Spacer(),
                      IconButton(onPressed: (){
                        datetime.DatePicker.showDateTimePicker(
                            context,
                            minTime: RaqiCubit.get(context).from.add(Duration(minutes: 30)),
                            maxTime: RaqiCubit.get(context).from.add(Duration(hours: 6))
                        ).then((value) {
                          setState(() {
                            to = DateFormat('yyyy-MM-dd – kk:mm').format(value!).toString();
                            RaqiCubit.get(context).to = value;
                          });
                        });
                      }, icon: Icon(Icons.calendar_month_outlined,color: buttonsColor,))
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                new TextButton(
                  child: new Text("${getLang(context,"reserve")}" ,style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                  onPressed: () {
                    if(RaqiCubit.get(context).to != null){
                      RaqiCubit.get(context).reserve(RaqiCubit.get(context).teacherModel!.uId,RaqiCubit.get(context).teacherModel!.name,RaqiCubit.get(context).teacherModel!.image);
                      RaqiCubit.get(context).sendNotification("حجز جديد!", "تهانينا ${RaqiCubit.get(context).userModel!.name} حجز موعد جديد معك ", RaqiCubit.get(context).teacherModel!.deviceToken, "reserve", RaqiCubit.get(context).userModel!.uId);
                      RaqiCubit.get(context).saveNotification("reserve","حجز جديد!", "تهانينا ${RaqiCubit.get(context).userModel!.name} حجز موعد جديد معك ", RaqiCubit.get(context).teacherModel!.uId);
                      Navigator.of(context).pop();
                    }
                    else{
                      showToast(text: "please choose the session date", state: ToastStates.WARNING);
                    }

                  },
                ),
                new TextButton(
                  child: Text("${getLang(context,"cancel")}"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ));
  }
}

int rate = 3 ;
Widget starRate(int i){
  return InkWell(
    onTap: (){
      rate = i ;
      print(rate);
    },
    child: Icon(Icons.star , color: Colors.amber,size: 40,),
  );
}


