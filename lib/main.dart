import 'package:flutter/material.dart';

const String studentName = 'Putu Agus Dedy Putra Adnyana';
const String studentId = '2415051104';

void main() {
  runApp(const MyApp());
}

// =====================================================
// APP
// =====================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

// =====================================================
// MAIN PAGE / RESPONSIVE SHELL
// =====================================================

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    CoursesPage(),
    ProfilePage(),
  ];

  // NavigationBar untuk Compact dan Medium
  Widget buildNavigationBar() {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school),
          label: 'Courses',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  // NavigationRail untuk Expanded
  Widget buildNavigationRail() {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school),
          label: Text('Courses'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Profile'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // COMPACT / MEDIUM
        if (constraints.maxWidth < 840) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Course Explorer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: pages[selectedIndex],
            bottomNavigationBar: buildNavigationBar(),
          );
        }

        // EXPANDED
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Course Explorer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Row(
            children: [
              buildNavigationRail(),
              const VerticalDivider(
                width: 1,
              ),
              Expanded(
                child: pages[selectedIndex],
              ),
            ],
          ),
        );
      },
    );
  }
}

// =====================================================
// REUSABLE WIDGET 1 - STUDENT IDENTITY
// =====================================================

class StudentIdentity extends StatelessWidget {
  const StudentIdentity({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          studentName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'NIM: $studentId',
        ),
      ],
    );
  }
}

