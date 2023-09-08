import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_service/blocs/order/order_bloc.dart';
import 'package:social_service/core/values/app_colors.dart';
import 'package:social_service/core/widgets/base_app_bar.dart';
import 'package:social_service/core/widgets/custom_button.dart';
import 'package:social_service/presentasion/pages/detail_history_order/detail_history_order_screen.dart';
import 'package:social_service/router/app_pages.dart';

class HistoryOrderScreen extends StatefulWidget {
  const HistoryOrderScreen({super.key});

  @override
  State<HistoryOrderScreen> createState() => _HistoryOrderScreenState();
}

class _HistoryOrderScreenState extends State<HistoryOrderScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(LoadingOrderHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        headerTitle: "History Order",
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is OrderHistoryLoaded) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: ListView.builder(
                itemCount: state.orders.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: AppColors.palePurple,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                state.orders[index].user?.name ?? "name",
                                style: const TextStyle(
                                  color: AppColors.purpleBackground,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "Rp.${state.orders[index].totalPriceOrder}" ??
                                    "",
                                style: TextStyle(
                                  color: AppColors.purpleBackground,
                                  fontWeight: FontWeight.bold,
                                ),
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
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  AppRouter.push(context,  DetailHistoryOrder(order: state.orders[index]), Routes.detailHistoryOrderScreen);
                                },
                                style: ButtonStyle(
                                  backgroundColor: const MaterialStatePropertyAll(
                                      Colors.white),
                                  shape: const MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(15)),
                                        side: BorderSide(
                                            color: AppColors.purpleBackground,
                                            width: 2)),
                                  ),
                                  overlayColor: MaterialStateProperty.resolveWith(
                                    (states) {
                                      return states
                                              .contains(MaterialState.pressed)
                                          ? Colors.grey
                                          : null;
                                    },
                                  ),
                                ),
                                child: Text(
                                  "Detail",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                          color: AppColors.purpleBackground),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
