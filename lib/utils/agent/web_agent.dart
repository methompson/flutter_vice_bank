import 'package:flutter_vice_bank/utils/agent/base.dart';
import 'package:web/web.dart';

class AgentGetter extends AbstractAgentGetter {
  @override
  String getUserAgent() {
    return window.navigator.userAgent;
  }

  @override
  bool isPWA() {
    return window.matchMedia('(display-mode: standalone)').matches;
  }
}
