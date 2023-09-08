import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_service/core/values/app_colors.dart';
import 'package:social_service/models/category_model.dart';
import 'package:social_service/presentasion/pages/products/products_screen.dart';
import 'package:social_service/router/app_pages.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, top: 12.0),
      child: GestureDetector(
        onTap: () {
          AppRouter.push(context, ProductsScreen(category: category), Routes.productsScreen);
        },
        child: Container(
          height: 150,
          width: 125,
          decoration: const BoxDecoration(
              color: AppColors.paleBlue,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                    color: AppColors.palePurple,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svg/ic_${category.code}.svg',
                  ),
                ),
              ),
              Text(
                category.name,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColors.purpleBackground,
                      fontWeight: FontWeight.bold,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
