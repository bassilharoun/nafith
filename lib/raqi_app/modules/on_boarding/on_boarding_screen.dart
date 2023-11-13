import 'package:flutter/material.dart';
import 'package:nafith/raqi_app/modules/login/login_screen.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';
import 'package:nafith/raqi_app/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel{
   String image;
   String title;
   String body ;

  BoardingModel({
    required this.image ,
    required this.title ,
    required this.body ,
});
}

class OnBoardingScreen extends StatefulWidget {

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  var boardController = PageController();



  bool isLast = false ;

  void submit(){
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      navigateAndFinish(context, LoginScreen());
    });

  }

  @override
  Widget build(BuildContext context) {

    List<BoardingModel> boarding = [
      BoardingModel(
          image: 'assets/images/on1.png',
          title: "${getLang(context,"Nafith")}",
          body: "${getLang(context,"onBoard1")}"),
      BoardingModel(
          image: 'assets/images/on2.png',
          title: "${getLang(context,"Nafith")}",
          body: "${getLang(context,"onBoard2")}"),
      BoardingModel(
          image: 'assets/images/on3.png',
          title: "${getLang(context,"inNafith")}",
          body: "${getLang(context,"onBoard3")}"),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(function: submit,
              text: "${getLang(context,"skip")}"),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (index){
                if(index == boarding.length - 1){
                  setState(() {
                    isLast = true ;
                  }
                  );
                }else {
                  setState(() {
                    isLast = false ;
                  }
                  );
                }
              },
              physics: BouncingScrollPhysics(),
              controller: boardController,
              itemBuilder: (context , index) => buildBoardingItem(boarding[index]),
              itemCount: boarding.length,
            ),
          ),
          Row(
            children: [
              SmoothPageIndicator(
                effect: ExpandingDotsEffect(
                  dotColor: Colors.grey,
                  dotHeight: 10,
                  expansionFactor: 4,
                  dotWidth: 10,
                  spacing: 5,
                  activeDotColor: buttonsColor
                ),
                  controller: boardController, count: 3),
              Spacer(),
              FloatingActionButton(
                  onPressed: (){
                    if(isLast){
                      submit();
                    }
                    else{
                      boardController.nextPage(duration: Duration(milliseconds: 750), curve: Curves.decelerate);
                    }

                  },
              child : Icon(Icons.arrow_forward_ios)
              )

            ],
          ),
        ],),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Image(
          image: AssetImage('${model.image}')),
      Spacer(),
      Text(
        '${model.title}',
        style: TextStyle(
          fontSize: 30,
        ),

      ),
      SizedBox(
        height: 15,),
      Expanded(
        child: Container(
          child: Text(
            '${model.body}',
            style: TextStyle(
              fontSize: 23,
            ),

          ),
        ),
      ),
    ],) ;
}
