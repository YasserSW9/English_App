import 'package:bloc/bloc.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/features/manage_grades_and_classes/data/models/create_class_request_body.dart';
import 'package:english_app/features/manage_grades_and_classes/data/repos/create_class_repo.dart'; // تأكد من الاستيراد الصحيح للريبو
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/create_class_state.dart'; // تأكد من الاستيراد الصحيح للـ State
import 'package:flutter/material.dart';

class CreateClassCubit extends Cubit<CreateClassState> {
  final CreateClassRepo createClassRepo; // استخدام الريبو الجديد
  TextEditingController classNameController = TextEditingController();
  TextEditingController gradeIdController =
      TextEditingController(); // متحكم جديد لـ grade_id
  final formKey = GlobalKey<FormState>();

  CreateClassCubit(this.createClassRepo)
    : super(const CreateClassState.initial());

  void emitCreateClassLoaded() async {
    emit(const CreateClassState.loading());

    if (formKey.currentState?.validate() == false) {
      if (!isClosed) {
        emit(
          const CreateClassState.error(
            error: 'Please fill all fields correctly.',
          ),
        );
      }
      return;
    }

    final int? parsedGradeId = int.tryParse(gradeIdController.text);
    if (parsedGradeId == null) {
      if (!isClosed) {
        // إضافة هذا الفحص
        emit(
          const CreateClassState.error(
            error: 'Grade ID must be a valid number.',
          ),
        );
      }
      return;
    }

    CreateClassRequestBody createClassRequestBody = CreateClassRequestBody(
      name: classNameController.text,
      gradeId: parsedGradeId, // استخدام gradeId المحول
    );

    final response = await createClassRepo.createClass(
      // استدعاء دالة الريبو الصحيحة
      createClassRequestBody,
    );

    response.when(
      success: (createClassResponse) {
        if (!isClosed) {
          // إضافة هذا الفحص
          emit(CreateClassState.success(createClassResponse));
        }
      },
      failure: (error) {
        if (!isClosed) {
          // إضافة هذا الفحص
          emit(
            CreateClassState.error(
              error: error.apiErrorModel.message ?? 'Unknown Error',
            ),
          );
        }
      },
    );
  }

  @override
  Future<void> close() {
    gradeIdController.dispose(); // التخلص من المتحكم الجديد
    classNameController.dispose();
    return super.close();
  }
}
