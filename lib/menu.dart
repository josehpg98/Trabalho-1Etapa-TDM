import 'package:flutter/material.dart';
import 'package:MultiToolsApp/screens/listcontato.dart';
import 'package:MultiToolsApp/screens/formcontato.dart';
import 'package:MultiToolsApp/screens/form.dart';
import 'package:MultiToolsApp/screens/list.dart';


class MenuOptions extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MenuOptionsState();
  }
}

class MenuOptionsState extends State<MenuOptions>{
  int paginaAtual = 0;
  PageController? pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina){
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          ListaTarefa(),
          ListaContato(),

        ],
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: paginaAtual,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.access_alarm),
              label: "Tarefas"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket),
              label : "Contatos"),


        ],
        onTap: (pagina) {
          pc?.animateToPage(pagina, duration:
          const Duration(milliseconds: 250), curve: Curves.ease);
        },
        backgroundColor: Colors.green,
      ),
    );
  }
}