import 'package:flutter/material.dart';

class ImageSliderDots extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Function(int) onDotTapped;

  const ImageSliderDots({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.onDotTapped,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return GestureDetector(
          onTap: () => onDotTapped(index),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 3),
            width: currentIndex == index ? 10 : 6,
            height: 6,
            decoration: BoxDecoration(
              color:
                  currentIndex == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}