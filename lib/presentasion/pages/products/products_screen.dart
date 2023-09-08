import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_service/blocs/cart/cart_bloc.dart';
import 'package:social_service/blocs/product/product_bloc.dart';
import 'package:social_service/core/values/app_colors.dart';
import 'package:social_service/core/widgets/base_app_bar.dart';
import 'package:social_service/core/widgets/floating_button_custom.dart';
import 'package:social_service/models/category_model.dart';
import 'package:social_service/presentasion/pages/custom_order/custom_order_screen.dart';
import 'package:social_service/repositories/cart/cart_screen.dart';
import 'package:social_service/router/app_pages.dart';

class ProductsScreen extends StatefulWidget {
  final Category category;

  const ProductsScreen({super.key, required this.category});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadingProduct());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const FloatingButtonCustom(),
      appBar: BaseAppBar(
        headerTitle: widget.category.name,
        heightPurpleColor: 125,
        isSearchBar: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Products",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: AppColors.black.withOpacity(0.6),
                    ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductInitial) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is ProductLoaded) {
                    final products = state.products
                        .where((element) =>
                            element.category == widget.category.code)
                        .toList();
                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.0 / 1.4,
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                      ),
                      itemCount: products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext contextGrid, int index) {
                        return GestureDetector(
                          onTap: () {
                            AppRouter.push(
                                context,
                                CustomOrderScreen(product: products[index]),
                                Routes.customOrderScreen);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.palePurple,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withOpacity(0.6),
                                    blurRadius: 1,
                                    offset: const Offset(0, 1),
                                  )
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    width:
                                        MediaQuery.of(contextGrid).size.width,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(imageProduct(
                                            products[index].category)),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                          6.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      products[index].name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("Something Went Wrong!"),
                    );
                  }
                },
              ),
            ],
          ),
        ),
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
