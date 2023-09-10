import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

class _BIcsView extends StatelessWidget {
  const _BIcsView();

  @override
  Widget build(BuildContext context) {
    final mapBlocState = context.watch<MapBloc>().state;

    return GoogleMap(
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
        controller.getVisibleRegion().then((value) async {
          context.read<MapBloc>().setMapController(controller);
          context.read<MapBloc>().loadBICsFromBICRepository();
        });
      },
    );
  }
}
