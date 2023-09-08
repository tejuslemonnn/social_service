part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  const ProductLoaded({this.products = const <Product>[]});

  @override
  List<Object?> get props => [products];
}

class ProductLoading extends ProductState {}

class ProductSearchLoaded extends ProductState {
  final List<Product> searchResults;

  const ProductSearchLoaded({this.searchResults = const <Product>[]});

  @override
  List<Object?> get props => [searchResults];
}