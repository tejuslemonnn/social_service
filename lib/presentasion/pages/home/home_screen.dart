import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_service/blocs/auth/auth_bloc.dart';
import 'package:social_service/blocs/cart/cart_bloc.dart';
import 'package:social_service/blocs/category/category_bloc.dart';
import 'package:social_service/blocs/order/order_bloc.dart';
import 'package:social_service/blocs/product/product_bloc.dart';
import 'package:social_service/core/values/app_colors.dart';
import 'package:social_service/core/widgets/category_carousel.dart';
import 'package:social_service/core/widgets/floating_button_custom.dart';
import 'package:social_service/core/widgets/product_carousel.dart';
import 'package:social_service/models/user_model.dart';
import 'package:social_service/presentasion/pages/user_profile/user_profile.dart';
import 'package:social_service/repositories/cart/cart_screen.dart';
import 'package:social_service/router/app_pages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(LoadingOrderProcess());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc authBloc) => authBloc.state.user);

    double width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const FloatingButtonCustom(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _header(context, user),
            Padding(
              padding: EdgeInsets.only(
                  left: 24, right: 24, bottom: 16, top: height / 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Category Service",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: AppColors.white.withOpacity(0.6),
                        ),
                  ),
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryInitial) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is CategoryLoaded) {
                        return CategoryCarousel(categories: state.categories);
                      } else {
                        return const Center(
                          child: Text("Something Went Wrong!"),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "News",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: AppColors.black.withOpacity(0.6),
                        ),
                  ),
                  _listNews(width, height),
                  const SizedBox(height: 20),
                  Text(
                    "Popular Product",
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
                        return ProductCarousel(
                          products: state.products
                              .where((product) => product.isPopular)
                              .toList(),
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
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, User user) {
    double width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: height / 4,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
        color: AppColors.purpleBackground,
      ),
      child: Stack(
        children: [
          Positioned(
              top: -(width / 4),
              left: width - (width / 4),
              child: Transform.rotate(
                angle: 2,
                child: Container(
                  width: width / 2,
                  height: width / 2,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.transparent,
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x87e7e7e7), Color(0x00d9d9d9)],
                    ),
                  ),
                ),
              )),
          Positioned(
              top: height / 8,
              right: width / 1.5,
              child: Transform.rotate(
                angle: 2,
                child: Container(
                  width: width / 2,
                  height: width / 2,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.transparent,
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x87e7e7e7), Color(0x00d9d9d9)],
                    ),
                  ),
                ),
              )),
          Positioned.fill(
              bottom: 36,
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name ?? "Hi, Customer",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(color: AppColors.white),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Need Help?",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        color:
                                            AppColors.white.withOpacity(0.8)),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              AppRouter.push(context, const UserProfileScreen(),
                                  Routes.profileScreen);
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColors.white,
                              child:
                                  user.photo != null && user.photo!.isNotEmpty
                                      ? ClipOval(
                                          child: Image.network(
                                            user.photo!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(Icons.person),
                            ),
                          )
                        ],
                      ))))
        ],
      ),
    );
  }

  Widget _listNews(double width, double height) {
    return SizedBox(
      height: height / 4,
      width: width,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12.0, top: 12.0),
            child: Row(
              children: [
                Container(
                  height: height / 4,
                  width: width / 3,
                  decoration: const BoxDecoration(
                    color: AppColors.purpleBackground,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(Icons.newspaper,
                          color: Colors.white, size: 50),
                      Text(
                        "Breaking News",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: AppColors.white),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                Container(
                  height: height / 4,
                  width: width / 2,
                  decoration: const BoxDecoration(
                    color: AppColors.paleBlue,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        "Teknisi siap datang ke lokasi anda",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Segera service barang anda!",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: AppColors.black.withOpacity(0.6)),
                      ),
                      const Spacer(),
                      Stack(
                        children: [
                          Container(
                            height: 40,
                            width: width / 2,
                            decoration: const BoxDecoration(
                                color: AppColors.purpleBackground,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                )),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Bisa Bayar Dengan",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: AppColors.white),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              height: 40,
                              width: width / 6,
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/svg/ic_cash.svg",
                                      height: 25),
                                  Text(
                                    "COD",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class showFloatingButton extends StatelessWidget {
  const showFloatingButton({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
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
}
