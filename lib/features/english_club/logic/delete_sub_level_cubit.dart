// delete_sub_level_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/features/english_club/data/models/delete_sub_level_response.dart';
import 'package:english_app/features/english_club/data/repos/delete_sub_level_repo.dart';
import 'package:english_app/features/english_club/logic/delete_sub_level_state.dart';

class DeleteSubLevelCubit extends Cubit<DeleteSubLevelState> {
  final DeleteSubLevelRepo _deleteSubLevelRepo;

  DeleteSubLevelCubit(this._deleteSubLevelRepo)
    : super(const DeleteSubLevelState.initial());

  void emitDeleteSubLevel(String deleteLevelId, String deleteSubLevelId) async {
    emit(const DeleteSubLevelState.loading());
    final response = await _deleteSubLevelRepo.deleteSubLevel(
      deleteLevelId,
      deleteSubLevelId,
    );
    response.when(
      success: (deleteSubLevelResponse) {
        emit(DeleteSubLevelState.success(deleteSubLevelResponse));
      },
      failure: (error) {
        emit(
          DeleteSubLevelState.error(
            error: error.apiErrorModel.message ?? 'Unknown error',
          ),
        );
      },
    );
  }
}
