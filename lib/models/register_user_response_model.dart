class RegisterUserResponseModel {
  int id;
  String nickName;
  String email;
  String role;

  RegisterUserResponseModel({
    required this.id,
    required this.nickName,
    required this.email,
    required this.role,
  });

  factory RegisterUserResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterUserResponseModel(
      id: json['id'],
      nickName: json['nickName'],
      email: json['email'],
      role: json['role'],
    );
  }
}
