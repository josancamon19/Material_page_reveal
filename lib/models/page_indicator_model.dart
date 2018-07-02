import 'dart:ui';

import 'package:flutter/material.dart';

class PageIndicatorModel extends StatelessWidget {
  final String iconAssetPath;
  final Color color;
  final bool isHollow;
  final double activePercent;

  PageIndicatorModel(
      {this.iconAssetPath, this.color, this.isHollow, this.activePercent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54.0,height: 64.0,
      child: new Center(
        child: Container(
          height: lerpDouble(20.0, 45.0, activePercent),
          width: lerpDouble(20.0, 45.0, activePercent),
          decoration: BoxDecoration(
              color: isHollow
                  ? Color(0x88ffffff).withAlpha((0x88 * activePercent).round())
                  : Color(0x88ffffff),
              shape: BoxShape.circle,
              border: Border.all(
                  width: 3.0,
                  color: isHollow
                      ? Color(0x88ffffff)
                          .withAlpha((0x88 * (1 - activePercent)).round())
                      : Colors.transparent)),
          child: new Opacity(
            opacity: activePercent,
            child: Image.asset( // ignore: conflicting_dart_import
              iconAssetPath,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
