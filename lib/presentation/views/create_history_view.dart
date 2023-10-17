import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';

import '../../infrastructure/datasources/datasources.dart';
import '../../infrastructure/repositories/repositories.dart';
import '../widgets/history/history_widgets.dart';

class CreateHistoryView extends StatelessWidget {
  const CreateHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryBloc(
          token: context.read<AuthBloc>().state.token!,
          owner: context.read<AuthBloc>().state.id!,
          historyRepository: HistoryRepositoryImpl(
            historyDatasource: HistoryDatasourceImpl(
                firebaseStorageRepository: FirebaseStorageRepositoryImpl(
              firebaseStorageDataSource: FirebaseStorageDatasourceImpl(),
            )),
          )),
      child: const Stack(children: [
        _CreateHistoryView(),
        _CardWithMessage(),
      ]),
    );
  }
}

class _CreateHistoryView extends StatefulWidget {
  const _CreateHistoryView({super.key});

  @override
  State<_CreateHistoryView> createState() => _CreateHistoryViewState();
}

class _CreateHistoryViewState extends State<_CreateHistoryView> {
  int _currentStep = 0;

  final List<Step> _steps = [
    Step(
      title: const Text("Cargar Audio"),
      content: LoadAudio(),
    ),
    Step(
      title: const Text("Cargar Imágenes"),
      content: LoadImages(),
    ),
    const Step(
      title: Text("Cargar Segmentos de Texto"),
      content: LoadTextSegments(),
    ),
    Step(
      title: const Text("Cargar Videos (Opcional)"),
      content: LoadVideos(),
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: width * 0.5,
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Nombre de la historia",
                alignLabelWithHint: true,
                border: InputBorder.none,
              ),
              onChanged: (value) {
                context.read<HistoryBloc>().changeHistoryName(value);
              },
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25, // Tamaño de fuente personalizado
                fontWeight: FontWeight.bold, // Texto en negritas (bold)
              ),
            ),
          ),
        ),
      ),
      body: Stepper(
        steps: _steps,
        currentStep: _currentStep,
        onStepTapped: (step) {
          setState(() {
            _currentStep = step;
          });
        },
        onStepContinue: () {
          if (_currentStep < _steps.length - 1) {
            setState(() {
              _currentStep++;
            });
          }
          if (_currentStep == _steps.length - 1) {
            // Create history
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          } else {
            Navigator.pop(context);
          }
        },
        physics: const BouncingScrollPhysics(),
        type: StepperType.horizontal,
        connectorColor: MaterialStateProperty.all(Colors.blue),
        controlsBuilder: (context, controlsDetails) {
          return SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentStep == 0)
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.cancel),
                    onPressed: controlsDetails.onStepCancel,
                    label: const Text("Cancel"),
                  ),
                if (_currentStep != 0)
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: controlsDetails.onStepCancel,
                    label: const Text("Back"),
                  ),
                const SizedBox(width: 10),
                if (_currentStep != _steps.length - 1)
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: controlsDetails.onStepContinue,
                    label: const Text("Next"),
                  ),
                if (_currentStep == _steps.length - 1)
                  FilledButton.icon(
                    icon: const Icon(Icons.check),
                    onPressed: context.read<HistoryBloc>().createHistory,
                    label: const Text("Finish"),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CardWithMessage extends StatelessWidget {
  const _CardWithMessage({super.key});

  Card _buildLoadingCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("Creando historia..."),
          ],
        ),
      ),
    );
  }

  Card _buildErrorCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Icon(Icons.error),
            const SizedBox(height: 10),
            const Text("Error al crear la historia"),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () => context
                  .read<HistoryBloc>()
                  .changeHistoryStatus(HistoryStatus.initial),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildSuccessCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Icon(Icons.check),
            const SizedBox(height: 10),
            const Text("La historia se creó exitosamente"),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () => context
                  .read<HistoryBloc>()
                  .changeHistoryStatus(HistoryStatus.initial),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = 300;
    double maxHeight = 300;
    HistoryStatus historyStatus = context
        .select((HistoryBloc historyBloc) => historyBloc.state.historyStatus);
    return Stack(
      children: [
        if (historyStatus != HistoryStatus.initial)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            color: Colors.black.withOpacity(0.5),
          ),
        AnimatedPositioned(
          top: (historyStatus != HistoryStatus.initial) ? 100 : -500,
          left: 0,
          right: 0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Center(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width < maxWidth
                  ? MediaQuery.sizeOf(context).width
                  : maxWidth,
              height: MediaQuery.sizeOf(context).height < maxHeight
                  ? MediaQuery.sizeOf(context).height
                  : maxHeight,
              child: Column(
                children: [
                  if (historyStatus == HistoryStatus.loading)
                    _buildLoadingCard(),
                  if (historyStatus == HistoryStatus.error)
                    _buildErrorCard(context),
                  if (historyStatus == HistoryStatus.loaded)
                    _buildSuccessCard(context),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
