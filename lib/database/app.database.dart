import 'package:MultiToolsApp/database/contatodao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:MultiToolsApp/database/tarefadao.dart';

 const String tableSQL = 'CREATE TABLE tarefas ('
    'id INTEGER PRIMARY KEY,'
    'descricao TEXT, '
    'obs TEXT)';

const String tableSQL1 = 'CREATE TABLE contatos ('
    'id INTEGER PRIMARY KEY,'
    'nome TEXT, '
    'telefone TEXT, '
    'email TEXT, '
    'local TEXT)';

  Future<Database> getDatabase() async {
    final String path = join(await getDatabasesPath(), 'dbtarefas.db');
    return openDatabase(path,
        onCreate: (db, version) {
          db.execute(TarefaDao.tableSQL);
          db.execute(ContatoDao.tableSQL1);
        },
        onUpgrade: (db, oldVersion, newVersion) async{
          var batch = db.batch();
          print("Versão antiga: " + oldVersion.toString());
          print("Versão nova: " + newVersion.toString());

          if (newVersion == 2){
            //batch.execute(tableSql2);
            //trocar a versão da DB para 2 para poder gerar a tabela de compras
            batch.execute(tableSQL1);
          }
          await batch.commit();
        },
        version: 2,
        onDowngrade: onDatabaseDowngradeDelete
    );
  }
