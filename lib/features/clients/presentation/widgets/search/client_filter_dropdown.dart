import 'package:flutter/material.dart';

class ClientFilterDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Map<String, String>? displayItems;
  final bool isSort;

  const ClientFilterDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.displayItems,
    this.isSort = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isSort ? Colors.orange.shade50 : Colors.grey.shade50,
        border: Border.all(
          color: isSort ? Colors.orange.shade200 : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: Icon(
            Icons.arrow_drop_down,
            color: isSort ? Colors.orange : Colors.grey,
          ),
          style: const TextStyle(fontSize: 12, color: Colors.black87),
          onChanged: onChanged,
          items: items.map((String item) {
            final displayText = displayItems != null
                ? displayItems![item]!
                : item;
            final isSelected = value == item && item != 'Все' && item != 'name';

            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                displayText,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
