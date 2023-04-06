import 'package:flutter/material.dart';
import '../components/editor.dart';
import '../database/compradao.dart';
import '../models/compra.dart';
import 'package:flutter/services.dart';

class FormCompra extends StatefulWidget {
  final Compra? compra; //? pode receber valor nulo
  static const List<String> lista = <String>['teste', 'Two', 'Three', 'Four'];

  FormCompra({this.compra}); // {} significa que a compra é opcional

  @override
  State<StatefulWidget> createState() {
    return FormCompraState();
  }
}

class FormCompraState extends State<FormCompra> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorQuantidade = TextEditingController();
  final TextEditingController _controladorFabricante = TextEditingController();
  final TextEditingController _controladorLocal = TextEditingController();
  int check = 0;
  int? _id; //pode conter valor nulo
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

    final String text = _controladorQuantidade.text;

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
    _controladorQuantidade.dispose();
    _controladorFabricante.dispose();
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
                  Colors.red,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: const Text("Form Compra"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            criarCompra(context);
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
              Text('Trabalho de TDM - 03/04/2023'),
              //Editor(_controladorNome, "Nome", "Informe o nome do produto", Icons.emoji_food_beverage),
              //Editor(_controladorQuantidade, "Quantidade", "Informe a quantidade", Icons.shopping_basket),
              //Editor(_controladorFabricante, "Fabricante", "Informe o fabricante", Icons.person),
              //Editor(_controladorLocal, "Local", "Informe o local", Icons.store),

              Container(

              ),
              TextFormField(
                style: TextStyle(
                  fontSize: 25.0,
                  //color: Colors.blueAccent,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo não pode ser vazio';
                  }
                  return null;
                },
                controller: _controladorNome,
                decoration: InputDecoration(
                  icon: new Icon(Icons.emoji_food_beverage),
                  labelText: 'Nome',
                  hintText: 'Informe o nome do produto',
                  //errorText: _errorText,
                ),
              ),

              TextFormField(
                style: TextStyle(
                  fontSize: 25.0,
                  //color: Colors.blueAccent,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo não pode ser vazio';
                  }
                  return null;
                },
                inputFormatters: <TextInputFormatter>[
                  // for below version 2 use this
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                  FilteringTextInputFormatter.digitsOnly

                ],
                keyboardType: TextInputType.number,
                controller: _controladorQuantidade,
                decoration: InputDecoration(
                  icon: new Icon(Icons.shopping_basket),
                  labelText: 'Quantidade',
                  hintText: 'Informe a quantidade',
                ),
              ),

              TextFormField(
                style: TextStyle(
                  fontSize: 25.0,
                  //color: Colors.blueAccent,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo não pode ser vazio';
                  }
                  return null;
                },
                controller: _controladorFabricante,
                decoration: InputDecoration(
                  icon: new Icon(Icons.person),
                  labelText: 'Fabricante',
                  hintText: 'Informe o fabricante',
                ),
              ),

              TextFormField(
                style: TextStyle(
                  fontSize: 25.0,
                  //color: Colors.blueAccent,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo não pode ser vazio';
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

  void criarCompra(BuildContext context) {
    CompraDao _dao = CompraDao();
    if (_id != null) {
      //entramos em uma alteração

      final compra = Compra(
          _id!,//! garante que o valor não é nulo
          _controladorNome.text,
          _controladorQuantidade.text,
          _controladorFabricante.text,
          _controladorLocal.text);
      print("Compra criada: " + compra.toString());
      _dao.update(compra).then((id) {
       _mensagem(context, "Compra alterada com sucesso");
        Navigator.pop(context);
      });
    } else {
      //entramos em uma inclusão

      final compra = Compra(
          0,
          _controladorNome.text,
          _controladorQuantidade.text,
          _controladorFabricante.text,
          _controladorLocal.text);
      print("Compra criada: " + compra.toString());
      _dao.save(compra).then((id) {
        _mensagem(context, "Compra adicionada com sucesso");
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    super.initState(); //executa a instrução padrão do método initState
    if (widget.compra != null) {
      // alteração
      _id = widget.compra!.id;
      _controladorNome.text = widget.compra!.nome;
      _controladorQuantidade.text = widget.compra!.quantidade;
      _controladorFabricante.text = widget.compra!.fabricante;
      _controladorLocal.text = widget.compra!.local;
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


