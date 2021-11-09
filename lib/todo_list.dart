import 'package:flutter/material.dart';
import 'package:todo_app/todo_card.dart';
import 'package:todo_app/todo_model.dart';

class TodoList extends StatefulWidget {
  const TodoList({
    Key? key,
    required this.todos,
    this.filter = "all",
    required this.removeTask,
  }) : super(key: key);
  final List<TodoModel> todos;
  final String filter;
  final Function(int) removeTask;
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  String? keyword;
  @override
  Widget build(BuildContext context) {
    List<TodoModel> todos = widget.todos;
    todos.sort((e1, e2) => e2.startDate!.compareTo(e1.startDate!));
    if (widget.filter == "today") {
      todos = todos.where((element) => isToday(element.startDate!)).toList();
    } else if (widget.filter == "upcoming") {
      todos = todos
          .where((element) => element.startDate!.isAfter(DateTime.now()))
          .toList();
    }
    if (keyword != null && keyword!.isNotEmpty) {
      todos = todos
          .where((element) =>
              element.taskName!.toLowerCase().contains(keyword!.toLowerCase()))
          .toList();
    }
    if (todos.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.do_not_disturb_alt,
              size: 50,
            ),
            Text(
              "No task",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
              ),
              hintText: 'Search by task name',
              suffixIcon: Icon(
                Icons.search,
              ),
            ),
            onChanged: (value) {
              setState(() {
                keyword = value;
              });
            },
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Remove task'),
                          content: Text(
                            'Are you sure to remove this task?',
                            style: TextStyle(fontSize: 16),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'No',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                TodoModel data = todos.elementAt(index);
                                widget.removeTask(widget.todos.indexOf(data));
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  splashColor: Colors.pinkAccent,
                  child: TodoCard(
                    taskName: todos.elementAt(index).taskName!,
                    priority: todos.elementAt(index).priority!,
                    startDate: todos.elementAt(index).startDate!,
                    description: todos.elementAt(index).description!,
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 4,
              ),
              itemCount: todos.length,
            ),
          ),
        ],
      );
    }
  }
}

bool isToday(DateTime date) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime aDate = DateTime(date.year, date.month, date.day);
  if (today == aDate) {
    return true;
  }
  return false;
}

// bool isOneWeekNear(DateTime date) {
//   DateTime oneWeekAway = DateTime.now().add(Duration(days: 7));
//   return date.isAfter(DateTime.now()) && date.isBefore(oneWeekAway);
// }
