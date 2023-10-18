import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/presentation/blocs/bic_bloc/bic_bloc.dart';

import '../widgets/widgets.dart';

class SearchAndSelectHistoriesView extends StatelessWidget {
  const SearchAndSelectHistoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    double maxWidth = 650;
    double maxHeight = 500;

    return Center(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width < maxWidth
            ? MediaQuery.sizeOf(context).width
            : maxWidth,
        height: MediaQuery.sizeOf(context).height < maxHeight
            ? MediaQuery.sizeOf(context).height
            : maxHeight,
        child: Card(
          elevation: 5.0,
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                      onPressed: context.read<BicBloc>().closeAddHistoriesToBIC,
                      icon: const Icon(Icons.close_rounded)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SecondCustomTextFormField(
                  minLines: 1,
                  maxLines: 1,
                  labelText: 'Buscar historia por nombre',
                  prefixIcon: const Icon(Icons.search),
                  onChanged: (text) {},
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 3),
                        title: _HistoryCard(maxWidth: maxWidth),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final double maxWidth;
  const _HistoryCard({super.key, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width < maxWidth
          ? MediaQuery.sizeOf(context).width
          : maxWidth,
      child: Card(
        elevation: 5.0,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Checkbox(
                    checkColor: Colors.white,
                    value: true,
                    onChanged: (value) {
                      // context.read<BicBloc>().existsChanged();
                    }),
                const Text("Título de la historia"),
                const Spacer(),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.play_arrow)),
              ],
            )),
      ),
    );
  }
}
