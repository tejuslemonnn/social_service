import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:social_service/models/custom_order_model.dart';
import 'package:social_service/models/product_model.dart';

part 'custom_order_state.dart';

class CustomOrderCubit extends Cubit<CustomOrderProcess> {
  CustomOrderCubit() : super(CustomOrderProcess.inital());

  void initializeCustomOrder(Product product) {
    emit(
      state.copyWith(
        customOrder: CustomOrder(
          product: product,
          serviceType: '',
          fee: 0,
          quantity: 0,
          totalPrice: 0,
          productNoted: '',
        ),
        customOrderStatus: CustomOrderStatus.inital,
      ),
    );
  }

  void productNotedChanged(String value) {
    emit(
      state.copyWith(
        customOrder: state.customOrder.copyWith(productNoted: value),
        customOrderStatus: CustomOrderStatus.inital,
      ),
    );
  }

  void serviceTypeChanged(String serviceType, int fee) {
    emit(
      state.copyWith(
        customOrder:
            state.customOrder.copyWith(serviceType: serviceType, fee: fee),
        customOrderStatus: CustomOrderStatus.inital,
      ),
    );
  }

  void quantityChanged(int value) {
    final newTotalPrice = value * state.customOrder.fee;

    emit(
      state.copyWith(
        customOrder: state.customOrder
            .copyWith(quantity: value, totalPrice: newTotalPrice),
        customOrderStatus: CustomOrderStatus.inital,
      ),
    );
  }

  Future<void> customOrderFormSubmitted() async {
    if (state.customOrderStatus == CustomOrderStatus.submitting) return;
    emit(state.copyWith(customOrderStatus: CustomOrderStatus.submitting));
    try {
      emit(state.copyWith(customOrderStatus: CustomOrderStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          customOrderStatus: CustomOrderStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
