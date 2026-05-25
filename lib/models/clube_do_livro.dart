class ClubeDoLivro {
  final String id;
  final String nome;
  final String descricao;
  final String tema;
  int participantes;

  ClubeDoLivro({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.tema,
    this.participantes = 0,
  });
  factory ClubeDoLivro.fromJson(Map<String, dynamic> json) {
    return ClubeDoLivro(
      id: json['id'],
      nome: json['name'],
      descricao: json['description'] ?? "Clube sem descrição", //pode ser null
      tema: json['theme'],
    );
  }
}