import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constants/constants.dart';
import '../../domain/entities/entities.dart';
import '../../infrastructure/datasources/datasources.dart';
import '../../infrastructure/repositories/repositories.dart';
import '../blocs/blocs.dart';
import '../js_bridge/js_bridge.dart';
import '../widgets/widgets.dart';

class CreateBICView extends StatelessWidget {
  final void Function() onClosePressed;
  final void Function() goToTheBeginningOfTheForm;
  final void Function() minimizeInfoWindow;
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
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: Key('$latitude$longitude'),
      create: (context) => BicBloc(
        goToTheBeginningOfTheForm: goToTheBeginningOfTheForm,
        onClosePressed: onClosePressed,
        minimizeInfoWindow: minimizeInfoWindow,
        toggleBICCreation: toggleBICCreation,
        latitude: latitude,
        longitude: longitude,
        bicRepository: BICRepositoryImpl(bicDatasource: BICDatasourceImpl()),
        token: context.read<AuthBloc>().state.token!,
      ),
      child: const _CreateBICView(),
    );
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
              const Text('Crear Bien de Interés Cultural',
                  style: TextStyle(fontSize: 20)),
              const Spacer(),
              CloseButton(
                onPressed: context.read<BicBloc>().onClosePressed,
              )
            ],
          ),
          const FittedBox(
            child: SizedBox(
              width: 600,
              child: _Form(),
            ),
          )
        ],
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form();

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (!context.read<BicBloc>().isStateValid()) {
                      context.read<BicBloc>().goToTheBeginningOfTheForm();
                      return;
                    }
                    context.read<BicBloc>().submit().then((value) {
                      SubmissionStatus submissionStatus =
                          context.read<BicBloc>().state.status;
                      if (submissionStatus ==
                          SubmissionStatus.submissionSuccess) {
                        context.read<MapBloc>().loadBICsFromBICRepository();
                        context.read<BicBloc>().minimizeInfoWindow();
                        context.read<BicBloc>().toggleBICCreation().then(
                            (value) =>
                                context.read<BicBloc>().onClosePressed());
                        _showSnackBar(
                            context, '¡El BIC se ha creado correctamente!');
                      } else {
                        context.read<BicBloc>().onClosePressed();
                        _showSnackBar(
                            context, '¡Ha ocurrido un error al crear el BIC!');
                      }
                    });
                  },
                  child: const Text('Crear'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: context.read<BicBloc>().onClosePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Cancelar',
                      style: TextStyle(color: Colors.black)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _loadImagesFromDrive(
      void Function(HistouricImageInfo)
          functionToLoadTheImageInTheBlock) async {
    GooglePicker.callFilePicker(
      apiKey: Environment.pickerApiKey,
      appId: Environment.pickerApiAppId,
      mediaType: 'image',
    );
    _waitUntilThePickerIsOpen().then((value) {
      _waitUntilThePickerIsClosed().then((value) {
        if (!GooglePicker.callGetIsThereAnError()) {
          final imagesInfo = GooglePicker.getSelectedImagesIds();
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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
