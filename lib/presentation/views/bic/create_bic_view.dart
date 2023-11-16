import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/presentation/presentation.dart';
import 'package:uuid/uuid.dart';

import '../../../config/config.dart';
import '../../../domain/domain.dart';
import '../../blocs/blocs.dart';

class CreateBICView extends StatelessWidget {
  const CreateBICView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CreateBICView();
  }
}

class _CreateBICView extends StatelessWidget {
  const _CreateBICView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Crear Bien de Interés Cultural',
                style: TextStyle(fontSize: 20),
              ),
              const Spacer(),
              CloseButton(
                onPressed: context.read<BicBloc>().onClosePressed,
              )
            ],
          ),
          const FittedBox(child: SizedBox(width: 600, child: _Form())),
        ],
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  @override
  Widget build(BuildContext context) {
    final formState = context.watch<BicBloc>().state;
    final colors = Theme.of(context).colorScheme;

    return Form(
      child: Column(
        children: [
          SecondCustomTextFormField(
            labelText: 'Nombre',
            hintText: 'Ingrese el nombre del Bien de Interés Cultural',
            onChanged: context.read<BicBloc>().nameChanged,
            errorMessage: context.read<BicBloc>().state.bicName.errorMessage,
          ),
          const SizedBox(height: 16.0),
          SecondCustomTextFormField(
            labelText: 'Descripción',
            hintText: 'Ingrese la descripción del Bien de Interés Cultural',
            minLines: 3,
            maxLines: 5,
            onChanged: context.read<BicBloc>().descriptionChanged,
            errorMessage:
                context.read<BicBloc>().state.bicDescription.errorMessage,
          ),
          Row(
            children: [
              Checkbox(
                  value: formState.exists,
                  onChanged: (value) {
                    context.read<BicBloc>().existsChanged();
                  }),
              const Text('El Bien de Interés Cultural existe'),
            ],
          ),
          const SizedBox(height: 16.0),
          if (formState.driveImagesInfo.isEmpty)
            const Text(
              'No hay imágenes seleccionadas',
            ),
          if (formState.driveImagesInfo.isNotEmpty)
            ImageCarousel(imagesInfo: formState.driveImagesInfo),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _loadImagesFromDrive(
                context.read<BicBloc>().driveImageInfoAdded,
              );
            },
            child: const Text('Agregar fotos desde Google Drive'),
          ),
          const SizedBox(height: 16.0),
          const _AddHistories(),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                ElevatedButton(
                  onPressed: () => _createHistory(context),
                  child: const Text('Crear'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: context.read<BicBloc>().onClosePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.secondary,
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: colors.onSecondary),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _createHistory(BuildContext context) {
    if (!context.read<BicBloc>().isStateValid()) {
      context.read<BicBloc>().goToTheBeginningOfTheForm();
      return;
    }
    context.read<BicBloc>().submit().then((value) {
      SubmissionStatus submissionStatus = context.read<BicBloc>().state.status;
      if (submissionStatus == SubmissionStatus.submissionSuccess) {
        context.read<MapBloc>().loadBICsFromBICRepository();
        context.read<BicBloc>().minimizeInfoWindow();
        context
            .read<BicBloc>()
            .toggleBICCreation()
            .then((value) => context.read<BicBloc>().onClosePressed());
        SnackBars.showInfoSnackBar(
          context,
          '¡El BIC se ha creado correctamente!',
        );
      } else {
        context.read<BicBloc>().onClosePressed();
        SnackBars.showInfoSnackBar(
          context,
          '¡Ha ocurrido un error al crear el BIC!',
        );
      }
    });
  }

  void _loadImagesFromDrive(
    void Function(HistouricImageInfo) functionToLoadTheImageInTheBlock,
  ) async {
    GooglePicker.callFilePicker(
      apiKey: Environment.pickerApiKey,
      appId: Environment.pickerApiAppId,
      mediaType: MediaType.image,
    );
    _waitUntilThePickerIsOpen().then((value) {
      _waitUntilThePickerIsClosed().then((value) {
        if (!GooglePicker.callGetIsThereAnError()) {
          final imagesInfo = GooglePicker.getInfoOfSelectedImages();
          for (var imageInfo in imagesInfo) {
            functionToLoadTheImageInTheBlock(imageInfo);
          }
        }
      });
    });
  }

  Future<void> _waitUntilThePickerIsOpen() async {
    while (!GooglePicker.callGetIsThereAnError() &&
        !GooglePicker.callGetIsPickerOpen()) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> _waitUntilThePickerIsClosed() async {
    while (GooglePicker.callGetIsPickerOpen()) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
}

class _AddHistories extends StatelessWidget {
  const _AddHistories();

  @override
  Widget build(BuildContext context) {
    List<Story> selectedHistories =
        context.select((BicBloc bloc) => bloc.state.selectedHistories);

    return Column(
      children: [
        (selectedHistories.isEmpty)
            ? const Text(
                'No hay historias añadidas',
              )
            : const _SelectedHistories(),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: context.read<BicBloc>().openAddHistoriesToBIC,
          child: const Text('Añadir historias'),
        ),
      ],
    );
  }
}

class _SelectedHistories extends StatelessWidget {
  const _SelectedHistories();

  @override
  Widget build(BuildContext context) {
    double maxWidth = 600;
    double maxHeight = 260;
    List<Story> selectedHistories =
        context.select((BicBloc bloc) => bloc.state.selectedHistories);

    return SizedBox(
      height: (selectedHistories.length > 3)
          ? maxHeight
          : selectedHistories.length * 80,
      width: MediaQuery.sizeOf(context).width < maxWidth
          ? MediaQuery.sizeOf(context).width
          : maxWidth,
      child: ListView.builder(
        itemCount: selectedHistories.length,
        itemBuilder: (context, index) {
          //The height of each ListTile is 80
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 3),
            title: BlocProvider(
              create: (context) {
                const uuid = Uuid();
                final htmlAudioId = uuid.v4();
                return HtmlAudioOnlyWithPlayButtonBloc(
                  htmlAudioId: htmlAudioId,
                  audioUrl: selectedHistories[index].audio.audioUri,
                );
              },
              child: _HistoryCard(
                historyId: selectedHistories[index].id,
                maxWidth: maxWidth,
                historyTitle: selectedHistories[index].title,
              ),
            ),
          );
        },
      ),
    );
  }
}

//TODO: Use the HistoryCardWithPlayButton widget instead
class _HistoryCard extends StatelessWidget {
  final double maxWidth;
  final String historyTitle;
  final String historyId;
  const _HistoryCard({
    required this.maxWidth,
    required this.historyTitle,
    required this.historyId,
  });

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
              Text(historyTitle),
              const Spacer(),
              HtmlAudioOnlyWithPlayButton(
                audioId:
                    context.read<HtmlAudioOnlyWithPlayButtonBloc>().htmlAudioId,
              ),
              IconButton(
                onPressed: () {
                  context.read<BicBloc>().removeHistory(historyId);
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
