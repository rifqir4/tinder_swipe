import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tinder_swipe/src/swipe_child.dart';

enum CardStatus { like, dislike, rewind, none }

class SwipeController extends ChangeNotifier {
  Function(CardStatus status, int length) callback = ((status, length) {});

  int length = 0;
  CardStatus? prevStatus;
  bool canRewind = false;

  List<dynamic> _data = [];
  List<dynamic> get data => _data;

  void initData(List<dynamic> newData) {
    _data = newData;
  }

  SwipeChild? get dataSecondLast {
    if (_data.length < 2) return null;
    return SwipeChild(index: _data.length - 2, data: _data[data.length - 2]);
  }

  SwipeChild? get dataLast {
    if (_data.isEmpty) return null;
    return SwipeChild(index: _data.length - 1, data: _data[data.length - 1]);
  }

  bool _isAnimate = false;

  Offset _position = Offset.zero;
  Offset get position => _position;

  bool _isDragging = false;
  bool get isDragging => _isDragging;

  Size _screenSize = Size.zero;
  Size get screenSize => _screenSize;

  double _angle = 0;
  double get angle => _angle;

  void startPosition(DragStartDetails details) {
    _isDragging = true;
  }

  void updatePoisiton(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;

    notifyListeners();
  }

  void endPosition() {
    _isDragging = false;

    final status = getStatus(isForce: true);

    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        dislike();
        break;
      default:
        resetPosition();
    }
  }

  double getStatusOpacity() {
    const delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;

    return min(opacity, 1);
  }

  CardStatus? getStatus({bool isForce = false}) {
    final x = _position.dx;

    if (isForce) {
      const delta = 100;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    } else {
      const delta = 20;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    }
    return null;
  }

  void like() {
    if (!_isAnimate) {
      _isAnimate = true;
      _angle = 20;
      _position += Offset(screenSize.width * 1.5, 0);
      notifyListeners();

      _nextCard();
      prevStatus = CardStatus.like;
    }
  }

  void dislike() {
    if (!_isAnimate) {
      _isAnimate = true;
      _angle = -20;
      _position -= Offset(screenSize.width * 1.5, 0);
      notifyListeners();

      _nextCard();
      prevStatus = CardStatus.dislike;
    }
  }

  void rewind(dynamic prevData) async {
    if (prevStatus != null && canRewind) {
      _isDragging = true;
      _data.add(prevData);
      notifyListeners();

      _angle = prevStatus == CardStatus.like ? 20 : -20;
      _position = prevStatus == CardStatus.like
          ? Offset(screenSize.width * 1.5, 0)
          : Offset(-screenSize.width * 1.5, 0);
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 200));
      _isDragging = false;
      _angle = 0;
      _position = const Offset(0, 0);
      canRewind = false;
      notifyListeners();
      callback(CardStatus.rewind, _data.length);
    }
  }

  void resetPosition() {
    _position = Offset.zero;
    _angle = 0;
    _isAnimate = false;
    notifyListeners();
  }

  void _nextCard() async {
    if (_data.isEmpty) return;
    await Future.delayed(const Duration(milliseconds: 400));
    _data.removeLast();
    notifyListeners();
    canRewind = true;
    callback(prevStatus ?? CardStatus.none, _data.length);
    resetPosition();
  }

  void setScreenSize(Size size) {
    _screenSize = size;
  }

  void addData(List<dynamic> newData) {
    _data.insertAll(0, newData);
    notifyListeners();
  }
}
