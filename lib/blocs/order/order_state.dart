part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoaded extends OrderState {
  final Cart? cart;
  final User? user;
  final String? address;
  final String? paymentMethod;
  final Order? order;
  final double? fromLat;
  final double? fromLng;
  final double? toLat;
  final double? toLng;

  OrderLoaded({
    this.cart,
    this.user,
    this.address,
    this.paymentMethod,
    this.fromLat,
    this.fromLng,
    this.toLat,
    this.toLng,
  }) : order = Order(
    cart: cart,
    user: user,
    address: address,
    paymentMethod: paymentMethod,
  );

  @override
  List<Object?> get props =>
      [
        cart,
        user,
        address,
        paymentMethod,
        order,
        fromLat,
        fromLng,
        toLat,
        toLng
      ];
}

class OrderLoading extends OrderState {
  final Cart? cart;
  final User? user;
  final String? address;
  final String? paymentMethod;
  final Order? order;
  final double? fromLat;
  final double? fromLng;
  final double? toLat;
  final double? toLng;

  OrderLoading({
    this.cart,
    this.user,
    this.address,
    this.paymentMethod,
    this.fromLat,
    this.fromLng,
    this.toLat,
    this.toLng,
  }) : order = Order(
    cart: cart,
    user: user,
    address: address,
    paymentMethod: paymentMethod,
  );

  @override
  List<Object?> get props =>
      [
        cart,
        user,
        address,
        paymentMethod,
        order,
        fromLat,
        fromLng,
        toLat,
        toLng
      ];

}

class OrderProcessing extends OrderState {
  final Order order;
  final List<LatLng> polylinePoints;

  const OrderProcessing({required this.order, required this.polylinePoints});

  @override
  List<Object?> get props => [order, polylinePoints];
}

class OrderHistoryLoaded extends OrderState {
  final List<Order> orders;

  const OrderHistoryLoaded({this.orders = const <Order>[]});

  @override
  List<Object?> get props => [orders];
}
