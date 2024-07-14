import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sahil/Singleton/singleton.dart';
import 'package:sahil/constants/app_constants.dart';
import 'package:sahil/module/home/data/model/todo_model.dart';

part 'todohome_event.dart';

part 'todohome_state.dart';

class TodohomeBloc extends Bloc<TodohomeEvent, TodohomeState> {
  var fireStore = FirebaseFirestore.instance.collection('todo');
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();

  TodohomeBloc()
      : super(TodohomeInitial(isLoading: false, todoList: const [])) {
    on<TodoSuccessStateEvent>(_changeToSuccessState);
    on<ChangeToLoadingState>(_changeToLoadingState);
    on<TodoInitEvent>(_initTodo);
    on<AddTodoTask>(_addTodo);
    on<DeleteTodoTask>(_deleteTodo);
    on<UpdateTodoTask>(_updateTodoTask);
  }

  EventHandler<TodoInitEvent, TodohomeState> get _initTodo =>
      (event, emit) async {
        log("5555555555555");
        log("${Singleton.instance.userID}");

        add(ChangeToLoadingState(isLoading: true));
        fireStore
            .where('uid', isEqualTo: Singleton.instance.userID)
            .snapshots()
            .listen(
          (snapshot) {
            List<TodoModel> newList = [];
            var todoList = snapshot.docs
                .map((doc) => TodoModel.fromMap(doc.data(), doc.id))
                .toList();
            todoList.map(
              (e) {
                if (DateFormat("MM-dd-yyyy").format(e.createdAt) ==
                    DateFormat("MM-dd-yyyy").format(DateTime.now())) {
                  newList.add(e);
                }
              },
            ).toList();
            newList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            add(TodoSuccessStateEvent(todoList: newList));
          },
        );
      };

  EventHandler<UpdateTodoTask, TodohomeState> get _updateTodoTask =>
      (event, emit) {
        add(TodoSuccessStateEvent(isLoading: true));

        fireStore.doc('${event.docID}').update({
          'isCompleted': event.completed! ? 1 : 0,
        }).then(
          (value) {
            add(TodoSuccessStateEvent());
            showToast("Task updated");
          },
        ).onError(
          (error, stackTrace) {
            add(TodoSuccessStateEvent());
            showToast("Something went wrong");
          },
        );
      };

  EventHandler<TodoSuccessStateEvent, TodohomeState>
      get _changeToSuccessState => (event, emit) {
            emit(TodoListingSuccessState(
                isLoading: event.isLoading ?? false,
                todoList: event.todoList ?? state.todoList));
          };

  EventHandler<ChangeToLoadingState, TodohomeState> get _changeToLoadingState =>
      (event, emit) {
        emit(TodohomeLoadingState(
            isLoading: event.isLoading ?? false,
            todoList: event.todoList ?? state.todoList));
      };

  EventHandler<AddTodoTask, TodohomeState> get _addTodo => (event, emit) async {
        log("Singleton.instance.userID:${Singleton.instance.userID}");
        add(TodoSuccessStateEvent(isLoading: true));
        final todo = TodoModel(
          name: titleCtrl.text.trim(),
          description: descCtrl.text.trim(),
          isCompleted: false,
          createdAt: DateTime.now(),
          uid: Singleton.instance.userID, // User ID (if applicable)
        );
        await fireStore
            // Replace with your actual collection name
            .add(todo.toMap()) // Convert your data to a Map
            .then((documentReference) {
          emit(TodoAddedState(todoList: state.todoList, isLoading: false));
          add(TodoSuccessStateEvent());
          showToast("Task added successfully!");

          print('Document added with ID: ${documentReference.id}');
        }).catchError((error) {
          add(TodoSuccessStateEvent());
          showToast("Something went wrong!");
        });
      };

  EventHandler<DeleteTodoTask, TodohomeState> get _deleteTodo =>
      (event, emit) async {
        await fireStore.doc('${event.docID}').delete().then(
          (value) {
            showToast("Task deleted successfully!");
          },
        ).catchError((error) => showToast("Something went wrong!"));
      };
}
