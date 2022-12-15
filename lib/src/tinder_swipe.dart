import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'swipe_controller.dart';
import 'swipe_container.dart';

class TinderSwipe<T> extends StatelessWidget {
  const TinderSwipe({
    Key? key,
    this.controller,
    required this.builder,
    this.swipingBadge,
    this.fullSize = false,
    this.buildCardCustom,
  }) : super(key: key);

  final bool fullSize;
  final Widget? Function(Widget front)? buildCardCustom;
  final SwipeController? controller;
  final Widget Function(BuildContext context, T value, int index) builder;
  final Widget? Function(CardStatus status)? swipingBadge;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SwipeController>(
      create: (_) => controller ?? SwipeController(),
      child: SwipeContainer<T>(
        builder: builder,
        swipingBadge: swipingBadge,
        fullSize: fullSize,
        buildCardCustom: buildCardCustom,
      ),
    );
  }
}
