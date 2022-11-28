import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Represents a search bar used to filter through a list.
class SearchBar extends StatefulWidget {
  /// [placeholderText] - the text showing before user types.
  final String placeholderText;

  /// [textEditingController] - the text editing controller for this input field.
  final TextEditingController textEditingController;

  /// [searchFunction] - the function used for filtering the list.
  final Function searchFunction;

  /// Creates an instance of search bar.
  const SearchBar(
      {super.key,
      required this.placeholderText,
      required this.searchFunction,
      required this.textEditingController});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.all(4.0),
            child: TextField(
              controller: widget.textEditingController,
              onChanged: (value) => widget.searchFunction(value),
              style: const TextStyle(
                fontSize: 12,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(PhosphorIcons.magnifyingGlass),
                border: InputBorder.none,
                hintText: widget.placeholderText.toLowerCase(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
