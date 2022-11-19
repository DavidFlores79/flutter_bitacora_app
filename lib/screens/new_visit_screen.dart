import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class NewVisitScreen extends StatelessWidget {
  static const String routeName = 'newvisit';

  const NewVisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

    final Map<String, dynamic> formValues = {
      'nombreVisitante': '',
      'nombreAQuienVisita': '',
      'motivoVisita': '',
      'fechaEntrada': '',
      'fechaSalida': '',
      'imagenIdentificacion': 'imagen01.jpg',
      'placas': '',
      'tipoVehiculoId': 1,
      'userId': 1,
    };

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
              CustomInputField(
                hintText: 'Placas',
                labelText: 'Numero de Placa',
                suffixIcon: Icons.car_rental_outlined,
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
                suffixIcon: Icons.group,
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
                suffixIcon: Icons.group,
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
                suffixIcon: Icons.group,
                keyboardType: TextInputType.text,
                formProperty: 'motivoVisita',
                formValues: formValues,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomInputField(
                hintText: 'Fecha de Entrada',
                labelText: 'Fecha de Entrada',
                suffixIcon: Icons.date_range_outlined,
                keyboardType: TextInputType.datetime,
                formProperty: 'fechaEntrada',
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
                  print(value);
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
                    print('Formulario no valido');
                    return;
                  }
                  print(formValues);

                  // const nombreVisitante = "David Flores";
                  // const nombreAQuienVisita = "Glendy Perez";
                  // const motivoVisita = "Rappy";
                  // const imagenIdentificacion = "imagen01.jpg";
                  // final tipoVehiculoId = randomNumber(1, 4);
                  // const placas = "FYX-5689";
                  // final userId = randomNumber(1, 3);
                  // const fechaEntrada = "17-11-2022 10:03 PM";
                  // const fechaSalida = "";
                  const actualizado = 0;

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
                    actualizado,
                  );

                  Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                  // Navigator.pushReplacement(
                  //     context,
                  //     PageRouteBuilder(
                  //         pageBuilder:
                  //             (context, animation, secondaryAnimation) =>
                  //                 HomeScreen(),
                  //         transitionDuration: const Duration(seconds: 0)));
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
