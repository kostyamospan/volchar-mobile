import 'dart:io';
import 'package:deplom/header.dart';
import 'package:deplom/query_api.dart';
import 'package:deplom/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as p;
import 'package:image_crop/image_crop.dart';

class UploadRoute extends StatefulWidget {
  UploadRoute({Key key}) : super(key: key);
  File _image;
  File _cropedImage;

  @override
  _UploadRouteState createState() => _UploadRouteState();
}

class _UploadRouteState extends State<UploadRoute> {
  final cropKey = GlobalKey<CropState>();
  final textController = TextEditingController();
  bool _isPressed = false;

  Future getImage({p.ImageSource param = p.ImageSource.camera}) async {
    var image = await p.ImagePicker.pickImage(source: param);
    //image = await FlutterExifRotation.rotateImage(path: image.path);

    setState(() {
      widget._image = image;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.getImage();
    });
  }

  Future<bool> uploadImage() async {
    return QueryApi.upload(widget._cropedImage,
        (await StorageManager.isUserExist()).apiToken, textController.text);
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;

    if (area == null) {
      return Future.error(new Exception());
    }

    final sample = await ImageCrop.sampleImage(
      file: widget._image,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );
    setState(() {
      widget._cropedImage = file;
    });
    sample.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GestureDetector(
                child: Container(
              width: displayWidth(context),
              height: displayWidth(context),
              child: widget._image == null
                  ? Center(child: Text("Null"))
                  : Crop(
                      alwaysShowGrid: true,
                      key: cropKey,
                      aspectRatio: 1 / 1,
                      image: Image.file(widget._image).image),
            )),
            Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                width: displayWidth(context) * 0.85,
                child: TextField(
                  controller: textController,
                  maxLines: 3,
                  minLines: 1,
                  maxLength: 100,
                  decoration: InputDecoration(
                      helperText: "Description", border: OutlineInputBorder()),
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                )),
            RaisedButton(
              padding: EdgeInsets.all(15),
              onPressed: () async {
                if (widget._image != null && !_isPressed) {
                  _cropImage();
                  _isPressed = true;
                }
              },
              child: FutureBuilder(
                  future: widget._cropedImage != null && _isPressed
                      ? uploadImage()
                      : null,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text(
                          "Publish",
                          style: TextStyle(fontSize: 20),
                        );
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return CircularProgressIndicator();
                      case ConnectionState.done:
                        {
                          if (snapshot.hasError)
                            return Text("Error, try again");

                          if (snapshot.data != null) {
                            if (snapshot.data as bool) {
                              Navigator.pop(context);
                              return Text("Success");
                            } else {
                              return Text("Error");
                            }
                          }
                        }
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
