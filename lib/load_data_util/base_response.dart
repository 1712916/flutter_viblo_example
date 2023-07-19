import 'status_code.dart';

class ErrorResponse<T> extends BaseResponse<T> {
  ErrorResponse({
    required super.statusCode,
    required super.message,
    super.data,
  });
}

class SuccessResponse<T> extends BaseResponse<T> {
  SuccessResponse({
    required super.statusCode,
    required super.data,
    super.message,
  });
}

class BaseResponse<T> {
  final HttpStatusCode statusCode;
  final String? message;
  final T? data;

  BaseResponse({
    required this.statusCode,
    this.message,
    this.data,
  });
}

// BaseResponse<T> convertResponseFromPureType<T>(Response? response, T Function(dynamic data) fromString) {
//   if (response != null) {
//     if (response.statusCode?.statusHttpCode == HttpStatusCode.success) {
//       Map<String, dynamic> data = {};
//
//       if (response.data is String) {
//         data = jsonDecode(response.data);
//       } else if (response.data is Map) {
//         data = response.data;
//       }
//
//       final dataResponse = data['data'];
//       final statusCode = data['status']?.toString().parseInt()?.statusHttpCode ?? HttpStatusCode.success;
//       if (statusCode == HttpStatusCode.success) {
//         return SuccessResponse<T>(
//           statusCode: statusCode,
//           data: fromString.call(dataResponse),
//         );
//       } else {
//         // return error code and message.
//         final String messageError = data['message'] ?? '';
//         final bool isRetry = data['isRetry'] ?? false;
//         return ErrorResponse(statusCode: statusCode, message: messageError, isRetry: isRetry);
//       }
//     }
//   }
//   return ErrorResponse(statusCode: HttpStatusCode.badRequest, message: defaultErrorMessage, isRetry: true);
// }
//
// BaseResponse<T> convertResponse<T>(Response? response, T Function(Map<String, dynamic> json)? fromJson) {
//   if (response != null) {
//     if (response.statusCode?.statusHttpCode == HttpStatusCode.success) {
//       Map<String, dynamic> data = {};
//
//       if (response.data is String) {
//         data = jsonDecode(response.data);
//       } else if (response.data is Map) {
//         data = response.data;
//       }
//
//       final dataResponse = data['data'] ?? <String, dynamic>{};
//       final statusCode = data['status']?.toString().parseInt()?.statusHttpCode ?? HttpStatusCode.success;
//
//       if (statusCode == HttpStatusCode.success) {
//         return SuccessResponse<T>(
//           statusCode: statusCode,
//           data: fromJson?.call(dataResponse),
//         );
//       } else {
//         // return error code and message.
//         final String messageError = data['message'] ?? '';
//         final bool isRetry = data['isRetry'] ?? false;
//         final dataResponse = data['data'] ?? <String, dynamic>{};
//         return ErrorResponse(statusCode: statusCode, message: messageError, isRetry: isRetry, data: fromJson?.call(dataResponse));
//       }
//     }
//   }
//   return ErrorResponse(statusCode: HttpStatusCode.badRequest, message: defaultErrorMessage, isRetry: true,);
// }
//
// BaseResponse<List<T>> convertListResponse<T>(Response? response, T Function(Map<String, dynamic> json) fromJson) {
//   if (response != null) {
//     if (response.statusCode?.statusHttpCode == HttpStatusCode.success) {
//       Map<String, dynamic> data = {};
//
//       if (response.data is String) {
//         data = jsonDecode(response.data);
//       } else if (response.data is Map) {
//         data = response.data;
//       }
//
//       final dataResponse = data['data'];
//       final statusCode = data['status']?.toString().parseInt()?.statusHttpCode ?? HttpStatusCode.success;
//       if (dataResponse is List) {
//         return SuccessResponse<List<T>>(
//           statusCode: statusCode,
//           data: dataResponse.map((e) => fromJson(e)).toList(),
//         );
//       }
//     }
//   }
//   return ErrorResponse(statusCode: HttpStatusCode.badRequest, message: defaultErrorMessage, isRetry: false);
// }
