part of 'service_bloc.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object?> get props => [];
}

class LoadingService extends ServiceEvent{}

class UpdateStateServices extends ServiceEvent{
  final List<Service> services;

  const UpdateStateServices(this.services);

  @override
  List<Object?> get props => [services];
}