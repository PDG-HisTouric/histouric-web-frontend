import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/config/navigation/navigation_service.dart';
import 'package:histouric_web/domain/entities/entities.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';

class UsersDTS extends DataTableSource {
  final List<HistouricUser> users;
  final BuildContext context;
  final Function() onPressedEditButton;

  UsersDTS(this.users, this.context, this.onPressedEditButton);

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
          IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                NavigationService.navigatorKey.currentState!
                    .pushNamed('/dashboard/users/edit/${user.nickname}');
                //     .then((value) {
                //   context.read<UsersTableBloc>().initPageReloaded();
                // });
              }),
          IconButton(
              icon: Icon(Icons.delete_outline,
                  color: Colors.red.withOpacity(0.8)),
              onPressed: () {
                context.read<UsersTableBloc>().fetchUsers();
              }),
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
