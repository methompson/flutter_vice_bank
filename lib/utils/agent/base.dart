abstract class AbstractAgentGetter {
  String getUserAgent();
}

class AgentGetter extends AbstractAgentGetter {
  @override
  String getUserAgent() {
    return 'Base. (Something Went Wrong).';
  }
}
