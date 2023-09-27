import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';
import '../blocs/blocs.dart';
import '../widgets/widgets.dart';

class CreateRouteView extends StatelessWidget {
  const CreateRouteView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => MapBloc(
          token: context.read<AuthBloc>().state.token!,
          bicRepository: BICRepositoryImpl(bicDatasource: BICDatasourceImpl()),
        ),
      ),
      BlocProvider(
        create: (context) => RouteBloc(
          bicRepository: BICRepositoryImpl(bicDatasource: BICDatasourceImpl()),
          token: context.read<AuthBloc>().state.token!,
        ),
      ),
    ], child: const _CreateRouteView());
  }
}

class _CreateRouteView extends StatefulWidget {
  const _CreateRouteView();

  @override
  State<_CreateRouteView> createState() => _CreateRouteViewState();
}

class _CreateRouteViewState extends State<_CreateRouteView> {
  bool changeBICsOrder = false;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    final routeBlocState = context.watch<RouteBloc>().state;

    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: SizedBox(
            width: 400,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  const Text(
                    "Crear ruta",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SecondCustomTextFormField(
                    labelText: 'Nombre de la ruta',
                    minLines: 1,
                    maxLines: 1,
                  ),
                  SecondCustomTextFormField(
                    controller: routeBlocState.searchController,
                    minLines: 1,
                    maxLines: 1,
                    labelText: 'Buscar bien de interés cultural',
                    prefixIcon: const Icon(Icons.search),
                    onChanged: context.read<RouteBloc>().changeSearchTextField,
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Bienes de interés de la ruta",
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    child: routeBlocState.searchTextField.isEmpty
                        ? FadeIn(
                            child: changeBICsOrder
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ReorderableListView(
                                    buildDefaultDragHandles: false,
                                    onReorder: (oldIndex, newIndex) async {
                                      setState(() => changeBICsOrder = true);
                                      context
                                          .read<RouteBloc>()
                                          .changeBICsOrder(
                                            newIndex: newIndex,
                                            oldIndex: oldIndex,
                                          )
                                          .then((value) {
                                        context
                                            .read<MapBloc>()
                                            .changePolylinePoints(context
                                                .read<RouteBloc>()
                                                .state
                                                .bicsForRoute);
                                        setState(() => changeBICsOrder = false);
                                      });
                                    },
                                    children: [
                                      for (final bic
                                          in routeBlocState.bicsForRoute)
                                        FadeIn(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          key: ValueKey(bic.bicId),
                                          child: _CustomRow(
                                            index: routeBlocState.bicsForRoute
                                                .indexOf(bic),
                                            key: ValueKey(bic.bicId),
                                            bic: bic,
                                          ),
                                        ),
                                    ],
                                  ),
                          )
                        : FadeIn(
                            duration: const Duration(milliseconds: 200),
                            child: ListView(
                              children: [
                                Column(
                                  children: [
                                    if (routeBlocState.bicsForSearch.isEmpty)
                                      const ListTile(
                                        title: Text(
                                          "No se encontraron resultados",
                                        ),
                                      ),
                                    for (final bic
                                        in routeBlocState.bicsForSearch)
                                      ListTile(
                                        title: Text(bic.name),
                                        subtitle: Text(bic.description),
                                        trailing: IconButton(
                                          onPressed: () {
                                            context
                                                .read<RouteBloc>()
                                                .addBIC(bic)
                                                .then((createdBIC) {
                                              context.read<MapBloc>().addMarker(
                                                    latitude:
                                                        createdBIC.latitude,
                                                    longitude:
                                                        createdBIC.longitude,
                                                    name: createdBIC.name,
                                                    markerId: createdBIC.bicId!,
                                                  );
                                              context
                                                  .read<MapBloc>()
                                                  .changePolylinePoints(context
                                                      .read<RouteBloc>()
                                                      .state
                                                      .bicsForRoute);
                                            });
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // context.read<MapBloc>().add(CreateRoute());
                    },
                    child: const Text("Crear ruta"),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        const Expanded(child: _GoogleMap()),
      ],
    );
  }
}

class _CustomRow extends StatelessWidget {
  final int index;
  final BIC bic;

  const _CustomRow({super.key, required this.index, required this.bic});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(bic.name),
      subtitle: Text(bic.description),
      trailing: IconButton(
        onPressed: () {
          context.read<RouteBloc>().deleteBIC(index).then((value) {
            context.read<MapBloc>().deleteMarker(bic.bicId!);
            context.read<MapBloc>().changePolylinePoints(
                context.read<RouteBloc>().state.bicsForRoute);
          });
        },
        icon: const Icon(Icons.delete),
      ),
      leading: ReorderableDragStartListener(
        index: index,
        key: ValueKey(bic.bicId!),
        child: const Icon(Icons.drag_handle),
      ),
    );
  }
}

class _GoogleMap extends StatelessWidget {
  const _GoogleMap();

  @override
  Widget build(BuildContext context) {
    final mapBlocState = context.watch<MapBloc>().state;

    return GoogleMap(
      polylines: Set<Polyline>.of(mapBlocState.polylines.values),
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
          },
        );
      },
    );
  }
}
