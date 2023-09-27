import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../config/config.dart';
import '../../infrastructure/infrastructure.dart';
import '../blocs/blocs.dart';
import 'create_bic_view.dart';

class BicsView extends StatelessWidget {
  const BicsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(
        token: context.read<AuthBloc>().state.token!,
        bicRepository: BICRepositoryImpl(bicDatasource: BICDatasourceImpl()),
      ),
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
  bool isCardOpen = false;
  double latitude = 0;
  double longitude = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final mapBlocState = context.watch<MapBloc>().state;
    double maxWidth = 650;
    double maxHeight = 500;

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
              await context.read<MapBloc>().changeMarkerIdForBICCreation().then(
                (_) {
                  String newMarkerId =
                      context.read<MapBloc>().state.markerFroBICCreationId;
                  String name = 'Continuar aquí';
                  if (isTheFirstMarker) {
                    context
                        .read<MapBloc>()
                        .addMarker(
                          latitude: latLng.latitude,
                          longitude: latLng.longitude,
                          name: name,
                          markerId: newMarkerId,
                          onInfoWindowTap: toggleCard,
                        )
                        .then((value) {
                      isTheFirstMarker = false;
                      _showMarkerInfoWindow(latLng, newMarkerId);
                    });
                  } else {
                    context
                        .read<MapBloc>()
                        .setLastMarker(
                          latitude: latLng.latitude,
                          longitude: latLng.longitude,
                          name: name,
                          markerId: newMarkerId,
                          onInfoWindowTap: toggleCard,
                        )
                        .then((value) =>
                            _showMarkerInfoWindow(latLng, newMarkerId));
                  }
                },
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
                      onPressed: toggleBICCreation,
                      child: const Text('Cancelar'),
                    )
                  : ElevatedButton(
                      onPressed: toggleBICCreation,
                      child: const Text('Crear Bien de Interés Cultural'),
                    ),
            ),
          ),
        ),
        if (isCardOpen)
          GestureDetector(
            onTap: toggleCard,
            child: PointerInterceptor(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        AnimatedPositioned(
          top: isCardOpen ? 100 : -500,
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
              child: Card(
                elevation: 5.0,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CreateBICView(
                      latitude: latitude,
                      longitude: longitude,
                      onClosePressed: toggleCard,
                      goToTheBeginningOfTheForm: _goToTheBeginningOfTheForm,
                      minimizeInfoWindow: _minimizeInfoWindow,
                      toggleBICCreation: toggleBICCreation,
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

  void _goToTheBeginningOfTheForm() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _minimizeInfoWindow() {
    context.read<MapBloc>().state.controller?.hideMarkerInfoWindow(
        MarkerId(context.read<MapBloc>().state.markerFroBICCreationId));
  }

  void toggleCard() {
    setState(() {
      isCardOpen = !isCardOpen;
    });
  }

  Future<void> toggleBICCreation() async {
    context
        .read<MapBloc>()
        .deleteMarker(context.read<MapBloc>().state.markerFroBICCreationId)
        .then(
      (value) {
        setState(() {
          isCreatingBIC = !isCreatingBIC;
          isTheFirstMarker = true;
        });
        if (isCreatingBIC) {
          SnackBars.showInfoSnackBar(context, 'Toca el mapa para crear un BIC');
        }
      },
    );
  }

  void _showMarkerInfoWindow(LatLng latLng, String newMarkerId) {
    context.read<MapBloc>().state.controller?.showMarkerInfoWindow(
          MarkerId(newMarkerId),
        );
    setState(() {
      longitude = latLng.longitude;
      latitude = latLng.latitude;
    });
  }
}
