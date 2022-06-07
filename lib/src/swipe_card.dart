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
  }) : super(key: key);

  final bool isFront;
  final String text;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    context.read<SwipeController>().setScreenSize(size);
    return SizedBox.expand(
        child: isFront ? buildCardFront(context) : buildCard());
  }

  Widget buildCardFront(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        final _controller = context.read<SwipeController>();
        _controller.startPosition(details);
      },
      onPanUpdate: (details) {
        final _controller = context.read<SwipeController>();
        _controller.updatePoisiton(details);
      },
      onPanEnd: (_) {
        final _controller = context.read<SwipeController>();
        _controller.endPosition();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Consumer<SwipeController>(
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
      ),
    );
  }

  Widget buildCard() {
    return Container(
      color: isFront ? Colors.blue.shade100 : Colors.grey.shade300,
      child: Center(
        child: child ?? Text(text),
      ),
    );
  }

  Widget buildStamps(BuildContext context) {
    final provider = context.watch<SwipeController>();
    final status = provider.getStatus(isForce: false);
    final opacity = provider.getStatusOpacity();

    switch (status) {
      case CardStatus.like:
        final child =
            defaultStamp(text: "LIKE", color: Colors.green, opacity: opacity);
        return Positioned(top: 24, left: 24, child: child);
      case CardStatus.dislike:
        final child =
            defaultStamp(text: "NOPE", color: Colors.red, opacity: opacity);
        return Positioned(top: 24, right: 24, child: child);
      default:
        return Container();
    }
  }

  Widget defaultStamp({
    double angle = 0,
    required String text,
    required Color color,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Container(
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
