import 'dart:convert';
import 'package:ecommerce_app/Domain/Entities/product_model.dart';
import 'package:ecommerce_app/core/failure.dart';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;

abstract class RemoteDataSource {
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(
      String category);
  Future<Either<Failure, List<ProductModel>>> getAllProducts();
  Future<Either<Failure, ProductModel>> getAProduct(int id);
}

class RemoteDataSrc implements RemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://fakestoreapi.com';

  RemoteDataSrc({required this.client});

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final products =
            data.map((json) => ProductModel.fromJson(json)).toList();
        return Right(products);
      } else {
        return Left(
            ServerFailure('Failed to load products: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ServerFailure('Network error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getAProduct(int id) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/products/$id'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final product = ProductModel.fromJson(data);
        return Right(product);
      } else {
        return Left(
            ServerFailure('Failed to load product: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ServerFailure('Network error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(
      String category) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/products/category/$category'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final products =
            jsonList.map((json) => ProductModel.fromJson(json)).toList();
        return Right(products);
      } else {
        return Left(
            ServerFailure('Failed to load products: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ServerFailure('Network error: ${e.toString()}'));
    }
  }
}
