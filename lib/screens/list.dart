import 'package:MultiToolsApp/database/tarefaDao.dart';
import 'package:flutter/material.dart';
import 'package:MultiToolsApp/database/tarefaDao.dart';
import '../models/tarefa.dart';
import 'form.dart';

class ListaTarefa extends StatefulWidget {
  final List<Tarefa> _tarefas = [];

  @override
  State<StatefulWidget> createState() {
    return ListaTarefaState();
  }
}

class ListaTarefaState extends State<ListaTarefa> {
  final TarefaDao _dao = TarefaDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.green,
                    Colors.red,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          title: Text("Lista de Tarefas"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("clicou no botão flutuante");
            final Future future =
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FormTarefa();
            }));
            future.then((tarefa) {
              /// voltou do form com um objeto tarefa
              /// add na lista de tarefas
              ///widget._tarefas.add(tarefa);
              setState(() {});
            }); // push
          }, //onpressed
          child: Icon(Icons.add),
        ),
        body: FutureBuilder<List<Tarefa>>(
          initialData: [],
          future: Future.delayed(Duration(seconds: 1))
              .then((value) => _dao.findAll()),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;

              case ConnectionState.waiting:
                break;

              case ConnectionState.active:
                break;

              case ConnectionState.done:
                if (snapshot.data != null) {
                  final List<Tarefa>? tarefas = snapshot.data;
                  return ListView.builder(
                      itemCount: tarefas!.length,
                      itemBuilder: (context, index) {
                        final Tarefa tarefa = tarefas![index];
                        return ItemTarefa(context, tarefa);
                      });
                }
                break;

              default:
                return Center(child: Text("Nenhuma tarefa"));
            //break;
            }
            return Center(child: Text("Carregando..."));
          },
        ));
  }

  Widget ItemTarefa(BuildContext context, Tarefa _tarefa) {
    return GestureDetector(
      onTap: () {
        final Future future =
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FormTarefa(tarefa: _tarefa);
        }));
        future.then((value) => setState(() {}));
      },
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.add_alert),
          title: Text(_tarefa.descricao),
          subtitle: Text(_tarefa.obs),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget> [
              GestureDetector(
                onTap: (){
                  //_excluir(context, _tarefa.id);
                  showAlertDialog(context, _tarefa);
                },
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.delete_forever, color:Color.fromARGB(255, 200, 0, 0))
                ),
              )
            ]
          ),
        ),
      ),
    );
  }

  void _excluir(BuildContext context, int id){
    _dao.delete(id).then((value) => setState(() {}));
  }

  showAlertDialog(BuildContext context, Tarefa _tarefa) {
    Widget cancelButton = ElevatedButton(
      child: Text("Cancelar"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.deepPurple // Background color
      ),
    );
    Widget continueButton = ElevatedButton(
      child: Text("Remover"),
      onPressed:  () {
        Navigator.of(context).pop();
        _excluir(context, _tarefa.id);
      },
      style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 255, 0, 0) // Background color
      ),
    );
    AlertDialog alert = AlertDialog(
      title: Text("Remover item"),
      content: Text("Tem certeza que deseja remover este item?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

