import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:social_service/models/cart_model.dart';
import 'package:social_service/models/custom_order_model.dart';
import 'package:social_service/models/order_location_model.dart';
import 'package:social_service/models/order_status_model.dart';
import 'package:social_service/models/product_model.dart';
import 'package:social_service/models/routing_direction_model.dart';
import 'package:social_service/models/user_model.dart';

class ListOrders extends Equatable {
  final List<Order> orders;

  @override
  List<Object?> get props => [orders];

  const ListOrders({
    required this.orders,
  });

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((e) => e.toJson()).toList(),
    };
  }

  factory ListOrders.fromJson(Map<dynamic, dynamic> json) => ListOrders(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  static ListOrders fromSnapshot(List<Order> orders) {
    return ListOrders(
      orders: orders,
    );
  }
}

class Order extends Equatable {
  final Cart? cart;
  final User? user;
  final String? address;
  final String? paymentMethod;
  final RoutingDirection? routingDirection;
  final OrderStatusList? orderStatusList;
  final User? engineer;
  final int? totalPriceOrder;
  final OrderLocationModel? orderLocationModel;

  const Order({
    this.cart,
    this.user,
    this.address,
    this.paymentMethod,
    this.routingDirection,
    this.orderStatusList,
    this.engineer,
    this.totalPriceOrder,
    this.orderLocationModel,
  });

  @override
  List<Object?> get props => [
        cart,
        user,
        address,
        paymentMethod,
        routingDirection,
        orderStatusList,
        engineer,
        totalPriceOrder,
        orderLocationModel,
      ];

  Order copyWith({
    Cart? cart,
    User? user,
    String? address,
    String? paymentMethod,
    RoutingDirection? routingDirection,
    OrderStatusList? orderStatusList,
    User? engineer,
    int? totalPriceOrder,
    OrderLocationModel? orderLocationModel,
  }) {
    return Order(
      cart: cart ?? this.cart,
      user: user ?? this.user,
      address: address ?? this.address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      routingDirection: routingDirection ?? this.routingDirection,
      orderStatusList: orderStatusList ?? this.orderStatusList,
      engineer: engineer ?? this.engineer,
      totalPriceOrder: totalPriceOrder ?? this.totalPriceOrder,
      orderLocationModel: orderLocationModel ?? this.orderLocationModel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart': cart!.toJson(),
      'user': user!.toJson(),
      'address': address,
      'paymentMethod': paymentMethod,
      'routing_direction': routingDirection!.toJson(),
      'orderStatusList': orderStatusList!,
      'engineer': engineer!.toJson(),
      'totalPriceOrder': totalPriceOrder,
      'orderLocationModel': orderLocationModel!.toJson(),
    };
  }

