part of 'payment_method_cubit.dart';

class PaymentMethodInitial extends Equatable {
  final String paymentMethod;

  const PaymentMethodInitial({
    this.paymentMethod = 'COD',
  });

  factory PaymentMethodInitial.initial() {
    return const PaymentMethodInitial();
  }

  PaymentMethodInitial copyWith({
    String? paymentMethod,
  }) {
    return PaymentMethodInitial(
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  List<Object> get props => [paymentMethod];
}
