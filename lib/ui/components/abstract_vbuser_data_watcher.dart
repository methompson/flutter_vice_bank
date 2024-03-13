import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/vice_bank_user.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';

abstract class VBUserDataWatcher extends State {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    getDataAndResetTimer();
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ViceBankProvider, ViceBankUser?>(
      selector: (_, vbProvider) => vbProvider.currentUser,
      builder: (_, user, __) {
        if (user == null) {
          _timer?.cancel();
          _timer = null;
        } else {
          getDataAndResetTimer();
        }

        return Container();
      },
    );
  }

  Future<void> getApiData();

  Future<void> getDataAndResetTimer() async {
    _timer?.cancel();
    await getApiData();
    resetTimer();
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = Timer(
      Duration(minutes: 10),
      getDataAndResetTimer,
    );
  }
}
