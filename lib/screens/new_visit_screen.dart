import 'dart:convert';
import 'dart:typed_data';

import 'package:bitacora_app/models/models.dart';
import 'package:bitacora_app/shared/preferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:bitacora_app/providers/providers.dart';
import 'package:bitacora_app/screens/screens.dart';
import 'package:bitacora_app/services/services.dart';
import 'package:bitacora_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class NewVisitScreen extends StatefulWidget {
  static const String routeName = 'newvisit';

  NewVisitScreen({super.key});

  @override
  State<NewVisitScreen> createState() => _NewVisitScreenState();
}

class _NewVisitScreenState extends State<NewVisitScreen> {
  final ImagePicker _picker = ImagePicker();

  String base64String = "";

  ImageProvider<Object> imagenEscogida =
      const AssetImage('assets/placeholder.png');

  final Map<String, dynamic> formValues = {
    "nombreVisitante": "",
    "nombreAQuienVisita": "",
    "motivoVisita": "",
    "fechaEntrada": "",
    "fechaSalida": "",
    "imagenIdentificacion": "placeholder.png",
    "placas": "",
    "tipoVehiculoId": 1,
    "userId": 1,
  };

  void _pickImagebase64(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 25,
    );

    if (image == null) return;

    Uint8List imagebyte = await image.readAsBytes();
    base64String = base64Encode(imagebyte);
    formValues['imagenIdentificacion'] = base64String;
    setState(() {
      imagenEscogida = Image.memory(imagebyte).image;
    });
    //print(base64String);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    DateTime now = DateTime.now();
    final formatterDate = DateFormat('yyyy/MM/dd HH:mm');
    formValues['fechaEntrada'] = formatterDate.format(now).toString();
    User apiUser = User.fromJson(Preferences.apiUser);

    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Alta de Visita'),
        leading: IconButton(
            onPressed: () async {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            },
            icon: const FaIcon(FontAwesomeIcons.arrowLeft)),
        //backgroundColor: const Color.fromRGBO(35, 35, 35, 1),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Form(
          key: myFormKey,
          child: Column(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      Image(
                        width: double.infinity,
                        height: double.infinity,
                        image: imagenEscogida,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: TextButton(
                          onPressed: () => _pickImagebase64(ImageSource.camera),
                          child: const FaIcon(
                            FontAwesomeIcons.camera,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 50,
                        child: TextButton(
                          onPressed: () =>
                              _pickImagebase64(ImageSource.gallery),
                          child: const FaIcon(
                            FontAwesomeIcons.images,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomInputField(
                hintText: 'Placas',
                labelText: 'Numero de Placa',
                suffixIcon: FontAwesomeIcons.carRear,
                keyboardType: TextInputType.text,
                formProperty: 'placas',
                formValues: formValues,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomInputField(
                hintText: 'Nombre Visitante',
                labelText: 'Visitante',
                suffixIcon: FontAwesomeIcons.idCard,
                keyboardType: TextInputType.text,
                formProperty: 'nombreVisitante',
                formValues: formValues,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomInputField(
                hintText: 'A quien Visita',
                labelText: 'A quien visita',
                suffixIcon: FontAwesomeIcons.userGroup,
                keyboardType: TextInputType.text,
                formProperty: 'nombreAQuienVisita',
                formValues: formValues,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomInputField(
                hintText: 'Motivo',
                labelText: 'Motivo de la visita',
                suffixIcon: FontAwesomeIcons.solidMessage,
                keyboardType: TextInputType.text,
                formProperty: 'motivoVisita',
                formValues: formValues,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(
                height: 30,
              ),
              DropdownButtonFormField(
                value: 1,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Vehiculo')),
                  DropdownMenuItem(value: 2, child: Text('Motocicleta')),
                  DropdownMenuItem(value: 3, child: Text('Camion')),
                ],
                onChanged: (value) {
                  //print(value);
                  formValues['tipoVehiculoId'] = (value ?? 1);
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  // ignore: todo
                  // TODO: Imprimir valores del formulario
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); //ocultar el teclado del movil

                  if (!myFormKey.currentState!.validate()) {
                    //print('Formulario no valido');
                    return;
                  }
                  //print(formValues);
                  formValues['actualizado'] = 0;
                  formValues['userId'] = apiUser.id;

                  Provider.of<ListaVisitasProvider>(context, listen: false)
                      .agregarVisita(
                    formValues['nombreVisitante'],
                    formValues['nombreAQuienVisita'],
                    formValues['motivoVisita'],
                    formValues['fechaEntrada'],
                    formValues['fechaSalida'],
                    formValues['imagenIdentificacion'],
                    formValues['placas'],
                    formValues['tipoVehiculoId'],
                    formValues['userId'],
                    formValues['actualizado'],
                  );

                  // Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                },
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text('Guardar'),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
