import 'package:http/http.dart' as http;

class LoginRepository {
  Future<dynamic> login() async {
    const url = 'https://localhost:7275/api/User/login';
    final uri = Uri.parse(url);
    final response = await http.post(uri);

    if(response.statusCode == 200) {
      final token = response.body;
      return token;
    } else {
      throw "Something went wrong code ${response.statusCode}";
    }
  }
}