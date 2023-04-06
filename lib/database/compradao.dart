import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'app.database.dart';
import '../models/compra.dart';


class CompraDao{

  static const String tableSQL = 'CREATE TABLE compras ('
      'id INTEGER PRIMARY KEY,'
      'nome TEXT, '
      'quantidade TEXT, '
      'fabricante TEXT, '
      'local TEXT)';
  static const String _tableName = "compras";
  static const String _id = 'id';
  static const String _nome = 'nome';
  static const String _quantidade = 'quantidade';
  static const String _fabricante = 'fabricante';
  static const String _local = 'local';


  Map<String, dynamic> toMap(Compra compra){
    final Map<String, dynamic> compraMap = Map();
    compraMap[_nome] = compra.nome;
    compraMap[_quantidade] = compra.quantidade;
    compraMap[_fabricante] = compra.fabricante;
    compraMap[_local] = compra.local;
    return compraMap;

  }

  Future<int> save(Compra compra) async{
    final Database db = await getDatabase();
    Map<String, dynamic> compraMap = toMap(compra);
    return db.insert(_tableName, compraMap);
  }

  Future<int> update(Compra compra) async{
    final Database db = await getDatabase();
    Map<String, dynamic> compraMap = toMap(compra);
    return db.update(_tableName, compraMap, where: 'id =  ? ',
    whereArgs: [compra.id]);
  }

  Future<int> delete(int id) async{
    final Database db = await getDatabase();
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  List<Compra> toList(List<Map<String, dynamic>> result){
    final List<Compra> compras = [];
    for(Map<String, dynamic> row in result){
      final Compra compra = Compra(
        row[_id],
        row[_nome],
        row[_quantidade],
        row[_fabricante],
        row[_local],
      );
      compras.add(compra);
    }
    return compras;
  }

  Future<List<Compra>> findAll() async{
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query((_tableName));
    List<Compra> compras = toList(result);
    return compras;
  }
}