  factory Order.fromJson(Map<dynamic, dynamic> json) {
    // for cart
    Map<dynamic, dynamic> cartData = json['cart'] as Map<dynamic, dynamic>;

    List<OrderStatus> orderStatusList = [];
   if(json['orderStatus'] != null){
     for (dynamic orderStatusData in json['orderStatus']['ordersStatusList']) {
       OrderStatus orderStatus = OrderStatus(
         name: orderStatusData['name'],
         code: orderStatusData['code'],
         status: orderStatusData['status'],
       );
       orderStatusList.add(orderStatus);
     }
   }

    OrderStatusList orderStatusListData = OrderStatusList(
      ordersStatusList: orderStatusList,
    );

    List<CustomOrder> customOrders = [];
    for (dynamic orderData in cartData['customOrders']) {
      Product product = Product(
        name: orderData['product']['name'],
        category: orderData['product']['category'],
        isPopular: orderData['product']['isPopular'],
        code: orderData['product']['code'],
      );

      CustomOrder customOrder = CustomOrder(
        product: product,
        fee: orderData['fee'],
        productNoted: orderData['productNoted'],
        serviceType: orderData['serviceType'],
        totalPrice: orderData['totalPrice'],
        quantity: orderData['quantity'],
      );
      customOrders.add(customOrder);
    }

    Cart cart = Cart(customOrders: customOrders);
    // end for cart

    // for user
    User user = User(
      uid: json['user']['uid'],
      name: json['user']['name'],
      email: json['user']['email'],
      photo: json['user']['photo'],
    );
    // end for user

    RoutingDirection? routingDirection;
    if (json['routing_direction'] != null) {
      // for routingDirection

      // for features
      List<Feature> features = [];
      List<List<List<double>>>? coordinates = [];
      List<PurpleWaypoint> waypoints = [];

      for (dynamic featureData in json['routing_direction']['features']) {
        for (dynamic coordinate in featureData['geometry']['coordinates']) {
          coordinates.add(List<List<double>>.from(coordinate
              .map((x) => List<double>.from(x.map((x) => x.toDouble())))));
        }
        Geometry geometry = Geometry(
          type: featureData['geometry']['type'],
          coordinates: coordinates,
        );

        for (dynamic waypoint in json['routing_direction']['properties']
            ['waypoints']) {
          PurpleWaypoint purpleWaypoint = PurpleWaypoint(
            location: [
              waypoint['lat'],
              waypoint['lon'],
            ],
            originalIndex: waypoint['originalIndex'],
          );
          waypoints.add(purpleWaypoint);
        }

        FeatureProperties featureProperties = FeatureProperties(
          mode: json['routing_direction']['properties']['mode'],
          waypoints: waypoints,
        );

        Feature feature = Feature(
          type: featureData['type'],
          properties: featureProperties,
          geometry: geometry,
        );
        features.add(feature);
      }
      // end for features

      // for properties
      List<FluffyWaypoint> fluffyWaypoints = [];

      for (dynamic waypoint in json['routing_direction']['properties']
          ['waypoints']) {
        FluffyWaypoint fluffyWaypoint = FluffyWaypoint(
          lat: waypoint['lat'],
          lon: waypoint['lon'],
        );
        fluffyWaypoints.add(fluffyWaypoint);
      }

      RoutingDirectionProperties routingDirectionProperties =
          RoutingDirectionProperties(
              mode: json['routing_direction']['properties']['mode'],
              units: json['routing_direction']['properties']['units'],
              waypoints: fluffyWaypoints);

      routingDirection = RoutingDirection(
        features: features,
        properties: routingDirectionProperties,
        type: json['routing_direction']['type'],
      );
      // end for routingDirection
    }

    User? engineer;
    if (json['engineer'] != null) {
      engineer = User(
        uid: json['engineer']['uid'],
        name: json['engineer']['name'],
        email: json['engineer']['email'],
        photo: json['engineer']['photo'],
      );
    }

    OrderLocationModel? orderLocationModel;
    if (json['order_location_model'] != null) {
      orderLocationModel = OrderLocationModel(
        longitude: json['order_location_model']['longitude'],
        latitude: json['order_location_model']['latitude'],
        address: json['address'],
      );
    }

    return Order(
      cart: cart,
      user: user,
      address: json['address'],
      paymentMethod: json['paymentMethod'],
      routingDirection:
          json['routing_direction'] != null ? routingDirection : null,
      orderStatusList: orderStatusListData,
      totalPriceOrder: json['totalPriceOrder'],
      engineer: json['engineer'] != null ? engineer : null,
      orderLocationModel:
          json['order_location_model'] != null ? orderLocationModel : null,
    );
  }

  static Order fromSnapshop(DocumentSnapshot snapshot) {
    Order order = Order(
      address: snapshot['address'],
      paymentMethod: snapshot['paymentMethod'],
      totalPriceOrder: snapshot['totalPriceOrder'],
      engineer: snapshot['engineer'],
      user: snapshot['user'],
      cart: snapshot['cart'],
    );

    return order;
  }
}
