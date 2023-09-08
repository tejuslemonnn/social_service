import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_service/blocs/cart/cart_bloc.dart';
import 'package:social_service/blocs/order/order_bloc.dart';
import 'package:social_service/core/values/app_colors.dart';
import 'package:social_service/presentasion/pages/order/order_screen.dart';
import 'package:social_service/repositories/cart/cart_screen.dart';
import 'package:social_service/router/app_pages.dart';

class FloatingButtonCustom extends StatefulWidget {
  const FloatingButtonCustom({super.key});

  @override
  State<FloatingButtonCustom> createState() => _FloatingButtonCustomState();
}

class _FloatingButtonCustomState extends State<FloatingButtonCustom> {

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(LoadingOrderProcess());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderInitial) {
          return BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartInitial) {
                return const SizedBox.shrink();
              }

              if (state is CartLoaded && state.cart.customOrders.isNotEmpty) {
                return Container(
                  width: width,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      AppRouter.push(
                          context, const CartScreen(), Routes.cartScreen);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: AppColors.purpleBackground),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${state.cart.customOrders.length} Item",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          "Rp. ${state.cart.subTotal}",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        }

        if (state is OrderProcessing) {
          return Container(
            width: width,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: () {
                AppRouter.push(
                    context, const OrderScreen(), Routes.orderScreen);
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: AppColors.purpleBackground),
              child: Center(
                child: Text(
                  "Order Now",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppColors.white,
                      ),
                ),
              ),
            ),
          );
        } else {
          return BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartInitial) {
                return const SizedBox.shrink();
              }

              if (state is CartLoaded && state.cart.customOrders.isNotEmpty) {
                return Container(
                  width: width,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      AppRouter.push(
                          context, const CartScreen(), Routes.cartScreen);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: AppColors.purpleBackground),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${state.cart.customOrders.length} Item",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: AppColors.white,
                              ),
                        ),
                        Text(
                          "Rp. ${state.cart.subTotal}",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: AppColors.white,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        }
      },
    );
  }
}
