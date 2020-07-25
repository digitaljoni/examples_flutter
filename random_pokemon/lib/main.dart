import 'dart:math';

import 'package:flutter/material.dart';

const pokemonIndex = 150; // includes mew (+1 on Random())

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Pokemon',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: PokeRnd(),
      ),
    );
  }
}

class PokeRnd extends StatefulWidget {
  PokeRnd({Key key}) : super(key: key);

  @override
  _PokeRndState createState() => _PokeRndState();
}

class _PokeRndState extends State<PokeRnd> {
  int pokeId;
  bool isPokeballOpen = false;
  bool isPokemonDisplayed = false;

  final durationPokeball = Duration(
    milliseconds: 300,
  );

  void _showRandomPokemon() {
    if (isPokeballOpen) {
      setState(() {
        isPokeballOpen = false;
        isPokemonDisplayed = false;
      });
      Future.delayed(durationPokeball, () {
        _pickPokemon();
      });
    } else {
      setState(() {
        isPokeballOpen = true;
      });
      Future.delayed(durationPokeball + Duration(milliseconds: 50), () {
        setState(() {
          isPokemonDisplayed = true;
        });
      });
    }
  }

  void _pickPokemon() {
    setState(() {
      pokeId = Random().nextInt(pokemonIndex) + 1;
    });
  }

  @override
  void initState() {
    _pickPokemon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final buttonSize = min(250.0, screenWidth / 2);
    return Stack(
      children: <Widget>[
        Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
              gradient: RadialGradient(
            radius: 1.0,
            colors: [
              Color(0xFF303030),
              Color(0xFF111111),
            ],
          )),
        ),
        Center(
          child: AnimatedContainer(
            duration: durationPokeball + Duration(milliseconds: 100),
            width: isPokemonDisplayed ? screenWidth : 0,
            height: isPokemonDisplayed ? screenWidth : 0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.transparent,
                gradient: RadialGradient(
                  radius: 0.50,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0x00111111),
                  ],
                )),
          ),
        ),
        Center(
          child: AnimatedContainer(
            duration: durationPokeball,
            width: isPokemonDisplayed ? screenWidth * 0.75 : 0,
            child: Image(
              image: NetworkImage(
                  'https://pokeres.bastionbot.org/images/pokemon/$pokeId.png'),
            ),
            curve: Curves.easeInOutQuint,
          ),
        ),
        AnimatedPositioned(
          duration: durationPokeball,
          top: isPokeballOpen ? screenHeight - 50.0 : (screenHeight / 2) + 20,
          child: Stack(
            children: <Widget>[
              Container(
                width: screenWidth,
                height: screenHeight / 2,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.white,
                      width: 30.0,
                    ),
                  ),
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.0,
                    colors: [
                      Color(0xFFe4eaf2),
                      Color(0xFFc0cedb),
                    ],
                  ),
                ),
              ),
              Container(
                width: screenWidth,
                alignment: Alignment.topCenter,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    widthFactor: 1,
                    heightFactor: .5,
                    child: Container(
                      width: buttonSize + 10,
                      height: buttonSize + 10,
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: Alignment.topCenter,
                          radius: 1.0,
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xFF9ca8b8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        AnimatedPositioned(
          duration: durationPokeball,
          top: isPokeballOpen ? -(screenHeight / 2) + 40 : 0.0,
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: screenWidth,
                height: (screenHeight / 2) + 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 40.0,
                    ),
                  ),
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.0,
                    colors: [
                      Color(0xFFe84646),
                      Color(0xFFd20000),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        AnimatedPositioned(
          duration: durationPokeball,
          top: isPokeballOpen
              ? -(buttonSize / 2) + 60
              : (screenHeight / 2) - (buttonSize / 2) + 20,
          left: (screenWidth / 2) - (buttonSize / 2),
          child: _buildButton(buttonSize),
        ),
      ],
    );
  }

  Widget _buildButton(double buttonSize) {
    return GestureDetector(
      onTap: _showRandomPokemon,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.0,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFF9ca8b8),
            ],
          ),
          border: Border.all(
            color: Colors.black,
            width: 20.0,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.0,
              colors: [
                Color(0xFFe4eaf2),
                Color(0xFFc0cedb),
              ],
            ),
          ),
          child: Container(
            width: buttonSize,
            height: buttonSize,
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.0,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFF9ca8b8),
                ],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.0,
                  colors: [
                    Color(0xFFe4eaf2),
                    Color(0xFFc0cedb),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
