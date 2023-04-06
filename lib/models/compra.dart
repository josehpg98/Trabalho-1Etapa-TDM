class Compra {
  final int id;
  final String nome;
  final String quantidade;
  final String fabricante;
  final String local;


  Compra(this.id, this.nome, this.quantidade, this.fabricante, this.local);

  @override
  String toString() {
    return 'Compra(id: $id, nome: $nome, quantidade: $quantidade, fabricante: $fabricante, local: $local)';
  }
}