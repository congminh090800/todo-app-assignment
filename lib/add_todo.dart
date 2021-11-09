import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/priority.dart';
import 'package:todo_app/todo_model.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key, required this.addTask}) : super(key: key);
  final Function(TodoModel) addTask;
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _addForm = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  Priority _priority = Priority.Low;
  DateTime? _date;
  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(0),
      scrollable: true,
      title: Text("Add todo"),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(0),
        child: Form(
          key: _addForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (String? value) {
                  return (value == null || value.isEmpty) ? 'Required' : null;
                },
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: 'Description',
                ),
                maxLines: 5,
                minLines: 5,
                validator: (String? value) {
                  return (value == null || value.isEmpty) ? 'Required' : null;
                },
              ),
              SizedBox(
                height: 12,
              ),
              Text("Priority:"),
              DropdownButtonFormField<Priority>(
                value: _priority,
                items: Priority.values.map(
                  (Priority priority) {
                    return DropdownMenuItem<Priority>(
                      value: priority,
                      child: Text(
                        getPriorityName(priority),
                      ),
                    );
                  },
                ).toList(),
                onChanged: (Priority? value) {
                  setState(
                    () {
                      _priority = value!;
                    },
                  );
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    onConfirm: (date) {
                      setState(() {
                        _date = date;
                      });
                    },
                    currentTime: DateTime.now(),
                  );
                },
                child: Text(
                  _date != null
                      ? DateFormat.yMd().add_jm().format(_date!)
                      : "Click to pick a date (required)",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancel",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        TextButton(
          onPressed: () {
            if (_addForm.currentState!.validate() && _date != null) {
              TodoModel todoObj = TodoModel(nameController.text,
                  descriptionController.text, _date, _priority);
              widget.addTask(todoObj);
              Navigator.of(context).pop();
            }
          },
          child: Text(
            "Create",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
