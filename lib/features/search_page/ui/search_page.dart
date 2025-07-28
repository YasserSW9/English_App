// lib/features/search_page/ui/search_page.dart
import 'package:english_app/features/search_page/data/models/class_response.dart';
import 'package:english_app/features/search_page/logic/class_cubit.dart';
import 'package:english_app/features/search_page/logic/class_state.dart';
import 'package:english_app/features/search_page/ui/widgets/search_bar_widget.dart'; // تأكد من وجود هذا الويجت
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final Set<int> _expandedCards = {};

  String _selectedClassFilter = 'All';
  String _selectedGradeFilter = 'All';

  List<String> _currentClassOptions = ['All'];

  @override
  void initState() {
    super.initState();

    final ClassCubit classCubit = context.read<ClassCubit>();

    classCubit.emitGetClassesLoaded().then((_) {
      _updateClassDropdownOptions();
    });
  }

  void _updateClassDropdownOptions() {
    setState(() {
      if (_selectedGradeFilter == 'Temporary') {
        _currentClassOptions = ['temp1'];
        _selectedClassFilter = 'temp1';
      } else if (_selectedGradeFilter == 'All') {
        _currentClassOptions = ['All'];
        _selectedClassFilter = 'All';
      } else if (_selectedGradeFilter == 'Grade 7') {
        _currentClassOptions = ['sec1', 'sec2', 'sec3', 'sec4'];
      } else if (_selectedGradeFilter == 'Grade 8') {
        _currentClassOptions = ['sec1', 'sec2', 'sec3', 'sec4'];
      } else if (_selectedGradeFilter == 'Grade 9') {
        _currentClassOptions = ['sec1', 'sec2', 'sec3', 'sec4'];
      } else if (_selectedGradeFilter == 'Grade 10') {
        _currentClassOptions = ['sec1'];

        if (!_currentClassOptions.contains(_selectedClassFilter)) {
          _selectedClassFilter = _currentClassOptions.first;
        }
      } else {
        _currentClassOptions = ['All', 'temp1', "sec1", "sec2", "sec3", "sec4"];

        if (!_currentClassOptions.contains(_selectedClassFilter)) {
          _selectedClassFilter = 'All';
        }
      }
    });
    // بعد تحديث الـ UI (القوائم المنسدلة)، قم بتطبيق الفلاتر على الـ Cubit
    context.read<ClassCubit>().applyFilters(
      selectedClass: _selectedClassFilter,
      selectedGrade: _selectedGradeFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ClassCubit classCubit = context.read<ClassCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // الجزء العلوي من الصفحة: العنوان، فلاتر القوائم المنسدلة، شريط البحث
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
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedClassFilter,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            items: _currentClassOptions
                                .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(value),
                                    ),
                                  );
                                })
                                .toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedClassFilter = newValue;
                                });

                                classCubit.applyFilters(
                                  selectedClass: newValue,
                                  selectedGrade: _selectedGradeFilter,
                                );
                              }
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
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value:
                                _selectedGradeFilter, // القيمة الحالية المختارة للدرجة
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            items:
                                const <String>[
                                  'All',
                                  'Temporary',
                                  'Grade 7',
                                  'Grade 8',
                                  'Grade 9',
                                  'Grade 10',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(value),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedGradeFilter = newValue;
                                });
                                // عند تغيير الدرجة، قم بتحديث خيارات الفئة أيضاً
                                _updateClassDropdownOptions();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // شريط البحث
              SearchBarWidget(
                onChanged: (query) {
                  classCubit.searchController.text = query;
                  classCubit.performSearch(query);
                },
                hintText: 'Search',
                onFilterPressed: () {
                  classCubit.applyFilters(
                    selectedClass: _selectedClassFilter,
                    selectedGrade: _selectedGradeFilter,
                  );
                },
              ),
              const SizedBox(height: 15),
            ],
          ),

          // الجزء السفلي: عرض قائمة الطلاب باستخدام BlocConsumer
          Expanded(
            child: BlocConsumer<ClassCubit, ClassState<List<Students>>>(
              listener: (context, state) {
                // يمكنك إضافة منطق للاستماع هنا، مثل عرض رسائل خطأ أو تنبيهات
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

                        // منطق لتحديد اسم الدرجة المعروض بشكل صحيح
                        String displayedGradeName =
                            student.gradeName ?? "غير معروف";
                        // يمكنك استخدام gClassId لتعيين اسم الدرجة بشكل أكثر دقة إذا كان gradeName غير متوفر
                        // if (student.gClassId == 1) {
                        //   displayedGradeName = 'Temporary';
                        // } else if (student.gClassId == 2) {
                        //   displayedGradeName = 'Grade 7';
                        // } else if (student.gClassId == 3) {
                        //   displayedGradeName = 'Grade 8';
                        // } else if (student.gClassId == 4) {
                        //   displayedGradeName = 'Grade 9';
                        // } else if (student.gClassId == 5) {
                        //   displayedGradeName = 'Grade 10';
                        // }

                        // التأكد من عدم وجود قيم null للأسماء والحالات للعرض
                        final String studentClassName =
                            student.className ?? "UnKonown";
                        final String studentStatus = student.inactive == 1
                            ? "Active"
                            : "InActive";
                        final String studentSection = student.gradeName ??=
                            "unKnown";

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
                                            Colors.green, // خلفية افتراضية
                                        child:
                                            // تحقق صارم من أن profilePicture هو URL صالح للشبكة (http/https)
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
                                                        // في حالة فشل تحميل الصورة، عرض أيقونة شخص
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
                                  // الجزء الموسع للبطاقة (إذا كانت isExpanded صحيحة)
                                  if (isExpanded)
                                    Column(
                                      children: [
                                        const Divider(
                                          height: 20,
                                          thickness: 1,
                                          color: Colors.grey,
                                        ),
                                        // عرض تفاصيل إضافية للطالب (الدرجات، العملات، القصص المكتملة، المستويات)
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
                                        // أزرار التحديث وخريطة الطريق
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
                    // عرض رسالة الخطأ مع زر لإعادة المحاولة
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
      // زر عائم في الزاوية اليمنى السفلية
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

  // دالة مساعدة لإنشاء صفوف تفاصيل الطالب الموسعة لتقليل تكرار الكود
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
