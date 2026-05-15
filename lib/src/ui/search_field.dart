import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/query_provider.dart';

class SearchField extends ConsumerStatefulWidget {
  const SearchField({super.key, this.focusNode});

  final FocusNode? focusNode;

  @override
  ConsumerState<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(queryProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: true,
      focusNode: widget.focusNode,
      cursorColor: Colors.white70,
      style: const TextStyle(fontSize: 18, color: Colors.white),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Type to filter…',
        hintStyle: TextStyle(color: Colors.white38),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      onChanged: (value) => ref.read(queryProvider.notifier).set(value),
    );
  }
}
