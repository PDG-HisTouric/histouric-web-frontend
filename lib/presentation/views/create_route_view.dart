import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:histouric_web/presentation/presentation.dart';

import '../../domain/entities/entities.dart';
import '../../infrastructure/datasources/datasources.dart';
import '../../infrastructure/repositories/repositories.dart';
import '../blocs/blocs.dart';

class CreateRouteView extends StatelessWidget {
  const CreateRouteView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => MapBloc(
          // token: context.read<AuthBloc>().state.token!,
          token:
              "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0X21hbmFnZXJAZ21haWwuY29tIiwiaWF0IjoxNjk0NTg0MjQ0LCJleHAiOjE2OTQ1ODc4NDR9.wxmDeWfDq60Oha9DTcAYTmr0oA3AxvQOUMDmeJRU0MY",
          bicRepository: BICRepositoryImpl(bicDatasource: BICDatasourceImpl()),
        ),
      ),
      BlocProvider(
        create: (context) => RouteBloc(
          bicRepository: BICRepositoryImpl(bicDatasource: BICDatasourceImpl()),
          // token: context.read<AuthBloc>().state.token!,
          token:
              "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0X21hbmFnZXJAZ21haWwuY29tIiwiaWF0IjoxNjk0NTg0MjQ0LCJleHAiOjE2OTQ1ODc4NDR9.wxmDeWfDq60Oha9DTcAYTmr0oA3AxvQOUMDmeJRU0MY",
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

  @override
  Widget build(BuildContext context) {
    final mapBlocState = context.watch<MapBloc>().state;
    final routeBlocState = context.watch<RouteBloc>().state;

    return Row(
      children: [
        SizedBox(
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
                              ? const Center(child: CircularProgressIndicator())
                              : ReorderableListView(
                                  buildDefaultDragHandles: false,
                                  onReorder: (oldIndex, newIndex) async {
                                    setState(() => changeBICsOrder = true);
                                    await context
                                        .read<RouteBloc>()
                                        .changeBICsOrder(
                                          newIndex: newIndex,
                                          oldIndex: oldIndex,
                                        );
                                    setState(() => changeBICsOrder = false);
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
                                      title:
                                          Text("No se encontraron resultados"),
                                    ),
                                  for (final bic
                                      in routeBlocState.bicsForSearch)
                                    ListTile(
                                      title: Text(bic.name),
                                      subtitle: Text(bic.description),
                                      trailing: IconButton(
                                        onPressed: () {
                                          context.read<RouteBloc>().addBIC(bic);
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
        Expanded(
          child: GoogleMap(
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
          ),
        ),
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
          context.read<RouteBloc>().deleteBIC(index);
        },
        icon: const Icon(Icons.delete),
      ),
      leading: ReorderableDragStartListener(
        index: index,
        key: ValueKey(bic.bicId),
        child: const Icon(Icons.drag_handle),
      ),
    );
  }
}
