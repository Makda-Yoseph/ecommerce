import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/Domain/Entities/product_model.dart';

abstract class LocalDataSource {
  Future<Either<String, List<ProductModel>>> getCachedProducts();
  Future<Either<String, ProductModel>> getCachedProduct(int id);
  Future<Either<String, void>> cacheProducts(List<ProductModel> products);
  Future<Either<String, void>> cacheProduct(ProductModel product);
  Future<Either<String, List<ProductModel>>> getCachedProductsByCategory(
      String category);
  Future<Either<String, void>> cacheProductsByCategory(
      String category, List<ProductModel> products);
}

class LocalDataSrc implements LocalDataSource {
  final SharedPreferences prefs;

  LocalDataSrc(this.prefs);

  static const _cacheKey = 'cached_products';

  @override
  Future<Either<String, List<ProductModel>>> getCachedProducts() async {
    try {
      final jsonString = prefs.getString(_cacheKey);
      if (jsonString == null) return Left('No cached products available');

      final List<dynamic> jsonList = jsonDecode(jsonString);
      final products = jsonList
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return Right(products);
    } catch (e) {
      return Left('Failed to load cached products: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> cacheProducts(
      List<ProductModel> products) async {
    try {
      final jsonList = products.map((p) => p.toJson()).toList();
      await prefs.setString(_cacheKey, jsonEncode(jsonList));
      return const Right(null);
    } catch (e) {
      return Left('Failed to cache products: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, ProductModel>> getCachedProduct(int id) async {
    try {
      final result = await getCachedProducts();
      return result.fold(
        (error) => Left(error),
        (products) {
          final product = products.firstWhere(
            (p) => p.id == id,
            orElse: () => throw 'Product not found',
          );
          return Right(product);
        },
      );
    } catch (e) {
      return Left('Failed to get product $id: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> cacheProduct(ProductModel product) async {
    try {
      final result = await getCachedProducts();
      return await result.fold(
        (error) async {
          // If no cached list exists, create a new one
          return await cacheProducts([product]);
        },
        (products) async {
          final index = products.indexWhere((p) => p.id == product.id);
          if (index >= 0) {
            products[index] = product;
          } else {
            products.add(product);
          }
          return await cacheProducts(products);
        },
      );
    } catch (e) {
      return Left('Failed to cache product: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<ProductModel>>> getCachedProductsByCategory(
      String category) async {
    try {
      final jsonString = prefs.getString('category_$category');
      if (jsonString == null)
        return Left('No cached products for category: $category');

      final List<dynamic> jsonList = jsonDecode(jsonString);
      final products = jsonList
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return Right(products);
    } catch (e) {
      return Left('Failed to get cached products by category: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> cacheProductsByCategory(
      String category, List<ProductModel> products) async {
    try {
      final jsonList = products.map((p) => p.toJson()).toList();
      await prefs.setString('category_$category', jsonEncode(jsonList));
      return const Right(null);
    } catch (e) {
      return Left('Failed to cache products by category: ${e.toString()}');
    }
  }
}
