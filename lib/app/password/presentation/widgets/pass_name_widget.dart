import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/password/presentation/blocs/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PassNameWidget extends StatelessWidget {
  const PassNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<PasswordBloc>();
    final deviceWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<PasswordBloc, PasswordState>(
      buildWhen: (previous, current) =>
          (previous.model.name != current.model.name) ||
          (previous.model.images != current.model.images),
      builder: (context, state) {
        final model = state.model;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: AdsFormField(
                label: intl.passName,
                formField: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }

                    return model.images
                        .where(
                          (item) => item.key
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()),
                        )
                        .map((item) => item.key);
                  },
                  onSelected: (String selection) {
                    bloc.add(SelectNamePasswordEvent(name: selection));
                  },
                  fieldViewBuilder: (
                    context,
                    textEditingController,
                    focusNode,
                    onFieldSubmitted,
                  ) {
                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      onFieldSubmitted: (String value) {
                        onFieldSubmitted();
                      },
                      onChanged: (value) =>
                          bloc.add(ChangeNameEvent(name: value)),
                      decoration: InputDecoration(
                        hintText: intl.passNameHint,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: deviceWidth * 0.03,
            ),
            if (model.imgUrl != null)
              AdsCard(
                child: CachedNetworkImage(
                  imageUrl: model.imgUrl!,
                  width: 50,
                  placeholder: (context, url) => Skeletonizer(
                    child: Container(
                      width: 50,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
          ],
        );
      },
    );
  }
}
