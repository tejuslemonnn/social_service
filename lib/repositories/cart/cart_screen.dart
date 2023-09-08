import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_service/blocs/cart/cart_bloc.dart';
import 'package:social_service/core/values/app_colors.dart';
import 'package:social_service/core/widgets/base_app_bar.dart';
import 'package:social_service/core/widgets/custom_button.dart';
import 'package:social_service/presentasion/pages/payment_method/payment_screen.dart';
import 'package:social_service/router/app_pages.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: const BaseAppBar(
          headerTitle: "Cart",
        ),
        bottomSheet: bottomSheet(height, width),
        body: BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartLoaded) {
              if (state.cart.customOrders.isEmpty) {
                AppRouter.back(context);
              }
            }
          },
          child: SingleChildScrollView(
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
                  listCart(width),
                ],
              ),
            ),
          ),
        ));
  }

  BlocBuilder<CartBloc, CartState> bottomSheet(double height, double width) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is CartLoaded) {
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
                    onPressed: () {
                      AppRouter.push(
                          context, const PaymentScreen(), Routes.payemntScreen);
                    },
                    hint: "payment method")
              ],
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
    );
  }

  BlocBuilder<CartBloc, CartState> listCart(double width) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is CartLoaded) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.cart.customOrders.length,
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
                        height: MediaQuery.of(context).size.height / 7,
                        child: Image.asset(
                          imageProduct(
                              state.cart.customOrders[index].product.category),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.cart.customOrders[index].product.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Service: ",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Expanded(
                                  child: Text(
                                    state.cart.customOrders[index].serviceType,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Rp. ${state.cart.customOrders[index].totalPrice.toString()}",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.read<CartBloc>().add(
                                        CartAddProductToState(
                                            state.cart.customOrders[index]));
                                  },
                                  icon: const Icon(
                                    Icons.add_circle_outline_outlined,
                                    size: 30,
                                  ),
                                ),
                                AutoSizeText(
                                  state.cart.customOrders[index].quantity
                                      .toString(),
                                  minFontSize: 12,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.read<CartBloc>().add(
                                        CartRemoveProductToState(
                                            state.cart.customOrders[index]));
                                  },
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
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
