import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:todo_app/controller/todo_controller.dart';
import 'package:todo_app/create_task.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/util.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TodoController _todoController = TodoController();
  String selectedItem = 'todo';

  List<Todo> _unCompletedData = [];

  List<Todo> _completedData = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    _unCompletedData.clear();
    _completedData.clear();
    await _todoController.getAllTodos().then((todos) {
      for (Todo element in todos) {
        if (!element.isCompleted) {
          _unCompletedData.add(element);
        } else {
          _completedData.add(element);
        }
      }
      setState(() {});
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Todos loaded")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tasks",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
        ),
        centerTitle: false,
        leading: const Center(
          child: FlutterLogo(
            size: 40,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                loadData();
              },
              icon: const Icon(Icons.refresh)),
          PopupMenuButton<String>(
              icon: const Icon(Icons.menu),
              onSelected: (value) {
                setState(() {
                  selectedItem = value;
                });
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    child: Text('Todo'),
                    value: 'todo',
                  ),
                  const PopupMenuItem(
                    child: Text('Completed'),
                    value: 'completed',
                  )
                ];
              }),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateTodo()));
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromRGBO(37, 43, 103, 1.0),
      ),
      body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.green,
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  //delete
                  bool isDeleted = await _todoController.deleteTodo(
                      id: selectedItem == 'todo'
                          ? _unCompletedData[index].id
                          : _completedData[index].id);

                  if (isDeleted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      'Todo Deleted!',
                      style: TextStyle(color: Colors.green),
                    )));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      'Could not Delete Todo!',
                      style: TextStyle(color: Colors.green),
                    )));
                  }
                } else if (direction == DismissDirection.startToEnd) {
                  //edit
                  bool isUpdated = await _todoController.updateIsCompleted(
                      id: selectedItem == 'todo'
                          ? _unCompletedData[index].id
                          : _completedData[index].id);

                  if (isUpdated) {
                    //success
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      'Todo Markes as Completed!',
                      style: TextStyle(color: Colors.green),
                    )));
                  } else {
                    //error
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      'Could not Mark Todo as Completed!',
                      style: TextStyle(color: Colors.red),
                    )));
                  }
                }
              },
              child: TaskCard(
                dateTime: selectedItem == 'todo'
                    ? _unCompletedData[index].deadline
                    : _completedData[index].deadline,
                description: selectedItem == 'todo'
                    ? _unCompletedData[index].description
                    : _completedData[index].description,
                title: selectedItem == 'todo'
                    ? _unCompletedData[index].title
                    : _completedData[index].title,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemCount: selectedItem == 'todo'
              ? _unCompletedData.length
              : _completedData.length),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
          child: InkWell(
            onTap: () {
              showBarModalBottomSheet(
                  context: context,
                  builder: (context) {
                    if (_completedData.isEmpty) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(Icons.info, size: 50),
                            Text("You do not have any completed tasks")
                          ]);
                    }

                    return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          return TaskCard(
                            title: _completedData[index].title,
                            description: _completedData[index].description,
                            dateTime: _completedData[index].deadline,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 5,
                          );
                        },
                        itemCount: _completedData.length);
                  });
            },
            child: Material(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(37, 43, 103, 1.0),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 30,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      "Completed",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      '${_completedData.length}',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard(
      {Key? key,
      required this.title,
      required this.description,
      required this.dateTime})
      : super(key: key);

  final String title;
  final String description;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showBarModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      deadline(date: dateTime),
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
              );
            });
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Icon(
                Icons.check_circle_outline_outlined,
                size: 30,
                color: customColor(date: deadline(date: dateTime)),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromRGBO(37, 43, 103, 1.0),
                        ),
                      ),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ]),
              ),
              const SizedBox(
                width: 15,
              ),
              Row(children: [
                Icon(
                  Icons.notifications_outlined,
                  color: customColor(date: deadline(date: dateTime)),
                ),
                Text(deadline(date: dateTime),
                    style: TextStyle(
                      color: customColor(date: deadline(date: dateTime)),
                    ))
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
