import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todosql/counterBLOC/home.dart';
import 'package:todosql/layout/homelayout.dart';
import 'package:todosql/sheard/bloc_observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'todo',
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
