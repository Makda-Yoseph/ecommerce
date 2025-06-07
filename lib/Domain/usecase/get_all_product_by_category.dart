import 'package:ecommerce_app/Domain/Entities/product_model.dart';
import 'package:ecommerce_app/Domain/Repositary/product_repository.dart';
import 'package:ecommerce_app/core/failure.dart';
import 'package:either_dart/either.dart';

class GetAllProductByCategory {
  final ProductRepository productRepository;

  GetAllProductByCategory(this.productRepository);

  Future<Either<Failure, List<ProductModel>>> call(String category) {
    return productRepository.getAllProductByCategory(category);
  }
}
