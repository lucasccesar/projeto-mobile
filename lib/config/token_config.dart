class TokenConfig {
  static String token = '';

  static String? userId;
  static String? userName;
  static String? userEmail;
  static String? userRole;

  static bool get isAdmin {
    final role = userRole?.trim().toUpperCase();
    return role == 'ADMINISTRATOR' || role == 'ROLE_ADMINISTRATOR';
  }
}
