import 'package:equatable/equatable.dart';

class OrderStatusList extends Equatable {
  final List<OrderStatus> ordersStatusList;

  @override
  List<Object?> get props => [ordersStatusList];

  const OrderStatusList({
    required this.ordersStatusList,
  });

  Map<String, dynamic> toJson() {
    return {
      'ordersStatusList': ordersStatusList.map((e) => e.toJson()).toList(),
    };
  }

  factory OrderStatusList.fromJson(Map<dynamic, dynamic> json) =>
      OrderStatusList(
        ordersStatusList: List<OrderStatus>.from(
            json["ordersStatusList"].map((x) => OrderStatus.fromJson(x))),
      );
}

class OrderStatus extends Equatable {
  final String name;
  final String code;
  final String status;

  const OrderStatus({
    required this.name,
    required this.code,
    this.status = "pending",
  });

  @override
  List<Object?> get props => [name, code, status];

  static OrderStatus fromJson(Map<String, Object> json) {
    return OrderStatus(
      name: json['name'] as String,
      code: json['code'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, Object> toJson() {
    return {
      'name': name,
      'code': code,
      'status': status,
    };
  }
}
