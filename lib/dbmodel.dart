class TaskDB {
  final String name;
  final String description;
  final String owner;
  final List<String> coowner;
  final DateTime date_started;
  final DateTime date_finished;
  final int status;

  TaskDB({
    required this.name,
    required this.description,
    required this.owner,
    required this.coowner,
    required this.date_started,
    required this.date_finished,
    required this.status,
  });
}
