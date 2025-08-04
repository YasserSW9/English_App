// edit_section_name_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/features/english_club/data/models/edit_section_name_request_body.dart';
import 'package:english_app/features/english_club/data/repos/edit_section_name_repo.dart';
import 'package:english_app/features/english_club/logic/edit_section_name_state.dart';
import 'package:flutter/material.dart';

class EditSectionNameCubit extends Cubit<EditSectionNameState> {
  final EditSectionNameRepo _editSectionNameRepo;
  final TextEditingController sectionNameController = TextEditingController();

  EditSectionNameCubit(this._editSectionNameRepo)
    : super(const EditSectionNameState.initial());

  void emitEditSectionName(int editSectionId) async {
    emit(const EditSectionNameState.loading());
    EditSectionNameRequestBody editSectionNameRequestBody =
        EditSectionNameRequestBody(name: sectionNameController.text);
    final response = await _editSectionNameRepo.editSectionName(
      editSectionId,
      editSectionNameRequestBody,
    );
    response.when(
      success: (editSectionNameResponse) {
        emit(EditSectionNameState.success(editSectionNameResponse));
      },
      failure: (error) {
        emit(
          EditSectionNameState.error(
            error: error.apiErrorModel.message ?? 'Unknown error',
          ),
        );
      },
    );
  }
}
