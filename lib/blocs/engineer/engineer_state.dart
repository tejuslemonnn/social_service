part of 'engineer_bloc.dart';

abstract class EngineerState extends Equatable {
  const EngineerState();

  @override
  List<Object?> get props => [];
}

class EngineerInitial extends EngineerState {}

class EngineerOnline extends EngineerState {
  final ListOrders? listOrders;

  @override
  List<Object?> get props => [listOrders];

  const EngineerOnline({
    this.listOrders,
  });
}

class EngineerLoadingProcess extends EngineerState {}

class EngineerLookingOrderState extends EngineerState{
  final Order? order;

  @override
  List<Object?> get props => [order];

  const EngineerLookingOrderState({
    this.order,
  });
}

class EngineerProcessingOrderState extends EngineerState {
  final Order? order;
  final LatLng? positionEngineer;
  final List<LatLng> polylinePoints;

  @override
  List<Object?> get props => [order, polylinePoints, positionEngineer];

  const EngineerProcessingOrderState({
    this.order,
    this.polylinePoints = const [],
    this.positionEngineer,
  });
}
