import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:starter/core/services/snackbar/snack_bar_service.dart';
import '../../../app/data/models/request/snack_bar_request/confirm_snack_bar_request.dart';
import '../../../app/data/models/request/snack_bar_request/snack_bar_request.dart';
import '../../../app/data/models/response/snack_bar_response/confirm_snack_bar_response.dart';
import '../../../app/data/models/response/snack_bar_response/snack_bar_response.dart';
import '../../../locator.dart';
import '../../localization/localization.dart';
import '../navigation/navigation_service.dart';

/// A service that is responsible for returning future snackbar
class SnackBarServiceImpl implements SnackBarService {
  final _log = Logger('SnackBarServiceImpl');

  Completer<SnackBarResponse>? _snackBarCompleter;

  @override
  Future<SnackBarResponse> showSnackBar(SnackBarRequest request) {
    _snackBarCompleter = Completer<SnackBarResponse>();

    if (request is ConfirmSnackBarRequest) {
      _log.finer('showConfirmSnackBar');
      _showConfirmSnackBar(request);
    }

    return _snackBarCompleter!.future;
  }

  @override
  void completeSnackBar(SnackBarResponse response) {
    _snackBarCompleter!.complete(response);
    _snackBarCompleter = null;
  }

  void _showConfirmSnackBar(ConfirmSnackBarRequest request) {
    final local = AppLocalizations.of(Get.overlayContext!)!;

    ScaffoldMessenger.of(Get.overlayContext!).hideCurrentSnackBar();
    ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(SnackBar(
      content: Text(
        local.translate(request.message)!,
      ),
      dismissDirection: DismissDirection.horizontal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      margin: const EdgeInsets.all(8.0),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: local.translate(request.buttonText)!,
        onPressed: () {
          completeSnackBar(ConfirmSnackBarResponse((a) => a..confirmed = true));
          if (request.onPressed != null) {
            request.onPressed!();
          }
        },
      ),
    ));
  }
}
