import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todosql/counterBLOC/BLOC/cubit.dart';
import 'package:todosql/counterBLOC/BLOC/states.dart';

class CounterHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CounterCubit(),
      child: BlocConsumer<CounterCubit, CounterStates>(
        listener: (context, state) {
          if (state is CounterMinusState) {
            //print("minus state ${state.counter}");
          }
          
          if (state is CounterPlusState){
             //print("plus state ${state.counter}");
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Bloc'),
            ),
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        CounterCubit.get(context).minus();
                      },
                      child: Text('MINUS')),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Text(
                      '${CounterCubit.get(context).counter}',
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.w900),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        CounterCubit.get(context).plus();
                      },
                      child: Text('PLUS')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
