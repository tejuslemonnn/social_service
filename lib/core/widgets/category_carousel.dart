import 'package:flutter/material.dart';
import 'package:social_service/core/widgets/category_card.dart';
import 'package:social_service/models/category_model.dart';

class CategoryCarousel extends StatelessWidget {
  const CategoryCarousel({super.key, required this.categories});

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height / 6,
      width: width,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryCard(
            category: categories[index],
          );
        },
      ),
    );
  }
}
