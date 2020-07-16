import 'dart:ui';

import 'package:flutter/material.dart';

const albumImage =
    'https://raw.githubusercontent.com/digitaljoni/examples_flutter/master/music_player/images/album.png';
const avatarImage = 'https://randomuser.me/api/portraits/women/10.jpg';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        accentColor: Color(0xFF5a667a),
      ),
      home: MyWidget(),
    ),
  );
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.list),
        title: Text('MUSIC'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              right: 18.0,
            ),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(avatarImage),
                ),
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MusicIcon(Icons.shuffle),
            MusicIcon(Icons.fast_rewind),
            MusicIcon(Icons.pause, isSelected: true),
            MusicIcon(Icons.fast_forward),
            MusicIcon(Icons.repeat),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFF212e3e),
                Color(0xFF101424),
              ]),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100.0,
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(albumImage),
                      ),
                    ),
                    child: BackdropFilter(
                      filter: new ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                      child: new Container(
                        decoration: new BoxDecoration(
                            color: Colors.white.withOpacity(0.0)),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.height / 2.5,
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: Card(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        elevation: 20.0,
                        clipBehavior: Clip.antiAlias,
                        child: Image(
                          image: NetworkImage(albumImage),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 150.0,
              padding: EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 32.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MusicIcon(Icons.airplay),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Believer',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                        ),
                        Text(
                          'Imagine Dragons',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontWeight: FontWeight.normal,
                                color: Colors.white54,
                              ),
                        ),
                      ],
                    ),
                  ),
                  MusicIcon(Icons.volume_up),
                ],
              ),
            ),
            Container(
                child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('01:21'),
                      Text('-05:23'),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 10.0,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFF090e1a),
                      ),
                      bottom: BorderSide(
                        color: Color(0xFF273550),
                      ),
                    ),
                    color: Color(0xFF141f28),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0f9aeb), Colors.white],
                        ),
                      ),
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  ),
                ),
              ],
            )),
            SizedBox(
              height: 64.0,
            ),
          ],
        ),
      ),
    );
  }
}

class MusicIcon extends StatelessWidget {
  const MusicIcon(
    this.iconData, {
    this.isSelected = false,
    Key key,
  }) : super(key: key);

  final IconData iconData;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          gradient: isSelected
              ? RadialGradient(
                  colors: [
                    Colors.white38,
                    Colors.transparent,
                  ],
                )
              : null,
        ),
        padding: EdgeInsets.all(16.0),
        child: Icon(
          iconData,
          color: isSelected ? Colors.white : Theme.of(context).accentColor,
          size: 32.0,
        ),
      ),
    );
  }
}
