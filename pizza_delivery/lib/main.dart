import 'dart:math';

import 'package:flutter/material.dart';

const _availablePizzaSizes = [
  'S',
  'M',
  'L',
];

const _availableIngredients = [
  'mushroom',
  'leaf',
  'pepper',
  'olive',
  'cucumber',
];
double _radiansToDegrees(double angle) {
  return angle * 180 / pi;
}

double _degreesToRadians(double angle) {
  return angle * pi / 180;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Order',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PizzaOrderPage(),
    );
  }
}

class PizzaOrderPage extends StatefulWidget {
  PizzaOrderPage({
    Key key,
  }) : super(key: key);

  @override
  _PizzaOrderPageState createState() => _PizzaOrderPageState();
}

class _PizzaOrderPageState extends State<PizzaOrderPage> {
  String _pizzaSize = 'S';
  // int _selectedIndex = 0;

  void _onPizzaDialUpdate(int newIndex) {
    _selectedIndex = newIndex;
    _pizzaSize = _availablePizzaSizes[newIndex];
    setState(() {});
  }

  Map<String, double> _pizzaSizeRatio = {
    'S': 0.60,
    'M': 0.80,
    'L': 1.00,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pepperoni Pizza'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: Text('$_pizzaSize'),
            color: Colors.white,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.5,
            child: Center(
              // top: MediaQuery.of(context).size.height / 2,

              child: AnimatedContainer(
                alignment: Alignment.center,
                duration: Duration(
                  milliseconds: 300,
                ),
                width: 314.0 * _pizzaSizeRatio[_pizzaSize],
                height: 314.0 * _pizzaSizeRatio[_pizzaSize],
                child: Image.asset(
                  'assets/images/pizza.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          PizzaDial(
            onUpdate: _onPizzaDialUpdate,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 80,
            child: Container(
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width,
                child: Image.asset('assets/images/border.png')),
          ),
          IngredientsDial(
            onUpdate: (_) {},
          )
        ],
      ),
    );
  }
}

class MyDialItem extends StatelessWidget {
  final double radius;
  final double angle;
  final Widget child;
  MyDialItem({this.radius, this.angle, this.child});

  @override
  Widget build(BuildContext context) {
    return MyRadialPosition(
      radius: radius,
      angle: angle - 90,
      child: MyRotation(
        angle: angle,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: child,
        ),
      ),
    );
  }
}

class MyRadialPosition extends StatelessWidget {
  final double radius;
  final double angle;
  final Widget child;
  MyRadialPosition({this.radius, this.angle, this.child});

  @override
  Widget build(BuildContext context) {
    final angleinRadians = _degreesToRadians(angle);
    final x = radius * cos(angleinRadians);
    final y = radius * sin(angleinRadians);
    return new Transform(
      transform: Matrix4.translationValues(x, y, 0.0),
      child: child,
    );
  }
}

class MyRotation extends StatelessWidget {
  MyRotation({this.angle, this.child});

  final double angle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final angleinRadians = _degreesToRadians(angle);

    return Transform(
      transform: Matrix4.rotationZ(angleinRadians),
      alignment: FractionalOffset.center,
      child: child,
    );
  }
}

class PizzaDial extends StatelessWidget {
  PizzaDial({
    Key key,
    @required this.onUpdate,
  }) : super(
          key: key,
        );

  final Function onUpdate;

