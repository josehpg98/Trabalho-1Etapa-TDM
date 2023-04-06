class Tarefa {
  final int id;
  final String descricao;
  final String obs;

  Tarefa(this.id, this.descricao, this.obs);

  @override
  String toString() {
    return 'Tarefa(id: $id, descricao: $descricao, obs: $obs)';
  }
}