import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nafith/raqi_app/models/surah_model.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:quran/quran.dart' as quran;

class SurahPage extends StatelessWidget {
  final Surah surah;
  SurahPage({required this.surah});
  @override
  Widget build(BuildContext context) {
    int count = surah.versesCount;
    int index = surah.id;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          minimum: EdgeInsets.all(15),
          child: ListView(children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: header(),
            ),
            SizedBox(
              height: 5,
            ),
            RichText(
              textAlign: count <= 20 ? TextAlign.center : TextAlign.justify,
              text: TextSpan(
                children: [
                  for (var i = 1; i <= count; i++) ...{
                    TextSpan(
                      text: ' ' +
                          quran.getVerse(index, i, verseEndSymbol: false) +
                          ' ',
                      style: TextStyle(
                        fontFamily: 'Kitab',
                        fontSize: 25,
                        color: Colors.black87,
                      ),
                    ),
                    WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: CircleAvatar(
                          backgroundColor: textColor,
                          child: Text(
                            '$i',
                            textAlign: TextAlign.center,
                            textScaleFactor: i.toString().length <= 2 ? 1 : .8,
                            style: TextStyle(color: Colors.white),
                          ),
                          radius: 14,
                        ))
                  }
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget header() {
    return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              surah.arabicName,
              style: TextStyle(
                fontFamily: 'Aldhabi',
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' ' + quran.basmala + ' ',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'NotoNastaliqUrdu',
                fontSize: 24,
              ),
            ),
          ],
        ));
  }
}
