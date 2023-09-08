import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_service/blocs/auth/auth_bloc.dart';
import 'package:social_service/blocs/cart/cart_bloc.dart';
import 'package:social_service/blocs/category/category_bloc.dart';
import 'package:social_service/blocs/engineer/engineer_bloc.dart';
import 'package:social_service/blocs/order/order_bloc.dart';
import 'package:social_service/blocs/product/product_bloc.dart';
import 'package:social_service/blocs/profile/profile_bloc.dart';
import 'package:social_service/blocs/service/service_bloc.dart';
import 'package:social_service/cubits/custom_order/custom_order_cubit.dart';
import 'package:social_service/cubits/engineer/engineer_cubit.dart';
import 'package:social_service/cubits/login/login_cubit.dart';
import 'package:social_service/cubits/payment_method/payment_method_cubit.dart';
import 'package:social_service/cubits/search_address/search_address_cubit.dart';

import 'package:social_service/cubits/signup/signup_cubit.dart';
import 'package:social_service/repositories/auth/auth_repository.dart';
import 'package:social_service/repositories/category/category_repository.dart';
import 'package:social_service/repositories/database/database_repository.dart';
import 'package:social_service/repositories/geoapify/geoapify_repository.dart';
import 'package:social_service/repositories/geolocation/geolocation_repository.dart';
import 'package:social_service/repositories/order/order_repository.dart';
import 'package:social_service/repositories/products/product_repository.dart';
import 'package:social_service/repositories/services/service_repository.dart';

List<BlocProvider> listBlocProvider = [
  BlocProvider<AuthBloc>(
    create: (context) => AuthBloc(
      authRepository: AuthRepository(),
    ),
  ),
  BlocProvider<ProfileBloc>(
    create: (context) => ProfileBloc(
      authBloc: BlocProvider.of<AuthBloc>(context),
      databaseRepository: context.read<DatabaseRepository>(),
    )..add(
        LoadProfile(email: BlocProvider.of<AuthBloc>(context).state.user.email!),
      ),
  ),
  BlocProvider<SignupCubit>(
    create: (context) => SignupCubit(
      AuthRepository(),
    ),
  ),
  BlocProvider<LoginCubit>(
    create: (context) => LoginCubit(
      AuthRepository(),
    ),
  ),
  BlocProvider<CategoryBloc>(
    create: (context) => CategoryBloc(
      categoryRepository: CategoryRepository(),
    )..add(LoadingCategories()),
  ),
  BlocProvider<ProductBloc>(
    create: (context) => ProductBloc(
      productRepository: ProductRepository(),
    )..add(LoadingProduct()),
  ),
  BlocProvider<ServiceBloc>(
    create: (context) => ServiceBloc(
      serviceRepository: ServiceRepository(),
    )..add(LoadingService()),
  ),
  BlocProvider<CustomOrderCubit>(
    create: (context) => CustomOrderCubit(),
  ),
  BlocProvider<CartBloc>(
    create: (context) => CartBloc()..add(CartStarted()),
  ),
  BlocProvider<SearchAddressCubit>(
    create: (context) => SearchAddressCubit(GeoapifyRepository()),
  ),
  BlocProvider<PaymentMethodCubit>(
    create: (context) => PaymentMethodCubit(),
  ),
  BlocProvider<OrderBloc>(
    create: (context) => OrderBloc(
      authBloc: context.read<AuthBloc>(),
      cartBloc: context.read<CartBloc>(),
      searchAddressCubit: context.read<SearchAddressCubit>(),
      paymentMethodCubit: context.read<PaymentMethodCubit>(),
      orderRepository: OrderRepository(),
      geoapifyRepository: GeoapifyRepository(),
    )..add(OrderStarted()),
  ),
  BlocProvider<EngineerCubit>(
    create: (context) => EngineerCubit(
      geolocationRepository: GeolocationRepository(),
    ),
  ),
  BlocProvider<EngineerBloc>(
    create: (context) => EngineerBloc(
      orderRepository: OrderRepository(),
      authBloc: context.read<AuthBloc>(),
      engineerCubit: context.read<EngineerCubit>(),
      geolocationRepository: GeolocationRepository(),
      geoapifyRepository: GeoapifyRepository(),
    ),
  )
];
