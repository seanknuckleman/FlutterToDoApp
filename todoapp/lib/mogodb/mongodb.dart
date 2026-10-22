// ignore_for_file: avoid_print
// import 'dart:js_interop';

// import 'dart:html';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:todoapp/pages/home_page.dart';
import 'connection.dart';
// import 'package:todoapp/main.dart';

class MongoDatabase {
  ToDoItem createToDoItem(int id, String taskName, bool taskCompleted) {
    return ToDoItem(id, taskName, taskCompleted);
  }

  Future<List<ToDoItem>> updateToDoList() async {
    toDoList = [];
    var db = await Db.create(MONGO_URL);
    await db.open();

    var collection = db.collection(COLLECTION_NAME);
    List<ToDoItem> items = [];

    // var documents = collection.find();
    // var docs = collection.getIndexes();

    for (int i = 0; i < await collection.count(); i++) {
      var recordMap = await collection.findOne({'_id': i});
      List item = recordMap!.values.toList();
      items.add(ToDoItem(item[0], item[1], item[2]));
      item = [];
      // print(docs);
    }

    print(items);
    print("------------");

    for (var el in items) {
      print(el.taskName);
    }

    // for (var el in itemList) {
    //   print(el.id);
    //   print(el.taskName);
    //   print(el.taskCompleted);
    // }
    // for (int i = 0; i < ge; i++) {
    //   print(itemList.);
    //   print(el.taskName);
    //   print(el.taskCompleted);
    // }

    //.forEach((element) {
    //   // items.elementAt(index)
    // });
    // Future<List<Map<String, dynamic>>> documents = collection.getIndexes().asStream();
    // toDoList.add()

    // for (var element in documents) {

    // }
    // documents.forEach((element) {
    // final item = element.entries;
    // items.add(item);
    // items.add(ToDoItem(item[0], item[1], item[2]));
    // });

    // for (var item in Iterable.castFrom(collection as Iterable)) {
    //   items.add(ToDoItem(item[0], item[1], item[2]));
    // }

    // const stream = Stream.empty();
    // stream.listen(
    //   (value) {
    //     throw "Unreachable";
    //   },
    //   onDone: () {
    //     var data = Stream.fromIterable(elements);
    //     print('Done');
    //   },
    // );
    // while (!Stream.empty())

    // for (int i = 0; i < await collection.count(); i++) {
    //   var recordMap = await collection.findOne({'_id': i});
    //   List item = recordMap!.values.toList();
    //   toDoList.add(ToDoItem(item[0], item[1], item[2]));
    //   item = [];

    //   // print("-------------");
    // print(items);
    // print("-------------");
    // }
    // print(itemList);
    // for (var element in await itemList) {
    // print(element);
    // }

    // db.close();

    return items;
  }

  Future<int?> getDBCount() async {
    try {
      // establish a link to the mongodb cluster/database
      var db = await Db.create(MONGO_URL);
      await db.open();
      var result = await db.collection(COLLECTION_NAME).count();
      // db.close();
      return result;
    } catch (e) {
      print("ERROR ---- connecting to database -- (getDBCount): $e");
    }
    return null;
  }

  Future<Map<String, dynamic>?> findById(int id) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var result = await db.collection(COLLECTION_NAME).findOne({'_id': id});
    db.close();
    return result;
  }

  Future<void> addToDB(ToDoItem item) async {
    // establish a link to the mongodb cluster/database
    print("------------");
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_NAME);
    // add the ToDoItem to the collection
    await collection.insertOne({
      "_id": item.id,
      "task": item.taskName,
      "completed": item.taskCompleted,
    });
    print("------------");
    print(item.id);
    // db.close();
  }

  Future<void> deleteFromDB(int index) async {
    // attempt to connect to the database
    try {
      // establish a link to the mongodb cluster/database
      var db = await Db.create(MONGO_URL);
      await db.open();

      // delete the record to the collection
      await db.collection(COLLECTION_NAME).deleteOne({"_id": index});

      db.close();
    } catch (e) {
      print("ERROR ---- connecting to database  -- (deleteFromDB): $e");
    }
  }
}

// schema for database collection
class ToDoItem {
  String taskName;
  bool taskCompleted;
  int id;

  // constructor for ToDoItem
  ToDoItem(
    this.id,
    this.taskName,
    this.taskCompleted,
  );

  void flipTaskCompletedBool() => taskCompleted = !taskCompleted;

  //setters
  void setID(int id) => this.id = id;
  void setTaskName(String taskName) => this.taskName = taskName;
  // void setTaskCompleted(bool taskCompleted) =>
  //     this.taskCompleted = taskCompleted;

  // getters
  int getID() => id;
  String getTaskName() => taskName;
  bool getTaskCompleted() => taskCompleted;
}
