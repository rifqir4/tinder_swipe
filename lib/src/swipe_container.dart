import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_swipe/src/swipe_card.dart';
import 'package:tinder_swipe/src/swipe_child.dart';
import 'package:tinder_swipe/src/swipe_controller.dart';

class SwipeContainer<T> extends StatefulWidget {
  const SwipeContainer({
    Key? key,
    required this.builder,
    this.callback,
    this.swipingBadge,
  }) : super(key: key);

  final Widget Function(BuildContext context, T value, int index) builder;
  final Function(CardStatus status, int length, T? data)? callback;
  final Widget? Function(CardStatus status)? swipingBadge;

  @override
  State<SwipeContainer<T>> createState() => _SwipeContainerState<T>();
}

class _SwipeContainerState<T> extends State<SwipeContainer<T>> {
  @override
  void initState() {
    super.initState();
    if (widget.callback != null) {
      context.read<SwipeController>().initCallback(
        (CardStatus status, int length, dynamic data) {
          widget.callback!(status, length, data);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Selector<SwipeController, SwipeChild?>(
          selector: (_, provider) => provider.dataSecondLast,
          builder: (_, value, __) {
            if (value != null) {
              return SwipeCard(
                key: Key("cards-${value.index}"),
                isFront: false,
                child: widget.builder(
                  context,
                  value.data,
                  value.index,
                ),
                text: "cards-${value.index}",
                swipingBadge: widget.swipingBadge,
              );
            }
            return Container();
          },
        ),
        Selector<SwipeController, SwipeChild?>(
          selector: (_, provider) => provider.dataLast,
          builder: (_, value, __) {
            if (value != null) {
              return SwipeCard(
                key: Key("cards-${value.index}"),
                isFront: true,
                child: widget.builder(
                  context,
                  value.data,
                  value.index,
                ),
                text: "cards-${value.index}",
                swipingBadge: widget.swipingBadge,
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}
