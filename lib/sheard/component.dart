import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todosql/sheard/Cubit/cubit.dart';

class DefaultFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final Function onSubmit;
  final Function onchange;
  final Function validate;
  final String label;
  final IconData prefix;
  final bool isPassword;
  final IconData suffix;
  final Function onTap;
  final isEnabled;

  const DefaultFormField({
    Key key,
    @required this.controller,
    @required this.type,
    this.onSubmit,
    this.onchange,
    this.onTap,
    this.isEnabled = true,
    @required this.validate,
    @required this.label,
    @required this.prefix,
    this.suffix,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onchange,
      onTap: onTap,
      enabled: isEnabled,
      validator: validate,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefix),
          suffixIcon: suffix != null ? Icon(suffix) : null,
          border: OutlineInputBorder()),
    );
  }
}

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['time']}'),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                ),
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'done', id: model['id']);
                }),
            IconButton(
                icon: Icon(
                  Icons.archive,
                  color: Colors.black45,
                ),
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'archive', id: model['id']);
                }),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
    );


Widget tasksBuilder ({
@required List<Map> tasks,
}) => ConditionalBuilder(
          condition: tasks.length>0,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
              separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsetsDirectional.only(start: 20),
                    child: Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),
              itemCount: tasks.length),
          fallback: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  size: 100.0,
                  color: Colors.grey,
                ),
                Text(
                  'No Tasks Yet, please Add Some Tasks',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight:  FontWeight.bold,
                    color: Colors.grey
                  ),
                )
              ],
            ),
          ),
        );