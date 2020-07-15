import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: MyWidget(),
    ),
  );
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  ScrollController _controller;

  var top = 0.0;

  _scrollListener() {
    setState(() {
      top = -_controller.offset / 3;
    });
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: top,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height + 100.0,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage(
                    'https://raw.githubusercontent.com/digitaljoni/examples_flutter/master/seychelles/images/background.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0x19191919),
          ),
          SingleChildScrollView(
            controller: _controller,
            child: Content(),
          )
        ],
      ),
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          right: -150.0,
          top: -100.0,
          child: Image(
            image: NetworkImage(
              'https://raw.githubusercontent.com/digitaljoni/examples_flutter/master/seychelles/images/map.png',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: (MediaQuery.of(context).size.width > 480.0) ? 100.0 : 300.0,
            left: 18.0,
            right: 54.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  'Seychelles',
                  style: Theme.of(context).textTheme.headline2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 50.0,
                      ),
                ),
              ),
              SizedBox(height: 18.0),
              Container(
                width: (MediaQuery.of(context).size.width > 480.0)
                    ? MediaQuery.of(context).size.width / 2
                    : double.infinity,
                child: Text(
                  'The Seychelles is an archipelago of 115 islands in the Indian Ocean, off East Africa. It’s home to numerous beaches, coral reefs and nature reserves, as well as rare animals such as giant Aldabra tortoises. Mahé, a hub for visiting the other islands, is home to capital Victoria. ',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        height: 1.5,
                      ),
                ),
              ),
              SizedBox(height: 18.0),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text('See all activities'),
                    color: Colors.red,
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text('More Info'),
                  ),
                ],
              ),
              SizedBox(height: 18.0),
              InfoCards(),
            ],
          ),
        ),
      ],
    );
  }
}

class InfoCards extends StatelessWidget {
  const InfoCards({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgets = <Widget>[
      InfoCardWidget(),
      InfoCardWidget(),
      InfoCardWidget(),
    ];

    if (MediaQuery.of(context).size.width > 480.0) {
      return Row(
        children: _widgets,
      );
    }

    return Column(
      children: _widgets,
    );
  }
}

class InfoCardWidget extends StatelessWidget {
  const InfoCardWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width > 480.0)
          ? MediaQuery.of(context).size.width / 3.5
          : 350.0,
      child: Card(
        color: Colors.black38,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              18.0,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Tours',
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                  'View schedule for upcoming tours and book yours to see all the amazing things Seychelles has to offer!'),
            ],
          ),
        ),
      ),
    );
  }
}
