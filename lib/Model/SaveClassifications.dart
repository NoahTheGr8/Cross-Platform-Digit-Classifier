import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'utils.dart';
import 'ClassificationDBWorker.dart';
import 'Classification.dart';
import 'dart:async';
import 'package:gallery_saver/gallery_saver.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    required Key key,
    required this.camera,
  }) : super(key: key);
  final CameraDescription camera;
  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late Future<File> imageFile;
  late Image image;
  PictureDBWorker dbHelper = PictureDBWorker();
  late List<Classification> images;
  ImagePicker picker = ImagePicker();
  /*
  pickImageFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Utility.base64String(imgFile.readAsBytesSync());
      Classification picture = Classification(0, imgString, -1);
      dbHelper.save(picture);
      refreshImages();
    });
  }
  */
  refreshImages() {
    dbHelper.getClassification().then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }
  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    images = [];
    dbHelper = PictureDBWorker();
    refreshImages();
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            if (image != null && image.path != null) {
              File photoAsFile = File(image.path);
              GallerySaver.saveImage(image.path).then((path) {});
              String imgString = Utility.base64String(photoAsFile.readAsBytesSync());
              Classification picture = Classification(0, imgString, -1);
              dbHelper.save(picture);
              refreshImages();
              Navigator.pop(context);
            }
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class SaveImages extends StatefulWidget {
  SaveImages() : super();
  final String title = "Pick image to save :)";
  @override
  _SaveImageDemoSQLiteState createState() => _SaveImageDemoSQLiteState();
}

class _SaveImageDemoSQLiteState extends State<SaveImages> {
  late Future<File> imageFile;
  late Image image;
  late PictureDBWorker dbHelper;
  late List<Classification> images;

  @override
  void initState() {
    super.initState();
    images = [];
    dbHelper = PictureDBWorker();
    refreshImages();
  }

  refreshImages() {
    dbHelper.getClassification().then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

    /*
  pickImageFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Utility.base64String(imgFile.readAsBytesSync());
      Classification picture = Classification(0, imgString, -1);
      dbHelper.save(picture);
      refreshImages();
    });
  }
     */


  gridView() {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: images.map((photo) {
            return Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio : .25,
                child: Utility.imageFromBase64String(photo.picture_name),
                secondaryActions : [
                  IconSlideAction(
                    caption : "Delete",
                    color : Colors.red,
                    icon : Icons.delete,
                    onTap : () => dbHelper.deleteClassification(photo),
                  )
                ]);
          }).toList(),
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              //pickImageFromGallery();
              refreshImages();
            },
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: gridView(),
            )
          ],
        ),
      ),

      floatingActionButton : FloatingActionButton(
        child : Icon(Icons.add_a_photo, color : Colors.white),
        onPressed : () async {
          WidgetsFlutterBinding.ensureInitialized();
          // Obtain a list of the available cameras on the device.
          final cameras = await availableCameras();
          // Get a specific camera from the list of available cameras.
          final firstCamera = cameras[1];
          //Navigator.push(context, MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera, key: -1,)));
          refreshImages();
          ;
        },
      ),
    );
    refreshImages();
  }
}