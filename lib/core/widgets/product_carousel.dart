import 'package:flutter/material.dart';
import 'package:social_service/core/widgets/product_card.dart';
import 'package:social_service/models/product_model.dart';

class ProductCarousel extends StatelessWidget {
  const ProductCarousel({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height / 5,
      width: width,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ProductCard(
              product: products[index],
            ),
          );
        },
      ),
    );
  }
}
