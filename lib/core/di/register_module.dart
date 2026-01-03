import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:galaxymob/core/network/api_client.dart';
import 'package:galaxymob/core/network/network_info.dart';

/// Module for registering third-party dependencies
@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => ApiClient().dio;

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  NetworkInfo get networkInfo => NetworkInfoImpl(connectivity);
}
