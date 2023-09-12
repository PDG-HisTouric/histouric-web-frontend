part of 'bic_bloc.dart';

enum SubmissionStatus {
  notYetSubmitted,
  submissionInProgress,
  submissionSuccess,
  submissionFailure
}

final class BicState {
  final BICName bicName;
  final BICDescription bicDescription;
  final bool exists;
  final List<HistouricImageInfo> driveImagesInfo;
  final bool isValid;
  final SubmissionStatus status;

  BicState({
    this.bicName = const BICName.pure(),
    this.bicDescription = const BICDescription.pure(),
    this.exists = false,
    this.driveImagesInfo = const [],
    this.isValid = false,
    this.status = SubmissionStatus.notYetSubmitted,
  });

  BicState copyWith({
    BICName? bicName,
    BICDescription? bicDescription,
    bool? exists,
    List<HistouricImageInfo>? driveImagesInfo,
    bool? isValid,
    SubmissionStatus? status,
  }) {
    return BicState(
      bicName: bicName ?? this.bicName,
      bicDescription: bicDescription ?? this.bicDescription,
      exists: exists ?? this.exists,
      driveImagesInfo: driveImagesInfo ?? this.driveImagesInfo,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
    );
  }
}
