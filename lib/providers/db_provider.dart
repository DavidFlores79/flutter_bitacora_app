import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:productos_app/models/models.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart" show join;

class DBProvider {
  static Database? _dataBase;
  static final DBProvider db = DBProvider._();
  late List<Visitas> todasVisitas = [];
  DBProvider._();

  Future<Database> get dataBase async {
    if (_dataBase != null) return _dataBase!;

    _dataBase = await initDB();

    return _dataBase!;
  }

  Future<Database> initDB() async {
    //Path de donde almacenaremos la BD
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    //crear la ruta
    final path = join(documentsDirectory.path, 'bitacoraApp.db');
    print(path);

    //crear la DB
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE visitas(
            id INTEGER PRIMARY KEY,
            nombreVisitante TEXT,
            nombreAQuienVisita TEXT,
            motivoVisita TEXT,
            imagenIdentificacion TEXT,
            tipoVehiculoId INTEGER,
            placas TEXT,
            userId INTEGER,
            fechaEntrada TEXT,
            fechaSalida TEXT,
            actualizado INTEGER
          )
        ''');
      },
    );
  }

  Future<int> nuevaVisita(Visitas visita) async {
    final nombreVisitante = visita.nombreVisitante;
    final nombreAQuienVisita = visita.nombreAQuienVisita;
    final motivoVisita = visita.motivoVisita;
    final imagenIdentificacion = visita.imagenIdentificacion;
    final tipoVehiculoId = visita.tipoVehiculoId;
    final placas = visita.placas;
    final userId = visita.userId;
    final fechaEntrada = visita.fechaEntrada;
    final fechaSalida = visita.fechaSalida;
    final actualizado = visita.actualizado;

    final db = await dataBase;

    // final res = await db.insert('visitas', visita.toMap());
    final res = await db.rawInsert(
        'INSERT INTO visitas(nombreVisitante, nombreAQuienVisita, motivoVisita, imagenIdentificacion, tipoVehiculoId, placas, userId, fechaEntrada, fechaSalida, actualizado) VALUES("$nombreVisitante","$nombreAQuienVisita","$motivoVisita","$imagenIdentificacion",$tipoVehiculoId,"$placas",$userId,"$fechaEntrada","$fechaSalida", $actualizado)');

    print('Id Registrado: $res.');

    return res;
  }

  Future<Visitas?> getRecordById(int id) async {
    final db = await dataBase;

    // Get the record by Id
    List<Map<String, dynamic>> res = await db
        .rawQuery('SELECT * FROM visitas WHERE id = ?', [(id.toString())]);

    print(res);

    return res.isNotEmpty ? Visitas.fromMap(res.first) : null;
  }

  Future<List<Visitas>?> getRecordsNotUpdated(int actualizado) async {
    final db = await dataBase;
    // Get the records that where updated
    List<Map<String, dynamic>> res = await db.rawQuery(
      'SELECT * FROM visitas WHERE actualizado = ?',
      [(actualizado.toString())],
    );
    return res.isNotEmpty ? res.map((e) => Visitas.fromMap(e)).toList() : null;
  }

  Future<List<Visitas>?> getRecords() async {
    final db = await dataBase;

    // Get all the records
    List<Map<String, dynamic>> res = await db.rawQuery('SELECT * FROM visitas');

    return res.isNotEmpty ? res.map((e) => Visitas.fromMap(e)).toList() : null;
  }

  Future<int> deleteRecord(int id) async {
    final db = await dataBase;

    // Delete the record by Id
    final count = await db
        .rawDelete('DELETE FROM visitas WHERE id = ?', [(id.toString())]);
    print('Se elimaron: $count elemento(s).');

    return count;
  }

  Future<int> deleteAllRecords() async {
    final db = await dataBase;

    // Delete the records
    final count = await db.rawDelete('DELETE FROM visitas');
    print('Se elimaron: $count elemento(s)');

    return count;
  }

  Future<List<Visitas>?> deleteAllRecordsUpdated(int actualizado) async {
    final db = await dataBase;
    // Delete the records that where updated
    List<Map<String, dynamic>> res = await db.rawQuery(
      'DELETE FROM visitas WHERE actualizado = ?',
      [(actualizado.toString())],
    );
    return res.isNotEmpty ? res.map((e) => Visitas.fromMap(e)).toList() : null;
  }
}
