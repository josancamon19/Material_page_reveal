import 'package:flutter/material.dart';
import 'package:material_page_reveal/models/page_indicator_model.dart';
import 'package:material_page_reveal/ui/page.dart';

class PagerIndicator extends StatelessWidget {
  final List<Page> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  PagerIndicator(
      {this.pages, this.activeIndex, this.slideDirection, this.slidePercent});

  @override
  Widget build(BuildContext context) {
    List<PageIndicatorModel> indicators = [];
    for (var i = 0; i < pages.length; i++) {
      var percentActive;
      if (i == activeIndex) {
        percentActive = 1.0 - slidePercent;
      } else if (i == activeIndex - 1 &&
          slideDirection == SlideDirection.leftToRight) {
        percentActive = slidePercent;
      } else if (i == activeIndex + 1 &&
          slideDirection == SlideDirection.rightToLeft) {
        percentActive = slidePercent;
      } else {
        percentActive = 0.0;
      }

      bool isHollow = i > activeIndex ||
          (i == activeIndex && slideDirection == SlideDirection.leftToRight);

      final Page page = pages[i];
      indicators.add(PageIndicatorModel(
        iconAssetPath: page.iconAssetIcon,
        color: page.color,
        isHollow: isHollow,
        activePercent: percentActive,
      ));
    }
    final indicatorWidth = 55.0;
    final baseTranslation =((pages.length*indicatorWidth)/2)- (indicatorWidth/2);
    var translation = baseTranslation - (activeIndex*indicatorWidth);
    if(slideDirection ==  SlideDirection.leftToRight){
      translation += indicatorWidth*slidePercent;
    }else if(slideDirection ==  SlideDirection.rightToLeft){
      translation -= indicatorWidth*slidePercent;
    }
    return Column(
      children: <Widget>[
        Expanded(child: Container(),),
        new Transform(
          transform: Matrix4.translationValues(translation,0.0,0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indicators,
          ),
        )
      ],
    );
  }
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}
