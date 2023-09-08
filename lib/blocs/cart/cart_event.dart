part of 'cart_bloc.dart';

@immutable
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartStarted extends CartEvent {
  @override
  List<Object?> get props => [];
}

class CartAddProductToState extends CartEvent {
  final CustomOrder customOrder;

  const CartAddProductToState(this.customOrder);

  @override
  List<Object?> get props => [customOrder];
}

class CartRemoveProductToState extends CartEvent {
  final CustomOrder customOrder;

  const CartRemoveProductToState(this.customOrder);

  @override
  List<Object?> get props => [customOrder];
}