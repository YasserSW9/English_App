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

  List<Students> _allStudents = []; // جميع الطلاب من الـ API
  List<Students> _displayedStudents = []; // الطلاب بعد الفلاتر والبحث

  // قيم الفلاتر المختارة
  String _selectedClassFilter = 'All';
  String _selectedGradeFilter = 'All';

  // قوائم القيم الفريدة للفئات والدرجات لملء الـ Dropdowns
  List<String> _uniqueClassNames = ['All'];
  List<String> _uniqueGradeNames = ['All'];

  // بما أننا لا نعتمد على gClassId، يمكن إزالة _gradeNameToIdMap
  // final Map<String, int> _gradeNameToIdMap = {
  //   'Temporary': 1,
  //   'Grade 7': 2,
  //   'Grade 8': 3,
  //   'Grade 9': 4,
  //   'Grade 10': 5,
  // };

  ClassCubit(this._classRepo) : super(const ClassState.initial());

  List<String> get uniqueClassNames => _uniqueClassNames;
  List<String> get uniqueGradeNames => _uniqueGradeNames;

  Future<void> emitGetClassesLoaded() async {
    emit(const ClassState.loading());
    print('ClassCubit: Starting emitGetClassesLoaded...');

    final String startDate = '11/4/2023';
    final String endDate = '11/4/2024';

    final response = await _classRepo.getClasses(
      startDate: startDate,
      endDate: endDate,
    );

    response.when(
      success: (classResponse) {
        _allStudents.clear();
        Set<String> tempClassNames = {'All'}; // لتخزين الفئات الفريدة
        Set<String> tempGradeNames = {'All'}; // لتخزين الدرجات الفريدة

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
                    // جمع أسماء الفئات والدرجات الفريدة
                    if (student.className != null &&
                        student.className!.isNotEmpty) {
                      tempClassNames.add(
                        student.className!.trim(),
                      ); // إضافة قيمة مُهذبة
                    }
                    if (student.gradeName != null &&
                        student.gradeName!.isNotEmpty) {
                      tempGradeNames.add(
                        student.gradeName!.trim(),
                      ); // إضافة قيمة مُهذبة
                    }
                  }
                }
              }
            }
          }
        }

        _uniqueClassNames = tempClassNames.toList()..sort();
        _uniqueGradeNames = tempGradeNames.toList()..sort();

        print(
          'ClassCubit: Initial _allStudents collected: ${_allStudents.length} students.',
        );
        print('ClassCubit: Unique Class Names found: $_uniqueClassNames');
        print('ClassCubit: Unique Grade Names found: $_uniqueGradeNames');

        // تعيين الفلاتر الأولية (الافتراضية)
        _selectedClassFilter = 'All';
        _selectedGradeFilter = 'All';

        // تطبيق الفلاتر الأولية وعرض جميع الطلاب
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
    if (selectedClass != null) {
      _selectedClassFilter = selectedClass;
    }
    if (selectedGrade != null) {
      _selectedGradeFilter = selectedGrade;
    }

    _applyFiltersInternal();
    emit(ClassState.success(_displayedStudents));
    print(
      'ClassCubit: Filters applied. Displayed students: ${_displayedStudents.length}',
    );
  }

  void _applyFiltersInternal() {
    print(
      'ClassCubit: Entering _applyFiltersInternal. _allStudents count: ${_allStudents.length}',
    );
    List<Students> tempStudents = List.from(_allStudents);

    // 1. تطبيق فلتر البحث
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

    // 2. تطبيق فلتر الدرجة (Grade) باستخدام gradeName مباشرةً
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

    // 3. تطبيق فلتر الفئة (Class / Section) باستخدام className مباشرةً
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
