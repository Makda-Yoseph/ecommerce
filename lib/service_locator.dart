import 'package:ecommerce_app/Data/data_source/remote_data_src.dart';
import 'package:ecommerce_app/Data/repository/product_repository_Impl.dart';
import 'package:ecommerce_app/Domain/Repositary/product_repository.dart';

import 'package:ecommerce_app/core/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/Data/data_source/local_data_src.dart';
import 'package:ecommerce_app/Domain/usecase/get_all_product.dart';
import 'package:ecommerce_app/Domain/usecase/get_all_product_by_category.dart';
import 'package:ecommerce_app/presentation/home_bloc/home_block.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

final getIt = GetIt.instance;
Future<void> setup() async {
  var shared_preferences = await SharedPreferences.getInstance();
  var client = http.Client();
  var connectionChecker = Connectivity();

  getIt.registerLazySingleton<SharedPreferences>(() => shared_preferences);
  getIt.registerLazySingleton<http.Client>(() => client);
  getIt.registerSingleton<InternetConnectionChecker>(
      InternetConnectionChecker.instance);
  // getIt.registerSingleton<InternetConnectionChecker>(
  //     InternetConnectionChecker());

  // getIt.registerLazySingleton<Connectivity>(() => connectionChecker);
  getIt.registerLazySingleton<LocalDataSource>(
      () => LocalDataSrc(getIt<SharedPreferences>()));
  getIt.registerSingleton<NetworkInfo>(NetworkInfo(getIt()));
  getIt.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSrc(client: getIt<http.Client>()));
  getIt.registerSingleton<ProductRepository>(ProductRepositoryImpl(
      remoteDataSource: getIt<RemoteDataSource>(),
      localDataSource: getIt<LocalDataSource>(),
      networkInfo: getIt<NetworkInfo>()));

  getIt.registerSingleton<GetAllProduct>(
      GetAllProduct(productRepository: getIt<ProductRepository>()));
  getIt.registerSingleton<GetAllProductByCategory>(
      GetAllProductByCategory(getIt<ProductRepository>()));
  getIt.registerSingleton<HomeBloc>(HomeBloc(
      getAllProduct: getIt<GetAllProduct>(),
      getProductByCategory: getIt<GetAllProductByCategory>()));
}