// =====================================================
// HOME PAGE
// =====================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StudentIdentity(),

          const SizedBox(height: 30),

          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.school,
                  size: 90,
                ),

                const SizedBox(height: 16),

                const Text(
                  'Course Explorer',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Jelajahi course dan materi pembelajaran.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Selamat datang di Course Explorer',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.explore),
                  label: const Text(
                    'Mulai Menjelajah',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// COURSE DATA
// =====================================================

final List<Map<String, dynamic>> courses = [
  {
    'title': 'Responsive Layout',
    'code': 'MOB04',
    'status': 'Active',
    'credits': 3,
  },
  {
    'title': 'Navigation',
    'code': 'MOB05',
    'status': 'Planned',
    'credits': 3,
  },
  {
    'title': 'Interaction',
    'code': 'MOB06',
    'status': 'Planned',
    'credits': 3,
  },
  {
    'title': 'Form Input',
    'code': 'MOB07',
    'status': 'Active',
    'credits': 3,
  },
  {
    'title': 'Feedback',
    'code': 'MOB08',
    'status': 'Planned',
    'credits': 2,
  },
  {
    'title': 'Course Explorer',
    'code': 'MOB09',
    'status': 'Active',
    'credits': 3,
  },
];

// =====================================================
// COURSES PAGE
// =====================================================

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late List<bool> isFavorite;

  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    isFavorite = List<bool>.filled(
      courses.length,
      false,
    );
  }

  // Menentukan jumlah kolom berdasarkan ukuran layar
  int columnsFor(double width) {
    if (width < 600) {
      return 1;
    }

    if (width < 840) {
      return 2;
    }

    return 3;
  }

  void openCourseDetail(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailPage(
          course: courses[index],
          isFavorite: isFavorite[index],
          onFavoriteChanged: (value) {
            setState(() {
              isFavorite[index] = value;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int columns =
            columnsFor(constraints.maxWidth);

        // Filter course berdasarkan pencarian
        final filteredCourses = courses
            .asMap()
            .entries
            .where((entry) {
          final title =
              entry.value['title'].toString().toLowerCase();

          final code =
              entry.value['code'].toString().toLowerCase();

          final query = searchQuery.toLowerCase();

          return title.contains(query) ||
              code.contains(query);
        }).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // IDENTITAS
              const StudentIdentity(),

              const SizedBox(height: 20),

              // SEARCH
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search courses...',
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                  filled: true,
                  fillColor:
                      Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Available Courses',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // COURSE LIST / GRID
              if (filteredCourses.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      'Course tidak ditemukan.',
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemCount: filteredCourses.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,

                    // Compact lebih tinggi karena
                    // menggunakan satu kolom.
                    childAspectRatio:
                        columns == 1 ? 2.8 : 1.45,
                  ),
                  itemBuilder: (context, position) {
                    final originalIndex =
                        filteredCourses[position].key;

                    final course =
                        filteredCourses[position].value;

                    return CourseCard(
                      course: course,
                      isFavorite:
                          isFavorite[originalIndex],
                      onTap: () {
                        openCourseDetail(
                          originalIndex,
                        );
                      },
                      onFavorite: () {
                        setState(() {
                          isFavorite[originalIndex] =
                              !isFavorite[originalIndex];
                        });

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              isFavorite[originalIndex]
                                  ? '${course['title']} ditambahkan ke Favorite'
                                  : '${course['title']} dihapus dari Favorite',
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

// =====================================================
// REUSABLE WIDGET 2 - COURSE CARD
// =====================================================

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const CourseCard({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.blue.shade200,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      course['title'],
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      course['code'],
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      course['status'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                tooltip: isFavorite
                    ? 'Hapus Favorite'
                    : 'Tambah Favorite',
                onPressed: onFavorite,
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// COURSE DETAIL PAGE
// =====================================================

class CourseDetailPage extends StatefulWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;
  final ValueChanged<bool> onFavoriteChanged;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  State<CourseDetailPage> createState() =>
      _CourseDetailPageState();
}

class _CourseDetailPageState
    extends State<CourseDetailPage> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();

    isFavorite = widget.isFavorite;
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    widget.onFavoriteChanged(isFavorite);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? 'Course ditambahkan ke Favorite'
              : 'Course dihapus dari Favorite',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const StudentIdentity(),

            const SizedBox(height: 30),

            Center(
              child: CircleAvatar(
                radius: 45,
                child: const Icon(
                  Icons.school,
                  size: 45,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                widget.course['title'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.code,
                    ),
                    title: const Text(
                      'Course Code',
                    ),
                    subtitle: Text(
                      widget.course['code'],
                    ),
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.credit_score,
                    ),
                    title: const Text(
                      'Credits',
                    ),
                    subtitle: Text(
                      '${widget.course['credits']} SKS',
                    ),
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.check_circle,
                    ),
                    title: const Text(
                      'Status',
                    ),
                    subtitle: Text(
                      widget.course['status'],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: toggleFavorite,
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                label: Text(
                  isFavorite
                      ? 'Favorite Aktif'
                      : 'Tambah Favorite',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// PROFILE PAGE
// =====================================================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 55,
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Center(
            child: Text(
              'Profile Mahasiswa',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          const StudentIdentity(),

          const SizedBox(height: 30),

          const Divider(),

          const SizedBox(height: 20),

          const Text(
            'Feedback Praktikum',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const FeedbackForm(),
        ],
      ),
    );
  }
}

// =====================================================
// FEEDBACK FORM
// =====================================================

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() =>
      _FeedbackFormState();
}

class _FeedbackFormState
    extends State<FeedbackForm> {
  final formKey = GlobalKey<FormState>();

  final nameController =
      TextEditingController(
    text: studentName,
  );

  final nimController =
      TextEditingController(
    text: studentId,
  );

  final commentController =
      TextEditingController();

  void submitFeedback() {
    // Validasi form
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Konfirmasi sebelum mengirim
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Konfirmasi',
          ),
          content: const Text(
            'Apakah Anda yakin ingin mengirim feedback?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Batal',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                showDialog(
                  context: this.context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const AlertDialog(
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 20),
                          Text(
                            'Menyimpan...',
                          ),
                        ],
                      ),
                    );
                  },
                );

                Future.delayed(
                  const Duration(seconds: 1),
                  () {
                    if (!mounted) return;

                    Navigator.pop(this.context);

                    ScaffoldMessenger.of(this.context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Feedback berhasil dikirim',
                        ),
                      ),
                    );

                    showDialog(
                      context: this.context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'Hasil Feedback',
                          ),
                          content: Text(
                            'Nama: ${nameController.text}\n'
                            'NIM: ${nimController.text}\n'
                            'Komentar: ${commentController.text}',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                );
                              },
                              child: const Text(
                                'Tutup',
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              child: const Text(
                'Kirim',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    nimController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nama',
              prefixIcon: Icon(
                Icons.person,
              ),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Nama wajib diisi';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: nimController,
            decoration: const InputDecoration(
              labelText: 'NIM',
              prefixIcon: Icon(
                Icons.badge,
              ),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'NIM wajib diisi';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: commentController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Komentar',
              hintText:
                  'Minimal 5 karakter',
              prefixIcon: Icon(
                Icons.comment,
              ),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Komentar wajib diisi';
              }

              if (value.trim().length < 5) {
                return 'Komentar minimal 5 karakter';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: submitFeedback,
              icon: const Icon(
                Icons.send,
              ),
              label: const Text(
                'Kirim Feedback',
              ),
            ),
          ),
        ],
      ),
    );
  }
}