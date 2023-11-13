import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/app_cubit/app_states.dart';
import 'package:nafith/raqi_app/modules/books/pdf_api.dart';
import 'package:nafith/raqi_app/modules/books/view_book.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RaqiCubit , RaqiStates>(
      listener: (context , state) {
        // if (state is RaqiLoadBook){
        //
        // }
      },
      builder: (context , state) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text("${getLang(context,"books")}"),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: ()async{
                    RaqiCubit.get(context).loadBook();
                    final url = 'كتاب الرقية الشرعية من الكتاب والسنة د.خالد الجريسي_compressed.pdf';
                    final file = await PDFApi.loadFirebase(url);
                    openPdf(context, file, "الرقية الشرعية من الكتاب والسنة");

                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.white,
                        height: 120,
                        child: Row(
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Image(
                                      image: NetworkImage('https://image.winudf.com/v2/image/Y29tLmFsdWthaC5wZGY3X3NjcmVlbnNob3RzXzBfNmYwNmEyZmM/screen-0.jpg?h=500&fakeurl=1&type=.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Text(
                                      "الرقية الشرعية من الكتاب والسنة",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                    ),
                                    Row(children: [
                                      Spacer(),
                                      Text(
                                        "د.خالد الجريسي",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,

                                        ),
                                      ),
                                      Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            decoration: TextDecoration.lineThrough

                                        ),
                                      )
                                    ],),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: ()async{
                    final url = 'كتاب الفتاوى الذهبية في الرقى الشرعية.pdf';
                    final file = await PDFApi.loadFirebase(url);
                    openPdf(context, file, "الفتاوى الذهبية في الرقى الشرعية");
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.white,
                        height: 120,
                        child: Row(
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Image(
                                      image: NetworkImage('https://cms.ibn-jebreen.com/books/6_1424861439.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Text(
                                      "الفتاوى الذهبية في الرقى الشرعية",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                    ),
                                    Row(children: [
                                      Spacer(),
                                      Text(
                                          "عبد العزيز ابن باز",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,

                                          ),
                                        ),

                                      Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            decoration: TextDecoration.lineThrough

                                        ),
                                      )
                                    ],),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: ()async{
                    final url = 'كتاب لقط المرجان في علاج العين والسحر والجان.pdf';
                    final file = await PDFApi.loadFirebase(url);
                    openPdf(context, file, "لقط المرجان في علاج العين والسحر والجان");
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.white,
                        height: 120,
                        child: Row(
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Image(
                                      image: NetworkImage('http://roqia.khayma.com/morjan-front.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Text(
                                      "لقط المرجان في علاج العين والسحر والجان",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                    ),
                                    Row(children: [
                                      Spacer(),
                                      Text(
                                        "أنس حمد العويد",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,

                                        ),
                                      ),
                                    ],),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                  // Card(
                  //   elevation: 10,
                  //   child: Row(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: ClipRRect(
                  //           borderRadius: BorderRadius.circular(10),
                  //           child: Container(
                  //             child: Image.network('http://roqia.khayma.com/morjan-front.jpg'
                  //               ,fit: BoxFit.cover,
                  //             ),
                  //             width: 120,
                  //             height: 150,
                  //           ),
                  //         ),
                  //       ),
                  //       Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Container(
                  //               width: 220,
                  //               child: Text("لقط المرجان في علاج العين والسحر والجان",
                  //                 maxLines: 3,
                  //                 style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                  //           Text("أنس حمد عبد العزيز العويد",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey[600]),maxLines: 2,),
                  //         ],
                  //       )
                  //     ],
                  //   ),),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("أنظر ايضا",style: TextStyle(fontSize: 18,color: buttonsColor,fontWeight: FontWeight.w900),),
                ],
              ),
              Column(
                children: [
                  defaultTextButton(
                      function: ()async{
                        final url = 'book4.pdf';
                        final file = await PDFApi.loadFirebase(url);
                        openPdf(context, file , "الرُّقية الشرعية المختصرة");

                      },
                      text: "الرُّقية الشرعية المختصرة",color: Colors.blue),
                  defaultTextButton(
                      function: ()async{
                        final url = 'بعض أحكام الرقية الشرعية وأخذ الجعل عليها.pdf';
                        final file = await PDFApi.loadFirebase(url);
                        openPdf(context, file, "بعض أحكام الرقية الشرعية وأخذ الجعل عليها");

                      },
                      text: "بعض أحكام الرقية الشرعية وأخذ الجعل عليها",color: Colors.blue),
                ],
              )
            ],),
          ),
        ) ;
      },
    );
  }
  void openPdf(BuildContext context , dynamic file,String name){
    navigateTo(context, ViewBook(file , name));
  }
}
