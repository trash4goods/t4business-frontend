// features/app_initialization/presentation/presenters/splash_presenter_impl.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../interface/splash.interface.dart';

class SplashPresenterImpl extends SplashPresenterInterface
    with GetSingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _isAnimating = true.obs;
  final _logoOpacity = 0.0.obs;
  final _logoScale = 0.5.obs;
  final _showContinueButton = false.obs;
  final _tokenCheckCompleted = false.obs;
  final _isLoggedIn = false.obs;

  @override
  bool get isAnimating => _isAnimating.value;

  @override
  double get logoOpacity => _logoOpacity.value;

  @override
  double get logoScale => _logoScale.value;

  @override
  bool get showContinueButton => _showContinueButton.value;

  @override
  void onInit() {
    super.onInit();
    _setupAnimationController();
    _startInitialAnimation();
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }

  void _setupAnimationController() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _animationController.addListener(() {
      if (_animationController.value <= 0.2) {
        _logoOpacity.value = _animationController.value * 5;
      } else {
        _logoOpacity.value = 1.0;
      }

      final wave = 0.15 * (1 + sin(2 * pi * _animationController.value));
      _logoScale.value = 0.85 + wave;
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        _animationController.forward();
      }
    });
  }

  void _startInitialAnimation() {
    _isAnimating.value = true;
    _animationController.forward();
  }

  @override
  void onAnimationComplete() {
    _showContinueButton.value = true;
  }

  @override
  void onContinuePressed() {
    // Handled by controller
  }

  @override
  void onTokenCheckComplete(bool isLoggedIn) {
    _tokenCheckCompleted.value = true;
    _isLoggedIn.value = isLoggedIn;
  }
}
