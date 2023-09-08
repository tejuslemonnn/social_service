part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadingCategories extends CategoryEvent {}

class UpdateStateCategories extends CategoryEvent {
  final List<Category> categories;

  const UpdateStateCategories(this.categories);

  @override
  List<Object> get props => [categories];
}
