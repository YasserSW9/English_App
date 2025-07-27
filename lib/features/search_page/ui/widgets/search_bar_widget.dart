import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final VoidCallback? onFilterPressed;
  final ValueChanged<String> onChanged;

  const SearchBarWidget({
    Key? key,
    this.hintText = 'Search',
    this.onFilterPressed,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    _searchController.addListener(() {
      widget.onChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.deepPurple, width: 1),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
            suffixIcon: widget.onFilterPressed != null
                ? IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.black),
                    onPressed: widget.onFilterPressed,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
