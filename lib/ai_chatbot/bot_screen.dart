import 'package:flutter/material.dart';
import 'package:flutter_application_2/db/db_services.dart';
import 'package:flutter_application_2/model/contactsm.dart';
import 'package:flutter_application_2/services/ai_services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AutoCounselorChatScreen extends StatefulWidget {
  const AutoCounselorChatScreen({super.key});

  @override
  _AutoCounselorChatScreenState createState() => _AutoCounselorChatScreenState();
}

class _AutoCounselorChatScreenState extends State<AutoCounselorChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> messages = [];
  bool isLoading = false;

  Future<void> sendMessageAuto(String messageBody) async {
  final Telephony telephony = Telephony.instance;



  // Get saved contacts
  List<TContact> contactList = await DatabaseHelper().getContactList();

  if (contactList.isEmpty) {
    Fluttertoast.showToast(msg: "⚠️ No contacts found. Please add contacts.");
    return;
  }

  Fluttertoast.showToast(msg: "📨 Sending SMS messages...");

  for (var contact in contactList) {
    try {
      await telephony.sendSms(
        to: contact.number,
        message: messageBody,
      );
      Fluttertoast.showToast(msg: "✅ SMS sent to ${contact.number}");
    } catch (e) {
      Fluttertoast.showToast(msg: "❌ Failed to send SMS to ${contact.number}: $e");
    }
  }
}


  void _sendMessage() async {
  final input = _controller.text.trim();
  if (input.isEmpty) return;

  setState(() {
    messages.add({'role': 'user', 'text': input});
    _controller.clear();
    isLoading = true;
  });

  final emergencyKeywords = [
  "sucide",
  "depressed",
  "kill myself",
  "want to die",
  "can't take it"
];

bool isEmergency = emergencyKeywords.any(
  (keyword) => input.toLowerCase().contains(keyword.toLowerCase())
);

if (isEmergency) {
    // ✅ Get current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String locationUrl = "https://maps.google.com/?q=${position.latitude},${position.longitude}";

    String messageBody = "🚨 Urgent: The user may be in danger and needs support.\n"
        "Location: $locationUrl\n"
        "Message: \"$input\"\n"
        "Please check in on them immediately.";

    await sendMessageAuto(messageBody);
  }
  
  // 🔗 Call your API function
  String reply = await getCounselorReply(input);

  setState(() {
    messages.add({'role': 'counselor', 'text': reply});
    isLoading = false;
  });

  _scrollController.animateTo(
    _scrollController.position.maxScrollExtent + 100,
    duration: Duration(milliseconds: 300),
    curve: Curves.easeOut,
  );
}



Widget _buildMessage(Map<String, String> message) {
  bool isUser = message['role'] == 'user';

  return Container(
    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    child: Container(
      decoration: BoxDecoration(
        color: isUser ? Color(0xFF9F80A7) : Color(0xFFE0435E),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(12),
      child: isUser
          ? Text(
              message['text'] ?? '',
              style: TextStyle(
                color: Color(0xFFECE1EE),
                fontWeight: FontWeight.w500,
              ),
            )
          : MarkdownBody(
              data: message['text'] ?? '',
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  color: Color(0xFFECE1EE),
                  fontWeight: FontWeight.w500,
                ),
                strong: TextStyle(color: Color(0xFFECE1EE)),
                h1: TextStyle(color: Color(0xFFECE1EE), fontSize: 20, fontWeight: FontWeight.bold),
                h2: TextStyle(color: Color(0xFFECE1EE), fontSize: 18, fontWeight: FontWeight.bold),
                h3: TextStyle(color: Color(0xFFECE1EE), fontSize: 16, fontWeight: FontWeight.bold),
                listBullet: TextStyle(color: Color(0xFFECE1EE)),
              ),
            ),
    ),
  );
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
          resizeToAvoidBottomInset: true, // this ensures keyboard doesn't overlap content
      appBar: AppBar(
        title: Text("Auto-Counselor"),
        titleTextStyle: TextStyle(color: Color(0xFFECE1EE),fontWeight: FontWeight.w700,fontSize: 23),
        backgroundColor: Color(0xFF43061E),
              foregroundColor: Color(0xFFECE1EE), // this changes back arrow & title color

      ),
  body: SafeArea(
  child: LayoutBuilder(
    builder: (context, constraints) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isLoading) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Counselor is typing..."),
                    ),
                  );
                }
                return _buildMessage(messages[index]);
              },
            ),
          ),
          Divider(height: 10),
          Container(
            color: Color(0xFFECE1EE),
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              top: 6,
              bottom: MediaQuery.of(context).viewInsets.bottom + 8,
            ),
            child: Row(
              children: [
                Expanded(
  child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 8),
    child: TextField(
      controller: _controller,
      decoration: InputDecoration.collapsed(
        hintText: "Type your thoughts...",
      ),
      onSubmitted: (_) => _sendMessage(),
    ),
  ),
),

                IconButton(
                  icon: Icon(Icons.send, color: Color(0xFF43061E)),
                  onPressed: _sendMessage,
                )
              ],
            ),
          ),
        ],
      );
    },
  ),
),



    );
  }
}
