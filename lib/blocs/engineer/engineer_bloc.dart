import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_service/blocs/auth/auth_bloc.dart';
import 'package:social_service/blocs/auth/auth_bloc.dart';
import 'package:social_service/cubits/engineer/engineer_cubit.dart';
import 'package:social_service/models/order_model.dart';
import 'package:social_service/models/user_model.dart';
import 'package:social_service/presentasion/pages/engineer_home/engineer_home_screen.dart';
import 'package:social_service/repositories/auth/auth_repository.dart';
import 'package:social_service/repositories/geoapify/geoapify_repository.dart';
import 'package:social_service/repositories/geolocation/geolocation_repository.dart';
import 'package:social_service/repositories/order/order_repository.dart';
import 'package:social_service/router/app_pages.dart';

part 'engineer_event.dart';

part 'engineer_state.dart';

class EngineerBloc extends Bloc<EngineerEvent, EngineerState> {
  final OrderRepository _orderRepository;
  final GeolocationRepository _geolocationRepository;
  final GeoapifyRepository _geoapifyRepository;

  final AuthBloc _authBloc;
  final EngineerCubit _engineerCubit;

  StreamSubscription? _orderSubscription;
  StreamSubscription? _liveUserLocationSubscription;

  EngineerBloc({
    required OrderRepository orderRepository,
    required AuthBloc authBloc,
    required EngineerCubit engineerCubit,
    required GeolocationRepository geolocationRepository,
    required GeoapifyRepository geoapifyRepository,
  })  : _orderRepository = orderRepository,
        _authBloc = authBloc,
        _engineerCubit = engineerCubit,
        _geolocationRepository = geolocationRepository,
        _geoapifyRepository = geoapifyRepository,
        super(EngineerInitial()) {
    on<ClearStateEngineer>(_mapEngineerClearState);
    on<EngineerStarted>(_mapEngineerStartedToState);
    on<EngineerLoadingOrder>(_mapEngineerLoadedToState);
    on<EngineerLoadingOrderDetail>(_mapEngineerLoadDetailOrder);
    on<EngineerLookingOrderEvent>(_mapEngineerLookingOrderEvent);
    on<EngineerUpdateStateOrderProcessing>(_mapEngineerProcessOrder);
    on<EngineerClaimingOrder>(_mapEngineerClaimingOrder);
    on<EngineerProcessingOrderEvent>(_mapEngineerProcessingOrderEvent);
    on<EngineerNextStatus>(_mapEngineerNextStatus);
    on<EngineerCurrentOrder>(_mapEngineerCurrentOrder);
    on<EngineerCancelOrder>(_mapEngineerCancelOrder);

    _liveUserLocationSubscription =
        _geolocationRepository.locationStream.listen((position) {
      _engineerCubit.emit(
        _engineerCubit.state.copyWith(
          position: position,
          liveUserStatus: EngineerLocationStatus.loaded,
        ),
      );

      if (state is EngineerProcessingOrderState) {
        add(EngineerProcessingOrderEvent(
            order: (state as EngineerProcessingOrderState).order));
      }
    });
  }

  void _mapEngineerCancelOrder(
      EngineerCancelOrder event, Emitter<EngineerState> emit) {
    _orderRepository.cancelOrder(order: event.order!).then((value) {
      AppRouter.pushAndRemoveUntil(
        event.context,
        const EngineerHomeScreen(),
        Routes.homeScreen,
      );

      return add(EngineerStarted());
    });
  }

  void _mapEngineerCurrentOrder(
      EngineerCurrentOrder event, Emitter<EngineerState> emit) async {
    Order? order =
        await _orderRepository.currentOrder(user: _authBloc.state.user);
    if (order != null) {
      return add(
        EngineerLoadingOrderDetail(order: order),
      );
    } else {
      return add(EngineerStarted());
    }
  }

  void _mapEngineerClearState(
      ClearStateEngineer event, Emitter<EngineerState> emit) async {
    emit(EngineerInitial());
  }

  void _mapEngineerStartedToState(
      EngineerStarted event, Emitter<EngineerState> emit) {
    _orderSubscription?.cancel();
    _orderSubscription = _orderRepository.loadOrdersActive().listen((orders) {
      return add(EngineerLoadingOrder(listOrders: orders));
    });
  }

