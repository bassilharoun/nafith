import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/app_cubit/app_states.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';

class HomeTeacherScreen extends StatelessWidget {
  const HomeTeacherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RaqiCubit , RaqiStates>(
        listener:(context , state){},
        builder:(context , state){
          var userModel = RaqiCubit.get(context).userModel ;
          return ConditionalBuilder(
              condition: RaqiCubit.get(context).userModel != null,
              builder: (context) => Column(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0,left: 10,top: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CarouselSlider(
                        items: [
                          Image.asset('assets/images/banner1.png'),
                          Image.asset('assets/images/banner2.png'),
                        ],
                        options: CarouselOptions(
                            height: 210,
                            initialPage: 0,
                            viewportFraction: 1,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration: Duration(seconds: 1),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            scrollDirection: Axis.horizontal

                        )),
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${getLang(context,"welcome")} ${userModel!.name}')
                  ],
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: defaultButton(function: (){
                    RaqiCubit.get(context).changeBottomNavTeacher(3);

                  },
                      text: '${getLang(context,"eMoney")}'),
                ),
                defaultTextButton(function: (){
                  RaqiCubit.get(context).changeBottomNav(1);
                }, text: '${getLang(context,"sList")}', color: Colors.blue)
              ],) ,
              fallback: (context) => Center(child: CircularProgressIndicator(color: buttonsColor,)));

        }
    );
  }
}
