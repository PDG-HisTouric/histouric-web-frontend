import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/infrastructure/datasource/spring_boot_user_datasource.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';
import 'package:histouric_web/presentation/presentations.dart';

import '../../infrastructure/repositories/repositories.dart';
import '../datatables/users_datasource.dart';

class UsersTable extends StatelessWidget {
  const UsersTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UsersTableBloc(
              token: context.read<AuthBloc>().state.token!,
              userRepository: UserRepositoryImpl(
                userDatasource: SpringBootUserDatasource(),
              ),
            ),
        child: const _UsersTable());
  }
}

class _UsersTable extends StatefulWidget {
  const _UsersTable({super.key});

  @override
  UsersTableState createState() => UsersTableState();
}

class UsersTableState extends State<_UsersTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
    context.read<UsersTableBloc>().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final users = context.watch<UsersTableBloc>().state.users;

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
            source: UsersDTS(users, context),
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
