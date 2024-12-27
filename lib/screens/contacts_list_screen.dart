import 'package:flutter/material.dart';
import 'package:surefy_ai_assignment/screens/message_history_screen.dart';
import 'call_history_screen.dart';
import '../category.dart';
import 'package:contacts_service/contacts_service.dart';
import '../bottom_navigation_bar.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _isSearching = false;
  int _selectedCategory = 1; // Default to 'Contacts'
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  // Fetch contacts from the device
  Future<void> _fetchContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts.toList();

      // Sort contacts alphabetically by displayName
      _contacts.sort((a, b) {
        String nameA = a.displayName?.toLowerCase() ?? '';
        String nameB = b.displayName?.toLowerCase() ?? '';
        return nameA.compareTo(nameB); // Sort in ascending order
      });

      _filteredContacts = _contacts; // Show all contacts initially
    });
  }

  // Search contacts based on input
  void _searchContacts(String query) {
    final filtered = _contacts.where((contact) {
      final name = contact.displayName?.toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();
      return name.contains(searchQuery);
    }).toList();

    setState(() {
      _filteredContacts = filtered;
    });
  }

  // Function to group contacts by the first letter of their names
  Map<String, List<Contact>> _groupContactsByLetter() {
    Map<String, List<Contact>> groupedContacts = {};

    for (var contact in _filteredContacts) {
      final firstLetter =
          contact.displayName?.toUpperCase().substring(0, 1) ?? '#';
      if (groupedContacts.containsKey(firstLetter)) {
        groupedContacts[firstLetter]?.add(contact);
      } else {
        groupedContacts[firstLetter] = [contact];
      }
    }

    // Sort the keys alphabetically
    final sortedKeys = groupedContacts.keys.toList()..sort();
    Map<String, List<Contact>> sortedGroupedContacts = {};
    for (var key in sortedKeys) {
      sortedGroupedContacts[key] = groupedContacts[key]!;
    }

    return sortedGroupedContacts;
  }

  // Widget to build the alphabet index for quick navigation
  Widget _buildAlphabetIndex() {
    const alphabets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: alphabets.split('').map((letter) {
          return GestureDetector(
            onTap: () {
              _scrollToSection(letter);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2.0),
              child: Text(
                letter,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Scroll to a specific section
  void _scrollToSection(String letter) {
    final groupedContacts = _groupContactsByLetter();
    double totalOffset = 0.0;

    for (var key in groupedContacts.keys) {
      if (key == letter) {
        _scrollController.animateTo(
          totalOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      }
      double sectionHeight = 50.0 + (groupedContacts[key]!.length * 72.0);
      totalOffset += sectionHeight;
    }
  }

  // Widget to show the contact list
  Widget _buildContactList() {
    final groupedContacts = _groupContactsByLetter();

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollNotification) {
            return false; // Placeholder for further enhancements
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: groupedContacts.keys.length,
            itemBuilder: (context, index) {
              final sectionKey = groupedContacts.keys.elementAt(index);
              final contactsInSection = groupedContacts[sectionKey]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    margin: const EdgeInsets.only(right: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        sectionKey,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Contacts in the section
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: contactsInSection.length,
                    itemBuilder: (context, index) {
                      final contact = contactsInSection[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            contact.displayName != null &&
                                    contact.displayName!.isNotEmpty
                                ? contact.displayName![0].toUpperCase()
                                : "?",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(contact.displayName ?? "No Name"),
                        subtitle: Text(
                          contact.phones?.isNotEmpty == true
                              ? contact.phones!.first.value!
                              : "No Phone Number",
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
        _buildAlphabetIndex(), // Overlay alphabet index
      ],
    );
  }

  // Function to switch content based on the selected category
  Widget _buildCategoryContent() {
    switch (_selectedCategory) {
      case 0: // Calls
        return _buildCallHistory();
      case 1: // Contacts
        return _buildContactList();
      case 2: // Messages
        return const MessageHistoryScreen(); // Navigate to message history screen
      case 3: // Favorites
        return const Center(child: Text("Favorites will appear here"));
      default:
        return const SizedBox
            .shrink(); //If _selectedCategory does not match any of the predefined cases (0, 1, 2, 3), it defaults to returning an empty widget.Ensures that the app does not crash or throw errors
    }
  }

  // Function to navigate to CallHistoryScreen
  Widget _buildCallHistory() {
    return const CallHistoryScreen(); // Navigate to call history screen widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: _isSearching
            ? TextField(
                onChanged: _searchContacts,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: "Search Contacts",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                autofocus: true,
              )
            : Image.asset(
                'assets/images/logo.png', // Add your logo here
                width: 85,
                height: 29,
              ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2), // Light background
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
                size: 35,
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  _filteredContacts = _contacts; // Reset search
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2), // Light background
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: Colors.black,
                size: 35,
              ),
              onPressed: () {
                // Add notification functionality here
              },
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Category Bar
              CategoryBar(
                selectedIndex: _selectedCategory,
                onCategorySelected: (index) {
                  setState(() {
                    _selectedCategory = index;
                  });
                },
              ),
              const SizedBox(height: 10),
              // Dynamic content based on category
              Expanded(
                child: _buildCategoryContent(),
              ),
            ],
          ),
          // Add the icon only when the "Contacts" category is selected
          if (_selectedCategory == 1)
            Positioned(
              bottom: 30,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    // Perform an action when the button is pressed
                  },
                  backgroundColor:
                      Colors.blue, // Customize the button color if needed
                  shape: CircleBorder(), // Ensures the button is circular
                  elevation: 2, // Optional: adds some shadow for depth
                  child: const Icon(
                    Icons.add, // Message icon
                    color: Colors.white,
                    size: 30, // Icon size
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedTabIndex: _selectedCategory,
        onTabSelected: (index) {
          setState(() {
            _selectedCategory = index == 0 ? index : _selectedCategory;
          });
        },
      ),
    );
  }
}
