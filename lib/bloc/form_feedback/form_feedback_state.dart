part of 'form_feedback_bloc.dart';

abstract class FormFeedbackState {
  const FormFeedbackState();
}

class InitialFormFeedbackState extends FormFeedbackState {
  @override
  String toString() {
    return 'InitialFormFeedbackState{}';
  }
}

class LoadingFormFeedbackState extends FormFeedbackState {
  @override
  String toString() {
    return 'LoadingFormFeedbackState{}';
  }
}

class FailureFormFeedbackState extends FormFeedbackState {
  final String errorMessage;

  FailureFormFeedbackState({required this.errorMessage});

  @override
  String toString() {
    return 'FailureFormFeedbackState{errorMessage: $errorMessage}';
  }
}

class SuccessFormFeedbackState extends FormFeedbackState {
  @override
  String toString() {
    return 'SuccessFormFeedbackState{}';
  }
}