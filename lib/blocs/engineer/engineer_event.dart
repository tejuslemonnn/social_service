part of 'engineer_bloc.dart';

abstract class EngineerEvent extends Equatable {
  const EngineerEvent();

  @override
  List<Object?> get props => [];
}

class ClearStateEngineer extends EngineerEvent {}

class EngineerStarted extends EngineerEvent {}

class EngineerLoadingOrder extends EngineerEvent {
  final ListOrders? listOrders;
  final Order? order;

  @override
  List<Object?> get props => [listOrders, order];

  const EngineerLoadingOrder({
    this.listOrders,
    this.order,
  });
}

class EngineerLoadingOrderDetail extends EngineerEvent {
  final Order? order;
  final List<LatLng> polylinePoints;

  @override
  List<Object?> get props => [order, polylinePoints];

  const EngineerLoadingOrderDetail({
    this.order,
    this.polylinePoints = const [],
  });
}

class EngineerLookingOrderEvent extends EngineerEvent {
  final Order? order;

  @override
  List<Object?> get props => [order];

  const EngineerLookingOrderEvent({
    this.order,
  });
}

class EngineerUpdateStateOrderProcessing extends EngineerEvent {
  final Order? order;

  @override
  List<Object?> get props => [order];

  const EngineerUpdateStateOrderProcessing({
    this.order,
  });
}

class EngineerClaimingOrder extends EngineerEvent {
  final Order? order;
  final BuildContext context;

  @override
  List<Object?> get props => [order, context];

  const EngineerClaimingOrder({
    this.order,
    required this.context,
  });
}

class EngineerProcessingOrderEvent extends EngineerEvent {
  final Order? order;

  @override
  List<Object?> get props => [order];

  const EngineerProcessingOrderEvent({
    this.order,
  });
}

class EngineerCancelOrder extends EngineerEvent {
  final Order? order;
  final BuildContext context;

  const EngineerCancelOrder({
    this.order,
    required this.context,
  });

  @override
  List<Object?> get props => [order];
}

class EngineerNextStatus extends EngineerEvent {
  final Order? order;

  const EngineerNextStatus({
    this.order,
  });

  @override
  List<Object?> get props => [order];
}

class EngineerCurrentOrder extends EngineerEvent {}
