import 'package:flutter/material.dart';
import 'package:histouric_web/presentation/presentations.dart';

import '../datatables/users_datasource.dart';

class UsersTable extends StatefulWidget {
  const UsersTable({super.key});

  @override
  UsersTableState createState() => UsersTableState();
}

class UsersTableState extends State<UsersTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();

    //TODO HACER CONSULTA DE USUARIOS CON BLOC
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "Usuarios",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.onPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: PaginatedDataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Nombre de usuario')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Roles')),
              DataColumn(label: Text('Acciones')),
            ],
            source: UsersDTS([], context),
            header: const Text('Listado de usuarios', maxLines: 2),
            onRowsPerPageChanged: (value) {
              setState(() {
                _rowsPerPage = value ?? 10;
              });
            },
            rowsPerPage: _rowsPerPage,
            actions: [
              CustomElevatedButtonRounded(
                label: "Agregar Usuario",
                onPressed: () {
                  //TODO LLEVAR A PANTALLA DE CREAR USUARIO
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
