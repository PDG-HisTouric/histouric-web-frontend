import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/config.dart';
import '../../infrastructure/infrastructure.dart';
import '../blocs/blocs.dart';
import '../widgets/widgets.dart';
import '../datatables/users_data.dart';

class UsersTable extends StatelessWidget {
  const UsersTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersTableBloc(
        token: context.read<AuthBloc>().state.token!,
        userRepository: UserRepositoryImpl(
          userDatasource: UserDatasourceImpl(),
        ),
      ),
      child: const _UsersTable(),
    );
  }
}

class _UsersTable extends StatefulWidget {
  const _UsersTable();

  @override
  UsersTableState createState() => UsersTableState();
}

class UsersTableState extends State<_UsersTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final colors = Theme.of(context).colorScheme;
    final usersTableBloc = context.watch<UsersTableBloc>();
    final users = usersTableBloc.state.users;

    if (usersTableBloc.state.initializingControllers) {
      return const Center(child: CircularProgressIndicator());
    }

    if (usersTableBloc.state.nicknameController.text.isNotEmpty) {
      usersTableBloc.searchByNickname(
        //TODO: USE CONTEXT READ
        usersTableBloc.state.nicknameController.text,
      );
    } else {
      usersTableBloc.fetchUsers(); //TODO: USE CONTEXT READ
    }

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
              DataColumn(label: Text('Nombre de usuario')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Roles')),
              DataColumn(label: Text('Acciones')),
            ],
            source: UsersDTS(users ?? [], context),
            header: const Text('Listado de usuarios', maxLines: 2),
            onRowsPerPageChanged: (value) {
              setState(() {
                _rowsPerPage = value ?? 10;
              });
            },
            rowsPerPage: _rowsPerPage,
            actions: [
              Wrap(
                children: [
                  if (size.width > 600)
                    SearchInput(
                      controller: usersTableBloc.state.nicknameController,
                      onChanged: (_) {},
                    ),
                  if (size.width > 600) const SizedBox(width: 10),
                  CustomElevatedButtonRounded(
                    label: "Agregar Usuario",
                    onPressed: () {
                      NavigationService.navigateTo(
                        FluroRouterWrapper.createUser,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
