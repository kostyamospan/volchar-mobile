import 'package:deplom/header.dart';
import 'package:deplom/models/user.dart';
import 'package:deplom/query_api.dart';
import 'package:deplom/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart' as p;
import 'package:image_crop/image_crop.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

class ProfileUpdateRoute extends StatefulWidget {
  ProfileUpdateRoute(this.image, this.username, {Key key}) : super(key: key);

  String username;
  ImageProvider image;

  @override
  _ProfileUpdateRouteState createState() => _ProfileUpdateRouteState();
}

class _ProfileUpdateRouteState extends State<ProfileUpdateRoute> {
  TextEditingController _controller;
  bool _isButtonPressed = false;
  File _image;
  File _cropedImage;
  String _newUsername;

  final cropKey = GlobalKey<CropState>();

  _ProfileUpdateRouteState() {
    _controller = new TextEditingController();
    final text = "username";
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.fromPosition(
        TextPosition(offset: text.length),
      ),
    );
  }

  Future getImage({p.ImageSource param = p.ImageSource.camera}) async {
    var image = await p.ImagePicker.pickImage(source: param);

    setState(() {
      _image = image;
    });
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;

    if (area == null) {
      throw new Exception();
    }

    final sample = await ImageCrop.sampleImage(
      file: _image,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );
    setState(() {
      _cropedImage = file;
    });
    sample.delete();
  }

  Future<User> updateProfile() async {
    return QueryApi.profileUpdate((await StorageManager.isUserExist()).apiToken,
        updatedProfileFile: _cropedImage,
        updatedUsername: widget.username == _newUsername ? null : _newUsername);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Change profile image: ",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  await getImage().then((value) => _cropImage());
                },
                child: Stack(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 5, right: 10),
                        width: displayWidth(context) * 0.65,
                        height: displayWidth(context) * 0.65,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 5),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _cropedImage == null
                                  ? widget.image
                                  : Image.file(_cropedImage).image),
                        )),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Tap to choose image",
                          style: TextStyle(color: Colors.white70, fontSize: 25),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Change username: ",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Center(
              child: Container(
                width: displayWidth(context) * 0.7,
                child: TextField(
                  onChanged: (val) {
                    _newUsername = val;
                  },
                  controller: _controller,
                  maxLines: 1,
                  minLines: 1,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    _isButtonPressed = true;
                  });
                },
                child: FutureBuilder(
                    future: _isButtonPressed ? updateProfile() : null,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return CircularProgressIndicator();
                        case ConnectionState.none:
                          return Text("Done");
                        case ConnectionState.done:
                          _isButtonPressed = false;

                          if (snapshot.data != null) {
  
                            StorageManager.saveUser(snapshot.data as User)
                                .then((value) {
                             
                            });

                            Navigator.pushNamedAndRemoveUntil(
                                context, "/main", (route) => false);
                            return Text("Success!");
                          }
                      }

                      return SizedBox.shrink();
                    }),
              ),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: _cropedImage == null
                          ? widget.image
                          : Image.file(_cropedImage).image)),
            ),
            Offstage(
              offstage: true,
              child: Container(
                margin: EdgeInsets.only(left: 5, right: 10),
                width: displayWidth(context) * 0.65,
                height: displayWidth(context) * 0.65,
                child: Crop(
                  key: cropKey,
                  aspectRatio: 1 / 1,
                  image:
                      _image == null ? widget.image : Image.file(_image).image,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
