// lib/features/your_feature_folder/logic/class_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/features/search_page/data/models/class_response.dart';
import 'package:english_app/features/search_page/data/repos/class_repo.dart';
import 'package:english_app/features/search_page/logic/class_state.dart';
import 'package:flutter/material.dart';

class ClassCubit extends Cubit<ClassState<List<Students>>> {
  final ClassRepo _classRepo;
  TextEditingController searchController = TextEditingController();

  List<Students> _allStudents = [];
  List<Students> _displayedStudents = [];

  String? _selectedClassFilter;
  String? _selectedGradeFilter;

  final Map<String, int> _gradeFilterMap = {
    'Temporary': 1,
    'Grade 7': 2,
    'Grade 8': 3,
    'Grade 9': 4,
    'Grade 10': 5,
  };

  ClassCubit(this._classRepo) : super(const ClassState.initial());

  Future<void> emitGetClassesLoaded() async {
    emit(const ClassState.loading());

    final String startDate = '11/4/2023';
    final String endDate = '11/4/2024';

    final response = await _classRepo.getClasses(
      startDate: startDate,
      endDate: endDate,
    );

    response.when(
      success: (classResponse) {
        _allStudents.clear();
        if (classResponse.data != null) {
          for (var dataItem in classResponse.data!) {
            if (dataItem.classes != null) {
              for (var classItem in dataItem.classes!) {
                if (classItem.students != null) {
                  _allStudents.addAll(classItem.students!);
                }
              }
            }
          }
        }
        _displayedStudents = List.from(_allStudents);
        emit(ClassState.success(_displayedStudents));
      },
      failure: (error) {
        emit(
          ClassState.error(
            error: error.apiErrorModel.message ?? 'Unknown error',
          ),
        );
      },
    );
  }

  void performSearch(String query) {
    if (query.isEmpty) {
      _displayedStudents = List.from(_allStudents);
    } else {
      _displayedStudents = _allStudents.where((student) {
        final String name = student.name?.toLowerCase() ?? '';
        final String lowerCaseQuery = query.toLowerCase();
        return name.contains(lowerCaseQuery);
      }).toList();
    }
    _applyFiltersInternal();
    emit(ClassState.success(_displayedStudents));
  }

  void applyFilters({String? selectedClass, String? selectedGrade}) {
    _selectedClassFilter = selectedClass;
    _selectedGradeFilter = selectedGrade;

    _applyFiltersInternal();
    emit(ClassState.success(_displayedStudents));
  }

  void _applyFiltersInternal() {
    List<Students> tempStudents = List.from(_allStudents);

    if (searchController.text.isNotEmpty) {
      final String lowerCaseQuery = searchController.text.toLowerCase();
      tempStudents = tempStudents.where((student) {
        final String name = student.name?.toLowerCase() ?? '';
        return name.contains(lowerCaseQuery);
      }).toList();
    }

    if (_selectedGradeFilter != null && _selectedGradeFilter != 'All') {
      final int? actualGClassId = _gradeFilterMap[_selectedGradeFilter];
      // طباعة لتتبع اسم الدرجة وخريطة الـ grade_id
      print(
        'ClassCubit: Filtering by grade. Selected grade filter string: $_selectedGradeFilter, mapped gClassId: $actualGClassId',
      );

      if (actualGClassId != null) {
        tempStudents = tempStudents.where((student) {
          final bool matches = student.gClassId == actualGClassId;
          // يمكنك تفعيل هذه الطباعة لمزيد من التفاصيل حول كل طالب
          // print('  -> Student ${student.name} (gClassId: ${student.gClassId}) matches filter ($actualGClassId): $matches');
          return matches;
        }).toList();
      } else {
        print(
          'ClassCubit: WARNING! _selectedGradeFilter "$_selectedGradeFilter" did not map to a gClassId in _gradeFilterMap.',
        );
      }
    }

    _displayedStudents = tempStudents;
  }
}
