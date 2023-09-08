import 'package:equatable/equatable.dart';
import 'package:social_service/models/product_model.dart';

class CustomOrder extends Equatable {
  final String serviceType;
  final Product product;
  final String productNoted;
  final int quantity;
  final int fee;
  final int totalPrice;

  const CustomOrder({
    required this.serviceType,
    required this.product,
    required this.productNoted,
    required this.quantity,
    required this.fee,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [
        serviceType,
        product,
        productNoted,
        quantity,
        fee,
        totalPrice,
      ];

  CustomOrder copyWith({
    String? serviceType,
    Product? product,
    String? productNoted,
    int? quantity,
    int? fee,
    int? totalPrice,
  }) {
    return CustomOrder(
      serviceType: serviceType ?? this.serviceType,
      product: product ?? this.product,
      productNoted: productNoted ?? this.productNoted,
      quantity: quantity ?? this.quantity,
      fee: fee ?? this.fee,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, Object> toJson() {
    return {
      'serviceType': serviceType,
      'product': product.toJson(),
      'productNoted': productNoted,
      'quantity': quantity,
      'fee': fee,
      'totalPrice': totalPrice,
    };
  }

  static CustomOrder fromJson(Map<String, Object> json) {
    return CustomOrder(
      serviceType: json['serviceType'] as String,
      product: Product.fromJson(json['product'] as Map<String, Object>),
      productNoted: json['productNoted'] as String,
      quantity: json['quantity'] as int,
      fee: json['fee'] as int,
      totalPrice: json['totalPrice'] as int,
    );
  }
}
