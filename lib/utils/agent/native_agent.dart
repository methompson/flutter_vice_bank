import 'dart:io';

import 'package:flutter_vice_bank/utils/agent/base.dart';

class AgentGetter extends AbstractAgentGetter {
  @override
  String getUserAgent() {
    if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'iOS';
    } else if (Platform.isLinux) {
      return 'Linux';
    } else if (Platform.isMacOS) {
      return 'MacOS';
    } else if (Platform.isWindows) {
      return 'Windows';
    }

    return 'Unknown';
  }

  @override
  bool isPWA() {
    return false;
  }
}
