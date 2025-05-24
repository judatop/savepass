import 'package:equatable/equatable.dart';

abstract class NewAppVersionState extends Equatable {
  const NewAppVersionState();

  @override
  List<Object?> get props => [];
}

class NewAppVersionInitialState extends NewAppVersionState {
  const NewAppVersionInitialState() : super();
}

class GeneralErrorState extends NewAppVersionState {
  const GeneralErrorState() : super();
}
