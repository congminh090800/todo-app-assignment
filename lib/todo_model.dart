import 'package:intl/intl.dart';
import 'package:todo_app/priority.dart';

class TodoModel {
  String? taskName;
  String? description;
  Priority? priority;
  DateTime? startDate;
  TodoModel(this.taskName, this.description, this.startDate, this.priority);
  TodoModel.empty();
  toJSONEncode() {
    Map<String, dynamic> m = new Map();
    m['taskName'] = taskName;
    m['description'] = description;
    m['priority'] = priority!.index;
    m['startDate'] = DateFormat.yMd().add_jm().format(startDate!);
    return m;
  }
}
