import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/presentation/presentation.dart';

import '../../config/config.dart';
import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';
import '../blocs/blocs.dart';

class CreateBICView extends StatelessWidget {
  final void Function() onClosePressed;
  final void Function() goToTheBeginningOfTheForm;
  final void Function() minimizeInfoWindow;
  final void Function() closeAddHistoriesToBIC;
  final void Function() openAddHistoriesToBIC;
  final Future<void> Function() toggleBICCreation;
  final double latitude;
  final double longitude;

  const CreateBICView({
    super.key,
    required this.onClosePressed,
    required this.goToTheBeginningOfTheForm,
    required this.latitude,
    required this.longitude,
    required this.minimizeInfoWindow,
    required this.toggleBICCreation,
    required this.closeAddHistoriesToBIC,
    required this.openAddHistoriesToBIC,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: Key('$latitude$longitude'),
      create: (context) => BicBloc(
        historyRepository: HistoryRepositoryImpl(
          historyDatasource: HistoryDatasourceImpl(),
        ),
        goToTheBeginningOfTheForm: goToTheBeginningOfTheForm,
        onClosePressed: onClosePressed,
        minimizeInfoWindow: minimizeInfoWindow,
        toggleBICCreation: toggleBICCreation,
        latitude: latitude,
        longitude: longitude,
        closeAddHistoriesToBIC: closeAddHistoriesToBIC,
        openAddHistoriesToBIC: openAddHistoriesToBIC,
        bicRepository: BICRepositoryImpl(bicDatasource: BICDatasourceImpl()),
        // token: context.read<AuthBloc>().state.token!,
        token: '', //TODO: QUITAR
      ),
      child: const _CreateBICView(),
    );
  }
}

class _CreateBICView extends StatefulWidget {
  const _CreateBICView();

  @override
  State<_CreateBICView> createState() => _CreateBICViewState();
}

class _CreateBICViewState extends State<_CreateBICView> {
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

    return Form(
      child: Column(
        children: [
          SecondCustomTextFormField(
            labelText: 'Nombre',
            hintText: 'Ingresa el nombre del Bien de Interés Cultural',
            onChanged: context.read<BicBloc>().nameChanged,
            errorMessage: context.read<BicBloc>().state.bicName.errorMessage,
          ),
          const SizedBox(height: 16.0),
          SecondCustomTextFormField(
            labelText: 'Descripción',
            hintText: 'Ingresa la descripción del Bien de Interés Cultural',
            minLines: 3,
            maxLines: 5,
            onChanged: context.read<BicBloc>().descriptionChanged,
            errorMessage:
                context.read<BicBloc>().state.bicDescription.errorMessage,
          ),
          Row(
            children: [
              Checkbox(
                  checkColor: Colors.white,
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
              style: TextStyle(color: Colors.black),
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
                style: TextStyle(color: Colors.black),
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
    List<Story> selectedHistories =
        context.select((BicBloc bloc) => bloc.state.selectedHistories);

    return SizedBox(
      child: ListView.builder(
        itemCount: selectedHistories.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 3),
            title: BlocProvider(
              key: Key(selectedHistories[index].id),
              create: (context) => HtmlAudioOnlyWithPlayButtonBloc(
                audioUrl: selectedHistories[index].audio.audioUri,
              ),
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
    final key = UniqueKey();
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
                key: key,
                // audioUrl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
