import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class CreateBICView extends StatelessWidget {
  final void Function()? onClosePressed;

  const CreateBICView({super.key, required this.onClosePressed});

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
              child: _Form(onClosedPressed: onClosePressed),
            ),
          )
        ],
      ),
    );
  }
}

class _Form extends StatelessWidget {
  final void Function()? onClosedPressed;

  _Form({required this.onClosedPressed});

  final List<String> filesIds = [
    'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Ermita_cali.jpg/300px-Ermita_cali.jpg',
    'https://images.mnstatic.com/a9/f3/a9f36d28a6458cdc67726fd09ea08674.jpg',
    'https://www.elpais.com.co/resizer/WtXtPEaGFNQoo2BSOPV18x5AKUA=/arc-anglerfish-arc2-prod-semana/public/6HIDALNZSVGVNNVOWZFUJ6LZBA.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          const SecondCustomTextFormField(
            labelText: 'Nombre',
            hintText: 'Ingresa el nombre del Bien de Interés Cultural',
          ),
          const SizedBox(height: 16.0),
          const SecondCustomTextFormField(
            labelText: 'Descripción',
            hintText: 'Ingresa la descripción del Bien de Interés Cultural',
            minLines: 3,
            maxLines: 5,
          ),
          Row(
            children: [
              Checkbox(
                checkColor: Colors.white,
                value: false,
                onChanged: (value) {},
              ),
              const Text('El Bien de Interés Cultural existe'),
            ],
          ),
          const SizedBox(height: 16.0),
          ImageCarousel(filesIds: filesIds),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Agregar fotos desde Google Drive'),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                ElevatedButton(
                  onPressed: () {},
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
}
