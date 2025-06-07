import 'package:ecommerce_app/Domain/Entities/product_model.dart';
import 'package:ecommerce_app/core/failure.dart';
import 'package:either_dart/either.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getAllProdcut();
  Future<Either<Failure, ProductModel>> getAProduct(int id);
  Future<Either<Failure, List<ProductModel>>> getAllProductByCategory(
      String category);
}
