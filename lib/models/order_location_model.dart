import 'package:equatable/equatable.dart';

class OrderLocationModel extends Equatable {
  final double? latitude;
  final double? longitude;
  final String? address;

  @override
  List<Object?> get props => [latitude, longitude, address];

  const OrderLocationModel({
    this.latitude,
    this.longitude,
    this.address,
  });

  OrderLocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
  }) {
    return OrderLocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  factory OrderLocationModel.fromJson(Map<String, dynamic> map) {
    return OrderLocationModel(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      address: map['address'] as String,
    );
  }
}
