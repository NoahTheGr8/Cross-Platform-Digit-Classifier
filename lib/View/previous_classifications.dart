import 'package:digit_classifier/Model/Classification.dart';
import 'package:digit_classifier/Model/ClassificationDBWorker.dart';
import 'package:digit_classifier/Model/Utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:io';
import 'details_screen.dart';


///This class is used to pull previous classifications from a local database and present them to the user.
class PreviousClassifications extends StatefulWidget {
  @override
  PreviousClassificationsState createState() => PreviousClassificationsState();
}

class PreviousClassificationsState extends State<PreviousClassifications> {
  Future<File> imageFile;
  Image image;
  ClassificationDBWorker dbHelper = ClassificationDBWorker();
  List<Classification> images;

  @override
  initState() {
    super.initState();
    images = [];
    dbHelper = ClassificationDBWorker();
    refreshImages();
    }

  refreshImages() {
    dbHelper.getClassifications().then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

  gridView() {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: images.map((photo) {
            return GestureDetector(
              child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio : .25,
                    child: Utility.imageFromBase64String(photo.picture_name),
                    secondaryActions : [
                      IconSlideAction(
                          caption : "Delete",
                          color : Colors.red,
                          icon : Icons.delete,
                          onTap : () {
                            dbHelper.deleteClassification(photo);
                            refreshImages();
                          }
                      )
                    ]),
              onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return DetailScreen(photo);}));
                        },
              );}).toList(),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black12,
            title: Text(
              'Previous Classifications',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 0.8),
            )
        ),
        body: gridView()
    );
  }
}