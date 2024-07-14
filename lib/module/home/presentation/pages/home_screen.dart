import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sahil/Singleton/singleton.dart';
import 'package:sahil/constants/app_color.dart';
import 'package:sahil/custom_widgets/custom_dialog.dart';
import 'package:sahil/module/home/presentation/Bloc/todohome_bloc.dart';
import 'package:sahil/routes/routes.dart';
import 'package:sahil/utils/navigator_service.dart';
import 'package:sahil/utils/size_utils.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Widget builder(BuildContext context) {
    // Singleton.instance.getToken();
    // var data = FirebaseAuth.instance.currentUser!;
    // Singleton.instance.userID = data.uid;
    return BlocProvider(
      create: (context) => TodohomeBloc()..add(TodoInitEvent()),
      child: const HomeScreen(),
    ) /*,
    )*/
        ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.sectionText,
          title: const Text("To do List"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                customAlert(
                  isCenterAction: true,
                  context: context,
                  cancelButtonTExt: "No",
                  title: const Text(
                    "Are you sure you want to Logout",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onSubmit: () async {
                    NavigatorService.goBack();
                    try {
                      await FirebaseAuth.instance.signOut();
                      Singleton.instance.logout();
                      // Navigate to your login screen or handle successful logout as needed
                    } on FirebaseAuthException catch (e) {
                      Singleton.instance.logout();
                      print('Error signing out: ${e.code}');
                      // Handle errors appropriately, e.g., display an error message to the user
                    }
                  },
                );
              },
              icon: Icon(
                Icons.exit_to_app_rounded,
                color: AppColors.blackFont,
              ),
            ),
          ],
        ),
        body:
            BlocBuilder<TodohomeBloc, TodohomeState>(builder: (context, state) {
          if (state is TodoListingSuccessState &&
              (state.todoList ?? []).isEmpty) {
            return ModalProgressHUD(
                inAsyncCall: state.isLoading ?? false,
                child: const Center(child: Text("No Data Found!")));
          } else {
            return todoListView(state);
          }
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: floatingActionBtn());
  }

  Widget floatingActionBtn() {
    return FloatingActionButton(
      shape: const StadiumBorder(),
      backgroundColor: AppColors.sectionText,
      onPressed: () {
        NavigatorService.pushNamed(AppRoutes.todoForm);
      },
      child: const Icon(Icons.add),
    );
  }

  Widget todoListView(TodohomeState state) {
    return ModalProgressHUD(
      inAsyncCall: state.isLoading ?? false,
      child: Column(
        children: [
          if ((state.todoList ?? []).isNotEmpty) todayTaskCount(state),
          Expanded(
            child: ListView.builder(
              itemCount: state.todoList?.length ?? 0,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var todoDetails = state.todoList?[index];
                return Padding(
                  padding: getPadding(all: 8),
                  child: Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.red, // Background color on swipe
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    secondaryBackground: Container(
                      color: Colors.red, // Background color on swipe
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: getPadding(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {}
                      context
                          .read<TodohomeBloc>()
                          .add(DeleteTodoTask(docID: todoDetails.id));
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              todoDetails?.name ?? "",
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            if ((todoDetails?.description ?? "")
                                .isNotEmpty) // Only show description if it exists
                              Text(
                                (todoDetails?.description ?? ""),
                                maxLines: 20,
                                // Limit to two lines with ellipsis overflow
                                overflow: TextOverflow.ellipsis,
                              ),
                            // Spacer(), // Add some vertical space
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                        fillColor: WidgetStateProperty.all(
                                            todoDetails!.isCompleted
                                                ? Colors.green
                                                : Colors.white),
                                        value: todoDetails.isCompleted,
                                        onChanged: (value) {
                                          log("value: $value");
                                          customAlert(
                                            isCenterAction: true,
                                            context: context,
                                            cancelButtonTExt: "No",
                                            title: Text(
                                              value ?? false
                                                  ? "Are you sure you want to mark as completed"
                                                  : "Are you sure you want to mark as Not Complete",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onSubmit: () {
                                              NavigatorService.goBack();
                                              context.read<TodohomeBloc>().add(
                                                  UpdateTodoTask(
                                                      completed: value,
                                                      docID: todoDetails.id));
                                            },
                                          );
                                        }),
                                    // Handle checkbox change if needed
                                    Text(todoDetails.isCompleted
                                        ? 'Completed'
                                        : 'Not Completed'),
                                  ],
                                ),
                                Text(DateFormat.yMd()
                                    .add_jm()
                                    .format(todoDetails.createdAt)),
                                // Format date and time
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget todayTaskCount(TodohomeState state) {
    return Padding(
      padding: getPadding(all: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today Total Task",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: getPadding(all: 10),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${state.todoList?.length ?? 0}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
