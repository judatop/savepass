import 'package:equatable/equatable.dart';
import 'package:savepass/app/theme/infrastructure/models/theme_model.dart';
import 'package:savepass/app/theme/utils/theme_utils.dart';

abstract class ThemeState extends Equatable {
  final ThemeStateModel model;

  const ThemeState(this.model);

  @override
  List<Object> get props => [model];
}

class ThemeInitialState extends ThemeState {
  ThemeInitialState() : super(ThemeUtils.defaultAccountPreferencesModel);
}

class ChangeThemeState extends ThemeState {
  const ChangeThemeState(super.model);
}

class ThemeStateModel extends Equatable {
  final ThemeModel theme;

  const ThemeStateModel({
    required this.theme,
  });

  ThemeStateModel copyWith({
    ThemeModel? theme,
  }) {
    return ThemeStateModel(
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object?> get props => [
        theme,
      ];
}
