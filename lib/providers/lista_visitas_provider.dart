import 'package:flutter/material.dart';
import 'package:bitacora_app/models/models.dart';
import 'package:bitacora_app/providers/providers.dart';

class ListaVisitasProvider extends ChangeNotifier {
  List<Visitas> listaDeVisitas = [];

  final nuevaVisita = Visitas(
    nombreVisitante: 'David Flores3',
    nombreAQuienVisita: 'Glendy Perez3',
    motivoVisita: 'Albañil',
    fechaEntrada: '17-11-2022 10:30 PM',
    fechaSalida: '',
    imagenIdentificacion: 'imagen01.jpg',
    placas: 'YHN-4589',
    tipoVehiculoId: 1,
    userId: 1,
    actualizado: 0,
  );

  agregarVisita(
      String nombreVisitante,
      String nombreAQuienVisita,
      String motivoVisita,
      String fechaEntrada,
      String fechaSalida,
      String imagenIdentificacion,
      String placas,
      int tipoVehiculoId,
      int userId,
      int actualizado) async {
    final nuevaVisita = Visitas(
        nombreVisitante: nombreVisitante,
        nombreAQuienVisita: nombreAQuienVisita,
        motivoVisita: motivoVisita,
        imagenIdentificacion: imagenIdentificacion,
        tipoVehiculoId: tipoVehiculoId,
        placas: placas,
        userId: userId,
        fechaEntrada: fechaEntrada,
        fechaSalida: fechaSalida,
        actualizado: actualizado);

    final id = await DBProvider.db.nuevaVisita(nuevaVisita);

    nuevaVisita.id = id;

    listaDeVisitas.add(nuevaVisita);
    notifyListeners();
  }

  listarVisitas() async {
    final lista = await DBProvider.db.getRecords();
    listaDeVisitas = [...?lista];
    notifyListeners();
  }

  listarVisitasNoSincronizadas() async {
    final lista = await DBProvider.db.getRecordsNotUpdated(0);
    listaDeVisitas = [...?lista];
    notifyListeners();
  }

  listarVisitasSincronizadas() async {
    final lista = await DBProvider.db.getRecordsNotUpdated(1);
    listaDeVisitas = [...?lista];
    notifyListeners();
  }

  eliminarVisitaPorId(int id) async {
    await DBProvider.db.deleteRecord(id);
    listarVisitas; //ya se notifica en este metodo
  }

  actualizarSalida(int id) async {
    await DBProvider.db.checkOutDate(id);
    listarVisitas; //ya se notifica en este metodo
  }

  eliminarVisitasSincronizadas() async {
    final lista = await DBProvider.db.deleteAllRecordsUpdated(1);
    listaDeVisitas = [...?lista];
    notifyListeners();
  }

  eliminarTodasLasVisitas() async {
    await DBProvider.db.deleteAllRecords();
    listaDeVisitas = [];
    notifyListeners();
  }
}
