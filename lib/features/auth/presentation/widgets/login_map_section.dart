import 'package:flutter/material.dart';
import '../../../../core/widgets/animated_header_section.dart';

class LoginMapSection extends StatelessWidget {
  const LoginMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnimatedHeaderSection(
      title: 'Trash4Goods',
      subtitle: 'Create. Monitor. Reward. \n All-in-one platform for your business',
      logoWidth: 300,
      logoHeight: 100,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(16),
      ),
    );
  }
}