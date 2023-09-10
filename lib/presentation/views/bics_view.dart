import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BicsView extends StatelessWidget {
  const BicsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      // markers: mapController.markersSet,
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
          // ref.read(mapProvider(context).notifier).loadBICsFromBICRepository();
        });
      },
    );
  }
}
