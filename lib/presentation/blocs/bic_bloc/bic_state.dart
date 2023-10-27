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
  final List<Story> selectedHistories;
  final String titleForSearchQuery;
  final List<Story> historiesAfterSearch;
  final bool isValid;
  final SubmissionStatus status;
  final TextEditingController historyTitleController;
  final bool isSearchingHistories;

  BicState({
    this.bicName = const BICName.pure(),
    this.bicDescription = const BICDescription.pure(),
    this.exists = false,
    this.driveImagesInfo = const [],
    this.selectedHistories = const [],
    this.titleForSearchQuery = '',
    this.historiesAfterSearch = const [],
    this.isValid = false,
    this.status = SubmissionStatus.notYetSubmitted,
    required this.historyTitleController,
    this.isSearchingHistories = false,
  });

  BicState copyWith({
    BICName? bicName,
    BICDescription? bicDescription,
    bool? exists,
    List<HistouricImageInfo>? driveImagesInfo,
    List<Story>? selectedHistories,
    String? titleForSearchQuery,
    List<Story>? historiesAfterSearch,
    bool? isValid,
    SubmissionStatus? status,
    TextEditingController? historyTitleController,
    bool? isSearchingHistories,
  }) {
    return BicState(
      bicName: bicName ?? this.bicName,
      bicDescription: bicDescription ?? this.bicDescription,
      exists: exists ?? this.exists,
      driveImagesInfo: driveImagesInfo ?? this.driveImagesInfo,
      selectedHistories: selectedHistories ?? this.selectedHistories,
      titleForSearchQuery: titleForSearchQuery ?? this.titleForSearchQuery,
      historiesAfterSearch: historiesAfterSearch ?? this.historiesAfterSearch,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      historyTitleController:
          historyTitleController ?? this.historyTitleController,
      isSearchingHistories: isSearchingHistories ?? this.isSearchingHistories,
    );
  }
}
