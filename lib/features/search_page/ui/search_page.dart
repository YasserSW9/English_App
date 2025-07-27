import 'package:english_app/features/search_page/ui/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final Set<int> _expandedCards = {};

  final List<Map<String, dynamic>> userListData = [
    {
      'avatarColor': Colors.green,
      'icon': Icons.person,
      'name': 'تجربة دورة التطبيق',
      'details': 'Temporary \\ temp1 \\ Active',
    },
    {
      'avatarColor': Colors.green,
      'icon': Icons.person,
      'name': 'tessst',
      'details': 'Temporary \\ temp1 \\ Active',
    },
    {
      'avatarColor': Colors.green,
      'icon': Icons.person,
      'name': 'Raed Al-Noaimi',
      'details': 'Temporary \\ temp1 \\ Active',
    },
    {
      'avatarColor': Colors.green,
      'icon': Icons.person,
      'name': 'Test_student',
      'details': 'Temporary \\ temp1 \\ Active',
    },
    {
      'avatarColor': Colors.green,
      'icon': Icons.person,
      'name': 'Mousllam Al-sbie',
      'details': 'grade 7 \\ sec 1 \\ Active',
    },
  ];

  List<Map<String, dynamic>> _filteredUserList = [];

  @override
  void initState() {
    super.initState();

    _filteredUserList = List.from(userListData);
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUserList = List.from(userListData);
      } else {
        _filteredUserList = userListData.where((user) {
          final String name = user['name'].toLowerCase();

          final String lowerCaseQuery = query.toLowerCase();
          return name.contains(lowerCaseQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Column(
            children: [
              Container(
                color: Colors.deepPurple,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 40.0, bottom: 10.0),
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
                            value: 'All',
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            items: const <String>['All', 'Class 1', 'Class 2']
                                .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text('Class $value'),
                                    ),
                                  );
                                })
                                .toList(),
                            onChanged: (String? newValue) {},
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
                            value: 'All',
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            items:
                                const <String>[
                                  'All',
                                  'Grade 7',
                                  'Grade 8',
                                  'Grade 9',
                                  'Grade 10',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text('Grade $value'),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {},
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              SearchBarWidget(
                onChanged: _performSearch,
                hintText: 'Search',
                onFilterPressed: () {
                  //! Todo filtering
                },
              ),
              const SizedBox(height: 15),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _filteredUserList.length,
              itemBuilder: (BuildContext context, int index) {
                final userData = _filteredUserList[index];
                final bool isExpanded = _expandedCards.contains(index);

                return Card(
                  color: Colors.grey.shade100,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
                        vertical: 8.0,
                        horizontal: 10.0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: userData['avatarImage'] == null
                                    ? (userData['avatarColor'] ?? Colors.grey)
                                    : Colors.transparent,
                                child: userData['avatarImage'] != null
                                    ? ClipOval(
                                        child: Image.asset(
                                          userData['avatarImage']!,
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                        ),
                                      )
                                    : (userData['icon'] != null
                                          ? Icon(
                                              userData['icon'],
                                              color: Colors.white,
                                              size: 30,
                                            )
                                          : null),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userData['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      userData['details'],
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Image.asset(
                                          "assets/images/studentScore.png",
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                        child: Text(
                                          'Score',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        '2',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Image.asset(
                                          "assets/images/golden.png",
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                        child: Text(
                                          'Golden cards',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        '1',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Image.asset(
                                          "assets/images/silver.png",
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                        child: Text(
                                          'Silver cards',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        '1',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Image.asset(
                                          "assets/images/bronze.png",
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                        child: Text(
                                          'Bronze cards',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        '1',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Image.asset(
                                          "assets/images/borrowBook.png",
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                        child: Text(
                                          'Limit borrow books',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        '10',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Image.asset(
                                          "assets/images/finishedStudentStories.png",
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                        child: Text(
                                          'Finished stories',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        '99',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Image.asset(
                                          "assets/images/studentLevel.png",
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                        child: Text(
                                          'Finished Levels',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        '18',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 30,
                                          vertical: 10,
                                        ),
                                      ),
                                      child: const Text('Update'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
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
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: const Icon(Icons.download, color: Colors.white),
      ),
    );
  }
}
