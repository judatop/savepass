import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_state.dart';
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
        final textTheme = Theme.of(context).textTheme;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              intl.passName,
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (model.imgUrl != null)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CachedNetworkImage(
                      imageUrl: model.imgUrl!,
                      width: 20,
                      placeholder: (context, url) => Skeletonizer(
                        child: Container(
                          width: 20,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                SizedBox(
                  width: deviceWidth * 0.03,
                ),
                Flexible(
                  child: Autocomplete<String>(
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
                      FocusManager.instance.primaryFocus?.unfocus();
                      bloc.add(SelectNamePasswordEvent(name: selection));
                    },
                    fieldViewBuilder: (
                      context,
                      textEditingController,
                      focusNode,
                      onFieldSubmitted,
                    ) {
                      if (textEditingController.text != model.name.value) {
                        final previousSelection =
                            textEditingController.selection;
                        textEditingController.value = TextEditingValue(
                          text: model.name.value,
                          selection: previousSelection,
                        );
                      }

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
                        textInputAction: TextInputAction.next,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
