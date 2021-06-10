part of 'form_feedback_bloc.dart';

abstract class FormFeedbackEvent {
  const FormFeedbackEvent();
}

class SubmitFormFeedbackEvent extends FormFeedbackEvent {
  @override
  String toString() {
    return 'SubmitFormFeedbackEvent{}';
  }
}

class FailureFormFeedbackEvent extends FormFeedbackEvent {
  final String errorMessage;

  FailureFormFeedbackEvent({required this.errorMessage});

  @override
  String toString() {
    return 'FailureFormFeedbackEvent{errorMessage: $errorMessage}';
  }
}

class SuccessFormFeedbackEvent extends FormFeedbackEvent {
  @override
  String toString() {
    return 'SuccessFormFeedbackEvent{}';
  }
}
