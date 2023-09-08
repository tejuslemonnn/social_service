import 'package:equatable/equatable.dart';
import 'package:social_service/models/custom_order_model.dart';

class Cart extends Equatable {
  final List<CustomOrder> customOrders;

  const Cart({
    this.customOrders = const <CustomOrder>[],
  });

  @override
  List<Object?> get props => [customOrders];

  int get subTotal => customOrders.fold(0,
      (total, customOrder) => total + customOrder.fee * customOrder.quantity);

  String get subTotalString => subTotal.toStringAsFixed(2);

  Cart copyWith({
    List<CustomOrder>? customOrders,
  }) {
    return Cart(
      customOrders: customOrders ?? this.customOrders,
    );
  }

Map<String, Object> toJson() {
    return {
      'customOrders': customOrders.map((customOrder) => customOrder.toJson()).toList(),
    };
  }

  factory Cart.fromJson(Map<String, Object> json) {
    return Cart(
      customOrders: (json['customOrders'] as List<Object>).map((customOrder) => CustomOrder.fromJson(customOrder as Map<String, Object>)).toList(),
    );
  }
}
