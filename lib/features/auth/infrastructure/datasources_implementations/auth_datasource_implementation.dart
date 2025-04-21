import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDatasourceImplementation extends AuthDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      // connectTimeout: 5000,
      // receiveTimeout: 3000,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  @override
  Future<User> isAuthenticated(String token) async {
    try {
      final response = await dio.get(
        '/auth/check-status',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final user = UserMapper.fromJson(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          throw CustomError('Token incorrecto!', 401);
        }
      }
      throw CustomError('Error inesperado!', 500);
    } catch (e) {
      throw CustomError('Error Inesperado!', 500);
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 201) {
        return UserMapper.fromJson(response.data);
      } else {
        throw Exception('Failed to login');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas!',
            401,
          ); // throw WrongCredentials();
        } else if (e.type == DioExceptionType.connectionTimeout) {
          throw CustomError(
            'Revisr conexión a internet!',
            408,
          ); // ConnectionTimeout('Server error');
        } else if (e.response!.statusCode == 400) {
          throw CustomError('Bad request!', 400);
        }
      }
      throw CustomError('Error inesperado!', 500);
    } catch (e) {
      throw CustomError('Error Inesperado!', 500);
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {'email': email, 'password': password, 'fullName': fullName},
      );
      if (response.statusCode == 201) {
        return UserMapper.fromJson(response.data);
      } else {
        throw Exception('Failed to register');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.type == DioExceptionType.connectionTimeout) {
          throw CustomError('Revisr conexión a internet!', 408);
        } else if (e.response!.statusCode == 400) {
          throw CustomError('Bad request!', 400);
        }
      }
      throw CustomError('Error inesperado!', 500);
    } catch (e) {
      throw CustomError('Error Inesperado!', 500);
    }
  }
}
