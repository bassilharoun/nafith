import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nafith/raqi_app/models/surah_model.dart';
import 'package:nafith/raqi_app/modules/quran/onlineQuran.dart';
import 'package:nafith/raqi_app/modules/quran/reading_quran.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';
import 'package:quran/quran.dart' as quran;
import 'package:google_fonts/google_fonts.dart';

class QuranScreen extends StatefulWidget {
  @override
  _QuranScreenState createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> with TickerProviderStateMixin {
  List<Surah> surahList = [];
  int selectedIndex = 0;
  bool isReverse = false;
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    readJson();
    super.initState();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/surah.json');
    final data = await json.decode(response);
    for (var item in data["chapters"]) {
      surahList.add(Surah.fromMap(item));
    }
    debugPrint(surahList.length.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("القُرْآنُ الكَريم" ,style: GoogleFonts.cairo(fontSize: 20),),
        actions: [
          InkWell(
            onTap: (){
              navigateTo(context, OnlineQuranScreen());

            },
            child: Row(
            children: [
              Icon(Icons.menu_book_outlined),
              SizedBox(width: 5,),
              Text("${getLang(context,"oQuran")}",style: TextStyle(color: buttonsColor),),
              SizedBox(width: 5,)
            ],
        ),
          )
        ],
        leading: Transform.rotate(
          angle: isReverse ? pi : 2 * pi,
          child: IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                setState(() {
                  isReverse = !isReverse;
                });
              }),
        ),
      ),
      body: surahList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : chaptersList(isReverse ? surahList.reversed.toList() : surahList),
    );
  }

  Widget chaptersList(List<Surah> chapters) {
    return ListView.separated(
      controller: _controller,
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(
          child: Text(chapters[index].id.toString() ,style: TextStyle(color: Colors.white),),
          backgroundColor: buttonsColor,
        ),
        title: Text(chapters[index].name),
        subtitle: Text(chapters[index].versesCount.toString()),
        trailing: Text(
          chapters[index].arabicName,
          style: GoogleFonts.cairo(
            fontSize: 18,
          ),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                SurahPage(surah: chapters[index]),
          ),
        ),
      ),
      separatorBuilder: (context, index) => Divider(height: 1),
      itemCount: chapters.length,
    );
  }
}