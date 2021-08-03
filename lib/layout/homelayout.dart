import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todosql/sheard/Cubit/cubit.dart';
import 'package:todosql/sheard/Cubit/statse.dart';
import 'package:todosql/sheard/component.dart';
import 'package:intl/intl.dart';
import 'package:conditional_builder/conditional_builder.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) => {
          if (state is AppInsertDatabaseState) {Navigator.pop(context)}
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titels[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                    // insertToDatabase(
                    //   title: titleController.toString(),
                    //   time: timeController.toString(),
                    //   date: dateController.toString(),
                    // ).then((value) {
                    //   getDataFromDatabase(database).then((value) {
                    //     Navigator.pop(context);
                    //     //   setState(() {
                    //     //   isBottomSheetShown = false;
                    //     //   fabIcon = Icons.edit;
                    //     //   tasks = value;
                    //     // });
                    //   });
                    // });
                  }
                } else {
                  print('opened');
                  scaffoldKey.currentState
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DefaultFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'Title must not be empty';
                                    }
                                    return null;
                                  },
                                  label: "Task Title",
                                  prefix: Icons.title,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                DefaultFormField(
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value.format(context).toString();
                                    });
                                  },
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  label: "Task Time",
                                  prefix: Icons.watch_later_outlined,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                DefaultFormField(
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2021-12-25'))
                                        .then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value);
                                    });
                                  },
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'date must not be empty';
                                    }
                                    return null;
                                  },
                                  label: "Task Date",
                                  prefix: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);

                    titleController.clear();
                    dateController.clear();
                    timeController.clear();
                    print('clossed');
                  });

                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
                //* error handling
                //try {
                //   var name = await getName();
                //   print(name);
                //   throw ('some error');
                // } catch (e) {
                //   print('error ${e.toString()}');
                // }
                // getName().then((value) {
                //   print(value);
                //   print('ali');
                //   throw ('error');
                // }).catchError((e) => print('the error is ${e.toString()}'));
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: 'Archived'),
                ]),
          );
        },
      ),
    );
  }

  // Future<String> getName() async {
  //   return 'Ahmed mohamed';
  // }

}
