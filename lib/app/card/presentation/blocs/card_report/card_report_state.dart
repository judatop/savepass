import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/core/form/text_form.dart';

abstract class CardReportState extends Equatable {
  final CardReportStateModel model;

  const CardReportState(this.model);

  @override
  List<Object> get props => [model];
}

class CardReportInitialState extends CardReportState {
  const CardReportInitialState() : super(const CardReportStateModel());
}

class ChangeCardReportState extends CardReportState {
  const ChangeCardReportState(super.model);
}

class GeneralErrorState extends CardReportState {
  const GeneralErrorState(super.model);
}

class LoadingCardState extends CardReportState {
  const LoadingCardState(super.model);
}

class CardReportStateModel extends Equatable {
  final TextForm searchForm;
  final FormzSubmissionStatus status;
  final List<CardModel> cards;

  const CardReportStateModel({
    this.searchForm = const TextForm.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.cards = const [],
  });

  CardReportStateModel copyWith({
    TextForm? searchForm,
    FormzSubmissionStatus? status,
    List<CardModel>? cards,
  }) {
    return CardReportStateModel(
      searchForm: searchForm ?? this.searchForm,
      status: status ?? this.status,
      cards: cards ?? this.cards,
    );
  }

  @override
  List<Object?> get props => [
        searchForm,
        status,
        cards,
      ];
}
