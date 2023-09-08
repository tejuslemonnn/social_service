part of 'custom_order_cubit.dart';

enum CustomOrderStatus { inital, submitting, success, error }

class CustomOrderProcess extends Equatable {
  final CustomOrder customOrder;
  final CustomOrderStatus customOrderStatus;
  final String? errorMessage;

  const CustomOrderProcess({
    required this.customOrder,
    required this.customOrderStatus,
    this.errorMessage,
  });

  factory CustomOrderProcess.inital() {
    return const CustomOrderProcess(
      customOrder: CustomOrder(
        serviceType: "",
        product: Product(
          name: "",
          code: "",
          isPopular: false,
          category: "",
        ),
        productNoted: "",
        quantity: 0,
        totalPrice: 0,
        fee: 0,
      ),
      customOrderStatus: CustomOrderStatus.inital,
      errorMessage: "",
    );
  }

  @override
  List<Object?> get props => [
        customOrder,
        customOrderStatus,
        errorMessage,
      ];

  CustomOrderProcess copyWith({
    CustomOrder? customOrder,
    CustomOrderStatus? customOrderStatus,
    String? errorMessage,
  }) {
    return CustomOrderProcess(
      customOrder: customOrder ?? this.customOrder,
      customOrderStatus: customOrderStatus ?? this.customOrderStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@immutable
abstract class CustomOrderState extends Equatable {
  const CustomOrderState();

  @override
  List<Object?> get props => [];
}

class CustomOrderFailure extends CustomOrderState {
  final String errorMessage;

  const CustomOrderFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
