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
    this.enableCardSwipe,
  }) : super(key: key);

  final bool fullSize;
  final Widget? Function(Widget front)? buildCardCustom;
  final TinderSwipeController? controller;
  final Widget Function(BuildContext context, T value, int index, bool isFront)
      builder;
  final Widget? Function(CardStatus status, dynamic card)? swipingBadge;
  final bool Function(T card)? enableCardSwipe;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TinderSwipeController>.value(
      value: (controller ?? TinderSwipeController<T>())
        ..setCanSwipe(canSwipe: enableCardSwipe),
      child: SwipeContainer<T>(
        builder: builder,
        swipingBadge: swipingBadge,
        fullSize: fullSize,
        buildCardCustom: buildCardCustom,
        enableCardSwipe: enableCardSwipe,
      ),
    );
  }
}
