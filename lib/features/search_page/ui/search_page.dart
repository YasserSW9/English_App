// lib/features/search_page/ui/search_page.dart
import 'package:english_app/features/search_page/data/models/class_response.dart';
import 'package:english_app/features/search_page/logic/class_cubit.dart';
import 'package:english_app/features/search_page/logic/class_state.dart';
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

  // These should reflect the state of the Cubit, not manage their own state for filters
  // String _selectedClassFilter = 'All'; // No longer needed here
  // String _selectedGradeFilter = 'All'; // No longer needed here

  // No longer needed as options come directly from Cubit
  // List<String> _currentClassOptions = ['All'];

  @override
  void initState() {
    super.initState();
    // Fetch initial data and then Cubit will set its internal filters and unique names
    context.read<ClassCubit>().emitGetClassesLoaded();
  }

  // This method will now primarily trigger a UI rebuild and ensure Cubit's state is consistent
  void _updateFiltersAndDropdowns() {
    final ClassCubit classCubit = context.read<ClassCubit>();

    // This ensures the cubit's internal selectedClassFilter and selectedGradeFilter are in sync with UI
    // And also recalculates uniqueClassNames based on the grade filter
    classCubit.applyFilters(
      selectedClass:
          classCubit.selectedClassFilter, // Use cubit's current value
      selectedGrade:
          classCubit.selectedGradeFilter, // Use cubit's current value
    );
    // No need for setState here, as BlocConsumer will rebuild when state changes in cubit
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
                          child: BlocBuilder<ClassCubit, ClassState<List<Students>>>(
                            builder: (context, state) {
                              return DropdownButton<String>(
                                isExpanded: true,
                                // Use the value from the cubit's state
                                value: classCubit.selectedClassFilter,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                                // Use the uniqueClassNames from the cubit
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
                                    // Update the cubit's class filter and trigger a rebuild
                                    classCubit.applyFilters(
                                      selectedClass: newValue,
                                      selectedGrade: classCubit
                                          .selectedGradeFilter, // Keep the current grade filter
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
                          child: BlocBuilder<ClassCubit, ClassState<List<Students>>>(
                            builder: (context, state) {
                              return DropdownButton<String>(
                                isExpanded: true,
                                // Use the value from the cubit's state
                                value: classCubit.selectedGradeFilter,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                                // Use the uniqueGradeNames from the cubit (these are static once loaded)
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
                                    // Update the cubit's grade filter, this will also reset class filter to 'All'
                                    // and recalculate available class names.
                                    classCubit.applyFilters(
                                      selectedClass:
                                          'All', // Reset class filter to 'All' when grade changes
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
                onFilterPressed: () {
                  // This button might not be strictly necessary if filters apply on dropdown change
                  // but it's good to keep if there are other filter triggers
                  classCubit.applyFilters(
                    selectedClass: classCubit.selectedClassFilter,
                    selectedGrade: classCubit.selectedGradeFilter,
                  );
                },
              ),
              const SizedBox(height: 15),
            ],
          ),

          // Bottom section: display student list using BlocConsumer
          Expanded(
            child: BlocConsumer<ClassCubit, ClassState<List<Students>>>(
              listener: (context, state) {
                // You can add listening logic here, such as displaying error messages or alerts
              },
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

                        // Ensure no null values for names and statuses for display
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
                                        backgroundColor:
                                            Colors.green, // Default background
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
                                                        // In case of image load failure, show person icon
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
