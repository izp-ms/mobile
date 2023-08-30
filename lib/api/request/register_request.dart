class RegisterRequest {
  final String email;
  final String nickName;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.email,
    required this.nickName,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'nickName': nickName,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}