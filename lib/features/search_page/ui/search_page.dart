// lib/features/search_page/ui/search_page.dart
import 'package:english_app/features/search_page/data/models/class_response.dart';
import 'package:english_app/features/search_page/logic/class_cubit.dart';
import 'package:english_app/features/search_page/logic/class_state.dart';
import 'package:english_app/features/search_page/ui/widgets/date_filter_dialog.dart';
import 'package:english_app/features/search_page/ui/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final Set<int> _expandedCards = {};

  @override
  void initState() {
    super.initState();

    // Initial load of classes without specific date filters,
    // it will use the default dates set in the cubit.
    context.read<ClassCubit>().emitGetClassesLoaded();
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
                color: Colors.deepPurpleAccent.shade100,
                width: double.infinity,
                child: const Center(
                  child: Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.deepPurple,
                            width: 1,
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
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.deepPurple,
                            width: 1,
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
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
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
              const SizedBox(height: 10),
              // Search bar
              SearchBarWidget(
                onChanged: (query) {
                  classCubit.searchController.text = query;
                  classCubit.performSearch(query);
                },
                hintText: 'Search',
                onFilterPressed: () async {
                  // This is where the DateFilterDialog is called
                  final Map<String, dynamic>? result = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DateFilterDialog();
                    },
                  );

                  // After the dialog closes, process the selected dates
                  if (result != null &&
                      result['startDate'] != null &&
                      result['endDate'] != null) {
                    final DateTime startDate = result['startDate'];
                    final DateTime endDate = result['endDate'];

                    print('Start Date selected: $startDate');
                    print('End Date selected: $endDate');

                    // Pass these DateTime objects to ClassCubit to apply the date filter.
                    classCubit.updateDateRange(
                      startDate: startDate,
                      endDate: endDate,
                    );
                  }
                  // If the dialog was canceled or no dates were selected, no action is needed here,
                  // as updateDateRange already triggers a data reload.
                },
              ),
              const SizedBox(height: 15),
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
                    if (displayedStudents.isEmpty) {
                      return const Center(
                        child: Text("No Students Data To Show"),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: displayedStudents.length,
                      itemBuilder: (BuildContext context, int index) {
                        final student = displayedStudents[index];
                        final bool isExpanded = _expandedCards.contains(index);

                        final String studentClassName =
                            student.className ?? "UnKonown";
                        final String studentStatus = student.inactive == 1
                            ? "Active"
                            : "InActive";
                        final String studentSection =
                            student.gradeName ?? "unKnown";

                        return Card(
                          color: Colors.grey.shade100,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 17.0,
                            vertical: 15,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.grey.shade300),
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
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 10.0,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.green,
                                        child:
                                            (student.profilePicture != null &&
                                                student
                                                    .profilePicture!
                                                    .isNotEmpty)
                                            ? ClipOval(
                                                child: Image.network(
                                                  student.profilePicture!,
                                                  fit: BoxFit.cover,
                                                  width: 50,
                                                  height: 50,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return const Icon(
                                                          Icons.person,
                                                          color: Colors.white,
                                                          size: 30,
                                                        );
                                                      },
                                                ),
                                              )
                                            : const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              student.name ??
                                                  "Student Name Not Available",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              '$studentClassName \\ $studentSection \\ $studentStatus',
                                              style: TextStyle(
                                                fontSize: 12,
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
                                        const Divider(
                                          height: 20,
                                          thickness: 1,
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
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                print(
                                                  'Update button pressed for ${student.name}',
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.deepPurple,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 10,
                                                    ),
                                              ),
                                              child: const Text('Update'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                print(
                                                  'Road Map button pressed for ${student.name}',
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.deepPurple,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 10,
                                                    ),
                                              ),
                                              child: const Text('road map'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 50,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'An error occurred: $error',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
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
          const SizedBox(height: 60),
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(width: 24, height: 24, child: Image.asset(iconPath)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
