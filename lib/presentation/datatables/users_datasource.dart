import 'package:flutter/material.dart';
import 'package:histouric_web/domain/entities/entities.dart';

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
      DataCell(Text(user.roles.toString())),
      DataCell(Row(
        children: [
          IconButton(icon: Icon(Icons.edit_outlined), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.delete_outline,
                  color: Colors.red.withOpacity(0.8)),
              onPressed: () {}),
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
