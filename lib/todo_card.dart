import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/priority.dart';

Color getColor(Priority priority) {
  Color color = Colors.green;
  if (priority == Priority.Medium) {
    color = Colors.orange;
  } else if (priority == Priority.High) {
    color = Colors.red;
  }
  return color;
}

class TodoCard extends StatefulWidget {
  const TodoCard({
    Key? key,
    required this.priority,
    required this.taskName,
    required this.startDate,
    required this.description,
  }) : super(key: key);
  final Priority priority;
  final String taskName;
  final DateTime startDate;
  final String description;
  @override
  _TodoCardState createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  bool isExpand = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 4,
        color: getColor(widget.priority),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              contentPadding:
                  EdgeInsets.only(bottom: 0, top: 8, left: 8, right: 8),
              leading: Icon(
                Icons.splitscreen,
                size: 30,
                color: Colors.white,
              ),
              title: Text(
                widget.taskName.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  height: 2,
                ),
              ),
              subtitle: Text(
                'Start at: ' +
                    DateFormat.yMd().add_jm().format(widget.startDate) +
                    '\nPriority: ' +
                    getPriorityName(widget.priority),
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.white,
                ),
              ),
              isThreeLine: true,
            ),
            if (isExpand)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    thickness: 0.5,
                    color: Colors.white,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, top: 8),
                    child: Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: Icon(
                      isExpand
                          ? Icons.keyboard_arrow_up_sharp
                          : Icons.keyboard_arrow_down_sharp,
                      color: Colors.white,
                      size: 40,
                    ),
                    onTap: () {
                      setState(() {
                        this.isExpand = !this.isExpand;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
