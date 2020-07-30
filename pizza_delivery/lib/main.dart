import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

const _availablePizzaSizes = [
  'S',
  'M',
  'L',
];

const _availableIngredients = [
  'mushroom',
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
      debugShowCheckedModeBanner: false,
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
  final GlobalKey<_MySliderState> _sliderKey = GlobalKey();

  String _pizzaSize = 'S';

  String _activeIngredient;
  double _activeIngredientRatio;
  Map<String, double> _additionalToppings = <String, double>{};

  void _onPizzaDialUpdate(int newIndex) {
    _pizzaSize = _availablePizzaSizes[newIndex];
    setState(() {});
  }

  void _onIngredientsUpdate(int index) {
    _activeIngredient = _availableIngredients[index];
    _activeIngredientRatio = _additionalToppings.containsKey(_activeIngredient)
        ? _additionalToppings[_activeIngredient]
        : 0.0;
    setState(() {});
    _sliderKey?.currentState?.updateCount(_activeIngredientRatio);
  }

  void _onSliderUpdate(double _amount) {
    _activeIngredientRatio = _amount;
    _additionalToppings[_activeIngredient] = _amount;
    setState(() {});
  }

  Map<String, double> _pizzaSizeRatio = {
    'S': 0.60,
    'M': 0.80,
    'L': 1.00,
  };

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < _availableIngredients.length; i++) {
      _additionalToppings[_availableIngredients[i]] = 0.0;
    }

    _onIngredientsUpdate(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Text(
          'Pepperoni Pizza',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: Container(
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: new RawMaterialButton(
            shape: new CircleBorder(),
            elevation: 0.0,
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 40.0,
            ),
            onPressed: () {},
          ),
        ),
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
                child: Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/pizza.png'),
                    buildToppings(_additionalToppings['pepper'] > 0, 'pepper',
                        314.0 * _pizzaSizeRatio[_pizzaSize]),
                    buildToppings(_additionalToppings['olive'] > 0, 'olive',
                        314.0 * _pizzaSizeRatio[_pizzaSize]),
                    buildToppings(_additionalToppings['mushroom'] > 0,
                        'mushroom', 314.0 * _pizzaSizeRatio[_pizzaSize]),
                    buildToppings(_additionalToppings['cucumber'] > 0,
                        'cucumber', 314.0 * _pizzaSizeRatio[_pizzaSize]),
                  ],
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
            onUpdate: _onIngredientsUpdate,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 + 100,
            left: MediaQuery.of(context).size.width / 2 - 5,
            child: Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
          MySlider(
            key: _sliderKey,
            topping: _activeIngredient,
            count: _activeIngredientRatio,
            onUpdate: _onSliderUpdate,
            top: MediaQuery.of(context).size.height / 2 + 100,
          ),
        ],
      ),
    );
  }

  Positioned buildToppings(bool isVisible, String topping, double pizzaSize) {
    return Positioned(
      top: 0.0,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: Duration(
          milliseconds: 400,
        ),
        child: AnimatedContainer(
          width: isVisible ? pizzaSize : 600.0,
          height: isVisible ? pizzaSize : 600.0,
          duration: Duration(
            milliseconds: 400,
          ),
          child: Image.asset(
            'assets/images/pizza_$topping.png',
            fit: BoxFit.fill,
          ),
        ),
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

  Widget dialItemBuilder(String item, String selectedItem) {
    print('dial item');
    return Center(
      child: Text(
        item,
        style: TextStyle(
          color: selectedItem == item ? Colors.red : Colors.black87,
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

  Widget dialItemBuilder(String item, String selectedItem) {
    return Center(
      child: Container(
        width: 50.0,
        height: 50.0,
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
  String _selectedItem;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    angleDelta = angleDelta + (details.delta.dx / 600);
    setState(() {});
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _snapToAngle();
  }

  void _snapToAngle() {
    final angleInDegrees = _radiansToDegrees(angleDelta);
    final newAngleDelta =
        _dialItemDegree * (angleInDegrees / _dialItemDegree).round().toInt();
    int newIndex =
        getIndexFromDegrees(newAngleDelta, widget.dialItemList.length);
    angleDelta = _degreesToRadians(_dialItemDegree * -newIndex);
    if (widget.onUpdate != null) {
      widget.onUpdate(newIndex);
    }
    _selectedItem = widget.dialItemList[newIndex];
    setState(() {});
  }

  int getIndexFromDegrees(double angle, int itemCount) {
    return ((itemCount - (angle / _dialItemDegree)) % itemCount).toInt();
  }

  @override
  void initState() {
    super.initState();
    _buildDialMap();
    _selectedItem = widget.dialItemList[0];
  }

  Map<double, String> dialAngleItem = <double, String>{};

  void _buildDialMap() {
    for (var i = 0; i < widget.dialItemList.length; i++) {
      final dialItem = widget.dialItemList[i];

      dialAngleItem[i * _dialItemDegree] = dialItem;
      dialAngleItem[(widget.dialItemList.length + i) * _dialItemDegree] =
          dialItem;
    }

    // add items before first dial
    var index = 0;
    for (var i = widget.dialItemList.length - 1; i >= 0; i--) {
      index++;
      final dialItem = widget.dialItemList[i];
      dialAngleItem[-(index * _dialItemDegree)] = dialItem;
    }
  }

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
            child: Stack(
              alignment: Alignment.center,
              children: dialAngleItem.entries
                  .map<Widget>(
                    (e) => MyDialItem(
                      angle: e.key,
                      radius: _dialRadius - _edgeDistance,
                      child: widget.myBuilder(e.value, _selectedItem),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class MySlider extends StatefulWidget {
  MySlider({
    Key key,
    @required this.onUpdate,
    @required this.top,
    @required this.topping,
    @required this.count,
  }) : super(key: key);

  final String topping;
  final double count;

  final Function onUpdate;
  final double top;

  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  _MySliderState();

  double _amount = 0.0;
  double angleDelta = 0.0;

  final _startDegree = -32.0;
  final _endDegree = 32.0;

  Path _sliderPath;

  @override
  void initState() {
    super.initState();

    _sliderPath = drawPath();

    angleDelta =
        (_amount * _degreesToRadians(_startDegree.abs() + _endDegree.abs())) +
            _degreesToRadians(_startDegree);
    setState(() {});
  }

  void updateCount(double count) {
    _amount = count;
    angleDelta =
        (_amount * _degreesToRadians(_startDegree.abs() + _endDegree.abs())) +
            _degreesToRadians(_startDegree);
    setState(() {});
  }

  final _dialRadius = 300.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _amount = _amount + (details.delta.dx / 300);
    print(details.delta.dx);

    if (_amount <= 0.0) {
      _amount = 0.0;
    }

    if (_amount >= 1.0) {
      _amount = 1.0;
    }
    angleDelta =
        (_amount * _degreesToRadians(_startDegree.abs() + _endDegree.abs())) +
            _degreesToRadians(_startDegree);
    setState(() {});
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (widget.onUpdate != null) {
      widget.onUpdate(_amount);
    }

    setState(() {});
  }

  Path drawPath() {
    Size size = Size(280, 200);
    Path path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
      size.width / 2,
      0,
      size.width,
      size.height / 2,
    );
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      left: MediaQuery.of(context).size.width / 2 - (_dialRadius),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            child: Container(
              alignment: Alignment.topLeft,
              child: CustomPaint(
                //
                size: Size(280.0, 150),
                painter: PathPainter(_sliderPath),
              ),
            ),
          ),
          Positioned(
            child: ClipPath(
              clipper: MyCustomClipper(ratio: _amount),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                alignment: Alignment.topLeft,
                child: CustomPaint(
                  //
                  size: Size(280.0, 150),
                  painter: PathPainter(_sliderPath, color: Colors.red),
                ),
              ),
            ),
          ),
          GestureDetector(
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
                  color: Colors.transparent,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    MyRadialPosition(
                      radius: 245.0,
                      angle: 0.0 - 90,
                      child: MyRotation(
                        angle: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            width: 44.0,
                            height: 44.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black87,
                            ),
                            child:
                                Image.asset('assets/images/pizza_button.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  PathPainter(this.path, {this.color: Colors.black26});
  final Path path;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(this.path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class MyCustomClipper extends CustomClipper<Path> {
  MyCustomClipper({this.ratio: 0.5});
  final double ratio;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, 0.0);
    path.lineTo(size.width * ratio, 0.0);
    path.lineTo(size.width * ratio, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
