part of 'search_address_cubit.dart';

enum SearchAddressStatus { inital, loading, success, error }

class SearchAddressProcess extends Equatable {
  final String address;
  final SearchAddressStatus searchAddressStatus;
  final AutoCompleteAddress? autoCompleteAddress;
  final AutoCompleteAddressResult? autoCompleteAddressResult;
  final Position? position;

  const SearchAddressProcess({
    required this.address,
    required this.searchAddressStatus,
    this.autoCompleteAddress,
    this.autoCompleteAddressResult,
    this.position,
  });

  factory SearchAddressProcess.inital() {
    return const SearchAddressProcess(
      address: "",
      searchAddressStatus: SearchAddressStatus.inital,
      autoCompleteAddress: null,
      autoCompleteAddressResult: null,
      position: null,
    );
  }

  SearchAddressProcess copyWith({
    String? address,
    String? formatted,
    SearchAddressStatus? searchAddressStatus,
    AutoCompleteAddress? autoCompleteAddress,
    AutoCompleteAddressResult? autoCompleteAddressResult,
    Position? position,
  }) {
    return SearchAddressProcess(
      address: address ?? this.address,
      searchAddressStatus: searchAddressStatus ?? this.searchAddressStatus,
      autoCompleteAddress: autoCompleteAddress ?? this.autoCompleteAddress,
      autoCompleteAddressResult:
          autoCompleteAddressResult ?? this.autoCompleteAddressResult,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [
        address,
        searchAddressStatus,
        autoCompleteAddress,
        autoCompleteAddressResult
      ];
}
