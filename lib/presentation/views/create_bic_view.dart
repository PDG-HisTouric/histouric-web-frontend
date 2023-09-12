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
  final void Function()? onClosePressed;
  final void Function() goToTheBeginningOfTheForm;

  const CreateBICView({
    super.key,
    required this.onClosePressed,
    required this.goToTheBeginningOfTheForm,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BicBloc(
        bicRepository: BICRepositoryImpl(bicDatasource: BICDatasourceImpl()),
        token: context.read<AuthBloc>().state.token!,
      ),
      child: _CreateBICView(
        onClosePressed: onClosePressed,
        goToTheBeginningOfTheForm: goToTheBeginningOfTheForm,
      ),
    );
  }
}

class _CreateBICView extends StatelessWidget {
  const _CreateBICView({
    required this.onClosePressed,
    required this.goToTheBeginningOfTheForm,
  });

  final void Function()? onClosePressed;
  final void Function() goToTheBeginningOfTheForm;

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
                onPressed: onClosePressed,
              )
            ],
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: size.width * 0.3),
          //   child: _Form(),
          // ),
          FittedBox(
            child: SizedBox(
              width: 600,
              child: _Form(
                onClosedPressed: onClosePressed,
                goToTheBeginningOfTheForm: goToTheBeginningOfTheForm,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Form extends StatelessWidget {
  final void Function()? onClosedPressed;
  final void Function() goToTheBeginningOfTheForm;

  _Form({
    required this.onClosedPressed,
    required this.goToTheBeginningOfTheForm,
  });

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
              _loadAnImageFromDrive(
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
                  onPressed: () {
                    if (!context.read<BicBloc>().isStateValid()) {
                      goToTheBeginningOfTheForm();
                      return;
                    }
                  },
                  child: const Text('Crear'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: onClosedPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // Cambia el color de fondo a rojo
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

  _loadAnImageFromDrive(
      void Function(HistouricImageInfo)
          functionToLoadTheImageInTheBlock) async {
    JSHelper.callFilePicker(
      apiKey: Environment.pickerApiKey,
      appId: Environment.pickerApiAppId,
    );
    _waitUntilThePickerIsOpen().then((value) {
      _waitUntilThePickerIsClosed().then((value) {
        if (!JSHelper.callGetIsThereAnError()) {
          final imagesInfo = JSHelper.callGetSelectedFilesIds();
          for (var imageInfo in imagesInfo) {
            functionToLoadTheImageInTheBlock(imageInfo);
          }
        }
      });
    });
  }

  _waitUntilThePickerIsOpen() async {
    while (
        !JSHelper.callGetIsThereAnError() && !JSHelper.callGetIsPickerOpen()) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  _waitUntilThePickerIsClosed() async {
    while (JSHelper.callGetIsPickerOpen()) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
}
