import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/profile_delete_account_controller.interface.dart';
import '../presenter/profile_delete_account_presenter.interface.dart';
import 'delete_account_dialog.dart';

/// Wrapper widget that connects the DeleteAccountDialog with GetX reactive state
///
/// This widget handles the reactive state management and passes the appropriate
/// values to the stateless DeleteAccountDialog widget.
class DeleteAccountDialogWrapper extends StatelessWidget {
  final ProfileDeleteAccountPresenterInterface presenter;
  final ProfileDeleteAccountControllerInterface controller;

  const DeleteAccountDialogWrapper({
    super.key,
    required this.presenter,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DeleteAccountDialog(
        isLoading: presenter.isLoading,
        confirmationError: presenter.confirmationError,
        isConfirmationValid: presenter.isConfirmationValid,
        confirmationController: presenter.confirmationController,
        onConfirmationTextChanged: controller.onConfirmationTextChanged,
        onConfirmDelete: controller.confirmDelete,
        onCancelDelete: controller.cancelDelete,
      ),
    );
  }
}
