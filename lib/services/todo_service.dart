import 'package:http/http.dart';

class TodoService {
  final String baseUrl = 'https://shy-blue-fossa-wrap.cyclic.app';

  // get all todos
  Future<Response> getAllTodosRequest() async {
    return await get(Uri.parse('$baseUrl/todos'));
  }

  // Create a Todo
  Future<Response> createTodo(
      {required String title,
      required String description,
      required DateTime deadline}) async {
    Map<String, dynamic> body = {
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String()
    };

    return await post(Uri.parse('$baseUrl/todos'), body: body);
  }

  //get Todo by ID
  Future<Response> getTodo(String id) async {
    return await get(Uri.parse('$baseUrl/todos/$id'));
  }

  //Update isCompleted
  Future<Response> updateStatus(String id) async {
    Map<String, dynamic> body = {"isCompleted": true};
    return await patch(Uri.parse('$baseUrl/todos/$id'), body: body);
  }

  //Deleting a Todo
  Future<Response> deleteTodo(String id) async {
    return await delete(Uri.parse('$baseUrl/todos/$id'));
  }
}
