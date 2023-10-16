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
      create: (context) =>
          // HistoryBloc(owner: context.read<AuthBloc>().state.id!),
          HistoryBloc(
              owner: '',
              historyRepository: HistoryRepositoryImpl(
                historyDatasource: HistoryDatasourceImpl(
                    firebaseStorageRepository: FirebaseStorageRepositoryImpl(
                  firebaseStorageDataSource: FirebaseStorageDatasourceImpl(),
                )),
              )),
      child: const _CreateHistoryView(),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nueva historia",
          style: TextStyle(fontWeight: FontWeight.bold),
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
