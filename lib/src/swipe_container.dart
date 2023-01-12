import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_swipe/src/swipe_card.dart';
import 'package:tinder_swipe/src/swipe_child.dart';
import 'package:tinder_swipe/src/swipe_controller.dart';

class SwipeContainer<T> extends StatefulWidget {
  const SwipeContainer({
    Key? key,
    required this.builder,
    this.swipingBadge,
    this.fullSize = false,
    this.buildCardCustom,
    this.enableCardSwipe,
  }) : super(key: key);

  final bool fullSize;
  final Widget? Function(Widget front)? buildCardCustom;
  final Widget Function(BuildContext context, T value, int index) builder;
  final Widget? Function(CardStatus status, dynamic card)? swipingBadge;
  final bool Function(T card)? enableCardSwipe;

  @override
  State<SwipeContainer<T>> createState() => _SwipeContainerState<T>();
}

class _SwipeContainerState<T> extends State<SwipeContainer<T>> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Selector<TinderSwipeController, SwipeChild?>(
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
                fullSize: widget.fullSize,
                buildCardCustom: widget.buildCardCustom,
                // notFirst: true,
              );
            }
            return Container();
          },
        ),
        Selector<TinderSwipeController, SwipeChild?>(
          selector: (_, provider) => provider.dataLast,
          builder: (_, value, __) {
            if (value != null) {
              return SwipeCard(
                key: Key("cards-${value.index}"),
                isFront: true,
                // isFront: widget.canSwipe?.call(value.data) ?? true,
                child: widget.builder(
                  context,
                  value.data,
                  value.index,
                ),
                text: "cards-${value.index}",
                swipingBadge: widget.swipingBadge,
                fullSize: widget.fullSize,
                buildCardCustom: widget.buildCardCustom,
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}
