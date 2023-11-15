import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/config.dart';
import '../../domain/domain.dart';
import '../blocs/blocs.dart';

class UsersDTS extends DataTableSource {
  final List<HistouricUser> users;
  final BuildContext context;

  UsersDTS(this.users, this.context);

  @override
  DataRow getRow(int index) {
    final user = users[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(user.nickname)),
        DataCell(Text(user.email)),
        DataCell(Text(user.roles.map((role) => role.name).join(', '))),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  NavigationService.navigateTo(
                    '/dashboard/users/edit/${user.nickname}',
                  );
                },
              ),
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
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}
