import 'dart:convert';

import 'package:http/http.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/todo_service.dart';

class TodoController {
  final TodoService _todoService = TodoService();

// Get all Todos as a List
  Future<List<Todo>> getAllTodos() async {
    List<Todo> todo = [];
    await _todoService.getAllTodosRequest().then((response) {
      int statusCode = response.statusCode;
      // Map<String, dynamic> body = jsonDecode(response.body);
      if (statusCode == 200) {
        //Success
        todo = todoFromJson(response.body);
      } else {
        //error
        todo = [];
      }
    });

    return todo;
  }

//add a new Todo
  Future<bool> createTodo(
      {required String title,
      required String description,
      required DateTime deadline}) async {
    bool isSubmitted = false;

    await _todoService
        .createTodo(title: title, description: description, deadline: deadline)
        .then((response) {
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        //success
        isSubmitted = true;
      } else {
        //error

        isSubmitted = false;
      }
    }).catchError((onError) {
      isSubmitted = false;
    });
    return isSubmitted;
  }

  //update Todo completion (iscompleted = true)
  Future<bool> updateIsCompleted({required String id}) async {
    bool isUpdated = false;
    await _todoService.updateStatus(id).then((response) {
      int statusCode = response.statusCode;

      if (statusCode == 200) {
//success
        isUpdated = true;
      } else {
//error
        isUpdated = false;
      }
    }).catchError((onError) {
//error
      isUpdated = false;
    });

    return isUpdated;
  }

  //delete todo
  Future<bool> deleteTodo({required String id}) async {
    bool isDeleted = false;
    await _todoService.deleteTodo(id).then((response) {
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        isDeleted = true;
      } else {
        isDeleted = false;
      }
    }).catchError((onError) {
      isDeleted = false;
    });
    return isDeleted;
  }

  // get one todo
  Future<Todo?> getTodo(String id) async {
    Todo? todo;
    await _todoService.getTodo(id).then((response) {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = jsonDecode(response.body);
      if (statusCode == 200) {
        todo = Todo.fromJson(body);
      } else {
        todo = null;
      }
    });
    return todo;
  }
}
