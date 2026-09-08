/// Route names, as constants so a typo is a compile error rather than a
/// blank screen at runtime.
class AppRoute {
  const AppRoute._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';

  /// The tabbed shell — what login and splash land on.
  static const String main = '/';
  static const String postList = '/post-list';
  static const String postForm = '/create-post';
  static const String updateForm = '/edit-post';
  static const String userList = '/user-list';
  static const String userCreateForm = '/create-user';
  static const String userUpdateForm = '/edit-user';
  static const String userDetail = '/user-detail';
}