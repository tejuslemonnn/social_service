import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_service/blocs/engineer/engineer_bloc.dart';
import 'package:social_service/core/values/app_colors.dart';
import 'package:social_service/core/widgets/base_app_bar.dart';
import 'package:social_service/core/widgets/custom_button.dart';
import 'package:social_service/presentasion/pages/order_processing/order_processing_screen.dart';
import 'package:social_service/router/app_pages.dart';

class EngineerDetailOrder extends StatefulWidget {
  const EngineerDetailOrder({super.key});

  @override
  State<EngineerDetailOrder> createState() => _EngineerDetailOrderState();
}

class _EngineerDetailOrderState extends State<EngineerDetailOrder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const BaseAppBar(
        headerTitle: 'Detail Order',
      ),
      bottomSheet: _bottomSheet(width, height),
      body: BlocBuilder<EngineerBloc, EngineerState>(
        builder: (context, state) {
          if (state is EngineerLoadingProcess) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is EngineerLookingOrderState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cart",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: AppColors.black.withOpacity(0.6),
                          ),
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.order?.cart?.customOrders.length ?? 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            width: width,
                            decoration: const BoxDecoration(
                              color: AppColors.palePurple,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 7,
                                  child: Image.asset(
                                    imageProduct(state
                                            .order
                                            ?.cart
                                            ?.customOrders[index]
                                            .product
                                            .category ??
                                        ""),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.order?.cart?.customOrders[index]
                                                .product.name ??
                                            '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Service: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          Text(
                                            state
                                                    .order
                                                    ?.cart
                                                    ?.customOrders[index]
                                                    .serviceType ??
                                                "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Price: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          Text(
                                            "Rp. ${state.order?.cart?.customOrders[index].totalPrice.toString()}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "QTY: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          Text(
                                            "Rp. ${state.order?.cart?.customOrders[index].quantity}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                      state.order?.cart?.customOrders[index]
                                                  .productNoted !=
                                              ""
                                          ? Row(
                                              children: [
                                                Text(
                                                  "Noted: ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                                Text(
                                                  "${state.order?.cart?.customOrders[index].productNoted}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
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
      ),
    );
  }

  Widget _bottomSheet(double width, double height) {
    return BlocBuilder<EngineerBloc, EngineerState>(
      builder: (context, state) {
        if (state is EngineerLoadingProcess) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is EngineerLookingOrderState) {
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
                      "Rp. ${state.order?.cart?.subTotal.toString()}",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                CustomButtom(
                  onPressed: () {
                    context.read<EngineerBloc>().add(
                          EngineerClaimingOrder(
                            order: state.order,
                            context: context,
                          ),
                        );
                  },
                  hint: "Order",
                )
              ],
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

  String imageProduct(String product) {
    switch (product) {
      case "air-conditioner":
        return "assets/images/ac_image.png";
      case "laptop":
        return "assets/images/laptop_image.png";
      case "fan":
        return "assets/images/fan_image.png";
      default:
        return '';
    }
  }
}
