// import 'package:ecommerce_app/Domain/usecase/get_all_product.dart';
// import 'package:ecommerce_app/presentation/home_bloc/home_event.dart';
// import 'package:ecommerce_app/presentation/home_bloc/home_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class HomeBloc extends Bloc<ImageEvent, ImageState> {
//   final GetAllProduct getAllProduct;

//   HomeBloc({required this.getAllProduct}) : super(ImageLoadingState()) {
//     on<ImageFetch>(_onImageFetch);
//   }

//   Future<void> _onImageFetch(
//     ImageFetch event,
//     Emitter<ImageState> emit,
//   ) async {
//     emit(ImageLoadingState());

//     final result = await getAllProduct(); // using .call()

//     result.fold(
//       (failure) {
//         // You can pass the message if your state supports it
//         emit(ImageLoadFailState()); // Or: ImageLoadFailState(failure.message)
//       },
//       (products) {
//         emit(ImageLoaded(
//             products)); // Make sure ImageLoaded takes List<ProductModel>
//       },
//     );
//   }
// }

import 'package:ecommerce_app/Domain/usecase/get_all_product.dart';
import 'package:ecommerce_app/Domain/usecase/get_all_product_by_category.dart';
import 'package:ecommerce_app/presentation/home_bloc/home_event.dart';
import 'package:ecommerce_app/presentation/home_bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<ImageEvent, HomeState> {
  final GetAllProduct getAllProduct;
  final GetAllProductByCategory getProductByCategory;

  HomeBloc({
    required this.getAllProduct,
    required this.getProductByCategory,
  }) : super(LoadingState()) {
    on<ImageFetch>(_onImageFetch);
    on<ImageFetchByCategory>(_onCategoryFetch);
  }

  Future<void> _onImageFetch(ImageFetch event, Emitter<HomeState> emit) async {
    emit(LoadingState());
    final result = await getAllProduct();

    result.fold(
      (failure) => emit(LoadFailState()),
      (products) => emit(Loaded(products)),
    );
  }

  Future<void> _onCategoryFetch(
      ImageFetchByCategory event, Emitter<HomeState> emit) async {
    emit(LoadingState());
    final result = await getProductByCategory(event.category);

    result.fold(
      (failure) => emit(LoadFailState()),
      (products) => emit(Loaded(products)),
    );
  }
}
