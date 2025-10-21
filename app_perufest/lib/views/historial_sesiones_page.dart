import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/historial_sesion.dart';
import '../services/historial_sesion_service.dart';
import '../services/autenticacion_service.dart';

class HistorialSesionesPage extends StatefulWidget {
  const HistorialSesionesPage({Key? key}) : super(key: key);

  @override
  State<HistorialSesionesPage> createState() => _HistorialSesionesPageState();
}

class _HistorialSesionesPageState extends State<HistorialSesionesPage> {
  final HistorialSesionService _historialService = HistorialSesionService();
  String _userId = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Inicializar en el siguiente frame para que el contexto esté disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _obtenerUserId();
    });
  }

  void _obtenerUserId() {
    // Obtener el ID del usuario actual desde el argumento de la ruta
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['userId'] != null) {
      _userId = args['userId'].toString();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Inicios de Sesión'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userId.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Usuario no encontrado',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : StreamBuilder<List<HistorialSesion>>(
                  stream: _historialService.streamHistorialUsuario(_userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error al cargar el historial',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    final historial = snapshot.data ?? [];

                    if (historial.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No hay historial de inicios de sesión',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Los nuevos inicios de sesión aparecerán aquí',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          color: Colors.green.shade50,
                          child: Text(
                            'Total de inicios de sesión: ${historial.length}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: historial.length,
                            itemBuilder: (context, index) {
                              final sesion = historial[index];
                              return _buildHistorialItem(sesion, index);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }

  Widget _buildHistorialItem(HistorialSesion sesion, int index) {
    final formatoFecha = DateFormat('dd/MM/yyyy', 'es_ES');
    final formatoHora = DateFormat('HH:mm:ss', 'es_ES');
    final esHoy = _esHoy(sesion.fechaHora);
    final esAyer = _esAyer(sesion.fechaHora);
    
    String fechaTexto;
    if (esHoy) {
      fechaTexto = 'Hoy';
    } else if (esAyer) {
      fechaTexto = 'Ayer';
    } else {
      fechaTexto = formatoFecha.format(sesion.fechaHora);
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: index == 0
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green.shade50,
                    Colors.white,
                  ],
                )
              : null,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            backgroundColor: index == 0 ? Colors.green : Colors.green.shade300,
            radius: 24,
            child: Icon(
              Icons.login,
              color: Colors.white,
              size: index == 0 ? 24 : 20,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  'Usuario: ${sesion.usuario}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: index == 0 ? 16 : 15,
                  ),
                ),
              ),
              if (index == 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Más reciente',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Fecha: $fechaTexto',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Hora: ${formatoHora.format(sesion.fechaHora)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'IP: ${sesion.ipAddress}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _esHoy(DateTime fecha) {
    final hoy = DateTime.now();
    return fecha.year == hoy.year &&
           fecha.month == hoy.month &&
           fecha.day == hoy.day;
  }

  bool _esAyer(DateTime fecha) {
    final ayer = DateTime.now().subtract(const Duration(days: 1));
    return fecha.year == ayer.year &&
           fecha.month == ayer.month &&
           fecha.day == ayer.day;
  }
}