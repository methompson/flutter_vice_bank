abstract class AbstractAgentGetter {
  String getUserAgent();

  bool isPWA();
}

class AgentGetter extends AbstractAgentGetter {
  @override
  String getUserAgent() {
    return 'Base. (Something Went Wrong).';
  }

  @override
  bool isPWA() {
    return false;
  }
}
