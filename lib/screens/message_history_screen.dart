import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageHistoryScreen extends StatefulWidget {
  const MessageHistoryScreen({super.key});

  @override
  State<MessageHistoryScreen> createState() => _MessageHistoryScreenState();
}

class _MessageHistoryScreenState extends State<MessageHistoryScreen> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    // Request SMS permission
    if (await Permission.sms.request().isGranted) {
      // Fetch SMS messages
      List<SmsMessage> messages = await _query.querySms(
        kinds: [SmsQueryKind.inbox], // Fetch only inbox messages
        count: 100, // Limit the number of messages fetched
      );

      setState(() {
        _messages = messages;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      _showPermissionDeniedMessage();
    }
  }

  void _showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Allow DialerX to send and View SMS messages'),
      ),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return "";

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (date.isAfter(today)) {
      return "Today";
    } else if (date.isAfter(yesterday)) {
      return "Yesterday";
    } else {
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _messages.isEmpty
              ? const Center(
                  child: Text("No messages found."),
                )
              : ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          message.address?.substring(0, 1) ?? "?",
                        ),
                      ),
                      title: Text(message.address ?? "Unknown Sender"),
                      subtitle: Text(
                        message.body ?? "No content",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        formatDate(message.date),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    );
                  },
                ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              // Action when the floating button is pressed, e.g., navigate to new screen
            },
            backgroundColor:
                Colors.blue, // Customize the button color if needed
            shape: const CircleBorder(), // Ensures the button is circular
            elevation: 6.0, // Optional: adds some shadow for depth
            child: const Icon(
              Icons.add_comment_rounded, // Message icon
              color: Colors.white,
              size: 30, // Icon size
            ),
          ),
        ),
      ),
    );
  }
}
