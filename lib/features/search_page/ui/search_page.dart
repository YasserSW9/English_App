import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:english_app/core/networking/api_contants.dart';
import 'package:english_app/features/search_page/data/models/class_response.dart';
import 'package:english_app/features/search_page/logic/class_cubit.dart';
import 'package:english_app/features/search_page/logic/class_state.dart';
import 'package:english_app/features/search_page/logic/delete_student_cubit.dart';
import 'package:english_app/features/search_page/logic/delete_student_state.dart';
import 'package:english_app/features/search_page/ui/widgets/date_filter_dialog.dart';
import 'package:english_app/features/search_page/ui/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:english_app/features/search_page/logic/inactive_student_state.dart';
import 'package:english_app/features/search_page/logic/inactive_student_cubit.dart';
import 'package:english_app/features/search_page/data/models/inactive_response.dart';

// Imports for Edit Student functionality
import 'package:english_app/features/search_page/logic/edit_student_cubit.dart';
import 'package:english_app/features/search_page/logic/edit_student_state.dart';
import 'package:english_app/features/search_page/data/models/edit_student_request_body.dart';
import 'package:english_app/features/search_page/data/models/edit_student_response.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final Set<int> _expandedCards = {};

  late TextEditingController _nameController;
  late TextEditingController _borrowLimitController;

  @override
  void initState() {
    super.initState();
    context.read<ClassCubit>().emitGetClassesLoaded();
    _nameController = TextEditingController();
    _borrowLimitController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _borrowLimitController.dispose();
    super.dispose();
  }

  void _updateFiltersAndDropdowns() {
    final ClassCubit classCubit = context.read<ClassCubit>();
    classCubit.applyFilters(
      selectedClass: classCubit.selectedClassFilter,
      selectedGrade: classCubit.selectedGradeFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ClassCubit classCubit = context.read<ClassCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Column(
            children: [
              Container(
                height: 50.h,
                color: Colors.deepPurpleAccent,
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.deepPurple,
                            width: 1.w,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child:
                              BlocBuilder<
                                ClassCubit,
                                ClassState<List<Students>>
                              >(
                                builder: (context, state) {
                                  return DropdownButton<String>(
                                    isExpanded: true,
                                    value: classCubit.selectedClassFilter,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                    ),
                                    items: classCubit.uniqueClassNames
                                        .map<DropdownMenuItem<String>>((
                                          String value,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 8.0.w,
                                              ),
                                              child: Text(value),
                                            ),
                                          );
                                        })
                                        .toList(),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        classCubit.applyFilters(
                                          selectedClass: newValue,
                                          selectedGrade:
                                              classCubit.selectedGradeFilter,
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.deepPurple,
                            width: 1.w,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child:
                              BlocBuilder<
                                ClassCubit,
                                ClassState<List<Students>>
                              >(
                                builder: (context, state) {
                                  return DropdownButton<String>(
                                    isExpanded: true,
                                    value: classCubit.selectedGradeFilter,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                    ),
                                    items: classCubit.uniqueGradeNames
                                        .map<DropdownMenuItem<String>>((
                                          String value,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 8.0.w,
                                              ),
                                              child: Text(value),
                                            ),
                                          );
                                        })
                                        .toList(),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        classCubit.applyFilters(
                                          selectedClass: 'All',
                                          selectedGrade: newValue,
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              // Search bar
              SearchBarWidget(
                onChanged: (query) {
                  classCubit.searchController.text = query;
                  classCubit.performSearch(query);
                },
                hintText: 'Search',
                onFilterPressed: () async {
                  final Map<String, dynamic>? result = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DateFilterDialog();
                    },
                  );

                  if (result != null &&
                      result['startDate'] != null &&
                      result['endDate'] != null) {
                    final DateTime startDate = result['startDate'];
                    final DateTime endDate = result['endDate'];
                    classCubit.updateDateRange(
                      startDate: startDate,
                      endDate: endDate,
                    );
                  }
                },
              ),
              SizedBox(height: 15.h),
            ],
          ),
          Expanded(
            child: BlocConsumer<ClassCubit, ClassState<List<Students>>>(
              listener: (context, state) {},
              builder: (context, state) {
                return state.when(
                  initial: () => const Center(child: Text("Preparing data...")),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  success: (displayedStudents) {
                    return MultiBlocListener(
                      listeners: [
                        BlocListener<DeleteStudentCubit, DeleteStudentState>(
                          listener: (context, deleteState) {
                            deleteState.whenOrNull(
                              loading: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Deleting student...'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              success: (data) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      data.message ??
                                          'Student deleted successfully!',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                context
                                    .read<ClassCubit>()
                                    .emitGetClassesLoaded();
                              },
                              error: (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error deleting student: $error',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        BlocListener<
                          InactiveStudentCubit,
                          InactiveStudentState<InactiveResponse>
                        >(
                          listener: (context, inactiveState) {
                            inactiveState.whenOrNull(
                              loading: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Updating student status...'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              success: (data) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      data.message ??
                                          'Student status updated successfully!',
                                    ),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                                context
                                    .read<ClassCubit>()
                                    .emitGetClassesLoaded();
                              },
                              error: (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error updating student status: $error',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        BlocListener<EditStudentCubit, EditStudentState>(
                          listener: (context, editState) {
                            editState.whenOrNull(
                              loading: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Updating student details...',
                                    ),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              success: (data) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      (data as EditStudentResponse).message ??
                                          'Student details updated successfully!',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                context
                                    .read<ClassCubit>()
                                    .emitGetClassesLoaded();
                              },
                              error: (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error updating student details: $error',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                      child: Builder(
                        builder: (context) {
                          if (displayedStudents.isEmpty) {
                            return const Center(
                              child: Text("No Students Data To Show"),
                            );
                          }
                          return ListView.builder(
                            itemCount: displayedStudents.length,
                            itemBuilder: (BuildContext context, int index) {
                              final student = displayedStudents[index];
                              final bool isExpanded = _expandedCards.contains(
                                index,
                              );
                              final String studentClassName =
                                  student.className ?? "UnKonown";
                              final String displayStatus = student.inactive == 1
                                  ? "Active"
                                  : "Inactive";
                              final String studentSection =
                                  student.gradeName ?? "unKnown";

                              return Slidable(
                                key: ValueKey(student.id),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  extentRatio: 0.30,
                                  children: [
                                    SlidableAction(
                                      borderRadius: BorderRadius.circular(30),
                                      onPressed: (context) {
                                        // Scan Book action
                                      },
                                      backgroundColor: Colors.brown,
                                      foregroundColor: Colors.white,
                                      icon: Icons.qr_code_scanner,
                                      label: 'Scan Book',
                                    ),
                                  ],
                                ),
                                startActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  extentRatio: 0.5,
                                  children: [
                                    SlidableAction(
                                      borderRadius: BorderRadius.circular(30),
                                      onPressed: (context) {
                                        if (student.id != null) {
                                          context
                                              .read<DeleteStudentCubit>()
                                              .emitDeleteStudent(
                                                student.id!.toString(),
                                              );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Student ID is missing!',
                                              ),
                                              backgroundColor: Colors.orange,
                                            ),
                                          );
                                        }
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                    SlidableAction(
                                      borderRadius: BorderRadius.circular(30),
                                      onPressed: (context) {
                                        if (student.id != null) {
                                          final int newActiveStatusForApi =
                                              student.inactive == 1 ? 0 : 1;
                                          context
                                              .read<InactiveStudentCubit>()
                                              .emitMarkStudentActiveOrInactive(
                                                studentId: student.id!,
                                                newActiveStatus:
                                                    newActiveStatusForApi,
                                              );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Student ID is missing for status update!',
                                              ),
                                              backgroundColor: Colors.orange,
                                            ),
                                          );
                                        }
                                      },
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      icon: student.inactive == 1
                                          ? Icons.person_off
                                          : Icons.person_add,
                                      label: student.inactive == 1
                                          ? 'Inactive'
                                          : 'Activate',
                                    ),
                                  ],
                                ),
                                child: Card(
                                  color: Colors.grey.shade100,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 17.0.w,
                                    vertical: 15.h,
                                  ),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (isExpanded) {
                                          _expandedCards.remove(index);
                                        } else {
                                          _expandedCards.add(index);
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5.0.h,
                                        horizontal: 10.0.w,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 25.r,
                                                backgroundColor: Colors.green,
                                                child:
                                                    (student.profilePicture !=
                                                            null &&
                                                        student
                                                            .profilePicture!
                                                            .isNotEmpty)
                                                    ? ClipOval(
                                                        child: Image.network(
                                                          "${ApiConstants.imageUrl}${student.profilePicture!}",
                                                          fit: BoxFit.cover,
                                                          width: 50.w,
                                                          height: 50.h,
                                                          errorBuilder:
                                                              (
                                                                context,
                                                                error,
                                                                stackTrace,
                                                              ) {
                                                                return Icon(
                                                                  Icons.person,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 30.sp,
                                                                );
                                                              },
                                                        ),
                                                      )
                                                    : Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                        size: 30.sp,
                                                      ),
                                              ),
                                              SizedBox(width: 15.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      student.name ??
                                                          "Student Name Not Available",
                                                      style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    Text(
                                                      '$studentClassName \\ $studentSection \\ $displayStatus',
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: Colors.grey[900],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Icon(
                                                isExpanded
                                                    ? Icons.keyboard_arrow_up
                                                    : Icons.keyboard_arrow_down,
                                                color: Colors.black87,
                                              ),
                                            ],
                                          ),
                                          if (isExpanded)
                                            Column(
                                              children: [
                                                Divider(
                                                  height: 20.h,
                                                  thickness: 1.w,
                                                  color: Colors.grey,
                                                ),
                                                _buildDetailRow(
                                                  "Score",
                                                  "${student.score ?? 0}",
                                                  "assets/images/studentScore.png",
                                                ),
                                                _buildDetailRow(
                                                  "Golden cards",
                                                  "${student.goldenCoins ?? 0}",
                                                  "assets/images/golden.png",
                                                ),
                                                _buildDetailRow(
                                                  "Silver cards",
                                                  "${student.silverCoins ?? 0}",
                                                  "assets/images/silver.png",
                                                ),
                                                _buildDetailRow(
                                                  "Bronze cards",
                                                  "${student.bronzeCoins ?? 0}",
                                                  "assets/images/bronze.png",
                                                ),
                                                _buildDetailRow(
                                                  "Limit borrow books",
                                                  "${student.borrowLimit ?? 0}",
                                                  "assets/images/borrowBook.png",
                                                ),
                                                _buildDetailRow(
                                                  "Finished stories",
                                                  "${student.finishedStoriesCount ?? 0}",
                                                  "assets/images/finishedStudentStories.png",
                                                ),
                                                _buildDetailRow(
                                                  "Finished Levels",
                                                  "${student.finishedLevelsCount ?? 0}",
                                                  "assets/images/studentLevel.png",
                                                ),
                                                SizedBox(height: 10.h),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        _nameController.text =
                                                            student.name ?? '';
                                                        _borrowLimitController
                                                                .text =
                                                            student.borrowLimit
                                                                ?.toString() ??
                                                            '';

                                                        AwesomeDialog(
                                                          context: context,
                                                          dialogType: DialogType
                                                              .noHeader,
                                                          animType: AnimType
                                                              .bottomSlide,
                                                          title:
                                                              'Update Student',
                                                          desc:
                                                              'Update student details',
                                                          body: Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  16.0,
                                                                ),
                                                            child: Column(
                                                              children: [
                                                                ElevatedButton(
                                                                  onPressed: () {
                                                                    // TODO: Implement logic to delete student image
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    foregroundColor:
                                                                        Colors
                                                                            .white,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            10.r,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  child: const Text(
                                                                    'delete student image',
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 20.h,
                                                                ),

                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Container(
                                                                        height:
                                                                            40.h,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                            10.r,
                                                                          ),
                                                                          border: Border.all(
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                        child: DropdownButtonHideUnderline(
                                                                          child:
                                                                              DropdownButton<
                                                                                String
                                                                              >(
                                                                                value: 'temp1',
                                                                                items: const [
                                                                                  DropdownMenuItem(
                                                                                    value: 'temp1',
                                                                                    child: Text(
                                                                                      'Class temp1',
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                                onChanged:
                                                                                    (
                                                                                      value,
                                                                                    ) {},
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          10.w,
                                                                    ),
                                                                    Expanded(
                                                                      child: Container(
                                                                        height:
                                                                            40.h,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                            10.r,
                                                                          ),
                                                                          border: Border.all(
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                        child: DropdownButtonHideUnderline(
                                                                          child:
                                                                              DropdownButton<
                                                                                String
                                                                              >(
                                                                                value: 'Temporary',
                                                                                items: const [
                                                                                  DropdownMenuItem(
                                                                                    value: 'Temporary',
                                                                                    child: Text(
                                                                                      'Grade Temporary',
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                                onChanged:
                                                                                    (
                                                                                      value,
                                                                                    ) {},
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 20.h,
                                                                ),
                                                                TextField(
                                                                  controller:
                                                                      _nameController,
                                                                  decoration: InputDecoration(
                                                                    labelText:
                                                                        'student name',
                                                                    hintText:
                                                                        student
                                                                            .name ??
                                                                        '',
                                                                    border: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            10.r,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 20.h,
                                                                ),
                                                                TextField(
                                                                  controller:
                                                                      _borrowLimitController,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  decoration: InputDecoration(
                                                                    labelText:
                                                                        'borrow limit',
                                                                    hintText:
                                                                        '${student.borrowLimit ?? 0}',
                                                                    border: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            10.r,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 20.h,
                                                                ),
                                                                // "update" button inside the dialog
                                                                ElevatedButton(
                                                                  onPressed: () {
                                                                    final newName =
                                                                        _nameController
                                                                            .text
                                                                            .trim();
                                                                    final newBorrowLimit = int.tryParse(
                                                                      _borrowLimitController
                                                                          .text
                                                                          .trim(),
                                                                    );

                                                                    if (newName
                                                                            .isNotEmpty &&
                                                                        newBorrowLimit !=
                                                                            null) {
                                                                      if (student.id !=
                                                                              null &&
                                                                          student.gClassId !=
                                                                              null) {
                                                                        final requestBody = EditStudentRequestBody(
                                                                          name:
                                                                              newName,
                                                                          gClassId:
                                                                              student.gClassId!,
                                                                          borrowLimit:
                                                                              newBorrowLimit,
                                                                        );
                                                                        context
                                                                            .read<
                                                                              EditStudentCubit
                                                                            >()
                                                                            .emitEditStudentState(
                                                                              editStudentId: student.id!,
                                                                              editStudentRequestBody: requestBody,
                                                                            );
                                                                      } else {
                                                                        ScaffoldMessenger.of(
                                                                          context,
                                                                        ).showSnackBar(
                                                                          const SnackBar(
                                                                            content: Text(
                                                                              'Missing student data to update.',
                                                                            ),
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                          ),
                                                                        );
                                                                      }
                                                                      Navigator.of(
                                                                        context,
                                                                      ).pop();
                                                                    } else {
                                                                      ScaffoldMessenger.of(
                                                                        context,
                                                                      ).showSnackBar(
                                                                        const SnackBar(
                                                                          content: Text(
                                                                            'Please enter a valid name and number for borrow limit.',
                                                                          ),
                                                                          backgroundColor:
                                                                              Colors.red,
                                                                        ),
                                                                      );
                                                                    }
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .blue,
                                                                    foregroundColor:
                                                                        Colors
                                                                            .white,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            10.r,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                        'update',
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ).show();
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.deepPurple,
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10.r,
                                                              ),
                                                        ),
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 30.w,
                                                              vertical: 10.h,
                                                            ),
                                                      ),
                                                      child: const Text(
                                                        "Update",
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {},
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.deepPurple,
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10.r,
                                                              ),
                                                        ),
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 30.w,
                                                              vertical: 10.h,
                                                            ),
                                                      ),
                                                      child: const Text(
                                                        'road map',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                  error: (error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 50.sp,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'An error occurred: $error',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ClassCubit>().emitGetClassesLoaded();
                            },
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Download button pressed!');
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.download, color: Colors.white),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, String iconPath) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.h),
      child: Row(
        children: [
          SizedBox(width: 24.w, height: 24.h, child: Image.asset(iconPath)),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
