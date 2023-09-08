import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'payment_method_state.dart';

class PaymentMethodCubit extends Cubit<PaymentMethodInitial> {
  PaymentMethodCubit() : super(PaymentMethodInitial.initial());

  void selectPaymentMethod(String paymentMethod) {
    emit(
      state.copyWith(
        paymentMethod: paymentMethod,
      ),
    );
  }

}
