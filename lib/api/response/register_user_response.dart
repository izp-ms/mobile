class RegisterUserResponse {
  int id;
  String nickName;
  String email;
  String role;

  RegisterUserResponse({
    required this.id,
    required this.nickName,
    required this.email,
    required this.role,
  });

  factory RegisterUserResponse.fromJson(Map<String, dynamic> json) {
    return RegisterUserResponse(
      id: json['id'],
      nickName: json['nickName'],
      email: json['email'],
      role: json['role'],
    );
  }
}
