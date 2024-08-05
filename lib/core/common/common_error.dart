import 'enum/common_error_type.dart';

class CommonError {
  CommonErrorType errorType;
  Exception? error;
  String? message;
  bool isShowErrorView;
  String? privilegeAccess;

  CommonError({
    this.errorType = CommonErrorType.unknownException,
    this.error,
    this.message,
    this.isShowErrorView = true,
    this.privilegeAccess,
  });
}
