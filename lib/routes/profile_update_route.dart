import 'package:deplom/header.dart';
import 'package:deplom/models/user.dart';
import 'package:deplom/query_api.dart';
import 'package:deplom/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart' as p;
import 'package:image_crop/image_crop.dart';

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
  User _user;

  final cropKey = GlobalKey<CropState>();

  _ProfileUpdateRouteState() {
    _controller = new TextEditingController();
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final text = widget.username;
      _controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.fromPosition(
          TextPosition(offset: text.length),
        ),
      );
    });
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
    if (_image == null) return;

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

  Future saveUser(User _user) async {
    await StorageManager.saveUser(_user);
    Navigator.pop(context);
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
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Chose image from: "),
                            actions: <Widget>[
                              RaisedButton(
                                child: Text("Gallery"),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  getImage(param: p.ImageSource.gallery).then(
                                      (value) =>
                                          value != null ? _cropImage() : null);
                                  // .then((value) =>
                                  //     );
                                },
                              ),
                              RaisedButton(
                                child: Text("Camera"),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  getImage().then((value) => _cropImage()).then(
                                      (value) => Navigator.of(context).pop());
                                },
                              )
                            ],
                          ));
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
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() async {
                                _user = snapshot.data;
                                await saveUser(_user);
                              });
                            });

                            return Text("Success!");
                          }
                      }

                      return SizedBox.shrink();
                    }),
              ),
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
