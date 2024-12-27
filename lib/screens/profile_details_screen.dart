import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileDetailsScreen extends StatelessWidget {
  final String name;
  final String number;
  final String? photo;
  final List<CallLogEntry> callHistory;

  const ProfileDetailsScreen({
    super.key,
    required this.name,
    required this.number,
    this.photo,
    required this.callHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 16, bottom: 120, left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: const BorderRadius.vertical(),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 48), // Placeholder for balance
                          const Text(
                            'Profile Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert,
                                color: Colors.white),
                            onPressed: () {
                              // Add menu icon functionality here
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 100,
                  left: MediaQuery.of(context).size.width / 2 - 80,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            photo != null ? NetworkImage(photo!) : null,
                        child: photo == null
                            ? const Icon(Icons.person,
                                size: 80, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(height: 10),
                      //const SizedBox(width: 5),
                      Image.asset(
                        'assets/images/verify.png', // Replace with the correct path
                        width: 20,
                        height: 20,
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 19,
                          //fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Action Buttons
            const SizedBox(height: 160),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //Buttons are generated with _buildActionButton
                  _buildActionButton(Icons.call, "Call"),
                  _buildActionButton(Icons.message_outlined, "Message"),
                  _buildActionButton(Icons.notes, "Notes"),
                ],
              ),
            ),

            // Contact Info and Call History
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Contact Info',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: Colors
                            .transparent, // Optional to ensure no background
                        child: ListTile(
                          title: Text(number),
                          subtitle: const Text(
                            'Mobile',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          trailing: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.call,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 20),
                              Icon(
                                Icons.message,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Text(
                        'Other',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: Colors.transparent,
                        child: const ListTile(
                          leading: Icon(
                            Icons.favorite_border, // Heart icon on the left
                            color: Colors.grey,
                          ),
                          title: Text(
                            'Add to Favourites',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        child: const ListTile(
                          leading: Icon(
                            Icons.delete_outline, // Heart icon on the left
                            color: Colors.red,
                          ),
                          title: Text(
                            'Delete Contact',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Call History',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: callHistory.length,
                        itemBuilder: (context, index) {
                          final call = callHistory[index];
                          return Card(
                            child: ListTile(
                              leading: Icon(
                                call.callType == CallType.incoming
                                    ? Icons.call_received
                                    : Icons.call_made,
                                color: call.callType == CallType.incoming
                                    ? Colors.blue
                                    : Colors.green,
                              ),
                              title: Text(
                                call.callType == CallType.incoming
                                    ? "Incoming Call"
                                    : "Outgoing Call",
                              ),
                              subtitle: Text(_formatTime(call.timestamp!)),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int timestamp) {
    final callDate = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
    final now = DateTime.now();
    final difference = now.difference(callDate);

    if (difference.inDays == 0) {
      // If the call is today, show the time
      return "Today, ${DateFormat('h:mm a').format(callDate)}";
    } else if (difference.inDays == 1) {
      // If the call was yesterday, show "Yesterday" with time
      return "Yesterday, ${DateFormat('h:mm a').format(callDate)}";
    } else {
      // For older dates, show the full date and time
      return DateFormat('MMM d, h:mm a').format(callDate);
    }
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.grey, // Grey icon color
          size: 30, // Adjust size if necessary
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
              fontSize: 14, color: Colors.grey), // Grey text color
        ),
      ],
    );
  }
}
