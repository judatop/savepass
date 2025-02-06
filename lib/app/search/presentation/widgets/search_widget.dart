import 'package:atomic_design_system/molecules/text/ads_text_form_field.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdsTextFormField(
      focusNode: _focusNode,
      key: const Key('search_textField'),
      keyboardType: TextInputType.text,
      errorText: null,
      enableSuggestions: true,
      onChanged: (value) {},
      textInputAction: TextInputAction.search,
      onSubmitted: (String? value) {
        debugPrint('Submitted: $value');
      },
      suffixIcon: Icons.search,
    );
  }
}
