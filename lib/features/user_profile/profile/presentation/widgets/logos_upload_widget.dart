import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../product_managment/presentation/components/image_upload_component.dart';
import '../controllers/interface/profile.dart';
import '../presenters/interface/profile.dart';

class LogosUploadWidget extends StatelessWidget {
  final ProfileControllerInterface businessController;
  final ProfilePresenterInterface presenter;

  const LogosUploadWidget({
    super.key,
    required this.businessController,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final mainLogo = presenter.mainLogoUrl;
      final logos = presenter.logoUrls;

      return Column(
        children: [
          if (logos.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: logos.length,
                itemBuilder: (context, index) {
                  final logoUrl = logos[index];
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 8),
                    child: ImageUploadComponent(
                      imageUrl: logoUrl,
                      onUpload: () {},
                      onRemove: () {
                        businessController.deleteLogo(logoUrl);
                      },
                      title: '',
                      subtitle: '',
                      compact: true,
                      onSetAsLogo: () {
                        businessController.setMainLogo(logoUrl);
                      },
                      isLogo: logoUrl == mainLogo,
                      width: 100,
                      height: 100,
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 8),
          if (logos.length < 5)
            ImageUploadComponent(
              onUpload: () => businessController.uploadLogo(),
              title: 'Add Company Logo',
              subtitle: logos.isEmpty
                  ? 'Add up to 5 company logos'
                  : 'Add ${5 - logos.length} more logo(s)',
              compact: true,
            ),
        ],
      );
    });
  }
}
