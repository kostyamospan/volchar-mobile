import 'package:deplom/header.dart';
import 'package:deplom/models/user.dart';
import 'package:flutter/material.dart';
import 'package:deplom/widgets/publication.dart';
import 'package:deplom/query_api.dart';
import 'package:deplom/header.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage(this.username, {Key key}) : super(key: key);

  final String username;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<List<Widget>> loadPublications() async {
    return Future(() async {
      var apiRez = await QueryApi.getUserData(widget.username);
      var publ = List<Widget>.generate(apiRez.publications.length, (i) {
        print(apiRez.publications[i].imagePath);
        return new PublicationCard(apiRez.publications[i]);
      });

      var header = ProfileHeader(apiRez);
      publ.insert(0,header);
      return publ;
      // Future(()=>List<PublicationCard>.generate(10, (i){
      //   return new PublicationCard(new Publication(creator: new User(username:"username"),imageUrl: "https://img4.goodfon.ru/wallpaper/nbig/3/a0/osen-derevia-pririoda.jpg"));
      // }));//rez);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: loadPublications(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(child: CircularProgressIndicator());
                break;
              case ConnectionState.done:
                {
                  if (snapshot.data != null) {
                    return ListView(
                        children: snapshot.data as List<Widget>);
                  } else {
                    return Text("Error");
                  }
                }
            }
          }),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final User data;
  const ProfileHeader(this.data, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
                width: displayWidth(context) * 0.5,
                height: displayWidth(context) * 0.5,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(data.profileImagePathWidthDomain)),
                )),
          ),
          Text(
            data.username,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(3)),
                  width: 150,
                  height: 40,
                  child: Center(
                      child: Text("Subscribe",
                          style: TextStyle(fontSize: 20, color: Colors.white))),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(3)),
                  width: 150,
                  height: 40,
                  child: Center(
                      child: Text("Message",
                          style: TextStyle(fontSize: 20, color: Colors.white))),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Subscribers", style: TextStyle(fontSize: 25)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(data.subsctibersCount.toString(),
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Publications", style: TextStyle(fontSize: 25)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(data.publicationsCount.toString(),
                        style: TextStyle(fontSize: 20)),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              width: displayWidth(context) * 0.9,
              height: 1,
              color: Colors.black)
        ],
      ),
    );
  }
}
