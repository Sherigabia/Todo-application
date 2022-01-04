import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/todo_controller.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({Key? key}) : super(key: key);

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final TodoController _todoController = TodoController();

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _timeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  DateTime? myDate;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Todo",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              maxLines: 1,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromRGBO(37, 43, 103, 1.0),
                  )),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromRGBO(37, 43, 103, 1.0),
                  )),
                  hintText: 'please Enter your Title',
                  labelText: 'Title',
                  labelStyle: TextStyle(
                      color: Color.fromRGBO(37, 43, 103, 1.0),
                      fontWeight: FontWeight.w600),
                  floatingLabelBehavior: FloatingLabelBehavior.never),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Title Field is Required';
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromRGBO(37, 43, 103, 1.0),
                  )),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromRGBO(37, 43, 103, 1.0),
                  )),
                  hintText: 'please Enter your Description',
                  labelText: 'Discription',
                  labelStyle: TextStyle(
                      color: Color.fromRGBO(37, 43, 103, 1.0),
                      fontWeight: FontWeight.w600),
                  floatingLabelBehavior: FloatingLabelBehavior.never),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Desription Field is Required';
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _dateController,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ).then((selectedDate) {
                        final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
                        _dateController.text =
                            _dateFormat.format(selectedDate!);
                        myDate = selectedDate;
                      });
                    },
                    maxLines: 1,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Color.fromRGBO(37, 43, 103, 1.0),
                        )),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Color.fromRGBO(37, 43, 103, 1.0),
                        )),
                        hintText: 'please enter date',
                        labelText: 'Date',
                        labelStyle: TextStyle(
                            color: Color.fromRGBO(37, 43, 103, 1.0),
                            fontWeight: FontWeight.w600),
                        floatingLabelBehavior: FloatingLabelBehavior.never),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Date Field is Required';
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextFormField(
                    controller: _timeController,
                    maxLines: 1,
                    onTap: () {
                      showTimePicker(
                              context: context, initialTime: TimeOfDay.now())
                          .then((selectedTime) {
                        _timeController.text = selectedTime!.format(context);
                      });
                    },
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Color.fromRGBO(37, 43, 103, 1.0),
                        )),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Color.fromRGBO(37, 43, 103, 1.0),
                        )),
                        hintText: 'please Enter your Title',
                        labelText: 'Time',
                        labelStyle: TextStyle(
                            color: Color.fromRGBO(37, 43, 103, 1.0),
                            fontWeight: FontWeight.w600),
                        floatingLabelBehavior: FloatingLabelBehavior.never),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Time Field is Required';
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 55,
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(37, 43, 103, 1.0),
                        padding: const EdgeInsets.all(15)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        //Send data to the backend
                        // print(_titleController.text);
                        // print(_descriptionController.text);
                        // print(_dateController.text);
                        // print(_timeController.text);

                        bool isSent = await _todoController.createTodo(
                            title: _titleController.text,
                            description: _descriptionController.text,
                            deadline: myDate!);
                        isLoading = false;
                        if (isSent) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Todo Added Successfully",
                                      style: TextStyle(color: Colors.green))));

                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                            "Failed to add Todo",
                            style: TextStyle(color: Colors.red),
                          )));
                        }
                      } else {
                        //Validation Failed
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                          "All Fields are Required",
                          style: TextStyle(color: Colors.amber),
                        )));
                      }
                    },
                    child: const Text(
                      "Create",
                      style: TextStyle(color: Colors.white),
                    ))
          ],
        ),
      ),
    );
  }
}
