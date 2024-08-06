class AppConstant {
  static const String baseUrl = "https://fakestoreapi.com";

  //padding
  static const double paddingExtraSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 12.0;
  static const double paddingNormal = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 40.0;

  //radius
  static const double radiusSmall = 4.0;
  static const double radiusNormal = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusExtraLarge = 16.0;

  //icon size
  static const double iconSmall = 16.0;
  static const double iconNormal = 24.0;
  static const double iconExtraLarge = 40.0;

  //document collection firebase firestore
  static const String collectionUser = 'users';
  static const String collectionProducts = 'products';
  static const String collectioncarts = 'carts';
  static const String collectionImages = 'images';
  static const String collectionTransaction = 'transaction';

  //text
  static const textErrorEmpty = '@fieldName required';
  static const textInvalidEmailFormat =
      'The email address you entered is not valid. Please use the correct format (e.g., name@example.com)';
  static const String textErrorPasswordNotMatch = 'Password not match';
}
