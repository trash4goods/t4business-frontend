import 'package:flutter/material.dart';

import '../../../../../core/app/constants.dart';
import '../../../../../core/app/custom_getview.dart';
import '../widgets/settings_category_widget.dart';
import '../controller/profile_settings_controller.interface.dart';
import '../presenter/profile_settings_presenter.interface.dart';
import '../widgets/profile_settings_header.dart';

class ProfileSettingsView
    extends
        CustomGetView<
          ProfileSettingsControllerInterface,
          ProfileSettingsPresenterInterface
        > {
  const ProfileSettingsView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop =
              constraints.maxWidth > AppConstants.tabletBreakpoint;
          final isTablet =
              constraints.maxWidth > AppConstants.mobileBreakpoint &&
              constraints.maxWidth <= AppConstants.tabletBreakpoint;

          return SafeArea(
            child: SingleChildScrollView(
              child: Center(
                  child: SizedBox(
                width: isDesktop ? 800 : double.infinity,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      // header
                      ProfileSettingsHeader(onBack: businessController.onBack, title: 'Profile Settings'),
                  
                      // content (list of SettingsCategoryWidget)
                      const SizedBox(height: 24),
                      ...presenter.categories.map((category) {
                        return ProfileSettingsCategoryWidget(
                          category: category,
                          isDesktop: isDesktop,
                          isTablet: isTablet,
                          onTap: (id) => businessController.onCategoryTapped(id),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