  Widget dialItemBuilder(String item) {
    return Center(
      child: Text(
        item,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 32.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dial(
      onUpdate: onUpdate,
      dialItemList: _availablePizzaSizes,
      myBuilder: dialItemBuilder,
      top: MediaQuery.of(context).size.height / 2 - 80,
    );
  }
}

class IngredientsDial extends StatelessWidget {
  IngredientsDial({
    Key key,
    @required this.onUpdate,
  }) : super(
          key: key,
        );

  final Function onUpdate;

  Widget dialItemBuilder(String item) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(
          10.0,
        ),
        margin: EdgeInsets.all(
          10.0,
        ),
        child: Image.asset(
          'assets/images/$item.png',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dial(
      onUpdate: onUpdate,
      dialItemList: _availableIngredients,
      myBuilder: dialItemBuilder,
      top: MediaQuery.of(context).size.height / 2,
      radius: 500.0 - 40.0,
      centerToEdgeDistance: 50.0,
    );
  }
}

class Dial extends StatefulWidget {
  Dial(
      {Key key,
      @required this.onUpdate,
      this.dialItemList,
      this.myBuilder,
      this.top,
      this.radius: 500.0,
      this.centerToEdgeDistance: 32.0})
      : super(key: key);

  final Function onUpdate;
  final List<String> dialItemList;
  final Function myBuilder;
  final double top;
  final double radius;
  final double centerToEdgeDistance;

  @override
  _DialState createState() => _DialState(radius, centerToEdgeDistance);
}

class _DialState extends State<Dial> {
  _DialState(this._dialRadius, this._edgeDistance);

  final double _dialRadius;
  final double _edgeDistance;

  final _dialItemDegree = 16.0;

  double angleDelta = 0.0;
  String strDialAngle = '';

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    angleDelta = angleDelta + (details.delta.dx / 600);

    strDialAngle = 'Horizontal Drag : ${angleDelta * 180 / pi}';

    setState(() {});
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final angleInDegrees = _radiansToDegrees(angleDelta);

    // final newAngleDelta = (angleInDegrees / 20).round() * 20.0;

    final newAngleDelta =
        _dialItemDegree * (angleInDegrees / _dialItemDegree).round().toInt();
    // angleDelta = _degreesToRadians(newAngleDelta);

    strDialAngle = ' Rounded: $newAngleDelta  - $angleInDegrees - $angleDelta';

    int newIndex =
        getIndexFromDegrees(newAngleDelta, widget.dialItemList.length);

    angleDelta = _degreesToRadians(_dialItemDegree * -newIndex);

    if (widget.onUpdate != null) {
      widget.onUpdate(newIndex);
    }
    setState(() {});
  }

  int getIndexFromDegrees(double angle, int itemCount) {
    return ((itemCount - (angle / _dialItemDegree)) % itemCount).toInt();
  }

  @override
  void initState() {
    super.initState();

    _buildDialWidgets();
  }

  void _buildDialWidgets() {
    for (var i = 0; i < widget.dialItemList.length; i++) {
      final dialItem = widget.dialItemList[i];
      _dialWidgets.add(
        MyDialItem(
          angle: i * _dialItemDegree,
          radius: _dialRadius - _edgeDistance,
          child: widget.myBuilder(dialItem),
        ),
      );
      // add items after last item
      _dialWidgets.add(
        MyDialItem(
          angle: (widget.dialItemList.length + i) * _dialItemDegree,
          radius: _dialRadius - _edgeDistance,
          child: widget.myBuilder(dialItem),
        ),
      );
    }

    // add items before first dial
    var index = 0;
    for (var i = widget.dialItemList.length - 1; i >= 0; i--) {
      index++;
      final dialItem = widget.dialItemList[i];
      _dialWidgets.add(
        MyDialItem(
          angle: -(index * _dialItemDegree),
          radius: _dialRadius - _edgeDistance,
          child: widget.myBuilder(dialItem),
        ),
      );
    }
  }

  List<Widget> _dialWidgets = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      left: MediaQuery.of(context).size.width / 2 - (_dialRadius),
      child: GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: Transform(
          transform: Matrix4.rotationZ(angleDelta),
          alignment: FractionalOffset.center,
          child: Container(
            width: _dialRadius * 2,
            height: _dialRadius * 2,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20.0,
                  )
                ]),
            child: Stack(alignment: Alignment.center, children: _dialWidgets),
          ),
        ),
      ),
    );
  }
}

// class PizzaDial extends StatefulWidget {
//   PizzaDial({
//     Key key,
//     @required this.onUpdate,
//     this.dialItemList,
//   }) : super(key: key);

