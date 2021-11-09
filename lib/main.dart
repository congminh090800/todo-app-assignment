import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todo_app/add_todo.dart';
import 'package:todo_app/notification_service.dart';
import 'package:todo_app/priority.dart';
import 'package:todo_app/todo_list.dart';
import 'package:todo_app/todo_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(title: 'Todo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TodoModel> todos = [];
  bool loaded = false;
  final LocalStorage storage = new LocalStorage('todo_app');
  saveToLocal() {
    storage.setItem("todos", toJSONEncode(todos));
  }

  @override
  void initState() {
    super.initState();
    NotificationService.init();
    listenNotifications();
  }

  void listenNotifications() =>
      NotificationService.onNotifications.stream.listen(onClickedNotifications);

  void onClickedNotifications(String? payload) {
    print(payload);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storage.ready,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Todo App'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (!loaded) {
          var localTodos = storage.getItem("todos");
          if (localTodos != null) {
            todos = List<TodoModel>.from((localTodos as List).map((e) =>
                TodoModel(
                    e['taskName'],
                    e['description'],
                    DateFormat.yMd().add_jm().parse(e['startDate']),
                    getFromIndex(e['priority']))));
          }
          loaded = true;
        }
        return DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              bottom: TabBar(
                tabs: [
                  Tab(
                    text: "All",
                  ),
                  Tab(
                    text: "Today",
                  ),
                  Tab(
                    text: "Upcoming",
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                TodoList(
                  todos: todos,
                  removeTask: (index) {
                    setState(() {
                      TodoModel todo = todos.elementAt(index);
                      NotificationService.cancelNotification(
                          (todo.startDate!.millisecondsSinceEpoch / 1000)
                              .round());
                      todos.removeAt(index);
                      saveToLocal();
                    });
                  },
                ),
                TodoList(
                  todos: todos,
                  filter: "today",
                  removeTask: (index) {
                    setState(() {
                      TodoModel todo = todos.elementAt(index);
                      NotificationService.cancelNotification(
                          (todo.startDate!.millisecondsSinceEpoch / 1000)
                              .round());
                      todos.removeAt(index);
                      saveToLocal();
                    });
                  },
                ),
                TodoList(
                  todos: todos,
                  filter: "upcoming",
                  removeTask: (index) {
                    setState(() {
                      TodoModel todo = todos.elementAt(index);
                      NotificationService.cancelNotification(
                          (todo.startDate!.millisecondsSinceEpoch / 1000)
                              .round());
                      todos.removeAt(index);
                      saveToLocal();
                    });
                  },
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AddTodo(
                      addTask: (todoObj) {
                        print(todos.length);
                        NotificationService.showScheduledNotifications(
                          title: "Upcoming task",
                          body: todoObj.taskName,
                          payload: todos.length.toString(),
                          scheduledDate: todoObj.startDate!.subtract(
                            Duration(minutes: 10),
                          ),
                          id: (todoObj.startDate!.millisecondsSinceEpoch / 1000)
                              .round(),
                        );
                        setState(() {
                          todos.add(todoObj);
                        });
                        saveToLocal();
                      },
                    );
                  },
                );
              },
              tooltip: 'Add todo',
              child: Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}

toJSONEncode(List<TodoModel> todos) {
  return todos.map((e) => e.toJSONEncode()).toList();
}
