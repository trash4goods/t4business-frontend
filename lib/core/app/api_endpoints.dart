import 'package:t4g_for_business/utils/helpers/web_env.dart';

class ApiEndpoints {
  static String get devUrl => WebEnv.getEnv('API_BASE_DEV_URL');
  static const String base = '/api';
  static const String login = '/tokens';
  static const String verifyEmail = '/users/verify_email';
  static const String forgotPassword = '/users/recover_password';
  static const String checkEmailVerification = '/users/verified';
  static const String changePassword = '/users/change_password';
  static const String deleteAccount = '/users/delete_account';

  // DEPARTMENT
  static const String inviteToDepartment = '/departments/self/invite';
  static const String getDepartmentTeam = '/departments/team';
  static const String leaveDepartment = '/departments/leave';
  static const String transferOwnership = '/departments/transfer_ownership';
  static const String manageTeam = '/departments/team';

  // PRODUCT MANAGEMENT
  static const String getProducts = '/barcodes/t4b';
  static const String createProduct = '/barcodes/t4b';
  static const String updateProduct = '/barcodes/t4b';
  static const String deleteProduct = '/barcodes/t4b';
  static const String uploadCsv = '/barcodes/t4b/bulk';

  // MARKETPLACE PRODUCTS
  static const String marketplaceProductsBase = '/products/t4b';
  // GET /api/products/t4b?perPage=10&page=1&orderBy=id&categories=food&categories=sustainable
  // POST /api/products/t4b
  // PUT /api/products/t4b/67
  // DELETE /api/products/t4b/66

  // RULES
  static const String rulesBase = '/rules/t4b';
  // GET /api/rules/t4b?perPage=10&page=1&search=
  // POST /api/rules/t4b
  // PUT /api/rules/t4b/{id}
  // DELETE /api/rules/t4b/{id}

  // REWARDS
  static const String rewardsValidation = '/products/t4b/local_store';
}
