import 'package:english_app/features/manage_grades_and_classes/data/models/grades_response.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/create_class_cubit.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/delete_class_cubit.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/delete_grade_cubit.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/edit_class_cubit.dart';
import 'package:english_app/features/manage_grades_and_classes/logic/cubit/edit_grade_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class GradeAndSectionCard extends StatelessWidget {
  final Data grade;
  final Function(Classes, int) onSectionDeleted;
  final Function(Data gradeToEdit, String newName) onGradeNameEdited;
  final Function(Classes, String, int) onSectionNameEdited;

  const GradeAndSectionCard({
    required this.grade,
    required this.onSectionDeleted,
    required this.onGradeNameEdited,
    required this.onSectionNameEdited,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (grade == null) return const SizedBox.shrink();

    final List<Classes> sections = grade.classes ?? [];
    TextEditingController newClassNameController = TextEditingController();

    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepPurple.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<EditGradeCubit>().nameController.text =
                        grade.name ?? '';
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.scale,
                      title: 'Edit Grade Name',
                      body: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: context
                              .read<EditGradeCubit>()
                              .nameController,
                          decoration: InputDecoration(
                            labelText: 'Grade Name',
                            hintText: 'New name for "${grade.name ?? ''}"',
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                      ),
                      btnOkText: 'Save',
                      btnCancelText: 'Cancel',
                      btnOkOnPress: () {
                        final String newName = context
                            .read<EditGradeCubit>()
                            .nameController
                            .text
                            .trim();
                        if (newName.isEmpty) return;
                        onGradeNameEdited(grade, newName);
                        context.read<EditGradeCubit>().nameController.clear();
                      },
                      btnCancelOnPress: () =>
                          context.read<EditGradeCubit>().nameController.clear(),
                    ).show();
                  },
                  child: const Icon(Icons.edit, color: Colors.blue, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    grade.name ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      title: 'Delete Grade',
                      desc:
                          'Are you sure you want to delete "${grade.name ?? ''}"? This action cannot be undone.',
                      btnOkText: 'Delete',
                      btnCancelText: 'Cancel',
                      btnOkOnPress: () {
                        context.read<DeleteGradeCubit>().emitDeleteGrade(
                          gradeId: grade.id.toString(),
                        );
                      },
                    ).show();
                  },
                  child: const Icon(Icons.delete, color: Colors.red, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                newClassNameController.clear();
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
                  animType: AnimType.bottomSlide,
                  title: "Add New Class",
                  body: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: newClassNameController,
                      decoration: InputDecoration(
                        labelText: 'Class Name',
                        hintText: 'e.g., Section A',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),
                  btnOkText: 'Add',
                  btnCancelText: 'Cancel',
                  btnOkOnPress: () {
                    final String className = newClassNameController.text.trim();
                    if (className.isEmpty) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        title: 'Input Required',
                        desc: 'Class name cannot be empty.',
                        btnOkOnPress: () {},
                      ).show();
                      return;
                    }
                    context.read<CreateClassCubit>().classNameController.text =
                        className;
                    context.read<CreateClassCubit>().gradeIdController.text =
                        grade.id.toString();
                    context.read<CreateClassCubit>().emitCreateClassLoaded();
                    newClassNameController.clear();
                  },
                  btnCancelOnPress: () {
                    newClassNameController.clear();
                  },
                )..show();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Add New Class',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (sections.isNotEmpty)
              for (
                int sectionIndex = 0;
                sectionIndex < sections.length;
                sectionIndex++
              )
                Dismissible(
                  key: ValueKey(
                    '${grade.id ?? 0}_${sections[sectionIndex].id ?? sectionIndex}',
                  ),
                  direction: DismissDirection.horizontal,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.blue,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        title: 'Delete Section',
                        desc:
                            'Are you sure you want to delete "${sections[sectionIndex].name ?? ''}"? This cannot be undone.',
                        btnOkText: 'Delete',
                        btnCancelText: 'Cancel',
                        btnOkOnPress: () {
                          context.read<DeleteClassCubit>().emitDeleteClass(
                            classId: sections[sectionIndex].id.toString(),
                          );
                        },
                      ).show();
                      return false;
                    } else if (direction == DismissDirection.endToStart) {
                      context.read<EditClassCubit>().nameController.text =
                          sections[sectionIndex].name ?? '';

                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.scale,
                        title: 'Edit Section Name',
                        body: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: context
                                .read<EditClassCubit>()
                                .nameController,
                            decoration: InputDecoration(
                              labelText: 'Section Name',
                              hintText:
                                  'New name for "${sections[sectionIndex].name ?? ''}"',
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                        ),
                        btnOkText: 'Save',
                        btnCancelText: 'Cancel',
                        btnOkOnPress: () {
                          final String newSectionName = context
                              .read<EditClassCubit>()
                              .nameController
                              .text
                              .trim();
                          if (newSectionName.isEmpty) return;

                          context.read<EditClassCubit>().emitEditClassLoaded(
                            classId: sections[sectionIndex].id!,
                            gradeId: grade.id!,
                          );
                          context.read<EditClassCubit>().nameController.clear();
                        },
                        btnCancelOnPress: () => context
                            .read<EditClassCubit>()
                            .nameController
                            .clear(),
                      ).show();
                      return false;
                    }
                    return false;
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      sections[sectionIndex].name ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
