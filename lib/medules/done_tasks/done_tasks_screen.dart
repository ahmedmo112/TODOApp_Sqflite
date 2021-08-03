import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todosql/sheard/Cubit/cubit.dart';
import 'package:todosql/sheard/Cubit/statse.dart';
import 'package:todosql/sheard/component.dart';

class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).doneTasks;
        return tasksBuilder(tasks: tasks);
      },
    );
  }
}