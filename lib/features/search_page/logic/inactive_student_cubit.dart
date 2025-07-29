// ignore_for_file: unused_local_variable

import 'package:bloc/bloc.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/features/search_page/data/models/inactive_request_body.dart';
import 'package:english_app/features/search_page/data/models/inactive_response.dart';
import 'package:english_app/features/search_page/data/repos/inactive_repo.dart';
import 'package:english_app/features/search_page/logic/inactive_student_state.dart';

class InactiveStudentCubit
    extends Cubit<InactiveStudentState<InactiveResponse>> {
  final InactiveStudentRepo _inactiveStudentRepo;

  InactiveStudentCubit(this._inactiveStudentRepo)
    : super(const InactiveStudentState.initial());

  Future<void> emitMarkStudentActiveOrInactive({
    required int studentId,
    required int newActiveStatus,
  }) async {
    emit(const InactiveStudentState.loading());

    final InactiveRequestBody requestBody = InactiveRequestBody(
      active: newActiveStatus,
    );

    final response = await _inactiveStudentRepo.markStudentInactive(
      studentId: studentId,
      inactiveRequestBody: requestBody,
    );

    response.when(
      success: (inactiveResponse) {
        emit(InactiveStudentState.success(inactiveResponse));
      },
      failure: (errorHandler) {
        emit(
          InactiveStudentState.error(
            error:
                errorHandler.apiErrorModel.message ?? 'Unknown error occurred.',
          ),
        );
      },
    );
  }
}
