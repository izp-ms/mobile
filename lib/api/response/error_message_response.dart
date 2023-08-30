class ErrorMessageResponse {
  String message;

  ErrorMessageResponse({required this.message});

  factory ErrorMessageResponse.fromJson(Map<String, dynamic> json) {
    return ErrorMessageResponse(
      message: json['message'],
    );
  }
}
