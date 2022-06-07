import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_swipe/src/swipe_card.dart';
import 'package:tinder_swipe/src/swipe_child.dart';
import 'package:tinder_swipe/src/swipe_controller.dart';

class SwipeContainer<T> extends StatefulWidget {
  const SwipeContainer({
    Key? key,
    required this.builder,
    required this.data,
    this.callback,
  }) : super(key: key);

  final Widget Function(BuildContext context, T value, int index) builder;
  final List<T> data;
  final Function(CardStatus status, int length)? callback;

  @override
  State<SwipeContainer<T>> createState() => _SwipeContainerState<T>();
}

class _SwipeContainerState<T> extends State<SwipeContainer<T>> {
  @override
  void initState() {
    super.initState();
    context.read<SwipeController>().initData(widget.data);
    if (widget.callback != null) {
      context.read<SwipeController>().callback = widget.callback!;
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   final data = context.select<SwipeController, List>(((value) => value.data));
  //   return Stack(
  //     children: [
  //       if (data.length >= 2)
  //         SwipeCard(
  //           key: Key("cards-${data.length - 2}"),
  //           isFront: false,
  //           child: widget.builder(
  //             context,
  //             data[data.length - 2],
  //             data.length - 2,
  //           ),
  //           text: "cards-${data.length - 2}",
  //         ),
  //       if (data.isNotEmpty)
  //         SwipeCard(
  //           key: Key("cards-${data.length - 1}"),
  //           isFront: true,
  //           child: widget.builder(
  //             context,
  //             data[data.length - 1],
  //             data.length - 1,
  //           ),
  //           text: "cards-${data.length - 1}",
  //         ),
  //     ],
  //   );
  // }

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
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}
