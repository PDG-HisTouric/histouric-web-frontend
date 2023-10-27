import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/entities.dart';
import '../blocs/blocs.dart';
import '../widgets/widgets.dart';

class SearchAndSelectHistoriesView extends StatelessWidget {
  const SearchAndSelectHistoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    double maxWidth = 650;
    double maxHeight = 500;

    List<Story> historiesAfterSearch =
        context.select((BicBloc bloc) => bloc.state.historiesAfterSearch);
    TextEditingController historyTitleController =
        context.select((BicBloc bloc) => bloc.state.historyTitleController);
    bool isSearchingHistories =
        context.select((BicBloc bloc) => bloc.state.isSearchingHistories);

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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width < maxWidth
                          ? MediaQuery.sizeOf(context).width - 80
                          : maxWidth - 80,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SecondCustomTextFormField(
                          controller: historyTitleController,
                          minLines: 1,
                          maxLines: 1,
                          labelText: 'Buscar historia por título',
                          prefixIcon: const Icon(Icons.search),
                          onChanged:
                              context.read<BicBloc>().changeTitleForSearchQuery,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        width: 40,
                        child: IconButton(
                          onPressed:
                              context.read<BicBloc>().closeHistoriesAddition,
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: isSearchingHistories
                      ? const Column(
                          children: [
                            Spacer(),
                            CircularProgressIndicator(),
                            Spacer(),
                          ],
                        )
                      : SizedBox(
                          child: ListView.builder(
                            itemCount: historiesAfterSearch.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                title: BlocProvider(
                                  create: (context) =>
                                      HtmlAudioOnlyWithPlayButtonBloc(
                                    idPrefix: "audio-after-search",
                                    audioUrl: historiesAfterSearch[index]
                                        .audio
                                        .audioUri,
                                  ),
                                  child: _HistoryCard(
                                    historyId: historiesAfterSearch[index].id,
                                    maxWidth: maxWidth,
                                    historyTitle:
                                        historiesAfterSearch[index].title,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    children: [
                      ElevatedButton(
                        onPressed: context.read<BicBloc>().addSelectedHistories,
                        child: const Text('Agregar historias seleccionadas'),
                      ),
                      const SizedBox(width: 16.0),
                      ElevatedButton(
                        onPressed:
                            context.read<BicBloc>().cancelHistoriesAddition,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final double maxWidth;
  final String historyTitle;
  final String historyId;
  const _HistoryCard({
    required this.maxWidth,
    required this.historyTitle,
    required this.historyId,
  });

  bool _isHistorySelected(String historyId, List<Story> histories) {
    for (Story history in histories) {
      if (history.id == historyId) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    List<Story> selectedHistories =
        context.select((BicBloc bloc) => bloc.state.selectedHistories);
    bool selected = _isHistorySelected(historyId, selectedHistories);
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
                    value: selected,
                    onChanged: (value) {
                      context.read<BicBloc>().checkHistory(historyId);
                    }),
                Text(historyTitle),
                const Spacer(),
                HtmlAudioOnlyWithPlayButton(
                  audioId: context
                      .read<HtmlAudioOnlyWithPlayButtonBloc>()
                      .getAudioId(),
                ),
              ],
            )),
      ),
    );
  }
}
