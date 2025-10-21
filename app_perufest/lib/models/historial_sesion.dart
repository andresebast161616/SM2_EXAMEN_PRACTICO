class HistorialSesion {
  final String id;
  final String userId;
  final String usuario;
  final DateTime fechaHora;
  final String ipAddress;

  HistorialSesion({
    required this.id,
    required this.userId,
    required this.usuario,
    required this.fechaHora,
    required this.ipAddress,
  });

  factory HistorialSesion.fromMap(Map<String, dynamic> map, String id) {
    return HistorialSesion(
      id: id,
      userId: map['userId'] ?? '',
      usuario: map['usuario'] ?? '',
      fechaHora: DateTime.parse(map['fechaHora']),
      ipAddress: map['ipAddress'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'usuario': usuario,
      'fechaHora': fechaHora.toIso8601String(),
      'ipAddress': ipAddress,
    };
  }
}