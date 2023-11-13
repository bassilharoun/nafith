import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:path/path.dart';

class ViewBook extends StatefulWidget {
  dynamic file ;
  String name ;
  ViewBook(this.file,this.name);

  @override
  State<ViewBook> createState() => _ViewBookState();
}

class _ViewBookState extends State<ViewBook> {
  @override
  Widget build(BuildContext context) {
    RaqiCubit.get(context).emitRate();
    return Scaffold(
      appBar: AppBar(title: Text(widget.name),),
      body: PDFView(
        filePath: widget.file.path,
      )
    );
  }
}
