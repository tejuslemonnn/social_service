import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_service/blocs/auth/auth_bloc.dart';
import 'package:social_service/blocs/cart/cart_bloc.dart';
import 'package:social_service/cubits/engineer/engineer_cubit.dart';
import 'package:social_service/cubits/payment_method/payment_method_cubit.dart';
import 'package:social_service/cubits/search_address/search_address_cubit.dart';
import 'package:social_service/models/cart_model.dart';
import 'package:social_service/models/order_location_model.dart';
import 'package:social_service/models/order_model.dart';
import 'package:social_service/models/user_model.dart';
import 'package:social_service/presentasion/pages/home/home_screen.dart';
import 'package:social_service/repositories/geoapify/geoapify_repository.dart';
import 'package:social_service/repositories/order/order_repository.dart';
import 'package:social_service/router/app_pages.dart';

part 'order_event.dart';

part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CartBloc _cartBloc;
  final SearchAddressCubit _searchAddressCubit;
  final AuthBloc _authBloc;
  final PaymentMethodCubit _paymentMethodCubit;
  final EngineerCubit? _engineerCubit;

  StreamSubscription? _cartSubscription;
  StreamSubscription? _searchAddressSubscription;
  StreamSubscription? _paymentMethodSubscription;
  StreamSubscription? _orderSubscription;
  StreamSubscription? _orderHistorySubscription;
  StreamSubscription? _liveUserLocationSubscription;

  final OrderRepository _orderRepository;
  final GeoapifyRepository _geoapifyRepository;

  OrderBloc({
    required CartBloc cartBloc,
    required SearchAddressCubit searchAddressCubit,
    required AuthBloc authBloc,
    required PaymentMethodCubit paymentMethodCubit,
    required OrderRepository orderRepository,
    required GeoapifyRepository geoapifyRepository,
    EngineerCubit? liveUserLocationCubit,
  })  : _cartBloc = cartBloc,
        _searchAddressCubit = searchAddressCubit,
        _authBloc = authBloc,
        _paymentMethodCubit = paymentMethodCubit,
        _orderRepository = orderRepository,
        _geoapifyRepository = geoapifyRepository,
        _engineerCubit = liveUserLocationCubit,
        super(
          cartBloc.state is CartLoaded
              ? OrderLoaded(
                  cart: (cartBloc.state as CartLoaded).cart,
                  user: authBloc.state.user,
                  address: searchAddressCubit.state.address,
                  paymentMethod: paymentMethodCubit.state.paymentMethod,
                )
              : OrderInitial(),
        ) {
    on<OrderStarted>(_mapOrderStartedToState);
    on<UpdateOrder>(_mapUpdateOrderToState);
    on<CreateOrder>(_mapCreateOrderToState);
    on<LoadingOrderProcess>(_onLoadOrder);
    on<UpdateStateOrderProcess>(_onUpdateOrder);
    on<OrderCancel>(_onCancelOrder);
    on<LoadingOrderHistory>(_onLoadOrderHistory);
    on<UpdateStateOrderHistory>(_onUpdateOrderHistory);

    _cartSubscription = _cartBloc.stream.listen((state) {
      if (state is CartLoaded) {
        add(UpdateOrder(cart: state.cart));
      }
    });

    _searchAddressSubscription = _searchAddressCubit.stream.listen((state) {
      add(UpdateOrder(address: state.address));
    });

    _paymentMethodSubscription = _paymentMethodCubit.stream.listen((state) {
      add(UpdateOrder(paymentMethod: state.paymentMethod));
    });

    _liveUserLocationSubscription = _engineerCubit?.stream.listen((state) {
      add(UpdateOrder(
        fromLat: state.position?.latitude,
        fromLng: state.position?.longitude,
      ));
    });
  }

  void _mapOrderStartedToState(OrderStarted event, Emitter<OrderState> emit) {
    emit(OrderLoaded());
  }

  void _mapUpdateOrderToState(
      UpdateOrder event, Emitter<OrderState> emit) async {
    if (state is OrderLoaded) {
      final state = this.state as OrderLoaded;
      emit(
        OrderLoaded(
          cart: event.cart ?? state.cart,
          user: event.user ?? state.user,
          address: event.address ?? state.address,
          paymentMethod: event.paymentMethod ?? state.paymentMethod,
          fromLat: event.fromLat ?? state.fromLat,
          fromLng: event.fromLng ?? state.fromLng,
          toLat: event.toLat ?? state.toLat,
          toLng: event.toLng ?? state.toLng,
        ),
      );
    }
  }

  void _mapCreateOrderToState(
      CreateOrder event, Emitter<OrderState> emit) async {
    _cartSubscription?.cancel();
    _searchAddressSubscription?.cancel();
    _paymentMethodSubscription?.cancel();
    if (state is OrderLoaded) {
      final state = this.state as OrderLoaded;

      await _orderRepository.insertOrder(
          order: Order(
        cart: state.cart,
        user: state.user,
        address: state.address,
        paymentMethod: state.paymentMethod,
        orderLocationModel: OrderLocationModel(
          latitude: state.fromLat,
          longitude: state.fromLng,
        ),
      ));

      // clear state
      emit(OrderLoading(
        fromLat: null,
        fromLng: null,
        toLat: null,
        toLng: null,
        cart: null,
        paymentMethod: null,
        user: null,
        address: null,
      ));
    }
  }

  void _onLoadOrder(LoadingOrderProcess event, Emitter<OrderState> emit) async {
    if (_authBloc.state.authStatus == AuthStatus.authenticated) {
      final userId = _authBloc.state.user.uid;
      _orderSubscription?.cancel();
      _orderSubscription =
          _orderRepository.readOrderProcessing(userId).listen((order) {
        if (order != null) {
          return add(UpdateStateOrderProcess(order!));
        } else {
          return add(OrderStarted());
        }
      });
    }
  }

  void _onUpdateOrder(UpdateStateOrderProcess event, Emitter<OrderState> emit) {
    if (event.order.routingDirection != null && event.order.cart != null) {
      final polylinePoints = event
              .order.routingDirection!.features![0].geometry!.coordinates![0]
              .map((e) => LatLng(e[1], e[0]))
              .toList() ??
          [];

      return emit(
          OrderProcessing(order: event.order, polylinePoints: polylinePoints));
    }

    if (event.order.cart != null) {
      return emit(
          OrderProcessing(order: event.order, polylinePoints: const []));
    }
  }

  void _onCancelOrder(OrderCancel event, Emitter<OrderState> emit) async {
    await _orderRepository.cancelOrder(order: event.order).then((value) {
      AppRouter.pushAndRemoveUntil(
          event.context,
          const HomeScreen(),
          Routes.homeScreen);

      return add(OrderStarted());
    });
  }

  void _onLoadOrderHistory(
      LoadingOrderHistory event, Emitter<OrderState> emit) {
    _orderHistorySubscription?.cancel();
    _orderHistorySubscription = _orderRepository
        .getAllOrdersHistory(user: _authBloc.state.user)
        .listen((orders) {
      return add(UpdateStateOrderHistory(orders));
    });
  }

  void _onUpdateOrderHistory(
      UpdateStateOrderHistory event, Emitter<OrderState> emit) {
    emit(OrderHistoryLoaded(orders: event.orders));
  }
}
