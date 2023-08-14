import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/domain/entities/entities.dart';

import '../blocs/users_table_bloc/users_table_bloc.dart';

class UsersDTS extends DataTableSource {
  final List<HistouricUser> users;
  final BuildContext context;

  UsersDTS(this.users, this.context);

  @override
  DataRow getRow(int index) {
    final user = users[index];

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(user.id)),
      DataCell(Text(user.nickname)),
      DataCell(Text(user.email)),
      DataCell(Text(user.roles.map((role) => role.name).join(', '))),
      DataCell(Row(
        children: [
          IconButton(icon: Icon(Icons.edit_outlined), onPressed: () {}),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red.withOpacity(0.8),
            ),
            onPressed: () {
              context.read<UsersTableBloc>().deleteUser(user.id);
            },
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}
