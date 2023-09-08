import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_service/blocs/auth/auth_bloc.dart';
import 'package:social_service/blocs/engineer/engineer_bloc.dart';
import 'package:social_service/blocs/profile/profile_bloc.dart';
import 'package:social_service/core/values/app_colors.dart';
import 'package:social_service/core/widgets/custom_button.dart';
import 'package:social_service/cubits/engineer/engineer_cubit.dart';
import 'package:social_service/cubits/login/login_cubit.dart';
import 'package:social_service/models/user_model.dart';
import 'package:social_service/presentasion/pages/engineer_home/engineer_home_screen.dart';
import 'package:social_service/repositories/auth/auth_repository.dart';
import 'package:social_service/repositories/order/order_repository.dart';
import 'package:social_service/router/app_pages.dart';
import 'package:timelines/timelines.dart';

class OrderProcessingScreen extends StatefulWidget {
  const OrderProcessingScreen({super.key});

  @override
  State<OrderProcessingScreen> createState() => _OrderProcessingScreenState();
}

class _OrderProcessingScreenState extends State<OrderProcessingScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

    final user = context.select((AuthBloc bloc) => bloc.state.user);

    return Scaffold(
      body: BlocListener<EngineerBloc, EngineerState>(
        listener: (context, state) async {
          if (state is EngineerProcessingOrderState &&
              state.order?.orderStatusList?.ordersStatusList[3].status ==
                  'done') {
            OrderRepository().completedOrder(order: state.order!);

            context.read<EngineerBloc>().add(ClearStateEngineer());
            context.read<EngineerCubit>().changeEngineerStatus();

            AppRouter.pushAndRemoveUntil(
                context, const EngineerHomeScreen(), Routes.engineerHomeScreen);
          }

          if (state is EngineerInitial) {
            AppRouter.pushAndRemoveUntil(
                context, const EngineerHomeScreen(), Routes.engineerHomeScreen);

            context.read<EngineerCubit>().changeEngineerStatus();
          }
        },
        child: BlocBuilder<EngineerBloc, EngineerState>(
          builder: (context, state) {
            if (state is EngineerLoadingProcess ||
                state is EngineerLookingOrderState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is EngineerProcessingOrderState &&
                state.order?.routingDirection?.properties?.waypoints != null) {
              return SizedBox(
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        zoom: 18,
                        minZoom: 10,
                        maxZoom: 18,
                        center: LatLng(
                            state.order?.routingDirection?.properties
                                    ?.waypoints?[0].lat ??
                                0,
                            state.order?.routingDirection?.properties
                                    ?.waypoints?[0].lon ??
                                0),
                        interactiveFlags:
                            InteractiveFlag.all - InteractiveFlag.rotate,
                      ),
                      children: [
                        TileLayer(
                          subdomains: const ['a', 'b', 'c'],
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                  state.order?.routingDirection?.properties
                                          ?.waypoints?[0].lat ??
                                      0,
                                  state.order?.routingDirection?.properties
                                          ?.waypoints?[0].lon ??
                                      0),
                              builder: (context) => const Icon(
                                Icons.pin_drop,
                                color: Colors.blue,
                                size: 24,
                              ),
                            ),
                            Marker(
                              point: LatLng(
                                  state.order?.routingDirection?.properties
                                          ?.waypoints?[1].lat ??
                                      0,
                                  state.order?.routingDirection?.properties
                                          ?.waypoints?[1].lon ??
                                      0),
                              builder: (context) => const Icon(
                                Icons.pin_drop,
                                color: Colors.blue,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: state.polylinePoints,
                              strokeWidth: 4,
                              color: AppColors.purpleBackground,
                            ),
                          ],
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding:
                            EdgeInsets.only(bottom: height / 3.2, right: 20.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: AppColors.white,
                          child: IconButton(
                            onPressed: () {
                              _mapController.move(
                                LatLng(
                                    state.order?.routingDirection?.properties
                                            ?.waypoints?[1].lat ??
                                        0,
                                    state.order?.routingDirection?.properties
                                            ?.waypoints?[1].lon ??
                                        0),
                                18,
                              );
                            },
                            iconSize: 30,
                            color: AppColors.purpleBackground,
                            // style: ButtonStyle(
                            //   padding: MaterialStatePropertyAll(EdgeInsets.all(50))
                            // ),
                            icon: const Icon(
                              Icons.my_location_outlined,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DraggableScrollableSheet(
                      minChildSize: 0.3,
                      initialChildSize: 0.3,
                      maxChildSize: 0.8,
                      builder: (context, scrollController) {
                        // Calculate the current height of the sheet based on the animation value
                        final double sheetHeight =
                            MediaQuery.of(context).size.height * 0.8;

                        // Calculate the current border radius based on the sheet height
                        const double maxCornerRadius = 50.0;
                        const double minCornerRadius = 50.0;
                        double currentCornerRadius = maxCornerRadius -
                            ((sheetHeight -
                                    (MediaQuery.of(context).size.height *
                                        0.2)) /
                                sheetHeight *
                                maxCornerRadius);
                        currentCornerRadius = currentCornerRadius.clamp(
                            minCornerRadius, maxCornerRadius);

                        return SingleChildScrollView(
                          controller: scrollController,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Container(
                            height: sheetHeight,
                            width: width,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(currentCornerRadius)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: SvgPicture.asset(
                                    "assets/svg/ic_minus.svg",
                                    color: AppColors.black.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ListTile(
                                  leading: const CircleAvatar(
                                    radius: 25,
                                    backgroundColor: AppColors.purpleBackground,
                                    child: Icon(
                                      Icons.person,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  title: Text(
                                    state.order?.user?.name ?? "name",
                                    style: const TextStyle(
                                      color: AppColors.purpleBackground,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Rp.${state.order?.cart?.subTotal}" ??
                                        "10.000",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: CupertinoColors.systemYellow,
                                      ),
                                      Text(
                                        "4.5",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                state.order?.engineer != null
                                    ? _timelineProgress(context)
                                    : Center(
                                        child: Text(
                                          "Waiting for engineer",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                        ),
                                      ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomButtom(
                                        onPressed: () {
                                          context.read<EngineerBloc>().add(
                                                EngineerCancelOrder(
                                                  order: state.order,
                                                  context: context,
                                                ),
                                              );
                                        },
                                        hint: "Cancel",
                                        width: width,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomButtom(
                                        onPressed: () async {
                                          return showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Next Status'),
                                                content:
                                                    const SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text(
                                                          'Are you sure want to next status?'),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('Yes'),
                                                    onPressed: () async {
                                                      context
                                                          .read<EngineerBloc>()
                                                          .add(
                                                            EngineerNextStatus(
                                                                order: state
                                                                    .order),
                                                          );

                                                      AppRouter.back(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        hint: "Next",
                                        width: width,
                                      ),
                                    ),
                                  ],
                                ),
                                _listProductOrder(context),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _listProductOrder(context) {
    return BlocBuilder<EngineerBloc, EngineerState>(
      builder: (context, state) {
        if (state is EngineerProcessingOrderState) {
          return Expanded(
            child: SizedBox(
              child: ListView.builder(
                itemCount: state.order?.cart?.customOrders.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 100,
                      decoration: const BoxDecoration(
                          color: AppColors.palePurple,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        children: [
                          Image.asset("assets/images/laptop_image.png"),
                          // Add spacing between image and text
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.order?.cart?.customOrders[index].product
                                          .name ??
                                      "",
                                  style: const TextStyle(
                                    color: AppColors.purpleBackground,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Add spacing between title and subtitle
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Service: ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    Expanded(
                                      child: Text(
                                        state.order?.cart?.customOrders[index]
                                                .serviceType ??
                                            '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Rp.${state.order?.cart?.customOrders[index].totalPrice ?? ""}",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _timelineProgress(context) {
    return BlocBuilder<EngineerBloc, EngineerState>(
      buildWhen: (previous, current) {
        if (previous is EngineerProcessingOrderState &&
            current is EngineerProcessingOrderState) {
          return previous.order?.orderStatusList !=
              current.order?.orderStatusList;
        }
        return false;
      },
      builder: (context, state) {
        if (state is EngineerProcessingOrderState) {
          return SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: FixedTimeline.tileBuilder(
              theme: TimelineTheme.of(context).copyWith(
                direction: Axis.horizontal,
                connectorTheme:
                    TimelineTheme.of(context).connectorTheme.copyWith(
                          thickness: 3,
                          color: AppColors.purpleBackground,
                        ),
                indicatorTheme:
                    TimelineTheme.of(context).indicatorTheme.copyWith(
                          size: 25.0,
                          position: 0.5,
                        ),
              ),
              builder: TimelineTileBuilder.connected(
                connectionDirection: ConnectionDirection.after,
                indicatorBuilder: (_, index) {
                  return state.order?.orderStatusList?.ordersStatusList[index]
                              .name ==
                          "On The Way"
                      ? DotIndicator(
                          color: state.order?.orderStatusList
                                          ?.ordersStatusList[index].name ==
                                      "On The Way" &&
                                  state.order?.orderStatusList
                                          ?.ordersStatusList[index].status ==
                                      "done"
                              ? AppColors.buttonSuccessColor
                              : state
                                              .order
                                              ?.orderStatusList
                                              ?.ordersStatusList[index]
                                              .status ==
                                          "ongoing" &&
                                      state.order?.orderStatusList
                                              ?.ordersStatusList[index].name ==
                                          "On The Way"
                                  ? AppColors.buttonWarningColor
                                  : AppColors.iconColorDefault,
                          size: 30,
                          child: const Icon(
                            Icons.motorcycle,
                            size: 25,
                            color: AppColors.white,
                          ),
                        )
                      : state.order?.orderStatusList?.ordersStatusList[index]
                                  .name ==
                              "Payment"
                          ? DotIndicator(
                              color: state.order?.orderStatusList
                                              ?.ordersStatusList[index].name ==
                                          "Payment" &&
                                      state
                                              .order
                                              ?.orderStatusList
                                              ?.ordersStatusList[index]
                                              .status ==
                                          "done"
                                  ? AppColors.buttonSuccessColor
                                  : state
                                                  .order
                                                  ?.orderStatusList
                                                  ?.ordersStatusList[index]
                                                  .status ==
                                              "ongoing" &&
                                          state
                                                  .order
                                                  ?.orderStatusList
                                                  ?.ordersStatusList[index]
                                                  .name ==
                                              "Payment"
                                      ? AppColors.buttonWarningColor
                                      : AppColors.iconColorDefault,
                              size: 30,
                              child: const Icon(
                                Icons.money,
                                size: 25,
                                color: Colors.white,
                              ),
                            )
                          : state.order?.orderStatusList
                                      ?.ordersStatusList[index].name ==
                                  "In Progress"
                              ? DotIndicator(
                                  color: state
                                                  .order
                                                  ?.orderStatusList
                                                  ?.ordersStatusList[index]
                                                  .name ==
                                              "In Progress" &&
                                          state
                                                  .order
                                                  ?.orderStatusList
                                                  ?.ordersStatusList[index]
                                                  .status ==
                                              "done"
                                      ? AppColors.buttonSuccessColor
                                      : state
                                                      .order
                                                      ?.orderStatusList
                                                      ?.ordersStatusList[index]
                                                      .status ==
                                                  "ongoing" &&
                                              state
                                                      .order
                                                      ?.orderStatusList
                                                      ?.ordersStatusList[index]
                                                      .name ==
                                                  "In Progress"
                                          ? AppColors.buttonWarningColor
                                          : AppColors.iconColorDefault,
                                  size: 30,
                                  child: const Icon(
                                    Icons.home_repair_service,
                                    size: 25,
                                    color: AppColors.white,
                                  ),
                                )
                              : DotIndicator(
                                  color: state
                                                  .order
                                                  ?.orderStatusList
                                                  ?.ordersStatusList[index]
                                                  .name ==
                                              "Done" &&
                                          state
                                                  .order
                                                  ?.orderStatusList
                                                  ?.ordersStatusList[index]
                                                  .status ==
                                              "done"
                                      ? AppColors.buttonSuccessColor
                                      : state
                                                      .order
                                                      ?.orderStatusList
                                                      ?.ordersStatusList[index]
                                                      .status ==
                                                  "ongoing" &&
                                              state
                                                      .order
                                                      ?.orderStatusList
                                                      ?.ordersStatusList[index]
                                                      .name ==
                                                  "done"
                                          ? AppColors.buttonWarningColor
                                          : AppColors.iconColorDefault,
                                  size: 30,
                                  child: const Icon(
                                    Icons.check_circle_outline,
                                    size: 25,
                                    color: AppColors.white,
                                  ),
                                );
                },
                connectorBuilder: (_, index, ___) => DashedLineConnector(
                  color: state.order?.orderStatusList?.ordersStatusList[index]
                              .status ==
                          "done"
                      ? AppColors.buttonSuccessColor
                      : state.order?.orderStatusList?.ordersStatusList[index]
                                  .status ==
                              "ongoing"
                          ? AppColors.buttonWarningColor
                          : AppColors.iconColorDefault,
                ),
                itemExtentBuilder: (context, index) =>
                    MediaQuery.of(context).size.width / 4.5,
                itemCount:
                    state.order?.orderStatusList?.ordersStatusList.length ?? 0,
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
