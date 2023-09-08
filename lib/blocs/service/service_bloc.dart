import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_service/models/service_model.dart';
import 'package:social_service/repositories/services/service_repository.dart';

part 'service_event.dart';

part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository _serviceRepository;
  StreamSubscription? _serviceSubscription;

  ServiceBloc({required ServiceRepository serviceRepository})
      : _serviceRepository = serviceRepository,
        super(ServiceInitial()) {
    on<LoadingService>(_onLoadProduct);
    on<UpdateStateServices>(_onUpdateProducts);
  }

  void _onLoadProduct(LoadingService event, Emitter<ServiceState> emit) {
    _serviceSubscription?.cancel();
    _serviceSubscription = _serviceRepository.getAllServices().listen(
          (services) => add(
            UpdateStateServices(services),
          ),
        );
  }

  void _onUpdateProducts(
      UpdateStateServices event, Emitter<ServiceState> emit) {
    emit(ServiceLoaded(services: event.services));
  }
}
