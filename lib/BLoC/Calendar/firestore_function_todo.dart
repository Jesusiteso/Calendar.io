import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreConectionsTODO {
  CollectionReference _firestore;
  var _firebaseUser;

  FirestoreConectionsTODO(BuildContext context) {
    var user = context.watch<User>();
    this._firebaseUser = user.email;
    this._firestore = FirebaseFirestore.instance.collection(this._firebaseUser);
  }

  void addTodoTask(title, description) {
    var uid = Uuid();
    var uuid = uid.v4();
    this
        ._firestore
        .doc(uuid)
        .set({
          'uuid': uuid,
          'type': 'task',
          'title': title,
          'description': description,
          'status': false,
        })
        .then((value) => print('Task added'))
        .catchError((e) {
          this
              ._firestore
              .add({"key": 'initialnote'})
              .then((value) => print('initialnote'))
              .catchError((onError) => print('kabloom!'));
          print("Something went wrong in adding task: $e");
        });
  }

  void changeTaskStatus(uuid, status) {
    this
        ._firestore
        .doc(uuid)
        .update({'status': (!status)})
        .then((value) => print('Document updated'))
        .catchError((e) => print('somethin failed in update: $e'));
  }

  void updateTask(uuid, title, description) {
    this
        ._firestore
        .doc(uuid)
        .update({
          'title': title,
          'description': description,
        })
        .then((value) => print("Task text updated"))
        .catchError((e) => print("Something failed in updated $e"));
  }

  void deleteTask(uuid) {
    this
        ._firestore
        .doc(uuid)
        .delete()
        .then((value) => print('Succefully deleted'))
        .catchError((e) => print('somethin failed in delete: $e'));
  }

  Future getAllTasks() async {
    return this._firestore.where('type', isEqualTo: 'task').get();
  }

  Future getAllTasksByStatus(status) async {
    return this._firestore.where('status', isEqualTo: status).get();
  }
}
