import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:social_service/repositories/geolocation/geolocation_repository.dart';

part 'engineer_state.dart';

class EngineerCubit extends Cubit<EngineerProcess> {
  final GeolocationRepository _geolocationRepository;
  StreamSubscription? _locationSubscription;

  EngineerCubit({required GeolocationRepository geolocationRepository})
      : _geolocationRepository = geolocationRepository,
        super(EngineerProcess.inital());

  void getCurrentLocation() async {
    _locationSubscription =
        _geolocationRepository.locationStream.listen((position) {
      emit(
        state.copyWith(
          position: position,
          liveUserStatus: EngineerLocationStatus.loaded,
        ),
      );
    });
  }

  void changeEngineerStatus() {
    emit(
      state.copyWith(isOnline: !state.isOnline),
    );
  }

  void showProfile() {
    emit(
      state.copyWith(showProfile: !state.showProfile),
    );
  }
}
