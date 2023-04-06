import 'package:MultiToolsApp/database/contatodao.dart';
import 'package:flutter/material.dart';
import 'package:MultiToolsApp/database/contatodao.dart';
import 'package:MultiToolsApp/models/contato.dart';
import 'formcontato.dart';

class ListaContato extends StatefulWidget {
  final List<Contato> _contatos = [];

  @override
  State<StatefulWidget> createState() {
    return ListaContatoState();
  }
}

class ListaContatoState extends State<ListaContato> {
  final ContatoDao _dao = ContatoDao();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.transparent,
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
          title: Text("Lista de Contatos"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("clicou no botão flutuante");
            final Future future =
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FormContato();
            }));
            future.then((contato) {
              /// voltou do form com um objeto compra
              /// add na lista de compras
              ///widget._compras.add(compra);
              setState(() {});
            }); // push
          }, //onpressed
          child: Icon(Icons.add),
        ),
        body: FutureBuilder<List<Contato>>(
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
                  final List<Contato>? contatos = snapshot.data;
                  return ListView.builder(
                      itemCount: contatos!.length,
                      itemBuilder: (context, index) {
                        final Contato contato = contatos![index];
                        return ItemContato(context, contato);
                      });
                }
                break;

              default:
                return Center(child: Text("Nenhum contato!"));
            //break;
            }
            return Center(child: Text("Carregando contatos..."));
          },
        ));
  }

  Widget ItemContato(BuildContext context, Contato _contato) {
    return GestureDetector(
      onTap: () {
        final Future future =
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FormContato(contato: _contato);
        }));
        future.then((value) => setState(() {}));
      },
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.fastfood),
          title: Text(_contato.nome),
          subtitle: Text("\nTelefone: " + _contato.telefone + "\nEmail: " + _contato.email + "\nLocal: " + _contato.local),
          trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget> [
                GestureDetector(
                  onTap: (){
                    //_excluir(context, _compra.id);
                    showAlertDialog(context, _contato);
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

  showAlertDialog(BuildContext context, Contato _contato) {
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
        _excluir(context, _contato.id);
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

