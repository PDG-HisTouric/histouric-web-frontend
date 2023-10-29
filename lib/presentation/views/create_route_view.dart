import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:uuid/uuid.dart';

import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';
import '../blocs/blocs.dart';
import '../widgets/widgets.dart';

class CreateRouteView extends StatelessWidget {
  const CreateRouteView({super.key});

  @override
  Widget build(BuildContext context) {
    double widthOfTheMap = MediaQuery.of(context).size.width - 400;
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => MapBloc(
          // token: context.read<AuthBloc>().state.token!, //TODO: PONER
          token: "", //TODO: QUITAR
          bicRepository: BICRepositoryImpl(bicDatasource: BICDatasourceImpl()),
        ),
      ),
      BlocProvider(
        create: (context) => RouteBloc(
          widthOfTheMap: widthOfTheMap,
          bicRepository: BICRepositoryImpl(bicDatasource: BICDatasourceImpl()),
          // token: context.read<AuthBloc>().state.token!, //TODO: PONER
          token: "", //TODO: QUITAR
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
  final scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(
      () {
        final double originalHeight =
            context.read<RouteBloc>().getOriginalRouteFormHeight(context);
        final double currentHeight = context
            .read<RouteBloc>()
            .getRouteFormHeightWithoutTopAndBottomFixedWidgets(context)
            .toDouble();
        if (currentHeight <= originalHeight) {
          context.read<RouteBloc>().changeScrollBar(
                isTheScrollBarUp: true,
                isTheScrollBarDown: true,
              );
          return;
        }
        final routeBlocState = context.read<RouteBloc>().state;
        final double scrollPosition = scrollController.position.pixels;
        final double scrollMaxPosition =
            scrollController.position.maxScrollExtent;
        final double scrollMinPosition =
            scrollController.position.minScrollExtent;
        final bool isTheScrollBarUp = scrollPosition == scrollMinPosition;
        final bool isTheScrollBarDown = scrollPosition == scrollMaxPosition;
        if (isTheScrollBarUp != routeBlocState.isTheScrollBarUp ||
            isTheScrollBarDown != routeBlocState.isTheScrollBarDown) {
          context.read<RouteBloc>().changeScrollBar(
              isTheScrollBarUp: isTheScrollBarUp,
              isTheScrollBarDown: isTheScrollBarDown);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routeBlocState = context.watch<RouteBloc>().state;
    final bool isTheScrollBarUp = context
        .select((RouteBloc routeBloc) => routeBloc.state.isTheScrollBarUp);
    final bool isTheScrollBarDown = context
        .select((RouteBloc routeBloc) => routeBloc.state.isTheScrollBarDown);
    final double height = context
        .read<RouteBloc>()
        .getRouteFormHeightWithoutTopAndBottomFixedWidgets(context);
    final double widthOfTheMap = context.select((RouteBloc routeBloc) =>
        routeBloc.state.widthOfTheMap -
        (routeBlocState.isTheUserSelectingHistories ? 400 : 0));
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: widthOfTheMap, child: const _GoogleMap()),
          ],
        ),
        AnimatedPositioned(
            left: routeBlocState.isTheUserSelectingHistories ? 400 : -400,
            top: 0,
            bottom: 0,
            duration: const Duration(milliseconds: 300),
            child: PointerInterceptor(child: const _SelectHistoryView())),
        PointerInterceptor(
          child: Container(
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
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 7),
                  child: Text(
                    "Crear ruta",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                if (!isTheScrollBarUp)
                  const SizedBox(width: 400, height: 1, child: Divider()),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: SizedBox(
                      width: 400,
                      height: height,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: _RouteForm(),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 20),
                if (!isTheScrollBarDown)
                  const SizedBox(width: 400, height: 1, child: Divider()),
                Padding(
                  padding: const EdgeInsets.only(top: 9, bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      // context.read<MapBloc>().add(CreateRoute());
                    },
                    child: const Text("Crear ruta"),
                  ),
                ),
                // const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectedBIC extends StatelessWidget {
  final int index;
  final BIC bic;

  const _SelectedBIC({
    super.key,
    required this.index,
    required this.bic,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        ListTile(
          title: Text(
            bic.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          subtitle: Wrap(
            alignment: WrapAlignment.center,
            children: [
              _ShowBICButton(bic: bic),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () =>
                      context.read<RouteBloc>().selectHistoryButtonPressed(bic),
                  child: const Text("Mostrar historias"),
                ),
              ),
            ],
          ),
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
            child: const InkWell(
              mouseCursor: SystemMouseCursors.grab,
              child: Icon(Icons.drag_handle),
            ),
          ),
        ),
        const Divider(),
      ],
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

class _SelectHistoryView extends StatelessWidget {
  const _SelectHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final BIC emptyBIC = BIC(
      name: "",
      latitude: 0,
      longitude: 0,
      description: "",
      exists: false,
      nicknames: [],
      imagesUris: [],
      histories: [],
    );
    final BICState emptyBICState = BICState(bic: emptyBIC);
    BICState bicState = context.select((RouteBloc routeBloc) =>
        routeBloc.state.bicsForRoute.firstWhere(
            (bicState) => bicState.isTheUserSelectingHistoriesForThisBIC,
            orElse: () => emptyBICState));
    BIC bic = bicState.bic;

    if (bicState == emptyBICState) {
      return const SizedBox();
    }

    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  bic.name,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Seleccione la historia que aparecerá en este BIC a la hora de recorrer la ruta",
                    style: TextStyle(fontSize: 15),
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: bic.histories.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 3),
                      title: BlocProvider(
                        create: (context) {
                          const uuid = Uuid();
                          final htmlAudioId = uuid.v4();
                          return HtmlAudioOnlyWithPlayButtonBloc(
                            htmlAudioId: htmlAudioId,
                            audioUrl: bic.histories[index].audio.audioUri,
                          );
                        },
                        child: HistoryCardWithPlayButton(
                          originOfSelectedHistories: "createRouteView",
                          bicId: bic.bicId,
                          historyId: bic.histories[index].id,
                          maxWidth: 400,
                          historyTitle: bic.histories[index].title,
                          onCheckBoxChanged: (String historyId) {
                            context
                                .read<RouteBloc>()
                                .selectHistory(historyId, bic.bicId!);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Guardar"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Cancelar",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedBICList extends StatefulWidget {
  const _SelectedBICList();

  @override
  State<_SelectedBICList> createState() => _SelectedBICListState();
}

class _SelectedBICListState extends State<_SelectedBICList> {
  bool changeBICsOrder = false;

  @override
  Widget build(BuildContext context) {
    List<BICState> bicsForRoute =
        context.select((RouteBloc routeBloc) => routeBloc.state.bicsForRoute);
    return Column(children: [
      const SizedBox(
        width: double.infinity,
        child: Text(
          "Mueva verticalmente los BIC para definir el orden de recorrido de la ruta. El BIC en la parte superior inicia la ruta.",
          style: TextStyle(fontSize: 15),
          textAlign: TextAlign.left,
        ),
      ),
      changeBICsOrder
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Expanded(
              child: ReorderableListView(
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
                    context.read<MapBloc>().changePolylinePoints(
                        context.read<RouteBloc>().state.bicsForRoute);
                    setState(() => changeBICsOrder = false);
                  });
                },
                children: [
                  for (final bicState in bicsForRoute)
                    FadeIn(
                      duration: const Duration(milliseconds: 200),
                      key: ValueKey(bicState.bic.bicId),
                      child: _SelectedBIC(
                        index: bicsForRoute.indexOf(bicState),
                        key: ValueKey(bicState.bic.bicId),
                        bic: bicState.bic,
                      ),
                    ),
                ],
              ),
            ),
    ]);
  }
}

class _SearchedBICList extends StatelessWidget {
  const _SearchedBICList({super.key});

  @override
  Widget build(BuildContext context) {
    List<BIC> bicsForSearch =
        context.select((RouteBloc routeBloc) => routeBloc.state.bicsForSearch);
    return Column(
      children: [
        if (bicsForSearch.isEmpty)
          const ListTile(
            title: Text(
              "No se encontraron resultados",
            ),
          ),
        for (final bic in bicsForSearch) _SearchedBIC(bic: bic),
      ],
    );
  }
}

class _SearchedBIC extends StatelessWidget {
  final BIC bic;

  const _SearchedBIC({super.key, required this.bic});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        ListTile(
          leading: const SizedBox(width: 50),
          title: Text(
            bic.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          subtitle: Center(child: _ShowBICButton(bic: bic)),
          trailing: IconButton(
            onPressed: () {
              context.read<RouteBloc>().addBIC(bic).then((createdBIC) {
                context.read<MapBloc>().addMarker(
                      latitude: createdBIC.latitude,
                      longitude: createdBIC.longitude,
                      name: createdBIC.name,
                      markerId: createdBIC.bicId!,
                    );
                context.read<MapBloc>().changePolylinePoints(
                    context.read<RouteBloc>().state.bicsForRoute);
              });
            },
            icon: const Icon(Icons.add),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class _RouteForm extends StatelessWidget {
  const _RouteForm({super.key});

  @override
  Widget build(BuildContext context) {
    final routeBlocState = context.watch<RouteBloc>().state;
    final String searchTextField = routeBlocState.searchTextField;
    return Column(
      children: [
        const SecondCustomTextFormField(
          labelText: 'Nombre de la ruta',
          minLines: 1,
          maxLines: 1,
        ),
        SecondCustomTextFormField(
          labelText: 'Descripción',
          hintText: 'Ingrese la descripción de la ruta',
          minLines: 3,
          maxLines: 5,
          onChanged: context.read<RouteBloc>().changeDescription,
          // errorMessage:
          // context.read<BicBloc>().state.bicDescription.errorMessage, //TODO: PONER
        ),
        SecondCustomTextFormField(
          controller: routeBlocState.searchController,
          minLines: 1,
          maxLines: 1,
          labelText: 'Buscar Bien de Interés Cultural (BIC)',
          prefixIcon: const Icon(Icons.search),
          onChanged: context.read<RouteBloc>().changeSearchTextField,
        ),
        Expanded(
          child: searchTextField.isEmpty
              ? FadeIn(
                  child: _SelectedBICList(),
                )
              : FadeIn(
                  duration: const Duration(milliseconds: 200),
                  child: const _SearchedBICList(),
                ),
        ),
      ],
    );
  }
}

class _ShowBICButton extends StatelessWidget {
  final BIC bic;
  const _ShowBICButton({super.key, required this.bic});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () =>
            context.read<RouteBloc>().selectHistoryButtonPressed(bic),
        child: const Text("Mostrar BIC"),
      ),
    );
  }
}
