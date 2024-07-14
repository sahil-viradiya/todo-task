part of 'todohome_bloc.dart';

@immutable
sealed class TodohomeState {
  bool? isLoading;
  List<TodoModel>? todoList;
  bool? autoValidate;

  TodohomeState({
    this.isLoading = false,
    this.todoList = const [],
    this.autoValidate = false,
  });
}

final class TodohomeInitial extends TodohomeState {
  TodohomeInitial({
    super.isLoading = null,
    super.todoList = null,
    super.autoValidate = false,
  });
}

final class TodohomeLoadingState extends TodohomeState {
  TodohomeLoadingState({
    super.isLoading = null,
    super.todoList = null,
    super.autoValidate = false,
  });
}

final class TodoAddedState extends TodohomeState {
  TodoAddedState({
    super.isLoading = null,
    super.todoList = null,
    super.autoValidate = false,
  });
}

final class TodoListingSuccessState extends TodohomeState {
  TodoListingSuccessState({
    super.isLoading = null,
    super.todoList = null,
    super.autoValidate = false,
  });
}
