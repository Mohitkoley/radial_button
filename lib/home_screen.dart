import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:vector_math/vector_math.dart" show radians;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scale;
  late Animation<double> translation;
  late Animation<double> rotation;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    scale = Tween<double>(begin: 1.5, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    translation = Tween<double>(begin: 0.0, end: 100.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.elasticOut));
    rotation = Tween<double>(begin: 0, end: 360).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(0.0, 0.8, curve: Curves.easeInOut),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Rotating buttons")),
        body: SizedBox.expand(
          child: RadialAnimation(
            controller: animationController,
            scale: scale,
            translation: translation,
            rotation: rotation,
          ),
        ));
  }
}

class RadialAnimation extends StatelessWidget {
  RadialAnimation(
      {super.key,
      required this.controller,
      required this.scale,
      required this.translation,
      required this.rotation});
  AnimationController controller;
  Animation<double> scale;
  Animation<double> translation;
  Animation<double> rotation;

  _open() {
    controller.forward(from: 0);
  }

  _close() {
    controller.reverse(from: 1);
  }

  _buildButton(double angle, {Color color = Colors.orange, IconData? icon}) {
    final double rad = radians(angle);
    return Transform(
      transform: Matrix4.identity()
        ..translate(
            (translation.value) * cos(rad), (translation.value) * sin(rad)),
      child: FloatingActionButton(
        onPressed: _close,
        child: Icon(icon),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: radians(rotation.value),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildButton(0,
                    color: Colors.red, icon: FontAwesomeIcons.thumbtack),
                _buildButton(45,
                    color: Colors.green, icon: FontAwesomeIcons.sprayCan),
                _buildButton(90,
                    color: Colors.orange, icon: FontAwesomeIcons.fire),
                _buildButton(135,
                    color: Colors.blue, icon: FontAwesomeIcons.kiwiBird),
                _buildButton(180,
                    color: Colors.black, icon: FontAwesomeIcons.cat),
                _buildButton(225,
                    color: Colors.indigo, icon: FontAwesomeIcons.paw),
                _buildButton(270,
                    color: Colors.pink, icon: FontAwesomeIcons.bong),
                _buildButton(315,
                    color: Colors.yellow, icon: FontAwesomeIcons.bolt),
                Transform.scale(
                  scale: scale.value - 1,
                  child: FloatingActionButton(
                    onPressed: _close,
                    child: Icon(FontAwesomeIcons.circleXmark),
                    backgroundColor: Colors.red,
                  ),
                ),
                Transform.scale(
                  scale: scale.value,
                  child: FloatingActionButton(
                    onPressed: _open,
                    backgroundColor: Colors.blue,
                    child: Icon(FontAwesomeIcons.solidCircleDot),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
