import 'package:MultiToolsApp/database/compradao.dart';
import 'package:flutter/material.dart';
import 'package:MultiToolsApp/database/compradao.dart';
import '../models/compra.dart';
import 'formcompra.dart';

class ListaCompra extends StatefulWidget {
  final List<Compra> _compras = [];

  @override
  State<StatefulWidget> createState() {
    return ListaCompraState();
  }
}


class ListaCompraState extends State<ListaCompra> {
  final CompraDao _dao = CompraDao();

  @override
  Widget build(BuildContext context) {
    // widget._compras.add(Compra("aa", 'aa'));
    // widget._compras.add(Compra("bb", 'cc'));

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
              return FormCompra();
            }));
            future.then((compra) {
              /// voltou do form com um objeto compra
              /// add na lista de compras
              ///widget._compras.add(compra);
              setState(() {});
            }); // push
          }, //onpressed
          child: Icon(Icons.add),
        ),
        body: FutureBuilder<List<Compra>>(
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
                  final List<Compra>? compras = snapshot.data;
                  return ListView.builder(
                      itemCount: compras!.length,
                      itemBuilder: (context, index) {
                        final Compra compra = compras![index];
                        return ItemCompra(context, compra);
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

  Widget ItemCompra(BuildContext context, Compra _compra) {
    return GestureDetector(
      onTap: () {
        final Future future =
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FormCompra(compra: _compra);
        }));
        future.then((value) => setState(() {}));
      },
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.fastfood),
          title: Text(_compra.nome),
          subtitle: Text("Quantidade: " + _compra.quantidade + "\nFabricante: " + _compra.fabricante + "\nLocal: " + _compra.local),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget> [
              GestureDetector(
                onTap: (){
                  //_excluir(context, _compra.id);
                  showAlertDialog(context, _compra);
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

  showAlertDialog(BuildContext context, Compra _compra) {
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
        _excluir(context, _compra.id);
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

