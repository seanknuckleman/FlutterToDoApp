import 'package:flutter/material.dart';
import 'package:todoapp/mogodb/mongodb.dart';
import 'package:todoapp/util/dialog_box.dart';
import 'package:todoapp/util/todo_tile.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<ToDoItem> toDoList = [];

Future<List<ToDoItem>> itemList = MongoDatabase().updateToDoList();

// Future<List> itemList = MongoDatabase().updateToDoList();
// var itemStream = Stream.f

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController(); // text controller
  final db =
      MongoDatabase(); // shorthand for calling a mongodb.dart mongodatabase class method

  void checkBoxChanged(bool? value, int index) {
    // checkbox was tapped
    setState(() {
      // db.toDoList[index][2] = !db.toDoList[index][2];
      // db.updateList();
    });
  }

  void updateDataBase() async {
    toDoList = await db.updateToDoList();
  }

  void saveNewTask() {
    // save new task
    // var f = db.getDBCount();
    setState(() {
      var item = db.createToDoItem(
        toDoList.length,
        _controller.text,
        false,
      );

      // ignore: avoid_print
      print("****$item****");

      // toDoList.add(item);
      db.addToDB(item); // add to database
      updateDataBase(); // update UI with database
      _controller.clear(); // clear text controller
    });
    updateDataBase(); // update UI with database
    Navigator.of(context).pop(); // close the modal
  }

  // void updateDB() {
  //   setState(() {
  //     db.updateToDoList();
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    itemList = MongoDatabase().updateToDoList();
    super.initState();
  }

  // create a new task
  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            myController: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  void deleteTask(int index) {
    setState(() {
      db.deleteFromDB(index); // Remove from Database
      toDoList.removeAt(index); // Remove from UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text("TO DO"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: toDoList.length,
          itemBuilder: (context, index) {
            return FutureBuilder<Map<String, dynamic>?>(
                future: db.findById(index),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ToDoTile(
                      taskName: toDoList[index].getTaskName(),
                      taskCompleted: toDoList[index].getTaskCompleted(),
                      onChanged: (value) => checkBoxChanged(value, index),
                      deleteFunction: (context) => deleteTask(index),
                    );
                  } else if (snapshot.hasError) {
                    // Handle errors (optional)
                    return Text('Error: ${snapshot.error}');
                  }
                  // Show a loading indicator while waiting
                  return const Center(child: CircularProgressIndicator());
                });
          }),
    );
  }
}
