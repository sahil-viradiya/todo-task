part of 'todohome_bloc.dart';

@immutable
sealed class TodohomeEvent {}

class TodoInitEvent extends TodohomeEvent {
  TodoInitEvent();
}

class AddTodoTask extends TodohomeEvent {
  AddTodoTask();
}

class DeleteTodoTask extends TodohomeEvent {
  String? docID;

  DeleteTodoTask({this.docID});
}

class UpdateTodoTask extends TodohomeEvent {
  String? docID;
  bool? completed;

  UpdateTodoTask({this.docID, this.completed});
}

class TodoSuccessStateEvent extends TodohomeEvent {
  bool? isLoading;
  List<TodoModel>? todoList;

  TodoSuccessStateEvent({this.isLoading, this.todoList});
}

class ChangeToLoadingState extends TodohomeEvent {
  bool? isLoading;
  List<TodoModel>? todoList;

  ChangeToLoadingState({this.isLoading, this.todoList});
}