  void _mapEngineerLoadedToState(
      EngineerLoadingOrder event, Emitter<EngineerState> emit) {
    emit(
      EngineerOnline(listOrders: event.listOrders),
    );
  }

  void _mapEngineerLoadDetailOrder(
      EngineerLoadingOrderDetail event, Emitter<EngineerState> emit) {
    emit(
      EngineerLoadingProcess(),
    );
    _orderSubscription?.cancel();
    _orderSubscription = _orderRepository
        .readOrderProcessing(event.order?.user?.uid)
        .listen((order) {
      return add(EngineerLookingOrderEvent(order: order));
    });
  }

  void _mapEngineerLookingOrderEvent(
      EngineerLookingOrderEvent event, Emitter<EngineerState> emit) {
    if (event.order?.engineer != null) {
      return add(EngineerUpdateStateOrderProcessing(order: event.order));
    } else if (event.order != null) {
      emit(EngineerLookingOrderState(order: event.order));
    } else {
      return add(ClearStateEngineer());
    }
  }

  void _mapEngineerProcessOrder(
      EngineerUpdateStateOrderProcessing event, Emitter<EngineerState> emit) {
    if (event.order?.routingDirection != null) {
      final polylinePoints = event
              .order?.routingDirection?.features?[0].geometry?.coordinates![0]
              .map((e) => LatLng(e[1], e[0]))
              .toList() ??
          [];
      emit(
        EngineerProcessingOrderState(
            order: event.order, polylinePoints: polylinePoints),
      );
    } else {
      emit(
        EngineerProcessingOrderState(
            order: event.order, polylinePoints: const []),
      );
    }
  }

  void _mapEngineerClaimingOrder(
      EngineerClaimingOrder event, Emitter<EngineerState> emit) async {
    try {
      if (_engineerCubit.state.position == null) {
        throw Exception("Engineer position is not available.");
      }

      final routingDirection = await _geoapifyRepository.routingDirection(
        fromLat: event.order?.orderLocationModel?.latitude ?? 0,
        fromLon: event.order?.orderLocationModel?.longitude ?? 0,
        toLat: _engineerCubit.state.position?.latitude ?? 0,
        toLon: _engineerCubit.state.position?.longitude ?? 0,
      );

      if (routingDirection != null) {
        Map<String, dynamic> data = {
          'routing_direction': routingDirection?.toJson(),
          'engineer': _authBloc.state.user.toJson(),
        };

        _orderRepository.updateOrder(
          order: event.order!,
          data: data,
        );

        return add(
          EngineerUpdateStateOrderProcessing(order: event.order),
        );
      }
    } catch (_) {}
  }

  void _mapEngineerProcessingOrderEvent(
      EngineerProcessingOrderEvent event, Emitter<EngineerState> emit) async {
    try {
      Map<String, dynamic> data = {};

      if (_engineerCubit.state.position == null) {
        throw Exception("Engineer position is not available.");
      }

      if (event.order?.routingDirection != null) {
        data['routing_direction/properties/waypoints/1'] = {
          'lat': _engineerCubit.state.position?.latitude,
          'lon': _engineerCubit.state.position?.longitude,
        };
      }

      _orderRepository.updateOrder(
        order: event.order!,
        data: data,
      );

      return add(
        EngineerUpdateStateOrderProcessing(order: event.order),
      );
    } catch (_) {}
  }

  void _mapEngineerNextStatus(
      EngineerNextStatus event, Emitter<EngineerState> emit) async {
    Map<String, dynamic> data = {};

    for (var index = 0;
        index < event.order!.orderStatusList!.ordersStatusList.length;
        index++) {
      var element = event.order!.orderStatusList!.ordersStatusList[index];

      if (element.code == "in_progress" && element.status == "ongoing") {
        data['orderStatus/ordersStatusList/$index/status'] = "done";
        data['orderStatus/ordersStatusList/${index + 1}/status'] = "done";
        break;
      }

      if (element.status == "ongoing") {
        data['orderStatus/ordersStatusList/$index/status'] = "done";
      }

      if (element.status == "pending") {
        data['orderStatus/ordersStatusList/$index/status'] = "ongoing";
        break;
      }
    }

    await _orderRepository.updateOrder(
      order: event.order!,
      data: data,
    );

    return add(
      EngineerUpdateStateOrderProcessing(order: event.order),
    );
  }
}
