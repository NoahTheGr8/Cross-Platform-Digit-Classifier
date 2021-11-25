import 'package:digit_classifier/View/results_screen.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Digit Classifier';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Color(0xFF355C7D),

        // Define the default font family.
        fontFamily: 'RaleWay',

      ),
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),

      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    ImagePicker picker = ImagePicker();
    File file;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(

            onTap: () async{
              //take photo
              XFile? photo = await picker.pickImage(source: ImageSource.camera);

              //convert the photo to a file object
              file = File(photo!.path);

              //pass the image to get processed
              Navigator.push(context, MaterialPageRoute(builder: (context) => ResultsScreen(file)));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  vertical: 14, horizontal: 16),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Take Photo',
                    style: TextStyle(color: Color(0xFF0F0BDB)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.add_a_photo_outlined, color: Color(0xFF0F0BDB))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),



          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF355C7D), // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: () async{
              //select photo from gallery
              XFile? photo = await picker.pickImage(source: ImageSource.gallery);

              //Convert the image to a File object
              file = File(photo!.path);

              //pass the image to get processed
              Navigator.push(context, MaterialPageRoute(builder: (context) => ResultsScreen(file)));
            },
            child: const Text('Select from Gallery'),
          ),
        ],
      ),
    );
  }
}