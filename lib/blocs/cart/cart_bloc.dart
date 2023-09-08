import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:social_service/models/cart_model.dart';
import 'package:social_service/models/custom_order_model.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<CartStarted>(_mapCartStarted);
    on<CartAddProductToState>(_mapCartAddProductToState);
    on<CartRemoveProductToState>(_mapCartRemoveProductToState);
  }

  void _mapCartStarted(CartStarted event, Emitter<CartState> emit) async {
    emit(CartInitial());

    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(const CartLoaded());
    } catch (_) {}
  }

  void _mapCartAddProductToState(
      CartAddProductToState event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      try {
        final cartLoadedState = state as CartLoaded;
        final existingIndex = cartLoadedState.cart.customOrders.indexWhere(
            (order) => order.product.code == event.customOrder.product.code);

        if (existingIndex != -1) {
          List<CustomOrder> updatedCustomOrders =
              List.from(cartLoadedState.cart.customOrders);

          updatedCustomOrders[existingIndex] = event.customOrder.copyWith(
            quantity: updatedCustomOrders[existingIndex].quantity + 1,
            totalPrice: updatedCustomOrders[existingIndex].totalPrice +
                event.customOrder.fee,
          );

          emit(
            CartLoaded(
              cart: cartLoadedState.cart
                  .copyWith(customOrders: updatedCustomOrders),
            ),
          );
        } else {
          emit(
            CartLoaded(
              cart: Cart(
                customOrders: List.from(cartLoadedState.cart.customOrders)
                  ..add(event.customOrder),
              ),
            ),
          );
        }
      } catch (_) {}
    }
  }

  void _mapCartRemoveProductToState(
      CartRemoveProductToState event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      try {
        final cartLoadedState = state as CartLoaded;
        final existingIndex = cartLoadedState.cart.customOrders.indexWhere(
            (order) => order.product.code == event.customOrder.product.code);

        if (existingIndex != -1 &&
            cartLoadedState.cart.customOrders[existingIndex].quantity > 1) {
          List<CustomOrder> updatedCustomOrders =
              List.from(cartLoadedState.cart.customOrders);

          updatedCustomOrders[existingIndex] = event.customOrder.copyWith(
            quantity: updatedCustomOrders[existingIndex].quantity - 1,
            totalPrice: updatedCustomOrders[existingIndex].totalPrice -
                event.customOrder.fee,
          );

          emit(
            CartLoaded(
              cart: cartLoadedState.cart
                  .copyWith(customOrders: updatedCustomOrders),
            ),
          );
        } else {
          emit(
            CartLoaded(
              cart: Cart(
                customOrders: List.from(cartLoadedState.cart.customOrders)
                  ..remove(event.customOrder),
              ),
            ),
          );
        }
      } catch (_) {}
    }
  }
}
