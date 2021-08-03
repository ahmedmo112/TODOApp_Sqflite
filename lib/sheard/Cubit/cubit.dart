import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todosql/medules/archived_tasks/archive_tasks_screen.dart';
import 'package:todosql/medules/done_tasks/done_tasks_screen.dart';
import 'package:todosql/medules/new_tasks/new_tasks_screen.dart';
import 'package:todosql/sheard/Cubit/statse.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchiveTasksScreen(),
  ];

  List<String> titels = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print('database created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT , time TEXT , status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((e) {
        print('Error when creating Table ${e.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print('database opened');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    return await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date , time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print("$value inserted successfully");
        emit(AppInsertDatabaseState());

//! when insert will get data then  update it on screen
        getDataFromDatabase(database);
      }).catchError((e) {
        print('Error when Inserting new record ${e.toString()}');
      });
      return null;
    });
  }

  void getDataFromDatabase(database) {

    newTasks =[];
    doneTasks =[];
    archiveTasks =[];

    emit(AppGetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });

      emit(AppGetDatabaseState());
    });
  }

  updateData({@required String status, @required int id}) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', '$id']).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  deleteData({ @required int id}) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?',
        ['$id']).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void changeBottomSheetState(
      {@required bool isShow, @required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
