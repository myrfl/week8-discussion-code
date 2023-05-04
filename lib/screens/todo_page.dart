/*
  Created by: Claizel Coubeili Cepe
  Date: updated April 26, 2023
  Description: Sample todo app with Firebase 
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';
import 'modal_todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    List<Todo> todoList = context.watch<TodoListProvider>().todo;

    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: ((context, index) {
          final todo = todoList[index];
          return Dismissible(
            key: Key(todo.id.toString()),
            onDismissed: (direction) {
              // Delete item when swiped
              context.read<TodoListProvider>().deleteTodo(todo.title);

              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${todo.title} dismissed')));
            },
            background: Container(
              color: Colors.red,
              child: const Icon(Icons.delete),
            ),
            child: ListTile(
              title: Text(todo.title),
              leading: Checkbox(
                value: todo.completed,
                onChanged: (bool? value) {
                  context.read<TodoListProvider>().toggleStatus(index, value!);
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => TodoModal(
                          type: 'Edit',
                        ),
                      );
                    },
                    icon: const Icon(Icons.create_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => TodoModal(
                          type: 'Delete',
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_outlined),
                  )
                ],
              ),
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => TodoModal(
              type: 'Add',
            ),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
