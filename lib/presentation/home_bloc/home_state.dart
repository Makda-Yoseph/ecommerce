import 'package:ecommerce_app/Domain/Entities/product_model.dart';

abstract class HomeState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends HomeState {}

class Loaded extends HomeState {
  final List<ProductModel> items;

  Loaded(this.items);
}

class LoadFailState extends HomeState {}
