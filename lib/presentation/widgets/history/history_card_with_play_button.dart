import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/entities.dart';
import '../../blocs/blocs.dart';
import '../audio/audio.dart';

class HistoryCardWithPlayButton extends StatelessWidget {
  final double maxWidth;
  final String historyTitle;
  final String historyId;
  final String? bicId;
  final String originOfSelectedHistories;
  final Function(String historyId) onCheckBoxChanged;
  const HistoryCardWithPlayButton({
    super.key,
    required this.maxWidth,
    required this.historyTitle,
    required this.historyId,
    required this.onCheckBoxChanged,
    required this.originOfSelectedHistories,
    this.bicId,
  });

  bool _isHistorySelected(String historyId, List<Story> histories) {
    for (Story history in histories) {
      if (history.id == historyId) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    List<Story> selectedHistories;
    switch (originOfSelectedHistories) {
      case 'searchAndSelectHistoriesView':
        selectedHistories =
            context.select((BicBloc bloc) => bloc.state.selectedHistories);
        break;
      case 'createRouteView':
        selectedHistories = [];
        Story? history = context
            .select((RouteBloc bloc) => bloc.getSelectedHistoryById(bicId!));
        if (history != null) selectedHistories.add(history);
        break;
      default:
        selectedHistories = [];
        break;
    }
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
                      onCheckBoxChanged(historyId);
                    }),
                Text(historyTitle),
                const Spacer(),
                HtmlAudioOnlyWithPlayButton(
                  audioId: context
                      .read<HtmlAudioOnlyWithPlayButtonBloc>()
                      .htmlAudioId,
                ),
              ],
            )),
      ),
    );
  }
}
