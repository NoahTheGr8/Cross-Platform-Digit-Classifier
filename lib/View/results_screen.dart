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
  List<dynamic> _output; //List<dynamic> _output;
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
      threshold: 0,
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
                          (_output != null && _output.length != 0) ? Text(// _output!.length
                              'The digit is: ${_output[0]['label']}.',//_output?[0]['label']
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              )
                          )
                              : Text('Image not classified.'),

                          //---------------------------------------

                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);
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
                              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Classify Another Image',
                                    style: TextStyle(color: Color(0xFF355C7D)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.add_photo_alternate_outlined, color: Color(0xFF355C7D))
                                ],
                              ),
                            ),
                          ),

                          Divider(
                              height: 25,
                              thickness: 0
                          ),


                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              final snackBar = SnackBar(
                                content: const Text('Classification Stored Successfully.'),
                                duration: Duration(seconds: 2),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Store Classification',
                                    style: TextStyle(color: Color(0xFF355C7D)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.download , color: Color(0xFF355C7D))
                                ],
                              ),
                            ),
                          ),

                          //--------------------------------------------

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