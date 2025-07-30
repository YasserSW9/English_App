// delete_class_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/features/manage_grades_and_classes/data/repos/delete_class_repo.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/delete_class_state.dart';

class DeleteClassCubit extends Cubit<DeleteClassState> {
  final DeleteClassRepo deleteClassRepo;

  DeleteClassCubit(this.deleteClassRepo) : super(DeleteClassState.initial());

  void emitDeleteClass({required String classId}) async {
    emit(DeleteClassState.loading());

    final response = await deleteClassRepo.deleteClass(classId);

    response.when(
      success: (deleteClassResponse) {
        emit(DeleteClassState.success(deleteClassResponse));
      },
      failure: (error) {
        emit(
          DeleteClassState.error(
            error: error.apiErrorModel.message ?? 'Unknown error',
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
