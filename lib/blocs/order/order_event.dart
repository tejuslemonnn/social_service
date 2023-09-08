part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class OrderStarted extends OrderEvent {}

class UpdateOrder extends OrderEvent {
  final Cart? cart;
  final User? user;
  final String? address;
  final String? paymentMethod;
  final double? fromLat;
  final double? fromLng;
  final double? toLat;
  final double? toLng;

  @override
  List<Object?> get props =>
      [cart, user, address, paymentMethod, fromLat, fromLng, toLat, toLng];

  const UpdateOrder({
    this.cart,
    this.user,
    this.address,
    this.paymentMethod,
    this.fromLat,
    this.fromLng,
    this.toLat,
    this.toLng,
  });
}

class CreateOrder extends OrderEvent {
  final Order order;

  const CreateOrder({required this.order});

  @override
  List<Object?> get props => [order];
}

class LoadingOrderProcess extends OrderEvent {}

class UpdateStateOrderProcess extends OrderEvent {
  final Order order;

  const UpdateStateOrderProcess(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderCancel extends OrderEvent{
  final Order order;
  final BuildContext context;

  const OrderCancel({
    required this.order,
    required this.context
  });

  @override
  List<Object?> get props => [order];
}

class LoadingOrderHistory extends OrderEvent {}

class UpdateStateOrderHistory extends OrderEvent {
  final List<Order> orders;

  const UpdateStateOrderHistory(this.orders);

  @override
  List<Object?> get props => [orders];
}
