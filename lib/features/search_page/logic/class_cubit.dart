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

  String _selectedClassFilter = 'All';
  String _selectedGradeFilter = 'All';

  List<String> _uniqueClassNames = ['All'];
  List<String> _uniqueGradeNames = ['All'];

  DateTime? _currentStartDate;
  DateTime? _currentEndDate;

  ClassCubit(this._classRepo) : super(const ClassState.initial());

  List<String> get uniqueClassNames => _uniqueClassNames;
  List<String> get uniqueGradeNames => _uniqueGradeNames;
  String get selectedClassFilter => _selectedClassFilter;
  String get selectedGradeFilter => _selectedGradeFilter;

  Future<void> emitGetClassesLoaded({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(const ClassState.loading());
    print('ClassCubit: Starting emitGetClassesLoaded...');

    _currentStartDate = startDate ?? _currentStartDate ?? DateTime(2024, 4, 11);
    _currentEndDate = endDate ?? _currentEndDate ?? DateTime(2029, 4, 11);

    final String formattedStartDate =
        "${_currentStartDate!.year}-${_currentStartDate!.month.toString().padLeft(2, '0')}-${_currentStartDate!.day.toString().padLeft(2, '0')}";
    final String formattedEndDate =
        "${_currentEndDate!.year}-${_currentEndDate!.month.toString().padLeft(2, '0')}-${_currentEndDate!.day.toString().padLeft(2, '0')}";

    final response = await _classRepo.getClasses(
      startDate: formattedStartDate,
      endDate: formattedEndDate,
    );

    response.when(
      success: (classResponse) {
        _allStudents.clear();
        Set<String> allUniqueGradeNames = {'All'};

        if (classResponse.data != null) {
          print(
            'ClassCubit: API response data is not null. Items: ${classResponse.data!.length}',
          );
          for (var dataItem in classResponse.data!) {
            if (dataItem.classes != null) {
              for (var classItem in dataItem.classes!) {
                if (classItem.students != null) {
                  _allStudents.addAll(classItem.students!);
                  for (var student in classItem.students!) {
                    if (student.gradeName != null &&
                        student.gradeName!.isNotEmpty) {
                      allUniqueGradeNames.add(student.gradeName!.trim());
                    }
                  }
                }
              }
            }
          }
        }

        _uniqueGradeNames = allUniqueGradeNames.toList()..sort();
        print(
          'ClassCubit: Initial _allStudents collected: ${_allStudents.length} students.',
        );
        print(
          'ClassCubit: Unique Grade Names found (initial): $_uniqueGradeNames',
        );

        _selectedGradeFilter = 'All';
        _selectedClassFilter = 'All';

        _recalculateUniqueClassNamesForSelectedGrade();

        _applyFiltersInternal();
        emit(ClassState.success(_displayedStudents));
        print(
          'ClassCubit: Initial state emitted with ${_displayedStudents.length} displayed students.',
        );
      },
      failure: (error) {
        print(
          'ClassCubit: Error fetching classes: ${error.apiErrorModel.message ?? 'Unknown error'}',
        );
        emit(
          ClassState.error(
            error: error.apiErrorModel.message ?? 'Unknown error',
          ),
        );
      },
    );
  }

  void updateDateRange({
    required DateTime? startDate,
    required DateTime? endDate,
  }) {
    _currentStartDate = startDate;
    _currentEndDate = endDate;

    emitGetClassesLoaded(
      startDate: _currentStartDate,
      endDate: _currentEndDate,
    );
  }

  void performSearch(String query) {
    print('ClassCubit: Performing search with query: "$query"');
    searchController.text = query;
    _applyFiltersInternal();
    emit(ClassState.success(_displayedStudents));
    print(
      'ClassCubit: Search results emitted. Displayed students: ${_displayedStudents.length}',
    );
  }

  void applyFilters({String? selectedClass, String? selectedGrade}) {
    print(
      'ClassCubit: Applying filters. Class: $selectedClass, Grade: $selectedGrade',
    );

    bool gradeChanged = false;
    if (selectedGrade != null && _selectedGradeFilter != selectedGrade) {
      _selectedGradeFilter = selectedGrade;
      _selectedClassFilter = 'All';
      gradeChanged = true;
    }

    if (selectedClass != null) {
      _selectedClassFilter = selectedClass;
    }

    if (gradeChanged) {
      _recalculateUniqueClassNamesForSelectedGrade();
    }

    _applyFiltersInternal();
    emit(ClassState.success(_displayedStudents));
    print(
      'ClassCubit: Filters applied. Displayed students: ${_displayedStudents.length}',
    );
  }

  void _recalculateUniqueClassNamesForSelectedGrade() {
    Set<String> tempClassNames = {'All'};

    List<Students> studentsMatchingGrade = _allStudents.where((student) {
      if (_selectedGradeFilter == 'All') {
        return true;
      }
      final String studentGradeName =
          student.gradeName?.trim().toLowerCase() ?? '';
      final String filterGradeName = _selectedGradeFilter.trim().toLowerCase();
      return studentGradeName == filterGradeName;
    }).toList();

    for (var student in studentsMatchingGrade) {
      if (student.className != null && student.className!.isNotEmpty) {
        tempClassNames.add(student.className!.trim());
      }
    }

    _uniqueClassNames = tempClassNames.toList()..sort();
    print(
      'ClassCubit: Recalculated unique class names for grade "$_selectedGradeFilter": $_uniqueClassNames',
    );
  }

  void _applyFiltersInternal() {
    print(
      'ClassCubit: Entering _applyFiltersInternal. _allStudents count: ${_allStudents.length}',
    );
    List<Students> tempStudents = List.from(_allStudents);

    if (searchController.text.isNotEmpty) {
      final String lowerCaseQuery = searchController.text.toLowerCase();
      tempStudents = tempStudents.where((student) {
        final String name = student.name?.toLowerCase() ?? '';
        final String className = student.className?.toLowerCase() ?? '';
        final String gradeName = student.gradeName?.toLowerCase() ?? '';
        return name.contains(lowerCaseQuery) ||
            className.contains(lowerCaseQuery) ||
            gradeName.contains(lowerCaseQuery);
      }).toList();
      print(
        'ClassCubit: After search filter ("${searchController.text}"): ${tempStudents.length} students.',
      );
    }

    if (_selectedGradeFilter != 'All') {
      tempStudents = tempStudents.where((student) {
        final String studentGradeName =
            student.gradeName?.trim().toLowerCase() ?? '';
        final String filterGradeName = _selectedGradeFilter
            .trim()
            .toLowerCase();
        final bool matches = studentGradeName == filterGradeName;
        return matches;
      }).toList();
      print(
        'ClassCubit: After grade filter ("$_selectedGradeFilter"): ${tempStudents.length} students.',
      );
    }

    if (_selectedClassFilter != 'All') {
      tempStudents = tempStudents.where((student) {
        final String studentClassName =
            student.className?.trim().toLowerCase() ?? '';
        final String filterClassName = _selectedClassFilter
            .trim()
            .toLowerCase();
        final bool matches = studentClassName == filterClassName;
        return matches;
      }).toList();
      print(
        'ClassCubit: After class filter ("$_selectedClassFilter"): ${tempStudents.length} students.',
      );
    }

    _displayedStudents = tempStudents;
    print(
      'ClassCubit: Final _displayedStudents count: ${_displayedStudents.length}',
    );
  }
}
