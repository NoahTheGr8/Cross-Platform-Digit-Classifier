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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF355C7D), // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: () async{
              //take photo
              XFile? photo = await picker.pickImage(source: ImageSource.camera);

              //convert the photo to a file object
              file = File(photo!.path);

              //pass the image to get processed
              //Navigator.push(context, MaterialPageRoute(builder: (context) => ResultsScreen(photo)));
            },
            child: const Text('Take Picture'),
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
              //Navigator.push(context, MaterialPageRoute(builder: (context) => ResultsScreen(photo)));
            },
            child: const Text('Select from Gallery'),
          ),
        ],
      ),
    );
  }
}