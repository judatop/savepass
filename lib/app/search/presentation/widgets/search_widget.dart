import 'package:atomic_design_system/molecules/text/ads_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/search/presentation/blocs/search_bloc.dart';
import 'package:savepass/app/search/presentation/blocs/search_event.dart';
import 'package:savepass/app/search/presentation/blocs/search_state.dart';
import 'package:savepass/core/utils/regex_utils.dart';

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
    final bloc = Modular.get<SearchBloc>();

    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (previous, current) =>
          (previous.model.status != current.model.status),
      builder: (context, state) {
        final search = state.model.searchForm.value;

        return AdsTextFormField(
          initialValue: search,
          key: const Key('search_textField'),
          keyboardType: TextInputType.text,
          focusNode: _focusNode,
          errorText: null,
          enableSuggestions: false,
          onChanged: (value) {
            bloc.add(
              ChangeSearchTxtEvent(
                searchText: value,
              ),
            );
          },
          textInputAction: TextInputAction.search,
          onSubmitted: (String? value) {
            bloc.add(
              const SubmitSearchEvent(),
            );
          },
          suffixIcon: Icons.search,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegexUtils.lettersWithSpace,
            ),
          ],
        );
      },
    );
  }
}
