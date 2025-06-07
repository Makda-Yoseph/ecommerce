import 'package:ecommerce_app/Domain/Repositary/product_repository.dart';
import 'package:ecommerce_app/Domain/Entities/product_model.dart';
import 'package:ecommerce_app/core/failure.dart';
import 'package:either_dart/either.dart';

class GetAProduct {
  final ProductRepository repository;

  GetAProduct(this.repository);

  Future<Either<Failure, ProductModel>> call(int id) {
    return repository.getAProduct(id);
  }
}
