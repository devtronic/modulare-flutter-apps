class Task {
  int id;

  String text;

  DateTime? createdAt;

  DateTime? doneAt;

  bool isDone;

  Task({
    required this.text,
    this.createdAt,
    this.doneAt,
    this.id = 0,
    this.isDone = false,
  });
}
