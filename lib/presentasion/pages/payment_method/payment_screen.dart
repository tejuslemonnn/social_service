import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_service/blocs/auth/auth_bloc.dart';
import 'package:social_service/blocs/cart/cart_bloc.dart';
import 'package:social_service/blocs/order/order_bloc.dart';
import 'package:social_service/core/widgets/custom_button.dart';
import 'package:social_service/cubits/payment_method/payment_method_cubit.dart';
import 'package:social_service/cubits/search_address/search_address_cubit.dart';
import 'package:social_service/core/values/app_colors.dart';
import 'package:social_service/core/widgets/base_app_bar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_service/presentasion/pages/order/order_screen.dart';
import 'package:social_service/router/app_pages.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const BaseAppBar(
        headerTitle: "Payment",
      ),
      bottomSheet: bottomSheet(height, width),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _locationCard(height, width, context),
              const SizedBox(height: 20),
              Text(
                "Payment Method",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: AppColors.purpleBackground,
                    ),
              ),
              const SizedBox(height: 10),
              _buildPaymentMethodTable(width, height),
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationCard(double height, double width, BuildContext context) {
    return Container(
      height: height * 0.4,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.palePurple,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your location",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: AppColors.purpleBackground,
                ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              BlocBuilder<SearchAddressCubit, SearchAddressProcess>(
                buildWhen: (previous, current) =>
                    previous.autoCompleteAddressResult !=
                    current.autoCompleteAddressResult,
                builder: (context, state) {
                  return Expanded(
                    child: Text(
                      state.autoCompleteAddressResult?.formatted ?? "",
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: AppColors.purpleBackground,
                                fontWeight: FontWeight.normal,
                              ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _changeLocation,
                style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll(Colors.white),
                  shape: const MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        side: BorderSide(
                            color: AppColors.purpleBackground, width: 2)),
                  ),
                  overlayColor: MaterialStateProperty.resolveWith(
                    (states) {
                      return states.contains(MaterialState.pressed)
                          ? Colors.grey
                          : null;
                    },
                  ),
                ),
                child: Text(
                  "Change",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: AppColors.purpleBackground),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          _yourLocation(),
        ],
      ),
    );
  }

  Widget _yourLocation() {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderLoading) {
          AppRouter.pushAndRemoveUntil(
              context, const OrderScreen(), Routes.orderScreen);
        }
      },
      child: BlocBuilder<SearchAddressCubit, SearchAddressProcess>(
        buildWhen: (previous, current) =>
            previous.autoCompleteAddressResult !=
            current.autoCompleteAddressResult,
        builder: (context, state) {
          if (state.autoCompleteAddressResult == null) {
            return const SizedBox();
          }

          return Builder(
            builder: (context) {
              LatLng center = LatLng(state.autoCompleteAddressResult!.lat!,
                  state.autoCompleteAddressResult!.lon!);

              return Expanded(
                child: SizedBox(
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          center: center,
                          zoom: 16,
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
                                point: center,
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
                          padding:
                              const EdgeInsets.only(bottom: 8.0, right: 8.0),
                          child: CircleAvatar(
                            backgroundColor: AppColors.white,
                            child: IconButton(
                              onPressed: () {
                                _mapController.move(center, 16.0);
                              },
                              icon: const Icon(
                                Icons.my_location_outlined,
                                color: AppColors.purpleBackground,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _changeLocation() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
      clipBehavior: Clip.antiAlias,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: const BoxDecoration(
              color: AppColors.palePurple,
              borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
          child: Column(
            children: [
              BlocBuilder<SearchAddressCubit, SearchAddressProcess>(
                builder: (context, state) {
                  return TextFormField(
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          context
                              .read<SearchAddressCubit>()
                              .addressSubmit(state.address);
                        },
                      ),
                    ),
                    onChanged: (value) {
                      context.read<SearchAddressCubit>().addressChanged(value);
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              ListTile(
                title: ElevatedButton(
                  onPressed: ()  {
                    context.read<SearchAddressCubit>().getCurrentPosition();

                    AppRouter.back(context);
                  },
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(AppColors.palePurple),
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.all(15),
                    ),
                    side: MaterialStatePropertyAll(
                      BorderSide(width: 1),
                    ),
                  ),
                  child: Text(
                    "Current Location",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<SearchAddressCubit, SearchAddressProcess>(
                buildWhen: (previous, current) =>
                    previous.autoCompleteAddress !=
                        current.autoCompleteAddress ||
                    previous.searchAddressStatus != current.searchAddressStatus,
                builder: (context, state) {
                  if (state.searchAddressStatus ==
                      SearchAddressStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.searchAddressStatus ==
                      SearchAddressStatus.success) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount:
                            state.autoCompleteAddress?.results?.length ?? 0,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<SearchAddressCubit>()
                                    .autoAddressResult(state
                                        .autoCompleteAddress!.results![index]);

                                AppRouter.back(context);
                              },
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    AppColors.palePurple),
                                padding: MaterialStatePropertyAll(
                                  EdgeInsets.all(15),
                                ),
                                side: MaterialStatePropertyAll(
                                  BorderSide(width: 1),
                                ),
                              ),
                              child: Text(
                                state.autoCompleteAddress?.results
                                        ?.elementAt(index)
                                        .formatted ??
                                    "",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodTable(double width, double height) {
    return BlocBuilder<PaymentMethodCubit, PaymentMethodInitial>(
      builder: (context, state) {
        return Container(
          width: width,
          decoration: BoxDecoration(
            color: AppColors.palePurple,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: SvgPicture.asset('assets/svg/ic_hand-cash.svg'),
                title: const Text('COD'),
                trailing: Radio<String>(
                  value: "COD",
                  groupValue: state.paymentMethod,
                  onChanged: (value) {
                    context
                        .read<PaymentMethodCubit>()
                        .selectPaymentMethod(value!);
                  },
                ),
              ),
              const Divider(
                color: AppColors.black,
              ),
              ListTile(
                leading: SvgPicture.asset('assets/svg/ic_dana.svg'),
                title: const Text('Dana'),
                trailing: Radio<String>(
                  value: "Dana",
                  groupValue: state.paymentMethod,
                  onChanged: (value) {
                    context
                        .read<PaymentMethodCubit>()
                        .selectPaymentMethod(value!);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget bottomSheet(double height, double width) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is CartLoaded) {
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              return BlocBuilder<SearchAddressCubit, SearchAddressProcess>(
                builder: (context, addessState) {
                  return Container(
                    height: height / 8,
                    width: width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Rp. ${state.cart.subTotal.toString()}",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ],
                        ),
                        CustomButtom(
                            onPressed: () async {
                              context.read<OrderBloc>().add(
                                    UpdateOrder(
                                      cart: state.cart,
                                      user: authState.user,
                                      address: addessState
                                          .autoCompleteAddressResult?.formatted,
                                      fromLat: addessState
                                          .autoCompleteAddressResult?.lat,
                                      fromLng: addessState
                                          .autoCompleteAddressResult?.lon,
                                      toLat: -7.33350405,
                                      toLng: 112.79056069488871,
                                    ),
                                  );

                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return BlocBuilder<OrderBloc, OrderState>(
                                    builder: (context, orderFinalState) {
                                      if (orderFinalState is OrderLoaded) {
                                        return AlertDialog(
                                          title: const Text('Cancel booking'),
                                          content: const SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text(
                                                    'Are you sure want to order?'),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('No'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Yes'),
                                              onPressed: () async {
                                                context.read<OrderBloc>().add(
                                                    CreateOrder(
                                                        order: orderFinalState.order!));

                                                context.read<CartBloc>().add(CartStarted());
                                              },
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const Center(
                                          child: Text("Something Went Wrong!"),
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            },
                            hint: "Order")
                      ],
                    ),
                  );
                },
              );
            },
          );
        } else {
          return Center(
            child: Text(
              "Something Went Wrong",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          );
        }
      },
    );
  }
}
