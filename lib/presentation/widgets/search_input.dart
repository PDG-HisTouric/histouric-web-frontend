import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final void Function(String)? onChanged;

  const SearchInput({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: TextField(
          onChanged: onChanged,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            hintTextDirection: TextDirection.ltr,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "Buscar por nombre",
            prefixIcon: Icon(
              Icons.search_outlined,
            ),
          ),
        ),
      ),
    );
  }
}
