import 'package:equatable/equatable.dart';

abstract class NewAppVersionEvent extends Equatable {
  const NewAppVersionEvent();

  @override
  List<Object> get props => [];
}

class DownloadNewVersionEvent extends NewAppVersionEvent {
  const DownloadNewVersionEvent() : super();
}
