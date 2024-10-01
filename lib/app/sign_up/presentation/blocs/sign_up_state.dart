import 'package:equatable/equatable.dart';
import 'package:savepass/core/widgets/forms/text_form.dart';

abstract class SignUpState extends Equatable {
  final SignUpStateModel model;

  const SignUpState(this.model);

  @override
  List<Object> get props => [model];
}

class SignUpInitialState extends SignUpState {
  const SignUpInitialState() : super(const SignUpStateModel());
}

class ChangeSignUpState extends SignUpState {
  const ChangeSignUpState(super.model);
}

class SignUpStateModel extends Equatable {
  final TextForm name;
  final bool submitAlredyClicked;

  const SignUpStateModel({
    this.name = const TextForm.pure(),
    this.submitAlredyClicked = false,
  });

  SignUpStateModel copyWith({
    TextForm? name,
    bool? submitAlredyClicked,
  }) {
    return SignUpStateModel(
      name: name ?? this.name,
      submitAlredyClicked: submitAlredyClicked ?? this.submitAlredyClicked,
    );
  }

  @override
  List<Object?> get props => [
        name,
        submitAlredyClicked,
      ];
}
