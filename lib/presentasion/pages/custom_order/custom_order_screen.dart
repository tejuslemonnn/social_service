import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_service/blocs/cart/cart_bloc.dart';
import 'package:social_service/blocs/service/service_bloc.dart';
import 'package:social_service/core/widgets/base_app_bar.dart';
import 'package:social_service/core/widgets/custom_button.dart';
import 'package:social_service/cubits/custom_order/custom_order_cubit.dart';
import 'package:social_service/models/product_model.dart';
import 'package:social_service/router/app_pages.dart';

class CustomOrderScreen extends StatefulWidget {
  const CustomOrderScreen({super.key, required this.product});

  final Product product;

  @override
  State<CustomOrderScreen> createState() => _CustomOrderScreenState();
}

class _CustomOrderScreenState extends State<CustomOrderScreen> {
  @override
  void initState() {
    context.read<CustomOrderCubit>().initializeCustomOrder(widget.product);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const BaseAppBar(
        headerTitle: 'Custom Order',
      ),
      bottomSheet: bottomSheet(width, height),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const Divider(
                height: 20,
                thickness: 1,
              ),
              Text(
                "Select Service",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                "Required",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.normal,
                    ),
              ),
              const SizedBox(height: 15),
              servicesDropdown(),
              const Divider(
                height: 20,
                thickness: 1,
              ),
              Text(
                "Noted",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                "Optional",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
              const SizedBox(height: 15),
              BlocBuilder<CustomOrderCubit, CustomOrderProcess>(
                buildWhen: (previous, current) =>
                    previous.customOrder.productNoted !=
                    current.customOrder.productNoted,
                builder: (context, customOrderState) {
                  return TextFormField(
                    maxLength: 200,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onChanged: (value) {
                      context
                          .read<CustomOrderCubit>()
                          .productNotedChanged(value);
                    },
                  );
                },
              ),
              SizedBox(height: height * 0.35),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet(double width, double height) {
    return Container(
      height: height * 0.15,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          BlocBuilder<CustomOrderCubit, CustomOrderProcess>(
            buildWhen: (previous, current) =>
                previous.customOrder.quantity != current.customOrder.quantity ||
                previous.customOrder.serviceType !=
                    current.customOrder.serviceType,
            builder: (context, state) {
              return Row(
                children: [
                  Text(
                    "Total: ",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      state.customOrder.quantity > 1
                          ? context
                              .read<CustomOrderCubit>()
                              .quantityChanged(state.customOrder.quantity - 1)
                          : null;
                    },
                    child: const Icon(Icons.remove_circle_outline, size: 35),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    state.customOrder.quantity.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      state.customOrder.serviceType != ""
                          ? context
                              .read<CustomOrderCubit>()
                              .quantityChanged(state.customOrder.quantity + 1)
                          : null;
                    },
                    child: const Icon(
                      Icons.add_circle_outline,
                      size: 35,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 15),
          BlocBuilder<CustomOrderCubit, CustomOrderProcess>(
            buildWhen: (previous, current) =>
                previous.customOrder.serviceType !=
                    current.customOrder.serviceType ||
                previous.customOrder.fee != current.customOrder.fee ||
                previous.customOrder.quantity != current.customOrder.quantity,
            builder: (context, customOrderState) {
              return BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  if (cartState is CartInitial) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (cartState is CartLoaded) {
                    return CustomButtom(
                      onPressed: () {
                        if (customOrderState.customOrder.quantity > 0) {
                          context
                              .read<CustomOrderCubit>()
                              .customOrderFormSubmitted();

                          context.read<CartBloc>().add(
                                CartAddProductToState(
                                  customOrderState.customOrder,
                                  // customOrderState.product,
                                ),
                              );

                          AppRouter.back(context);
                        } else {
                          null;
                        }
                      },
                      hint:
                          "Total Price: ${customOrderState.customOrder.totalPrice}",
                      width: width,
                    );
                  } else {
                    return Center(
                      child: Text(
                        "Something Went Wrong",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    );
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }

  Widget servicesDropdown() {
    final TextEditingController textEditingController = TextEditingController();

    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        if (state is ServiceInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ServiceLoaded) {
          final services = state.services.where(
              (service) => service.categoryProduct == widget.product.category);

          return BlocBuilder<CustomOrderCubit, CustomOrderProcess>(
            buildWhen: (previous, current) =>
                previous.customOrder.serviceType !=
                    current.customOrder.serviceType &&
                previous.customOrder.fee == current.customOrder.fee,
            builder: (context, customOrderState) {
              return DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                hint: const Text(
                  'Select service',
                  style: TextStyle(fontSize: 14),
                ),
                items: services
                    .map((service) => DropdownMenuItem<String>(
                          value:
                              [service.name, service.fee.toString()].join(','),
                          child: Text(
                            service.name,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select service.';
                  }
                  return null;
                },
                onChanged: (value) {
                  final serviceValue = value!.split(',');
                  context.read<CustomOrderCubit>().serviceTypeChanged(
                      serviceValue[0], int.parse(serviceValue[1]));
                },
                value: customOrderState.customOrder.serviceType.isNotEmpty
                    ? customOrderState.customOrder.serviceType
                    : null,
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.only(right: 8),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                  iconSize: 24,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      controller: textEditingController,
                      expands: true,
                      maxLines: null,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: 'Search for an service...',
                        hintStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    final lowercaseSearchValue = searchValue.toLowerCase();
                    final lowercaseItemValue = item.value.toString().toLowerCase();
                    return lowercaseItemValue.contains(lowercaseSearchValue);
                  },
                ),
                onMenuStateChange: (isOpen) {
                  if(!isOpen){
                    textEditingController.clear();
                  }
                },
              );
            },
          );
        } else {
          return const Center(
            child: Text("Something Went Wrong!"),
          );
        }
      },
    );
  }
}
