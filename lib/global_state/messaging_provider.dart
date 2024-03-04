import 'package:flutter/material.dart';
import 'package:flutter_action_bank/data_models/messaging_data.dart';

final snackbarMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MessagingProvider extends ChangeNotifier {
  // TODO implement messaging provider
  // loading screen
  // Toast message

  LoadingScreenData? _loadingScreenData;
  List<SnackbarData> _snackbarData = [];

  LoadingScreenData? get loadingScreenData => _loadingScreenData;
  List<SnackbarData> get snackbarData => _snackbarData;

  void setLoadingScreenData(LoadingScreenData data) {
    _loadingScreenData = data;
    notifyListeners();
  }

  void clearLoadingScreen() {
    _loadingScreenData = null;
    notifyListeners();
  }

  void addSnackbar(SnackbarData data) {
    _snackbarData.add(data);
    notifyListeners();
  }

  void closeSnackBar(id) {
    _snackbarData.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
