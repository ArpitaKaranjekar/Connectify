import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:intl/intl.dart';

import 'profile_details_screen.dart';

void main() {
  runApp(const MaterialApp(
    home: CallHistoryScreen(),
  ));
}

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {
  Map<String, List<CallLogEntry>> _groupedCalls =
      {}; //Stores call logs grouped by date (Today, Yesterday, or formatted dates)

  @override
  void initState() {
    super.initState();
    _fetchCalls();
  }

//Uses the CallLog package to retrieve call history.
//Groups the call logs using _groupCallsByDate.
  Future<void> _fetchCalls() async {
    Iterable<CallLogEntry> calls = await CallLog.get();
    setState(() {
      _groupedCalls = _groupCallsByDate(calls.toList());
    });
  }

  Map<String, List<CallLogEntry>> _groupCallsByDate(List<CallLogEntry> calls) {
    Map<String, List<CallLogEntry>> groupedCalls = {
      "Today": [],
      "Yesterday": [],
    };

    final now = DateTime.now();

    for (var call in calls) {
      final callDate = DateTime.fromMillisecondsSinceEpoch(call.timestamp!)
          .toLocal(); // Converts the milliseconds into a DateTime

      if (now.difference(callDate).inDays == 0 && now.day == callDate.day) {
        groupedCalls["Today"]!.add(call);
      } else if (now.difference(callDate).inDays == 1) {
        groupedCalls["Yesterday"]!.add(call);
      } else {
        String formattedDate = DateFormat('MMM d, yyyy').format(callDate);
        groupedCalls.putIfAbsent(formattedDate, () => []).add(call);
      }
    }

    return groupedCalls;
  }

  Widget _buildGroupedCallList() {
    if (_groupedCalls.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } //Displays a loading spinner while call logs are being fetched.

    return ListView(
      children: _groupedCalls.keys.map((key) {
        final calls = _groupedCalls[key]!;
        return calls.isEmpty
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      key,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ...calls.map((call) => ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(call.name ?? call.number ?? "Unknown"),
                        subtitle: Row(
                          children: [
                            Icon(
                              _getIcon(call.callType),
                              color: _getIconColor(call.callType),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _getSubtitle(call),
                              style: TextStyle(
                                color: call.callType == CallType.missed
                                    ? Colors.red
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: Colors.grey,
                            size: 30,
                          ),
                          //Opens a ProfileDetailsScreen to show detailed information about the contact
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileDetailsScreen(
                                  name: call.name ?? "Unknown",
                                  number: call.number ?? "Unknown",
                                  photo:
                                      null, // Replace with photo if available
                                  callHistory: _groupedCalls[key]!,
                                ),
                              ),
                            );
                          },
                        ),
                      )),
                ],
              );
      }).toList(),
    );
  }

  IconData _getIcon(CallType? callType) {
    switch (callType) {
      case CallType.incoming:
        return Icons.call_received; // Incoming call icon
      case CallType.outgoing:
        return Icons.call_made; // Outgoing call icon
      case CallType.missed:
        return Icons.call_missed; // Missed call icon
      default:
        return Icons.call; // Default call icon
    }
  }

  Color _getIconColor(CallType? callType) {
    switch (callType) {
      case CallType.incoming:
        return Colors.blue; // Incoming calls in blue
      case CallType.outgoing:
        return Colors.green; // Outgoing calls in green
      case CallType.missed:
        return Colors.red; // Missed calls in red
      default:
        return Colors.grey; // Default icon color
    }
  }

  String _getSubtitle(CallLogEntry call) {
    if (call.callType == CallType.missed) {
      return "Missed  ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(call.timestamp!).toLocal())}";
    }
    return "${call.callType == CallType.incoming ? 'Incoming' : 'Outgoing'}  ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(call.timestamp!).toLocal())}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildGroupedCallList(),
      backgroundColor: Colors.white,
    );
  }
}
