import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../interface/scan_product_details_interfaces.dart';
import '../../presenters/interface/scan_product_details_interfaces.dart';

class ScanProductDetailsViewControl
    implements ScanProductDetailsViewController {
  ScanProductDetailsViewControl(this._presenter);

  final ScanProductDetailsViewPresenter _presenter;

  @override
  void back() {
    Get.back();
  }

  @override
  void onPageCarouselChanged(int index) {
    _presenter.productCarouselCurrent = index;
  }

  @override
  void showFullScreenImage(String imageUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Container(
              width: Get.width,
              height: Get.height,
              color: Colors.black,
              child: Center(child: _buildDialogImageWidget(imageUrl)),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: ClipOval(
                child: Material(
                  color: Colors.white.withValues(alpha: 179),
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogImageWidget(String imageUrl) {
    // Check if it's a local file path or URL
    final isLocalFile =
        !imageUrl.startsWith('http') && File(imageUrl).existsSync();

    if (isLocalFile) {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/images/default_event_picture.jpg",
            fit: BoxFit.contain,
          );
        },
      );
    } else {
      return Image.network(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/images/default_event_picture.jpg",
            fit: BoxFit.contain,
          );
        },
      );
    }
  }
}