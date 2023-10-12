import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';

import '../../config/config.dart';
import '../../domain/domain.dart';
import '../js_bridge/js_bridge.dart';
import '../widgets/history/history_widgets.dart';
import '../widgets/widgets.dart';

class CreateHistoryView extends StatelessWidget {
  const CreateHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          // owner: context.read<AuthBloc>().state.id!
          HistoryBloc(owner: 'ownerId'),
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
      title: Text("Cargar Audio"),
      content: LoadAudio(),
    ),
    Step(
      title: Text("Cargar Imágenes"),
      content: LoadImages(),
    ),
    Step(
      title: Text("Cargar Segmentos de Texto"),
      content: LoadTextSegments(),
    ),
    const Step(
      title: Text("Cargar Videos (Opcional)"),
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
                    onPressed: controlsDetails.onStepContinue,
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
