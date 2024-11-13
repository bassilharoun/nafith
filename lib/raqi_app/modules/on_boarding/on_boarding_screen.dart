import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nafith/raqi_app/modules/login/login_screen.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';
import 'package:nafith/raqi_app/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  String image;
  String title;
  String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  bool isLast = false;

  void submit() {
    if (isLast) {
      CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
        navigateAndFinish(context, LoginScreen());
      });
    } else {
      boardController.nextPage(
          duration: Duration(milliseconds: 750),
          curve: Curves.fastLinearToSlowEaseIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BoardingModel> boarding = [
      BoardingModel(
          image: 'assets/images/on1-removebg.png',
          title: "${getLang(context, "Nafith")}",
          body: "${getLang(context, "onBoard1")}"),
      BoardingModel(
          image: 'assets/images/on3.png',
          title: "${getLang(context, "inNafith")}",
          body: "${getLang(context, "onBoard3")}"),
      BoardingModel(
          image: 'assets/images/on2.png',
          title: "${getLang(context, "Nafith")}",
          body: "${getLang(context, "onBoard2")}"),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
              function: submit, text: "${getLang(context, "next")}"),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                physics: BouncingScrollPhysics(),
                controller: boardController,
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            SmoothPageIndicator(
                effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 10,
                    spacing: 5,
                    activeDotColor: buttonsColor),
                controller: boardController,
                count: 3),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${model.title}',
            style: TextStyle(fontSize: 30, color: buttonsColor),
          ),
          SizedBox(
            height: 15.h,
          ),
          // centered text
          Container(
            child: Text(
              textAlign: TextAlign.center,
              '${model.body}',
              style: TextStyle(
                fontSize: 16,
                color: greyColor,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          // SizedBox(
          //   height: 30.h,
          // ),
          Expanded(
            child: Stack(
              alignment: Alignment.center, // Center everything inside the Stack
              children: [
                Align(
                  alignment: Alignment.center,
                  child:
                      Image.asset("assets/images/on_boarding_background.png"),
                ),
                Opacity(
                  opacity: 0.8, // Set the opacity level here (0.0 - 1.0)
                  child: Align(
                    alignment: Alignment.center,
                    child: Image(
                      width: 270.w,
                      image: AssetImage(
                        '${model.image}',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
