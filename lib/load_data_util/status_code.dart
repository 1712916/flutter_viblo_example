/*Note: Add later if necessary*/

class _HttpStatusCode {
  //Informational responses (100–199)

  //Successful responses (200–299)
  static const int success = 200;
  static const int createSuccess = 201;
  static const int sendCodeSuccess = 204;

  //Redirection messages (300–399)

  //Client error responses (400–499)
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int findNotFound = 404;

//Server error responses (500–599)
  static const int internalError = 500;
}

enum HttpStatusCode {
  success,
  badRequest,
  unauthorized,
  forbidden,
  findNotFound,
  internalError,
}

extension ParseFromInt on int {
  HttpStatusCode get statusHttpCode => _getStatusCode();

  HttpStatusCode _getStatusCode() {
    switch (this) {
      case _HttpStatusCode.createSuccess:
        return HttpStatusCode.success;
      case _HttpStatusCode.success:
        return HttpStatusCode.success;
      case _HttpStatusCode.sendCodeSuccess:
        return HttpStatusCode.success;
      case _HttpStatusCode.badRequest:
        return HttpStatusCode.badRequest;
      case _HttpStatusCode.unauthorized:
        return HttpStatusCode.unauthorized;
      case _HttpStatusCode.forbidden:
        return HttpStatusCode.forbidden;
      case _HttpStatusCode.findNotFound:
        return HttpStatusCode.findNotFound;
      case _HttpStatusCode.internalError:
        return HttpStatusCode.internalError;
      default:
        return HttpStatusCode.findNotFound;
    }
  }
}

extension GetCode on HttpStatusCode {
  int get code => _getCode();

  _getCode() {
    switch (this) {
      case HttpStatusCode.success:
        return _HttpStatusCode.success;
      case HttpStatusCode.badRequest:
        return _HttpStatusCode.badRequest;
      case HttpStatusCode.unauthorized:
        return _HttpStatusCode.unauthorized;
      case HttpStatusCode.forbidden:
        return _HttpStatusCode.forbidden;
      case HttpStatusCode.findNotFound:
        return _HttpStatusCode.findNotFound;
    }
  }
}
