import 'package:flutter/material.dart';
import 'package:flutter_action_bank/data_models/messaging_data.dart';
import 'package:flutter_action_bank/ui/components/snackbars.dart';

final snackbarMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MessagingProvider extends ChangeNotifier {
  LoadingScreenData? _loadingScreenData;

  LoadingScreenData? get loadingScreenData => _loadingScreenData;

  void setLoadingScreenData(LoadingScreenData data) {
    _loadingScreenData = data;
    notifyListeners();
  }

  void clearLoadingScreen() {
    _loadingScreenData = null;
    notifyListeners();
  }

  void _showSnackbar(SnackBar snackbar) {
    final messenger = snackbarMessengerKey.currentState;
    messenger?.showSnackBar(snackbar);
  }

  void showInfoSnackbar(String info) {
    _showSnackbar(makeInfoSnackBar(info));
  }

  void showErrorSnackbar(String error) {
    _showSnackbar(makeErrorSnackBar(error));
  }

  void showSuccessSnackbar(String success) {
    _showSnackbar(makeSuccessSnackBar(success));
  }
}
