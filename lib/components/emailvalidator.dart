// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class EmailValidator {
//   static const String apiKey = '8522aa7f654848808fb341c356dbd9a0';

//   static Future<bool> validateEmail(String email) async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//             'https://api.zerobounce.net/v2/validate?api_key=$apiKey&email=$email'),
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         return data['status'] == 'valid';
//       } else {
//         throw Exception(
//             'ZeroBounce API request failed with status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error in validateEmail: $e');
//       return false;
//     }
//   }
// }
