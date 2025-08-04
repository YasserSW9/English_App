import 'package:bloc/bloc.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/features/search_page/data/models/edit_student_request_body.dart';
import 'package:english_app/features/search_page/data/repos/edit_student_repo.dart';
import 'package:english_app/features/search_page/logic/edit_student_state.dart';

class EditStudentCubit extends Cubit<EditStudentState> {
  final EditStudentRepo _editStudentRepo;

  EditStudentCubit(this._editStudentRepo)
    : super(const EditStudentState.initial());

  void emitEditStudentState({
    required int editStudentId,
    required EditStudentRequestBody editStudentRequestBody,
  }) async {
    emit(const EditStudentState.loading());
    final response = await _editStudentRepo.editStudent(
      editStudentId,
      editStudentRequestBody,
    );
    response.when(
      success: (editStudentResponse) {
        emit(EditStudentState.success(editStudentResponse));
      },
      failure: (error) {
        emit(
          EditStudentState.error(
            error: error.apiErrorModel.message ?? 'Unknown error',
          ),
        );
      },
    );
  }
}
