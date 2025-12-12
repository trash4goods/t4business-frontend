import 'package:flutter/material.dart';

class DragHandleWidget extends StatelessWidget {
  const DragHandleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: 4,
        width: 40,
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}
