import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

abstract class BaseRepository {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  final GetStorage storage = GetStorage();

  String? get token => storage.read<String>('token');

  Options authHeaders({Map<String, dynamic>? extra}) => Options(
    headers: {
      'Authorization': 'Bearer $token',
      ...?extra,
    },
  );


  Future<(T?, String?)> run<T>({
    required Future<Response<dynamic>> Function(String token) request,
    required T? Function(Response<dynamic> response) onSuccess,
    String notLoggedInMsg = 'You are not logged in',
    String genericErrorMsg = 'Request failed',
  }) async {
    try {
      final String? currentToken = token;

      if (currentToken == null || currentToken.isEmpty) {
        return (null, notLoggedInMsg);
      }

      final Response<dynamic> response = await request(currentToken);

      print('STATUS: ${response.statusCode}');
      print('RESPONSE: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return (onSuccess(response), null);
      }

      return (null, genericErrorMsg);
    } on DioException catch (e) {
      print('ERROR status=${e.response?.statusCode} data=${e.response?.data}');

      if (e.response?.statusCode == 401) {
        return (null, 'Unauthorized. Please login again.');
      }

      return (
      null,
      e.response?.data?.toString() ?? e.message ?? genericErrorMsg,
      );
    } catch (e) {
      print('ERROR: $e');
      return (null, e.toString());
    }
  }
}