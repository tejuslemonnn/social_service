import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_service/blocs/product/product_bloc.dart';
import 'package:social_service/router/app_pages.dart';
import 'package:social_service/core/values/app_colors.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    super.key,
    this.headerTitle = "",
    this.heightWhiteColor = 40,
    this.heightPurpleColor = 40,
    this.isHomeScreem = false,
    this.borderRadiusPurple = BorderRadius.zero,
    this.isSearchBar = false,
  });

  final String headerTitle;
  final double heightWhiteColor;
  final double heightPurpleColor;
  final bool isHomeScreem;
  final BorderRadiusGeometry borderRadiusPurple;
  final bool isSearchBar;

  @override
  Widget build(BuildContext context) {
    bool canPop = Navigator.canPop(context);
     Timer? _searchDebouncer;

    return AppBar(
        backgroundColor: AppColors.palePurple,
        shape: RoundedRectangleBorder(borderRadius: borderRadiusPurple),
        elevation: 0,
        title: headerTitle != ""
            ? Text(
                headerTitle,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: AppColors.purpleBackground),
              )
            : const SizedBox.shrink(),
        centerTitle: true,
        leading: canPop
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.purpleBackground,
                ),
                onPressed: () {
                  AppRouter.back(context);
                },
              )
            : const SizedBox.shrink(),
        bottom: isHomeScreem == false
            ? PreferredSize(
                preferredSize: Size.fromHeight(heightPurpleColor),
                child: Column(
                  children: [
                    isSearchBar == true
                        ? BlocBuilder<ProductBloc, ProductState>(
                            builder: (context, state) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 16.0, left: 16, bottom: 16),
                                child: TextField(
                                  style: const TextStyle(
                                      color: AppColors.purpleBackground),
                                  decoration: InputDecoration(
                                    hintText: 'Search...',
                                    hintStyle: const TextStyle(
                                        color: AppColors.purpleBackground),
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: AppColors.purpleBackground,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    _searchDebouncer?.cancel();

                                    _searchDebouncer = Timer(const Duration(milliseconds: 500), () {
                                      context.read<ProductBloc>().add(SearchProducts(value));
                                    });
                                  },
                                ),
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                    Container(
                      width: double.infinity,
                      height: heightWhiteColor,
                      decoration: const BoxDecoration(
                        color: AppColors.pageBackground,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(50),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const PreferredSize(
                preferredSize: Size.fromHeight(0), child: SizedBox.shrink()));
  }

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + heightPurpleColor);
}
