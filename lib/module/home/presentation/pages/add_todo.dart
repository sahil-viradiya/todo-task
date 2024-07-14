
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahil/custom_widgets/app_button.dart';
import 'package:sahil/custom_widgets/app_textfield_with_label.dart';
import 'package:sahil/module/home/presentation/Bloc/todohome_bloc.dart';
import 'package:sahil/utils/navigator_service.dart';
import 'package:sahil/utils/size_utils.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../constants/app_color.dart';

class TodoForm extends StatelessWidget {
  TodoForm({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => TodohomeBloc(),
      child: TodoForm(),
    );
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.sectionText,
        title: const Text("Add Todo Task"),
        centerTitle: true,
      ),
      body:
          BlocConsumer<TodohomeBloc, TodohomeState>(listener: (context, state) {
        if (state is TodoAddedState) {
          NavigatorService.goBack();
        }
      }, builder: (context, state) {
        var bloc = context.read<TodohomeBloc>();
        return ModalProgressHUD(
          inAsyncCall: state.isLoading ?? false,
          child: Padding(
            padding: getPadding(all: 20),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                autovalidateMode: state.autoValidate!
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(children: [
                  AppTextFieldWithLabel(
                    maxLength: 80,
                    controller: bloc.titleCtrl,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        bloc.titleCtrl.text.trim();
                        return 'Title is required.';
                      }
                      return null;
                    },
                    // controller: name,
                    labelText: 'Title',
                    hintText: 'Enter title',
                    onChanged: (string) {},
                  ),
                  AppTextFieldWithLabel(
                    maxLength: 250,
                    controller: bloc.descCtrl,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        bloc.descCtrl.text.trim();
                        return 'Description is required.';
                      }
                      return null;
                    },
                    // controller: name,
                    labelText: 'Description',
                    minLines: 3,
                    maxLines: 7,
                    hintText: 'Enter description',
                    onChanged: (string) {},
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AppButton(
                    color: AppColors.sectionText,
                    onTap: () {
                      state.autoValidate = true;

                      if (formKey.currentState!.validate()) {
                        context.read<TodohomeBloc>().add(AddTodoTask());
                      }
                    },
                    textColor: AppColors.blackFont,
                    buttonText: 'Submit',
                  )
                ]),
              ),
            ),
          ),
        );
      }),
    );
  }
}
