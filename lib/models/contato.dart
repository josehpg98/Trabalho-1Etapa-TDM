class Contato {
  final int id;
  final String nome;
  final String telefone;
  final String email;
  final String local;


  Contato(this.id, this.nome, this.telefone, this.email, this.local);

  @override
  String toString() {
    return 'Contato(id: $id, nome: $nome, telefone: $telefone, email: $email, local: $local)';
  }
}