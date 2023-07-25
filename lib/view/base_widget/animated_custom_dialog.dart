import 'package:flutter/material.dart';
import 'dart:math' as math;

void showAnimatedDialog(BuildContext context, Widget dialog, {bool isFlip = false, bool dismissible = true}) {
  showGeneralDialog(
      context: context,
      pageBuilder: (context, animation1, animation2) => dialog,
      barrierDismissible: dismissible,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: Duration(milliseconds: 500),
      transitionBuilder: (context, a1, a2, widget) {
        if (isFlip) {
          return Rotation3DTransition(
            alignment: Alignment.center,
            turns: Tween<double>(begin: math.pi, end: 2.0 * math.pi).animate(
              CurvedAnimation(
                parent: a1,
                curve: Interval(
                  0.0,
                  1.0,
                  curve: Curves.linear,
                ),
              ),
            ),
            child: widget,
          );
        } else{
          return Transform.scale(
            scale: a1.value,
            child: widget,
          );
        }
      });
}

class Rotation3DTransition extends AnimatedWidget {
  final Alignment? alignment;
  final Widget? child;

  const Rotation3DTransition({
    Key? key,
    required Animation<double> turns,
    this.alignment,
    this.child,
  }) : super(key: key, listenable: turns);

  Animation<double> get turns => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0006)
      ..rotateY(turnsValue);
    return Transform(
      transform: transform,
      alignment: FractionalOffset(0.5, 0.5),
      child: child,
    );
  }
}
