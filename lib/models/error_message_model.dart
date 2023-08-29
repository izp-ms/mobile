class ErrorMessageModel {
  String message;

  ErrorMessageModel({required this.message});

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    return ErrorMessageModel(
      message: json['message'],
    );
  }
}
