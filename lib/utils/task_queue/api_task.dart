enum TaskStatus { pending, running, success }

abstract class APITask {
  TaskStatus get status;

  Future<void> execute();

  Map<String, dynamic> toJson();
}