//   final Function onUpdate;
//   final List<String> dialItemList;

//   @override
//   _PizzaDialState createState() => _PizzaDialState();
// }

// class _PizzaDialState extends State<PizzaDial> {
//   final _pizzaCircleRadius = 500.0;
//   final _dialItemDegree = 16.0;

//   double angleDelta = 0.0;
//   String strDialAngle = '';

//   void _onHorizontalDragUpdate(DragUpdateDetails details) {
//     angleDelta = angleDelta + (details.delta.dx / 600);

//     strDialAngle = 'Horizontal Drag : ${angleDelta * 180 / pi}';

//     if (widget.onUpdate != null) {
//       widget.onUpdate(strDialAngle);
//     }
//     setState(() {});
//   }

//   void _onHorizontalDragEnd(DragEndDetails details) {
//     final angleInDegrees = _radiansToDegrees(angleDelta);

//     // final newAngleDelta = (angleInDegrees / 20).round() * 20.0;

//     final newAngleDelta =
//         _dialItemDegree * (angleInDegrees / _dialItemDegree).round().toInt();
//     // angleDelta = _degreesToRadians(newAngleDelta);

//     strDialAngle = ' Rounded: $newAngleDelta  - $angleInDegrees - $angleDelta';

//     int newIndex =
//         getIndexFromDegrees(newAngleDelta, widget.dialItemList.length);

//     angleDelta = _degreesToRadians(_dialItemDegree * -newIndex);

//     if (widget.onUpdate != null) {
//       widget.onUpdate(_availablePizzaSizes[newIndex]);
//     }
//     setState(() {});
//   }

//   int getIndexFromDegrees(double angle, int itemCount) {
//     return ((itemCount - (angle / _dialItemDegree)) % itemCount).toInt();
//   }

//   @override
//   void initState() {
//     super.initState();

//     _buildDialWidgets();
//   }

//   void _buildDialWidgets() {
//     for (var i = 0; i < widget.dialItemList.length; i++) {
//       final dialItem = widget.dialItemList[i];
//       _dialWidgets.add(
//         MyDialItem(
//           angle: i * _dialItemDegree,
//           radius: _pizzaCircleRadius - 32,
//           child: Center(
//             child: Text(
//               dialItem,
//               style: TextStyle(
//                 fontSize: 32.0,
//               ),
//             ),
//           ),
//         ),
//       );
//       // add items after last item
//       _dialWidgets.add(
//         MyDialItem(
//           angle: (widget.dialItemList.length + i) * _dialItemDegree,
//           radius: _pizzaCircleRadius - 32,
//           child: Center(
//             child: Text(
//               dialItem,
//               style: TextStyle(
//                 fontSize: 32.0,
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     // add items before first dial
//     var index = 0;
//     for (var i = widget.dialItemList.length - 1; i >= 0; i--) {
//       index++;
//       final dialItem = widget.dialItemList[i];
//       _dialWidgets.add(
//         MyDialItem(
//           angle: -(index * _dialItemDegree),
//           radius: _pizzaCircleRadius - 32,
//           child: Center(
//             child: Text(
//               dialItem,
//               style: TextStyle(
//                 fontSize: 32.0,
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   List<Widget> _dialWidgets = <Widget>[];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Positioned(
//         top: MediaQuery.of(context).size.height / 2,
//         left: MediaQuery.of(context).size.width / 2 - (_pizzaCircleRadius),
//         child: GestureDetector(
//           onHorizontalDragUpdate: _onHorizontalDragUpdate,
//           onHorizontalDragEnd: _onHorizontalDragEnd,
//           child: Transform(
//             transform: Matrix4.rotationZ(angleDelta),
//             alignment: FractionalOffset.center,
//             child: Container(
//               width: _pizzaCircleRadius * 2,
//               height: _pizzaCircleRadius * 2,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white,
//               ),
//               child: Stack(alignment: Alignment.center, children: _dialWidgets),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
