import 'package:flutter/material.dart';
import 'menu.dart';


void main() {
  runApp(
    MaterialApp(



      title: 'MultiTools',
      theme: ThemeData(primarySwatch: Colors.green),
      darkTheme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.green),
      themeMode: ThemeMode.dark,
      home: MenuOptions()
    )
  );
  //TarefaDao dao = TarefaDao();
  //dao.save(Tarefa(0, "teste tarefa", "obs da tarefa")).then((value) {
  //  dao.findAll().then((tarefa) => debugPrint(tarefa.toString()));
  //});

}



