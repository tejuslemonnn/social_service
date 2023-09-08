part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadingProduct extends ProductEvent{}

class UpdateStateProducts extends ProductEvent{
  final List<Product> products;

  const UpdateStateProducts(this.products);

  @override
  List<Object?> get props => [products];
}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}