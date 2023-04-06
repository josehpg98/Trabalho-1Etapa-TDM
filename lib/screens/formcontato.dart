import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:MultiToolsApp/components/editor.dart';
import 'package:MultiToolsApp/database/contatodao.dart';
import 'package:MultiToolsApp/models/contato.dart';
import 'package:flutter/services.dart';

class FormContato extends StatefulWidget {
  final Contato? contato; //? pode receber valor nulo
  static const List<String> lista = <String>['teste', 'Two', 'Three'];

  FormContato({this.contato}); //{} é opcional

  @override
  State<StatefulWidget> createState() {
    return FormContatoState();
  }
}

class FormContatoState extends State<FormContato> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorTelefone = TextEditingController();
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorLocal = TextEditingController();
  int check = 0;
  int? _id; //pode ter valor nulo
  final _formKey = GlobalKey<FormState>();

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return true;
  }

  bool checkStatus(int check) {
    if(check == 0){
      return true;
    }
    return false;
  }

  String? get _errorText {

    final text = _controladorNome.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 4) {
      return 'Too short';
    }

    return null;
  }

  String? get _errorTextNum {

    final String text = _controladorTelefone.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (isNumeric(text)) {
      return 'Too short';
    }

    return null;
  }

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorTelefone.dispose();
    _controladorEmail.dispose();
    _controladorLocal.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.green,
                    Colors.green,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          title: const Text("Form Contatos"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              criarContato(context);
            }

          },
          child: const Icon(Icons.save),
        ),
        body: SingleChildScrollView(

            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text('MultiToolsApp'),
                  Container(
                  ),
                  TextFormField(
                    style: TextStyle(
                      fontSize: 25.0,
                      //color: Colors.blueAccent,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo não pode ser Nulo!';
                      }
                      return null;
                    },
                    controller: _controladorNome,
                    decoration: InputDecoration(
                      icon: new Icon(Icons.emoji_food_beverage),
                      labelText: 'Nome',
                      hintText: 'Digite o nome do contato!',
                    ),
                  ),


                  TextFormField(
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo não pode ser nulo';
                      }
                      return null;
                    },
                    controller: _controladorTelefone,
                    decoration: InputDecoration(
                      icon: new Icon(Icons.person),
                      labelText: 'Telefone',
                      hintText: 'Digite o telefone',
                    ),
                  ),

                  TextFormField(
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo não pode ser nulo';
                      }
                      return null;
                    },
                    controller: _controladorEmail,
                    decoration: InputDecoration(
                      icon: new Icon(Icons.store),
                      labelText: 'E-mail',
                      hintText: 'Digite o -E-maill',
                    ),
                  ),

                  TextFormField(
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo não pode ser nulo';
                      }
                      return null;
                    },
                    controller: _controladorLocal,
                    decoration: InputDecoration(
                      icon: new Icon(Icons.store),
                      labelText: 'Local',
                      hintText: 'Digite o local',
                    ),
                  ),
                ],
              ),
            )
        )







    );

  }

  void criarContato(BuildContext context) {
    ContatoDao _dao = ContatoDao();
    if (_id != null) {
      //entramos em uma alteração

      final contato = Contato(
          _id!,//! garante que o valor não é nulo
          _controladorNome.text,
          _controladorTelefone.text,
          //aqui tbm, mesma coisa que a 243
          _controladorEmail.text,
          _controladorLocal.text);
      print("Contato criada: " + contato.toString());
      _dao.update(contato).then((id) {
        _mensagem(context, "Comntato alterado com sucesso");
        Navigator.pop(context);
      });
    } else {
      //entramos em uma inclusão

      final contato = Contato(
          0,
          _controladorNome.text,
          _controladorTelefone.text,
          _controladorEmail.text,
          _controladorLocal.text);
      //alterei em cima com parente e virgula (era só virgula)
      print("Contato criado: " + contato.toString());
      _dao.save(contato).then((id) {
        _mensagem(context, "Contato adicionado com sucesso");
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    super.initState(); //executa a instrução padrão do método initState
    if (widget.contato != null) {
      // alteração
      _id = widget.contato!.id;
      _controladorNome.text = widget.contato!.nome;
      _controladorTelefone.text = widget.contato!.telefone;
      _controladorEmail.text = widget.contato!.email;
      _controladorLocal.text = widget.contato!.local;
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
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>('_controladorNome', _controladorNome));
  }
}
