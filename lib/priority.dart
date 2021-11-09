enum Priority {
  Low,
  Medium,
  High,
}

String getPriorityName(Priority prio) {
  return prio.toString().split(".").elementAt(1);
}

Priority getFromIndex(int index) {
  return Priority.values.elementAt(index);
}
