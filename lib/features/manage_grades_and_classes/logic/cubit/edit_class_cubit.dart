import 'package:bloc/bloc.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/features/manage_grades_and_classes/data/models/edit_class_request_body.dart';
import 'package:english_app/features/manage_grades_and_classes/data/repos/edit_class_response.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/edit_class_state.dart';
import 'package:flutter/material.dart';

class EditClassCubit extends Cubit<EditClassState> {
  final EditClassRepo editClassRepo;

  TextEditingController nameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  EditClassCubit(this.editClassRepo) : super(const EditClassState.initial());

  void emitEditClassLoaded({required int classId, required int gradeId}) async {
    emit(const EditClassState.loading());

    EditClassRequestBody editClassRequestBody = EditClassRequestBody(
      name: nameController.text,
      gradeId: gradeId,
    );

    final response = await editClassRepo.editClass(
      classId,
      editClassRequestBody,
    );

    response.when(
      success: (editClassResponse) {
        emit(EditClassState.success(editClassResponse));
      },
      failure: (error) {
        emit(
          EditClassState.error(
            error: error.apiErrorModel.message ?? 'Unknown error',
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }
}
