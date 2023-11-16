import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/domain.dart';
import '../../../infrastructure/infrastructure.dart';
import '../../blocs/blocs.dart';
import '../../widgets/widgets.dart';
import '../bic/bic_view.dart';
import '../../widgets/history/history_card_with_play_button.dart';

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
          alertBloc: context.read<AlertBloc>(),
          ownerId: context.read<AuthBloc>().state.id!,
          routeRepository:
              RouteRepositoryImpl(routeDatasource: RouteDatasourceImpl()),
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

  BICForSearchState? _getOpenBICForSearchState(
      List<BICForSearchState> bicsForSearch) {
    try {
      return bicsForSearch
          .firstWhere((bicForSearch) => bicForSearch.isTheUserViewingThisBIC);
    } catch (e) {
      return null;
    }
  }

  BICForRouteState? _getOpenBICForRouteState(
      List<BICForRouteState> bicsForRoute) {
    try {
      return bicsForRoute
          .firstWhere((bicForRoute) => bicForRoute.isTheUserViewingThisBIC);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<BICForRouteState> bicsForRoute =
        context.select((RouteBloc routeBloc) => routeBloc.state.bicsForRoute);
    final List<BICForSearchState> bicsForSearch =
        context.select((RouteBloc routeBloc) => routeBloc.state.bicsForSearch);
    final double height = context
        .read<RouteBloc>()
        .getRouteFormHeightWithoutTopAndBottomFixedWidgets(context);
    final double widthOfTheMap =
        context.read<RouteBloc>().getWidthOfTheMap(context);
    final double widthOfTheSideMenu =
        context.read<RouteBloc>().getWidthOfTheSideMenu();
    final bool isTheUserSelectingHistories = context.select(
        (RouteBloc routeBloc) => routeBloc.state.isTheUserSelectingHistories);
    final bool isTheUserViewingABICOfTheSearch = context.select(
        (RouteBloc routeBloc) =>
            routeBloc.state.isTheUserViewingABICOfTheSearch);
    final bool isTheUserViewingABICOfTheRoute = context.select(
        (RouteBloc routeBloc) =>
            routeBloc.state.isTheUserViewingABICOfTheRoute);
    final BICForSearchState? openBICForSearchState =
        _getOpenBICForSearchState(bicsForSearch);
    final BICForRouteState? openBICForRouteState =
        _getOpenBICForRouteState(bicsForRoute);
    final colors = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedContainer(
                width: widthOfTheMap,
                curve: Curves.ease,
                duration: const Duration(milliseconds: 300),
                child: const _GoogleMap()),
          ],
        ),
        AnimatedPositioned(
          left: isTheUserViewingABICOfTheSearch
              ? widthOfTheSideMenu
              : -widthOfTheSideMenu,
          top: 0,
          bottom: 0,
          duration: const Duration(milliseconds: 300),
          child: PointerInterceptor(
              child: BicView(
            bic: openBICForSearchState?.bic,
            width: widthOfTheSideMenu,
            onCloseButtonPressed:
                context.read<RouteBloc>().closeBICWithSearchState,
          )),
        ),
        AnimatedPositioned(
          left: isTheUserViewingABICOfTheRoute
              ? widthOfTheSideMenu
              : -widthOfTheSideMenu,
          top: 0,
          bottom: 0,
          duration: const Duration(milliseconds: 300),
          child: PointerInterceptor(
              child: BicView(
            bic: openBICForRouteState?.bic,
            width: widthOfTheSideMenu,
            onCloseButtonPressed:
                context.read<RouteBloc>().closeBICWithRouteState,
          )),
        ),
        AnimatedPositioned(
          left: isTheUserSelectingHistories
              ? widthOfTheSideMenu
              : -widthOfTheSideMenu,
          top: 0,
          bottom: 0,
          duration: const Duration(milliseconds: 300),
          child: PointerInterceptor(child: const _SelectHistoryView()),
        ),
        PointerInterceptor(
          child: Container(
            decoration: BoxDecoration(
              color: colors.background,
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 7),
                  child: Text(
                    "Crear ruta",
                    style: TextStyle(fontSize: 20, color: colors.onBackground),
                  ),
                ),
                SizedBox(
                    width: widthOfTheSideMenu,
                    height: 1,
                    child: const Divider()),
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: widthOfTheSideMenu,
                      height: height,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: _RouteForm(),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 20),
                SizedBox(
                    width: widthOfTheSideMenu,
                    height: 1,
                    child: const Divider()),
                Padding(
                  padding: const EdgeInsets.only(top: 9, bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<RouteBloc>().saveRoute().then((_) {
                        context.read<MapBloc>().clearState();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                    ),
                    child: Text(
                      "Crear ruta",
                      style: TextStyle(color: colors.onPrimary),
                    ),
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
  final bool isTheUserSelectingHistoriesForThisBIC;
  final bool isTheUserViewingThisBIC;

  const _SelectedBIC({
    super.key,
    required this.index,
    required this.bic,
    required this.isTheUserSelectingHistoriesForThisBIC,
    required this.isTheUserViewingThisBIC,
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
              _ShowBICButton(
                isTheUserViewingThisBIC: isTheUserViewingThisBIC,
                bic: bic,
                origin: "selectedBic",
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: isTheUserSelectingHistoriesForThisBIC
                    ? ElevatedButton(
                        onPressed:
                            context.read<RouteBloc>().closeSelectedHistoryView,
                        child: const Text("Ocultar historias"),
                      )
                    : ElevatedButton(
                        onPressed: () =>
                            context.read<RouteBloc>().showHistoriesOfABic(bic),
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
    Map<PolylineId, Polyline> polylines =
        context.select((MapBloc mapBloc) => mapBloc.state.polylines);
    Set<Marker> markersSet =
        context.select((MapBloc mapBloc) => mapBloc.state.markersSet);

    return GoogleMap(
      polylines: Set<Polyline>.of(polylines.values),
      markers: markersSet,
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
  const _SelectHistoryView();

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
    final BICForRouteState emptyBICState = BICForRouteState(bic: emptyBIC);

    BICForRouteState bicState = context.select((RouteBloc routeBloc) =>
        routeBloc.state.bicsForRoute.firstWhere(
            (bicState) => bicState.isTheUserSelectingHistoriesForThisBIC,
            orElse: () => emptyBICState));

    BIC bic = bicState.bic;
    final double widthOfTheSideMenu =
        context.read<RouteBloc>().getWidthOfTheSideMenu();

    if (bicState == emptyBICState) {
      return const SizedBox();
    }

    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SizedBox(
        width: widthOfTheSideMenu,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      bic.name,
                      style: const TextStyle(fontSize: 20),
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed:
                          context.read<RouteBloc>().closeSelectedHistoryView,
                      icon: const Icon(Icons.close),
                    ),
                  ],
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
                          maxWidth: widthOfTheSideMenu,
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: context.read<RouteBloc>().saveHistorySelected,
                    child: const Text("Guardar"),
                  ),
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
    List<BICForRouteState> bicsForRoute =
        context.watch<RouteBloc>().state.bicsForRoute;
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
                        isTheUserViewingThisBIC:
                            bicState.isTheUserViewingThisBIC,
                        isTheUserSelectingHistoriesForThisBIC: context
                            .read<RouteBloc>()
                            .state
                            .bicsForRoute[bicsForRoute.indexOf(bicState)]
                            .isTheUserSelectingHistoriesForThisBIC,
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
  const _SearchedBICList();

  @override
  Widget build(BuildContext context) {
    List<BICForSearchState> bicsForSearch =
        context.select((RouteBloc routeBloc) => routeBloc.state.bicsForSearch);

    return Column(
      children: [
        if (bicsForSearch.isEmpty)
          const ListTile(
            title: Text(
              "No se encontraron resultados",
            ),
          ),
        for (final bicForSearch in bicsForSearch)
          _SearchedBIC(bic: bicForSearch.bic),
      ],
    );
  }
}

class _SearchedBIC extends StatelessWidget {
  final BIC bic;

  const _SearchedBIC({required this.bic});

  @override
  Widget build(BuildContext context) {
    final bicsForSearch =
        context.select((RouteBloc routeBloc) => routeBloc.state.bicsForSearch);

    bool isTheUserViewingThisBIC = false;
    for (var bicForSearch in bicsForSearch) {
      if (bicForSearch.bic.bicId == bic.bicId &&
          bicForSearch.isTheUserViewingThisBIC) {
        isTheUserViewingThisBIC = true;
      }
    }

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
          subtitle: Center(
              child: _ShowBICButton(
            isTheUserViewingThisBIC: isTheUserViewingThisBIC,
            bic: bic,
            origin: "searchedBic",
          )),
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
  const _RouteForm();

  @override
  Widget build(BuildContext context) {
    final routeBlocState = context.watch<RouteBloc>().state;
    final String searchTextField = routeBlocState.searchTextField;

    return Column(
      children: [
        SecondCustomTextFormField(
          controller: routeBlocState.nameController,
          labelText: 'Nombre de la ruta',
          minLines: 1,
          maxLines: 1,
          onChanged: context.read<RouteBloc>().changeName,
        ),
        SecondCustomTextFormField(
          controller: routeBlocState.descriptionController,
          labelText: 'Descripción',
          hintText: 'Ingrese la descripción de la ruta',
          minLines: 3,
          maxLines: 5,
          onChanged: context.read<RouteBloc>().changeDescription,
          // errorMessage:
          // context.read<BicBloc>().state.bicDescription.errorMessage, //TODO: ADD LATER
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
                  child: const _SelectedBICList(),
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
  final String origin;
  final bool isTheUserViewingThisBIC;
  const _ShowBICButton(
      {required this.bic,
      required this.origin,
      required this.isTheUserViewingThisBIC});

  @override
  Widget build(BuildContext context) {
    void Function() showBIC;
    void Function() hideBIC;
    switch (origin) {
      case "searchedBic":
        showBIC = () => context.read<RouteBloc>().showBICWithSearchState(bic);
        hideBIC = () => context.read<RouteBloc>().closeBICWithSearchState();
        break;
      case "selectedBic":
        showBIC = () => context.read<RouteBloc>().showBICWithRouteState(bic);
        hideBIC = () => context.read<RouteBloc>().closeBICWithRouteState();
        break;
      default:
        hideBIC = () => {};
        showBIC = () => {};
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isTheUserViewingThisBIC
          ? ElevatedButton(
              onPressed: hideBIC,
              child: const Text("Ocultar BIC"),
            )
          : ElevatedButton(
              onPressed: showBIC,
              child: const Text("Mostrar BIC"),
            ),
    );
  }
}
