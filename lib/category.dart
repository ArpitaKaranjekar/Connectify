import 'package:flutter/material.dart';

class CategoryBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  const CategoryBar({
    super.key,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ['Calls', 'Contacts', 'Messages', 'Favorites'];

    return Container(
      height: 50,
      color: Colors.white, // Background color
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onCategorySelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: selectedIndex == index
                    ? const Color(0xFF5864F8) // Active category color
                    : const Color(0xFFEDEDED), // Light gray background
              ),
              child: Row(
                children: [
                  Text(
                    categories[index],
                    style: TextStyle(
                      color:
                          selectedIndex == index ? Colors.white : Colors.grey,
                      fontWeight: selectedIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 5), // Space between text and icon
                  Icon(
                    Icons.expand_more,
                    color: selectedIndex == index ? Colors.white : Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
