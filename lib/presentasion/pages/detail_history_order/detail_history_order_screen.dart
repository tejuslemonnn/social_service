import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_service/core/values/app_colors.dart';
import 'package:social_service/core/widgets/base_app_bar.dart';
import 'package:social_service/models/order_model.dart';

class DetailHistoryOrder extends StatefulWidget {
  final Order order;

  const DetailHistoryOrder({super.key, required this.order});

  @override
  State<DetailHistoryOrder> createState() => _DetailHistoryOrderState();
}

class _DetailHistoryOrderState extends State<DetailHistoryOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        headerTitle: "History Detail",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "History Detail",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: AppColors.black.withOpacity(0.6),
                    ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "Name Engineer:",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.order.engineer?.name ?? '',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "Date:",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '1-09-2023',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "Location:",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.order.address ?? "",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "Total Price:",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Rp.${widget.order.totalPriceOrder}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "Rating:",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(children: [
                        const WidgetSpan(
                            child: Icon(
                          Icons.star,
                          color: CupertinoColors.systemYellow,
                        )),
                        TextSpan(
                          text: "4.5",
                          style: Theme.of(context).textTheme.headlineMedium,
                        )
                      ]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "List Product",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: AppColors.black.withOpacity(0.6),
                    ),
              ),
              const SizedBox(height: 10),
              _listProduct(widget.order),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listProduct(Order order) {
    return SizedBox(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: order.cart?.customOrders.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
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
                          order.cart?.customOrders[index].product.category ?? ""),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.cart?.customOrders[index].product.name ?? "",
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
                                order.cart?.customOrders[index].serviceType ?? "",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${order.cart?.customOrders[index].quantity ?? 0} x Rp.${order.cart?.customOrders[index].fee ?? 0}",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            "Rp.${order.cart?.customOrders[index].totalPrice ?? 0}",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
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
