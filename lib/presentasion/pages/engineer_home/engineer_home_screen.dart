import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_service/blocs/engineer/engineer_bloc.dart';
import 'package:social_service/core/values/app_colors.dart';
import 'package:social_service/core/widgets/custom_button.dart';
import 'package:social_service/cubits/engineer/engineer_cubit.dart';
import 'package:social_service/presentasion/pages/engineer_detail_order/engineer_detail_order_screen.dart';
import 'package:social_service/presentasion/pages/order_processing/order_processing_screen.dart';
import 'package:social_service/presentasion/pages/user_profile_engineer/user_profile_engineer.dart';
import 'package:social_service/router/app_pages.dart';

class EngineerHomeScreen extends StatefulWidget {
  const EngineerHomeScreen({super.key});

  @override
  State<EngineerHomeScreen> createState() => _EngineerHomeScreenState();
}

class _EngineerHomeScreenState extends State<EngineerHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EngineerBloc>().add(EngineerCurrentOrder());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    final MapController mapController = MapController();
    final DraggableScrollableController sheetController =
        DraggableScrollableController();

    return BlocListener<EngineerBloc, EngineerState>(
      listener: (context, state) {
        if (state is EngineerProcessingOrderState) {
          AppRouter.pushAndRemoveUntil(context, const OrderProcessingScreen(),
              Routes.engineerProcessOrderScreen);
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            AppRouter.push(context, const UserProfileEngineerScreen(),
                Routes.engineerDetailOrderScreen);
          },
          backgroundColor: AppColors.purpleBackground,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.white,
            child: Text(
              "S",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: AppColors.purpleBackground,
                  ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: Stack(
          children: [
            BlocBuilder<EngineerCubit, EngineerProcess>(
              buildWhen: (previous, current) =>
                  previous.position != current.position ||
                  previous.liveUserStatus != current.liveUserStatus,
              builder: (context, state) {
                final liveUserLocationCubit = context.read<EngineerCubit>();
                liveUserLocationCubit.getCurrentLocation();

                if (state.liveUserStatus == EngineerLocationStatus.initial) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.liveUserStatus == EngineerLocationStatus.loaded) {
                  return SizedBox(
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            center: LatLng(state.position!.latitude,
                                state.position!.longitude),
                            zoom: 18,
                            minZoom: 10,
                            maxZoom: 18,
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
                                  point: LatLng(state.position!.latitude,
                                      state.position!.longitude),
                                  builder: (context) => const Icon(
                                    Icons.pin_drop,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: height / 6, right: 20.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: AppColors.white,
                                child: IconButton(
                                  onPressed: () {
                                    mapController.move(
                                      LatLng(state.position!.latitude,
                                          state.position!.longitude),
                                      16,
                                    );
                                  },
                                  iconSize: 30,
                                  color: AppColors.purpleBackground,
                                  icon: const Icon(
                                    Icons.my_location_outlined,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("Error"),
                  );
                }
              },
            ),
            DraggableScrollableSheet(
              minChildSize: 0.15,
              initialChildSize: 0.15,
              maxChildSize: 0.8,
              controller: sheetController,
              builder: (context, scrollController) {
                // Calculate the current height of the sheet based on the animation value
                final double sheetHeight =
                    MediaQuery.of(context).size.height * 0.8;

                // Calculate the current border radius based on the sheet height
                const double maxCornerRadius = 50.0;
                const double minCornerRadius = 50.0;
                double currentCornerRadius = maxCornerRadius -
                    ((sheetHeight -
                            (MediaQuery.of(context).size.height * 0.2)) /
                        sheetHeight *
                        maxCornerRadius);
                currentCornerRadius =
                    currentCornerRadius.clamp(minCornerRadius, maxCornerRadius);

                return BlocBuilder<EngineerBloc, EngineerState>(
                  buildWhen: (previous, current) {
                    if (previous is EngineerOnline &&
                        current is EngineerOnline) {
                      return previous.listOrders != current.listOrders;
                    }
                    return previous != current;
                  },
                  builder: (context, engineerState) {
                    print(engineerState);
                    return BlocBuilder<EngineerCubit, EngineerProcess>(
                      builder: (context, engineerProcess) {
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
                                BlocBuilder<EngineerCubit, EngineerProcess>(
                                  buildWhen: (previous, current) =>
                                      previous.isOnline != current.isOnline ||
                                      previous.liveUserStatus !=
                                          current.liveUserStatus,
                                  builder: (context, stateIsOnline) {
                                    return CustomButtom(
                                      onPressed: stateIsOnline.isOnline == false
                                          ? // find order
                                          () {
                                              sheetController.animateTo(
                                                0.8,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.easeInOut,
                                              );

                                              context
                                                  .read<EngineerCubit>()
                                                  .changeEngineerStatus();

                                              context
                                                  .read<EngineerBloc>()
                                                  .add(EngineerStarted());
                                            }
                                          : // cancel
                                          stateIsOnline.liveUserStatus ==
                                                  EngineerLocationStatus.loaded
                                              ? () {
                                                  sheetController.animateTo(
                                                    0.15,
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    curve: Curves.easeInOut,
                                                  );

                                                  context
                                                      .read<EngineerCubit>()
                                                      .changeEngineerStatus();

                                                  context
                                                      .read<EngineerBloc>()
                                                      .add(
                                                          ClearStateEngineer());
                                                }
                                              : () {},
                                      iconData: stateIsOnline.isOnline == false
                                          ? Icons.search
                                          : Icons.close,
                                      hint: stateIsOnline.isOnline == false
                                          ? "Find Order"
                                          : "Cancel",
                                      color: stateIsOnline.isOnline == false
                                          ? AppColors.purpleBackground
                                          : Colors.red,
                                      width: width,
                                    );
                                  },
                                ),
                                const SizedBox(height: 40),
                                Text(
                                  "Order List",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 20),
                                _listOrder(
                                    engineerState: engineerState,
                                    engineerProcess: engineerProcess)
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _listOrder(
      {required EngineerState engineerState,
      required EngineerProcess engineerProcess}) {
    double width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

    if (engineerProcess.isOnline && engineerState is EngineerOnline) {
      return Expanded(
        child: ListView.builder(
          itemCount: engineerState.listOrders?.orders.length ?? 0,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColors.white,
                        child: Text(
                          "S",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                color: AppColors.purpleBackground,
                              ),
                        ),
                      ),
                      title: Text(
                        engineerState.listOrders?.orders[index].user?.name ??
                            "User Name",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        "${engineerState.listOrders?.orders[index].cart?.customOrders.length} item",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: AppColors.black,
                                ),
                      ),
                      trailing: Text(
                        "Rp. ${engineerState.listOrders?.orders[index].cart?.subTotal}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(seconds: 10),
                      height: 4,
                      width: engineerProcess.isOnline ? 0 : width,
                      alignment: Alignment.centerLeft,
                      curve: Curves.fastOutSlowIn,
                      color: AppColors.purpleBackground,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButtom(
                        onPressed: () {
                          context.read<EngineerBloc>().add(
                              EngineerLoadingOrderDetail(
                                  order:
                                      engineerState.listOrders?.orders[index]));
                          AppRouter.push(context, const EngineerDetailOrder(),
                              Routes.engineerDetailOrderScreen);
                        },
                        width: width,
                        hint: "Detail",
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
