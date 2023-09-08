import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_service/models/product_model.dart';
import 'package:social_service/repositories/products/product_repository.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  StreamSubscription? _productSubscription;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductInitial()) {
    on<LoadingProduct>(_onLoadProduct);
    on<UpdateStateProducts>(_onUpdateProducts);
    on<SearchProducts>(_onSearchProducts);
  }

  void _onLoadProduct(LoadingProduct event, Emitter<ProductState> emit) {
    _productSubscription?.cancel();
    _productSubscription = _productRepository.getAllProducts().listen(
          (products) => add(
            UpdateStateProducts(products),
          ),
        );
  }

  void _onUpdateProducts(
      UpdateStateProducts event, Emitter<ProductState> emit) {
    emit(ProductLoaded(products: event.products));
  }

  void _onSearchProducts(
      SearchProducts event, Emitter<ProductState> emit) async {

    add(LoadingProduct());
    await Future.delayed(const Duration(seconds: 1));

    if (state is ProductLoaded) {
      List<Product> allProducts = (state as ProductLoaded).products;
      List<Product> searchResults = allProducts
          .where((product) =>
              product.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();

      emit(ProductLoaded(products: searchResults));
    }
  }
}
