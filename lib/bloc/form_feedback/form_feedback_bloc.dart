import 'dart:async';

import 'package:bloc/bloc.dart';

part 'form_feedback_event.dart';
part 'form_feedback_state.dart';

class FormFeedbackBloc extends Bloc<FormFeedbackEvent, FormFeedbackState> {
  FormFeedbackBloc() : super(InitialFormFeedbackState());

  @override
  Stream<FormFeedbackState> mapEventToState(
    FormFeedbackEvent event,
  ) async* {
    if (event is SubmitFormFeedbackEvent) {
      yield LoadingFormFeedbackState();
    } else if (event is FailureFormFeedbackEvent) {
      yield FailureFormFeedbackState(errorMessage: event.errorMessage);
    } else if (event is SuccessFormFeedbackEvent) {
      yield SuccessFormFeedbackState();
    }
  }
}
