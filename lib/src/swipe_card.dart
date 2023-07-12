import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_swipe/src/swipe_controller.dart';

class SwipeCard extends StatelessWidget {
  const SwipeCard({
    Key? key,
    required this.isFront,
    required this.text,
    this.child,
    this.swipingBadge,
    this.fullSize = false,
    this.buildCardCustom,
    this.notFirst = false,
  }) : super(key: key);

  final bool fullSize;
  final Widget? Function(Widget front)? buildCardCustom;
  final bool isFront;
  final String text;
  final Widget? child;
  final Widget? Function(CardStatus status, dynamic card)? swipingBadge;
  final bool notFirst;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    context.read<TinderSwipeController>().setScreenSize(size);
    return SizedBox.expand(
        child: isFront
            ? buildCardFront(context)
            : (buildCardCustom?.call(buildCard()) ?? buildCard()));
  }

  Widget buildCardFront(BuildContext context) {
    final controller = context.read<TinderSwipeController>();
    final cardBuilder = LayoutBuilder(
      builder: (context, constraints) {
        return Consumer<TinderSwipeController>(
          builder: (context, provider, child) {
            final position = provider.position;
            final milliseconds = provider.isDragging ? 0 : 400;

            final center = constraints.smallest.center(Offset.zero);
            final angle = provider.angle * pi / 180;
            final rotatedMatrix = Matrix4.identity()
              ..translate(center.dx, center.dy)
              ..rotateZ(angle)
              ..translate(-center.dx, -center.dy);
            return AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: milliseconds),
                transform: rotatedMatrix..translate(position.dx, position.dy),
                child: child);
          },
          child: Stack(
            children: [
              buildCard(),
              buildStamps(context),
            ],
          ),
        );
      },
    );

    if (controller.canSwipe == false) {
      return cardBuilder;
    }

    return GestureDetector(
      onPanStart: (details) {
        final _controller = context.read<TinderSwipeController>();
        _controller.startPosition(details);
      },
      onPanUpdate: (details) {
        final _controller = context.read<TinderSwipeController>();
        _controller.updatePoisiton(details);
      },
      onPanEnd: (_) {
        final _controller = context.read<TinderSwipeController>();
        _controller.endPosition();
      },
      child: cardBuilder,
    );
  }

  Widget buildCard() {
    return Container(
      color: child == null ? Colors.blue.shade200 : null,
      child: Center(
        child: child ?? Text(text),
      ),
    );
/*
    return LayoutBuilder(
      builder: (context, constraints) {
        return Consumer<TinderSwipeController>(
          builder: (context, provider, child) {
            if (isFront) return child!;
            if (notFirst) return child!;

            final position = provider.position;
            final milliseconds = provider.isDragging ? 0 : 400;

            final center = constraints.smallest.center(Offset.zero);
            final angle = provider.angle * pi / 180;
            final rotatedMatrix = Matrix4.identity()
              ..translate(center.dx, center.dy)
              ..rotateZ(angle)
              ..translate(-center.dx, -center.dy);
            return AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: milliseconds),
                transform: rotatedMatrix..translate(position.dx, position.dy),
                child: child);
          },
          child: cardView,
        );
      },
    );
*/
  }

  Widget buildStamps(BuildContext context) {
    final provider = context.watch<TinderSwipeController>();
    final status = provider.getStatus(isForce: false);
    final opacity = provider.getStatusOpacity();

    switch (status) {
      case CardStatus.like:
        final child = defaultStamp(
          text: "LIKE",
          color: Colors.green,
          opacity: opacity,
          child: swipingBadge != null
              ? swipingBadge!(CardStatus.like, provider.dataLast)
              : null,
        );
        return fullSize ? child : Positioned(top: 24, left: 24, child: child);
      case CardStatus.dislike:
        final child = defaultStamp(
          text: "NOPE",
          color: Colors.red,
          opacity: opacity,
          child: swipingBadge != null
              ? swipingBadge!(CardStatus.dislike, provider.dataLast)
              : null,
        );
        return fullSize ? child : Positioned(top: 24, right: 24, child: child);
      default:
        return Container();
    }
  }

  Widget defaultStamp({
    double angle = 0,
    required String text,
    required Color color,
    required double opacity,
    Widget? child,
  }) {
    return Opacity(
      opacity: opacity,
      child: child ??
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: color,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
    );
  }
}
