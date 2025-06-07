import 'package:ecommerce_app/Domain/Repositary/product_repository.dart';
import 'package:ecommerce_app/Domain/Entities/product_model.dart';
import 'package:ecommerce_app/core/failure.dart';
import 'package:either_dart/either.dart';

class GetAllProduct {
  final ProductRepository productRepository;
  GetAllProduct({required this.productRepository});

  Future<Either<Failure, List<ProductModel>>> call() {
    return productRepository.getAllProdcut();
  }
}
