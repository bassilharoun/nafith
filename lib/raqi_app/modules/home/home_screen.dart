import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nafith/main.dart';
import 'package:nafith/raqi_app/app/global/styles/colors.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/app_cubit/app_states.dart';
import 'package:nafith/raqi_app/modules/store/widgets/popular_products.dart';
import 'package:nafith/raqi_app/paytaps/presentation/styles/app_colors.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';

// class HomeScreen extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<RaqiCubit , RaqiStates>(
//         listener:(context , state){},
//         builder:(context , state){
//           var userModel = RaqiCubit.get(context).userModel ;
//           return ConditionalBuilder(
//             condition: RaqiCubit.get(context).userModel != null,
//               builder: (context) => SingleChildScrollView(
//                 child: Column(children: [
//                   Padding(
//                     padding: const EdgeInsets.only(right: 10.0,left: 10,top: 10),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: CarouselSlider(
//                           items: [
//                             Image.asset('assets/images/banner1.png'),
//                             Image.asset('assets/images/banner2.png'),
//                           ],
//                           options: CarouselOptions(
//                               height: 210,
//                               initialPage: 0,
//                               viewportFraction: 1,
//                               enableInfiniteScroll: true,
//                               autoPlay: true,
//                               autoPlayInterval: Duration(seconds: 3),
//                               autoPlayAnimationDuration: Duration(seconds: 1),
//                               autoPlayCurve: Curves.fastOutSlowIn,
//                               scrollDirection: Axis.horizontal

//                           )),
//                     ),
//                   ),
//                   SizedBox(height: 15,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('${getLang(context,"welcome")} ${userModel!.name}'),
//                     ],
//                   ),
//                   SizedBox(height: 15,),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text("${getLang(context,"min")}: ${RaqiCubit.get(context).userModel!.minutes}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
//                         SizedBox(width: 30,),
//                         if(RaqiCubit.get(context).father != null)
//                           Text("${getLang(context,"affiliateMin")}: ${RaqiCubit.get(context).fatherMins}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 7,),
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: defaultButton(function: (){
//                       RaqiCubit.get(context).changeBottomNav(4);

//                     },
//                         text: "${getLang(context,"subscribe")}"),
//                   ),
//                   defaultTextButton(function: (){
//                     RaqiCubit.get(context).changeBottomNav(1);
//                   }, text: "${getLang(context,"Tlist")}", color: Colors.blue)
//                 ],),
//               ) ,
//               fallback: (context) => Center(child: CircularProgressIndicator(color: buttonsColor,)));

//     }
//     );
//   }
// }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RaqiCubit, RaqiStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorNeutrals.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TopBar(),
                  SearchInput(),
                  PromoCard(),
                  Headline(),
                  CardListView(),
                  SHeadline(),
                  PopularProducts(),
                  SizedBox(
                    height: 20.h,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Find your\nshaikh now",
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          // Container(
          //   decoration: BoxDecoration(boxShadow: [
          //     BoxShadow(
          //         offset: const Offset(12, 26),
          //         blurRadius: 50,
          //         spreadRadius: 0,
          //         color: Colors.grey.withOpacity(.25)),
          //   ]),
          //   child: const CircleAvatar(
          //     radius: 25,
          //     backgroundColor: Colors.white,
          //     child: Icon(
          //       Icons.icecream,
          //       size: 25,
          //       color: Color(0xff53E88B),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, left: 25.0, right: 25.0, bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: const Offset(12, 26),
              blurRadius: 50,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.1)),
        ]),
        child: TextField(
          onChanged: (value) {
            //Do something wi
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
          ),
        ),
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  const PromoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 120.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Color(0xff53E88B), Color(0xff15BE77)],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              15), // Ensures images respect container's rounded corners
          child: CarouselSlider(
            items: [
              Image.asset(
                'assets/images/islamic_slider.jfif',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width, // Ensures full width
              ),
              Image.asset(
                'assets/images/islamic_2_slider.jfif',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width, // Ensures full width
              ),
            ],
            options: CarouselOptions(
              height: 120.h,
              initialPage: 0,
              viewportFraction: 1.0, // Takes up full width of the viewport
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ),
    );
  }
}

class Headline extends StatelessWidget {
  const Headline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Top Shaikhs",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                "The best shaikhs for you",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              RaqiCubit.get(context).changeBottomNav(1);
            },
            child: Text(
              "View More",
              style: TextStyle(
                  color: ColorRaqi.purple100, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}

class SHeadline extends StatelessWidget {
  const SHeadline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Raqi products",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                "let's see what we have",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          InkWell(
            onTap: () {},
            child: Text(
              "View More",
              style: TextStyle(
                  color: ColorRaqi.purple100, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}

class CardListView extends StatelessWidget {
  const CardListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, right: 25.0, bottom: 15.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 175,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: RaqiCubit.get(context).teachers.length > 5
              ? 5
              : RaqiCubit.get(context).teachers.length,
          itemBuilder: (context, index) => Card(
              "${RaqiCubit.get(context).teachers[index].name}",
              "${RaqiCubit.get(context).teachers[index].image}",
              "${RaqiCubit.get(context).teachers[index].bio}",
              RaqiCubit.get(context).teachers[index].rate),
        ),
      ),
    );
  }
}

class Card extends StatelessWidget {
  final String text;
  final String imageUrl;
  final String subtitle;
  final dynamic teacherRate;

  Card(this.text, this.imageUrl, this.subtitle, this.teacherRate, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, bottom: 15),
      child: Container(
        width: 150,
        height: 150,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: ColorNeutrals.grey5,
          borderRadius: BorderRadius.circular(12.5),
          boxShadow: [
            BoxShadow(
                offset: const Offset(10, 20),
                blurRadius: 10,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.05)),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  imageUrl,
                )),
            Spacer(),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            SizedBox(
              height: 5,
            ),
            // Row(
            //   children: [
            //     Icon(
            //       Icons.star,
            //       color: Colors.amber,
            //     ),
            //     teacherRate == null
            //         ? Text(
            //             "0.0",
            //             style: TextStyle(fontSize: 18),
            //           )
            //         : Text(
            //             "${teacherRate.toStringAsFixed(1)}",
            //             style: TextStyle(fontSize: 18),
            //           ),
            //   ],
            // ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
