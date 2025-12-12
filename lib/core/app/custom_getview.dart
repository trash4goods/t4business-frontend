import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CustomGetView<Controller, Presenter extends GetxController>
    extends GetView<Presenter> {
  const CustomGetView({super.key});

  // Business logic (plain class or interface)
  Controller get businessController => Get.find<Controller>();

  // Presenter (state, observables, lifecycle)
  Presenter get presenter => controller; // Provided by GetView

  @override
  Widget build(BuildContext context) {
    return buildView(context);
  }

  @protected
  Widget buildView(BuildContext context);
}
