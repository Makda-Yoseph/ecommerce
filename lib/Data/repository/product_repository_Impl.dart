import 'package:ecommerce_app/Data/data_source/local_data_src.dart';
import 'package:ecommerce_app/Data/data_source/remote_data_src.dart';
import 'package:ecommerce_app/Domain/Repositary/product_repository.dart';

import 'package:ecommerce_app/core/network_info.dart';
import 'package:either_dart/either.dart';
import 'package:ecommerce_app/Domain/Entities/product_model.dart';
import 'package:ecommerce_app/core/failure.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProdcut() async {
    if (await networkInfo.isConnected()) {
      final remoteResult = await remoteDataSource.getAllProducts();
      return remoteResult.fold(
        (failure) => Left(failure),
        (products) async {
          await localDataSource.cacheProducts(products);
          return Right(products);
        },
      );
    } else {
      final localResult = await localDataSource.getCachedProducts();
      return localResult.fold(
        (error) => Left(CachingError(error)),
        (products) => Right(products),
      );
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getAProduct(int id) async {
    if (await networkInfo.isConnected()) {
      final remoteResult = await remoteDataSource.getAProduct(id);
      return remoteResult.fold(
        (failure) => Left(failure),
        (product) async {
          await localDataSource.cacheProduct(product);
          return Right(product);
        },
      );
    } else {
      final localResult = await localDataSource.getCachedProduct(id);
      return localResult.fold(
        (error) => Left(CachingError(error)),
        (product) => Right(product),
      );
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProductByCategory(
      String category) async {
    if (await networkInfo.isConnected()) {
      final remoteResult =
          await remoteDataSource.getProductsByCategory(category);
      return remoteResult.fold(
        (failure) => Left(failure),
        (products) async {
          await localDataSource.cacheProductsByCategory(category, products);
          return Right(products);
        },
      );
    } else {
      final localResult =
          await localDataSource.getCachedProductsByCategory(category);
      return localResult.fold(
        (error) => Left(CachingError(error)),
        (products) => Right(products),
      );
    }
  }
}
