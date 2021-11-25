import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';

class ResultsScreen extends StatefulWidget {
  File _image;
  ResultsScreen(this._image);
  @override
  ResultsScreenState createState() => ResultsScreenState(_image);
}

class ResultsScreenState extends State<ResultsScreen> {
  bool _loading = true;
  File _image;
  List<dynamic>? _output;
  final picker = ImagePicker();
  ResultsScreenState(this._image);

  @override
  initState() {
    super.initState();
    loadModel().then((value) {setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  loadModel() async {
    await Tflite.loadModel(model: 'assets/NN/MNIST-CNN.tflite', labels: 'assets/NN/labels.txt');
    classifyImage(_image);
  }

  classifyImage(File image) async {
    _output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
      threshold: 0.7,
      imageMean: 127.5,
      imageStd: 127.5,
      asynch: true
    );
    print("inside classify " + _output.toString());
  }


  @override
  Widget build(BuildContext context) {
    classifyImage(_image);
    print('results_screen - 0 errors?');
    print(_image.toString());
    print(_output);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text(
          'MNIST-trained Digit Classifier',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            letterSpacing: 0.8),
        )
      ),
      body: Container(
        color: Colors.black.withOpacity(0.9),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Color(0xFF2A363B),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: Container(
                      child: Column(
                        children: [
                          Container(
                              height: 250, width: 250,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.file(
                                    _image,
                                    fit: BoxFit.fill,
                                  )
                              )
                          ),
                          Divider(
                            height: 25,
                            thickness: 1,
                          ),
                          (_output != null) ? Text(
                              'The digit is: ${_output?[0]['label']}.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              )
                          )
                              : Text('Image not classified.'),
                          Divider(
                              height: 25,
                              thickness: 1
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF355C7D), // background
                              onPrimary: Colors.white, // foreground
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: const Text('Classify Another Image'),
                          ),
                          const SizedBox(height: 30)
                        ],
                      )
                  )
                )
              )
            ],
          )
        )
      )
    );
  }
}