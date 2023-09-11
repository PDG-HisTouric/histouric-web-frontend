import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:histouric_web/presentation/presentation.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../blocs/blocs.dart';

class BicsView extends StatelessWidget {
  const BicsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(),
      child: const _BIcsView(),
    );
  }
}

class _BIcsView extends StatefulWidget {
  const _BIcsView();

  @override
  State<_BIcsView> createState() => _BIcsViewState();
}

class _BIcsViewState extends State<_BIcsView> {
  bool isCreatingBIC = false;
  bool isTheFirstMarker = true;
  int counter = 0;
  bool isCardOpen = false;

  final ScrollController _scrollController = ScrollController();

  void toggleCard() {
    setState(() {
      isCardOpen = !isCardOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapBlocState = context.watch<MapBloc>().state;
    double maxWidth = 650; // Ancho máximo deseado
    double maxHeight = 500; // Alto máximo deseado

    return Stack(
      children: [
        GoogleMap(
          markers: mapBlocState.markersSet,
          mapType: MapType.normal,
          initialCameraPosition: const CameraPosition(
            target: LatLng(3.451929471542798, -76.5319398863662),
            zoom: 15,
          ),
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: (controller) {
            controller.getVisibleRegion().then(
              (value) async {
                context.read<MapBloc>().setMapController(controller);
                context.read<MapBloc>().loadBICsFromBICRepository();
              },
            );
          },
          onTap: (latLng) async {
            if (isCreatingBIC) {
              String newMarkerId = 'nuevo-bic-$counter';
              String name = 'Continuar aquí';
              if (isTheFirstMarker) {
                await context.read<MapBloc>().addMarker(
                      latitude: latLng.latitude,
                      longitude: latLng.longitude,
                      name: name,
                      markerId: newMarkerId,
                      onInfoWindowTap: toggleCard,
                    );
                isTheFirstMarker = false;
              } else {
                await context.read<MapBloc>().setLastMarker(
                      latitude: latLng.latitude,
                      longitude: latLng.longitude,
                      name: name,
                      markerId: newMarkerId,
                      onInfoWindowTap: toggleCard,
                    );
              }
              counter++;
              mapBlocState.controller?.showMarkerInfoWindow(
                MarkerId(newMarkerId),
              );
            }
          },
        ),
        Positioned(
          top: 20,
          right: 20,
          child: PointerInterceptor(
            child: Container(
              child: isCreatingBIC
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isCreatingBIC = false;
                        });
                      },
                      child: const Text('Cancelar'),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isCreatingBIC = true;
                        });
                      },
                      child: const Text('Crear Bien de Interés Cultural'),
                    ),
            ),
          ),
        ),

        // Fondo gris transparente cuando la card está abierta
        if (isCardOpen)
          GestureDetector(
            onTap: toggleCard, // Cierra la card al tocar el fondo
            child: PointerInterceptor(
              child: Container(
                color: Colors.black.withOpacity(0.5), // Color gris transparente
              ),
            ),
          ),
        AnimatedPositioned(
          top: isCardOpen ? 100 : -500, // Posición inicial y final de la card
          left: 0,
          right: 0,
          duration:
              const Duration(milliseconds: 300), // Duración de la animación
          curve: Curves.easeInOut, // Curva de la animación
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width < maxWidth
                  ? MediaQuery.of(context).size.width
                  : maxWidth, // Ancho máximo de 300 o el ancho de la pantalla
              height: MediaQuery.of(context).size.height < maxHeight
                  ? MediaQuery.of(context).size.height
                  : maxHeight, // Alto máximo de 300 o el alto de la pantalla
              child: Card(
                elevation: 5.0,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CreateBICView(
                      onClosePressed: toggleCard,
                      goToTheBeginningOfTheForm: () {
                        _scrollController.animateTo(
                          0.0,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
