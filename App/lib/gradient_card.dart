import "package:flutter/material.dart";

class GradientCard extends StatelessWidget {
  final double elevation;
  final Color begin;
  final Color end;
  final Widget child;

  const GradientCard(
      {Key key,
      this.elevation = 2.0,
      this.begin = Colors.white,
      this.end = Colors.white,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 2.0),
              blurRadius: elevation,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [begin, end],
          ),
        ),
        child: Card(
          elevation: 0.0,
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
