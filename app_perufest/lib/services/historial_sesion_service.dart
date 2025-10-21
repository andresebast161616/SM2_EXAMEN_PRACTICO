import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/historial_sesion.dart';
import 'ip_service.dart';

class HistorialSesionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'historial_sesiones_exaFloresM';

  // Registrar inicio de sesión
  Future<void> registrarInicioSesion({
    required String userId,
    required String usuario,
  }) async {
    try {
      final ipAddress = await IpService.obtenerIpPublica();
      
      final historial = HistorialSesion(
        id: '',
        userId: userId,
        usuario: usuario,
        fechaHora: DateTime.now(),
        ipAddress: ipAddress,
      );

      await _firestore.collection(_collection).add(historial.toMap());
      
      if (kDebugMode) {
        debugPrint('Inicio de sesión registrado para: $usuario');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error registrando inicio de sesión: $e');
      }
    }
  }

  // Obtener historial de un usuario
  Future<List<HistorialSesion>> obtenerHistorialUsuario(String userId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('fechaHora', descending: true)
          .get();

      return query.docs.map((doc) => 
          HistorialSesion.fromMap(doc.data(), doc.id)
      ).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error obteniendo historial: $e');
      }
      return [];
    }
  }

  // Stream para historial en tiempo real
  Stream<List<HistorialSesion>> streamHistorialUsuario(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('fechaHora', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HistorialSesion.fromMap(doc.data(), doc.id))
            .toList());
  }
}