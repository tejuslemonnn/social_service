import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:social_service/models/auto_complete_address_model.dart';
import 'package:social_service/repositories/geoapify/geoapify_repository.dart';

part 'search_address_state.dart';

class SearchAddressCubit extends Cubit<SearchAddressProcess> {
  final GeoapifyRepository _geoapifyRepository;

  SearchAddressCubit(this._geoapifyRepository)
      : super(SearchAddressProcess.inital());

  void addressChanged(String value) async {
    emit(
      state.copyWith(
        address: value,
        searchAddressStatus: SearchAddressStatus.inital,
      ),
    );
  }

  void autoAddressResult(AutoCompleteAddressResult autoCompleteAddressResult) {
    emit(
      state.copyWith(
        autoCompleteAddressResult: autoCompleteAddressResult,
      ),
    );
  }

  Future<void> getCurrentPosition() async {
    emit(state.copyWith(
      searchAddressStatus: SearchAddressStatus.loading,
    ));
    try {
      final autoCompleteAddress =
          await _geoapifyRepository.getCurrentPosition();

      if (autoCompleteAddress != null) {
        emit(
          state.copyWith(
            autoCompleteAddressResult: autoCompleteAddress.results![0],
          ),
        );

      } else {
        emit(
          state.copyWith(
            searchAddressStatus: SearchAddressStatus.error,
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          searchAddressStatus: SearchAddressStatus.error,
        ),
      );
    }
  }

  Future<void> addressSubmit(String address) async {
    emit(state.copyWith(
      searchAddressStatus: SearchAddressStatus.loading,
    ));
    try {
      final autoCompleteAddress =
          await _geoapifyRepository.autoCompleteAddress(state.address);

      if (autoCompleteAddress != null) {
        emit(
          state.copyWith(
            autoCompleteAddress: autoCompleteAddress,
            searchAddressStatus: SearchAddressStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            searchAddressStatus: SearchAddressStatus.error,
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          searchAddressStatus: SearchAddressStatus.error,
        ),
      );
    }
  }
}
