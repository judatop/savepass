import 'package:atomic_design_system/molecules/text/ads_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/search/presentation/blocs/search_bloc.dart';
import 'package:savepass/app/search/presentation/blocs/search_event.dart';
import 'package:savepass/core/utils/regex_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _search(SearchBloc bloc, String? value) {
    if (value != null && value.isNotEmpty && value.length > 1) {
      _focusNode.unfocus();
      bloc.add(
        SubmitSearchEvent(search: value),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<SearchBloc>();
    final intl = AppLocalizations.of(context)!;

    return AdsTextFormField(
      key: const Key('search_textField'),
      controller: _controller,
      keyboardType: TextInputType.text,
      focusNode: _focusNode,
      errorText: null,
      enableSuggestions: false,
      textInputAction: TextInputAction.search,
      onSubmitted: (String? value) => _search(bloc, value?.trim()),
      suffixIcon: Icons.search,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegexUtils.lettersWithSpace,
        ),
      ],
      onTapSuffixIcon: () => _search(bloc, _controller.text.trim()),
      onChanged: (value) {
        bloc.add(ChangeSearchTxtEvent(searchText: value));
      },
      hintText: intl.homeSearch,
    );
  }
}
