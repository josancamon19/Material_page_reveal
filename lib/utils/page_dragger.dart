import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_page_reveal/ui/pager_indicator.dart';

class PageDragger extends StatefulWidget {
  final bool canDragLeftToRight;
  final bool canDragRightToLeft;
  final StreamController<SlideUpdate> slideUpdateStream;

  PageDragger(
      {this.canDragLeftToRight,
      this.canDragRightToLeft,
      this.slideUpdateStream});

  @override
  _PageDraggerState createState() => _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  static const fullTransitionPx = 300.0;

  Offset dragStart;
  SlideDirection slideDirection;
  double slidePercent = 0.0;

  onDragStart(DragStartDetails dragStartDetails) {
    dragStart = dragStartDetails.globalPosition;
  }

  onDragUpdate(DragUpdateDetails dragUpdateDetails) {
    if (dragStart != null) {
      final newPosition = dragUpdateDetails.globalPosition;
      final dx = dragStart.dx - newPosition.dx;
      if (dx > 0.0 && widget.canDragRightToLeft) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0.0 && widget.canDragLeftToRight) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }
      if (slideDirection != SlideDirection.none) {
        slidePercent = ((dx / fullTransitionPx).abs()).clamp(0.0, 1.0);
      } else {
        slidePercent = 0.0;
      }
      widget.slideUpdateStream.add(
          new SlideUpdate(slideDirection, slidePercent, UpdateType.dragging));
      debugPrint("Dragging $slideDirection at $slidePercent");
    }
  }

  onDragEnd(DragEndDetails dragStartDetails) {
    widget.slideUpdateStream.add(
        new SlideUpdate(SlideDirection.none, 0.0, UpdateType.doneDragging));
    dragStart = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
    );
  }
}

class AnimatedPageDragger {
  static const percentPerMillisecond = 0.005;
  final slideDirection;
  final transitionGoal;

  AnimationController animationController;

  AnimatedPageDragger({
    this.slideDirection,
    this.transitionGoal,
    slidePercent,
    StreamController<SlideUpdate> slideUpdateStream,
    TickerProvider vsync,
  }) {
    final startSlidePercent = slidePercent;
    var endSlidePercent;
    var duration;

    if (transitionGoal == TransitionGoal.open) {
      endSlidePercent = 1.0;
      final slideRemaining = 1.0 - slidePercent;
      duration = Duration(
          milliseconds: (slideRemaining / percentPerMillisecond).round());
    } else {
      endSlidePercent = 0.0;
      duration = Duration(
          milliseconds: (slidePercent / percentPerMillisecond).round());
    }
    animationController = AnimationController(duration: duration, vsync: vsync)
      ..addListener(() {
        slidePercent = lerpDouble(
            startSlidePercent, endSlidePercent, animationController.value);
        slideUpdateStream.add(
            SlideUpdate(slideDirection, slidePercent, UpdateType.animating));
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          slideUpdateStream.add(SlideUpdate(
              slideDirection, endSlidePercent, UpdateType.doneAnimating));
        }
      });
  }
  run(){
    animationController.forward(from: 0.0);
  }
  dispose(){
    animationController.dispose();
  }
}

enum TransitionGoal {
  open,
  close,
}
enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

class SlideUpdate {
  final direction;
  final slidePercent;
  final updateType;

  SlideUpdate(this.direction, this.slidePercent, this.updateType);
}
