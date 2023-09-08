import 'package:flutter/material.dart';
import 'package:social_service/core/values/app_colors.dart';
import 'package:social_service/models/product_model.dart';
import 'package:social_service/presentasion/pages/custom_order/custom_order_screen.dart';
import 'package:social_service/router/app_pages.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouter.push(
            context,
            CustomOrderScreen(product: product),
            Routes.customOrderScreen);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
            color: AppColors.palePurple,
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: 175,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/laptop_image.png"),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      6.0,
                    ),
                  ),
                ),
                child: const Stack(
                  children: [
                    Positioned(
                      right: 6.0,
                      top: 8.0,
                      child: CircleAvatar(
                        radius: 14.0,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
             Text(
              product.name,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Row(
              children: [
                const Text(
                  "Category:",
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(
                  width: 4.0,
                ),
                Text(
                  product.category,
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
