import 'package:flutter/material.dart';
import '../components/editor.dart';
import '../models/tarefa.dart';
import '../database/tarefaDao.dart';

class FormTarefa extends StatefulWidget {
  final Tarefa? tarefa; //?pode receber valor nulo

  FormTarefa({this.tarefa}); //{} significa que a tarefa pode ser opcional

  @override
  State<StatefulWidget> createState() {
    return FormTarefaState();
  }
}

class FormTarefaState extends State<FormTarefa> {
  final TextEditingController _controladorTarefa = TextEditingController();
  final TextEditingController _controladorObs = TextEditingController();
  int? _id; //pode ter valor nulo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.black12,
                  Colors.amberAccent,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: const Text("Form Tarefa"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          criarTarefa(context);
        },
        child: const Icon(Icons.save),
      ),
      body: Column(
        children: <Widget>[
          Editor(_controladorTarefa, "Tarefa", "Informe a tarefa", Icons.chat),
          Editor(_controladorObs, "Obs", "Informe a obs", Icons.chat),
        ],
      ),
    );

  }

  void criarTarefa(BuildContext context) {
    TarefaDao _dao = TarefaDao();
    if (_id != null) {
      //entramos em uma alteração

      final tarefa = Tarefa(
          _id!,
          _controladorTarefa.text, //! garante que o valor não é nulo
          _controladorObs.text);
      print("Tarefa criada: " + tarefa.toString());
      _dao.update(tarefa).then((id) {
       _mensagem(context, "Tarefa alterada com sucesso");
        Navigator.pop(context);
      });
    } else {
      //entramos em uma inclusão

      final tarefa = Tarefa(
          0,
          _controladorTarefa.text, //! garante que o valor não é nulo
          _controladorObs.text);
      print("Tarefa criada: " + tarefa.toString());
      _dao.save(tarefa).then((id) {
        _mensagem(context, "Tarefa adicionada com sucesso");
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    super.initState(); //executa a instrução padrão do método initState
    if (widget.tarefa != null) {
      // alteração
      _id = widget.tarefa!.id; //!garante que tem informação na table tarefa
      _controladorTarefa.text =
          widget.tarefa!.descricao; //! ----
      _controladorObs.text =
          widget.tarefa!.obs; //! ----
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
  _mensagem(BuildContext, String msg) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(milliseconds: 4000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
      ),
    );
  }
}
//a


