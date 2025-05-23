// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<String> getCounselorReply(String userMessage) async {
//   const apiKey = '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';  // Replace with your actual key
//   const url = 'https://api.perplexity.ai/chat/completions';  // Hypothetical Sonar endpoint

//   final headers = {
//     'Authorization': 'Bearer $apiKey',
//     'Content-Type': 'application/json',
//   };

//   final body = jsonEncode({
//     "model": "sonar-reasoning-pro",  // or sonar-medium-chat, etc.
//     "messages": [
//       {"role": "user", "content": userMessage}
//     ],
//   });

//   final response = await http.post(Uri.parse(url), headers: headers, body: body);

//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     return data['choices'][0]['message']['content'];
//   } else {
//     print('Error: ${response.statusCode}');
//     return "Sorry, I couldn't process your request right now.";
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getCounselorReply(String userMessage) async {
  const apiKey = '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'; // Use your actual API key
  const url = 'https://api.perplexity.ai/chat/completions'; // Perplexity chat completion endpoint

  final headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    "model": "sonar-pro", // Empathetic model for reasoning
    "messages": [
      {
        "role": "system",
        "content":
"You are a kind and supportive counselor for women's safety. Speak like a calm, trusted friend. Give short, helpful, and empathetic advice. Avoid long paragraphs."      },
      {
        "role": "user",
        "content": userMessage
      }
    ],
    "temperature": 0.8, // Adds more human-like variety
    "max_tokens": 300   // Keeps responses complete but not too long
  });

  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      return "Sorry, I couldn't process your request right now.";
    }
  } catch (e) {
    print('Exception: $e');
    return "Something went wrong. Please try again later.";
  }
}

