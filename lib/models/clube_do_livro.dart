class ClubeDoLivro {
  final String id;
  final String nome;
  final String descricao;
  final String tema;
  final String? creatorId;
  int participantes;
  String datas;

  ClubeDoLivro({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.tema,
    this.creatorId,
    this.participantes = 0,
    this.datas = 'Sem datas definidas',
  });
  factory ClubeDoLivro.fromJson(Map<String, dynamic> json) {
    return ClubeDoLivro(
      id: json['id'],
      nome: json['name'],
      
      descricao: json['description']?.isEmpty == true || json['description'] == null
        ? 'Clube sem descrição'
        : json['description'], //pode ser null

      tema: json['theme'],
      creatorId: json['creatorId']?.toString(),
    );
  }
}