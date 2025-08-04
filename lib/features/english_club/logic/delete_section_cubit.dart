import 'package:bloc/bloc.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/features/english_club/data/repos/delete_section_repo.dart';
import 'package:english_app/features/english_club/logic/delete_section_state.dart';

class DeleteSectionCubit extends Cubit<DeleteSectionState> {
  final DeleteSectionRepo _deleteSectionRepo;

  DeleteSectionCubit(this._deleteSectionRepo)
    : super(const DeleteSectionState.initial());

  void emitDeleteSection(String deleteSectionId) async {
    emit(const DeleteSectionState.loading());
    final response = await _deleteSectionRepo.deleteSection(deleteSectionId);
    response.when(
      success: (deleteSectionResponse) {
        emit(DeleteSectionState.success(deleteSectionResponse));
      },
      failure: (error) {
        emit(
          DeleteSectionState.error(
            error: error.apiErrorModel.message ?? 'Unknown error',
          ),
        );
      },
    );
  }
}
