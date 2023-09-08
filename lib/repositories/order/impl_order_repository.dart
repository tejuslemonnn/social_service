import 'package:social_service/models/order_model.dart';
import 'package:social_service/models/user_model.dart';

abstract class ImplOrderRepository {
  Future<void> insertOrder({
    required Order order,
  });

  Stream<ListOrders?> loadOrdersActive();

  Stream<Order?> readOrderProcessing(uid);

  Future<void> updateOrder({
    required Order order,
    required Map<String, dynamic> data,
  });

  Future<void> completedOrder({
    required Order order,
  });

  Stream<List<Order>> getAllOrdersHistory({
    required User user,
  });

  Future<Order?> currentOrder({
    required User user,
  });

  Future<void> cancelOrder({
    required Order order,
  });
}
