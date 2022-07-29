import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'swipe_controller.dart';
import 'swipe_container.dart';

class TinderSwipe<T> extends StatelessWidget {
  const TinderSwipe({
    Key? key,
    this.controller,
    required this.builder,
    this.callback,
    this.swipingBadge,
  }) : super(key: key);

  final SwipeController? controller;
  final Widget Function(BuildContext context, T value, int index) builder;
  final Function(CardStatus status, int length, T? data)? callback;
  final Widget? Function(CardStatus status)? swipingBadge;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SwipeController>(
      create: (_) => controller ?? SwipeController(),
      child: SwipeContainer<T>(
        builder: builder,
        callback: callback,
        swipingBadge: swipingBadge,
      ),
    );
  }
}
