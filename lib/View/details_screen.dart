import 'package:digit_classifier/Model/Classification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digit_classifier/Model/Utility.dart';

class DetailScreen extends StatelessWidget {
  final Classification photo;
  DetailScreen(this.photo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Utility.imageFromBase64String(photo.picture_name),
                  Container(
                    height: 15,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Predicted class: " + photo.picture_classification.toString(),
                            style: TextStyle(fontSize: 25)
                        ),
                        Container(
                          height: 40
                        ),
                        Text("Tap on screen to return to main screen.",
                            style: TextStyle(fontSize: 15)
                        )
                      ],
                  )
                ],
              )
            ),
        onTap: () {
          Navigator.pop(context);
        }
        )
    );
  }
}