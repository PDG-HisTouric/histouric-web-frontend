import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  bool isTheFirstMarker = false;

  @override
  Widget build(BuildContext context) {
    final mapBlocState = context.watch<MapBloc>().state;

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
          onTap: (latLng) {
            if (isCreatingBIC) {
              if (isTheFirstMarker) {
                context.read<MapBloc>().addMarker(
                      latitude: latLng.latitude,
                      longitude: latLng.longitude,
                      name: 'Nuevo BIC',
                      markerId: 'nuevo-bic',
                    );
              } else {
                context.read<MapBloc>().setLastMarker(
                      latitude: latLng.latitude,
                      longitude: latLng.longitude,
                      name: 'Nuevo BIC',
                      markerId: 'nuevo-bic',
                    );
              }
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
      ],
    );
  }
}
