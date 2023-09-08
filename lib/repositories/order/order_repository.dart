import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_database/firebase_database.dart';
import 'package:social_service/models/order_model.dart';
import 'package:social_service/models/order_status_model.dart';
import 'package:social_service/models/user_model.dart';
import 'package:social_service/repositories/auth/auth_repository.dart';
import 'package:social_service/repositories/order/impl_order_repository.dart';

class OrderRepository extends ImplOrderRepository {
  final FirebaseDatabase _firebaseDatabase;
  final DatabaseReference _ordersRef =
      FirebaseDatabase.instance.ref().child('orders');
  final _authRepository = AuthRepository();

  final firestore.CollectionReference _orderCollection =
      firestore.FirebaseFirestore.instance.collection('orders');

  final firestore.CollectionReference _usersCollection =
      firestore.FirebaseFirestore.instance.collection('users');

  OrderRepository({FirebaseDatabase? firebaseDatabase})
      : _firebaseDatabase = firebaseDatabase ?? FirebaseDatabase.instance;

  @override
  Future<void> insertOrder({required Order order}) async {
    try {
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref('orders/${order.user?.uid}');
      Map<String, dynamic> data = {
        'cart': order.cart!.toJson(),
        'user': order.user!.toJson(),
        'address': order.address,
        'paymentMethod': order.paymentMethod,
        'order_location_model': order.orderLocationModel?.toJson(),
        'orderStatus': const OrderStatusList(
          ordersStatusList: [
            OrderStatus(
                name: "On The Way", code: "on_the_way", status: "ongoing"),
            OrderStatus(name: "Payment", code: "payment"),
            OrderStatus(name: "In Progress", code: "in_progress"),
            OrderStatus(name: "Done", code: "done"),
          ],
        ).toJson(),
        'engineer': null,
        'totalPriceOrder': order.cart?.subTotal,
      };

      await databaseReference.set(data);
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Stream<Order?> readOrderProcessing(uid) {
    try {
      DatabaseReference orderRef = _ordersRef.child(uid);
      return orderRef.onValue.map((event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> orderData =
              event.snapshot.value as Map<dynamic, dynamic>;
          return Order.fromJson(orderData);
        } else {
          return null;
        }
      });
    } catch (error) {
      throw Exception("Error getting order: $error");
    }
  }

  @override
  Stream<ListOrders?> loadOrdersActive() {
    try {
      DatabaseReference databaseReference = _ordersRef;
      return databaseReference.onValue.map((event) {
        if (event.snapshot.value != null) {
          Map<String, dynamic> data = {
            'orders':
                (event.snapshot.value as Map<dynamic, dynamic>).values.toList(),
          };

          ListOrders listOrders = ListOrders.fromJson(data);

          List<Order> filteredOrderrs = listOrders.orders
              .where((order) => order.engineer == null)
              .toList();

          return ListOrders(orders: filteredOrderrs);
        } else {
          return null;
        }
      });
    } catch (error) {
      throw Exception("Error getting order: $error");
    }
  }

  @override
  Future<void> updateOrder(
      {required Order order, required Map<String, dynamic> data}) async {
    try {
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref('orders/${order.user?.uid}');

      await databaseReference.update(data);
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Future<void> completedOrder({required Order order}) async {
    try {
      await _authRepository
          .updateWallet(
        wallet: order.cart?.subTotal ?? 0,
        email: order.engineer?.email ?? "",
      )
          .then((value) async {
        await _orderCollection.add({
          'cart': order.cart!.toJson(),
          'user': {
            "name": order.user?.name ?? "",
            "email": order.user?.email ?? "",
            'uid': order.user?.uid ?? '',
          },
          'address': order.address,
          'paymentMethod': order.paymentMethod,
          'engineer': {
            "name": order.engineer?.name ?? "",
            "email": order.engineer?.email ?? "",
            'uid': order.engineer?.uid ?? '',
          },
          'totalPriceOrder': order.cart?.subTotal,
        });

        DatabaseReference databaseReference =
            FirebaseDatabase.instance.ref('orders/${order.user?.uid}');

        await databaseReference.remove();
      });
    } catch (error) {
      throw Exception("Error getting order: $error");
    }
  }

  @override
  Stream<List<Order>> getAllOrdersHistory({required User user}) {
    if (user.role == "Engineer") {
      return _orderCollection
          .where('engineer.uid', isEqualTo: user.uid)
          .snapshots()
          .map((event) => event.docs
              .map((e) => Order.fromJson(e.data() as Map<String, dynamic>))
              .toList());
    } else {
      return _orderCollection
          .where('user.uid', isEqualTo: user.uid)
          .snapshots()
          .map((event) => event.docs
              .map((e) => Order.fromJson(e.data() as Map<String, dynamic>))
              .toList());
    }
  }

  @override
  Future<Order?> currentOrder({required User user}) async {
    final snapshot = await _ordersRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = {
        'orders': (snapshot.value as Map<dynamic, dynamic>).values.toList(),
      };

      ListOrders listOrders = ListOrders.fromJson(data);

      Order order = listOrders.orders
          .where((order) => order.engineer?.uid == user.uid)
          .first;

      return order;
    }
    return null;
  }

  @override
  Future<void> cancelOrder({required Order order}) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref('orders/${order.user?.uid}');

    await databaseReference.remove();
  }
}
