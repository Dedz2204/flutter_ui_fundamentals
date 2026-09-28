import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// LOAD JSON
Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );

  return jsonDecode(jsonString) as Map<String, dynamic>;
}

// MAIN
void main() {
  runApp(const MyApp());
}

// MY APP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning Dashboard',

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        fontFamily: 'Arial',
      ),

      home: const DashboardPage(),
    );
  }
}

// DASHBOARD
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,

        titleSpacing: 16,

        title: Row(
          children: [
            // ICON BUKU
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEBFF),
                borderRadius: BorderRadius.circular(14),
              ),

              child: const Icon(
                Icons.menu_book_rounded,
                color: Color(0xFF4F46E5),
                size: 27,
              ),
            ),

            const SizedBox(width: 12),

            const Text(
              'Learning Dashboard',
              style: TextStyle(
                color: Color(0xFF172033),
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                studentFuture = loadStudentData();
              });
            },

            icon: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFF374151),
              size: 28,
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),

      // BODY
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: studentFuture,

          builder: (context, snapshot) {
            // LOADING
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // ERROR
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Gagal memuat data:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text('Data tidak tersedia'),
              );
            }

            final data = snapshot.data!;

            final student =
                data['student']
                    as Map<String, dynamic>;

            final courses =
                data['courses'] as List<dynamic>;

            final completed = courses
                .where(
                  (course) =>
                      course['status'] == 'done',
                )
                .length;

            final totalCredits = courses.fold<int>(
              0,
              (total, course) =>
                  total + (course['credits'] as int),
            );

            // SCROLL VIEW
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                16,
                18,
                16,
                30,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // PROFILE CARD
                  ProfileCard(
                    name: student['name'] as String,
                    nim: student['nim'] as String,
                    semester: student['semester'] as int,
                  ),

                  SummarySection(
                    totalCourses: courses.length,
                    totalCredits: totalCredits,
                    completed: completed,
                  ),

                  const SizedBox(height: 22),

                  // TITLE DAFTAR MATA KULIAH
                  Row(
                    children: [
                      const Text(
                        'Daftar Mata Kuliah',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                          color: Color(0xFF172033),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFFE8E9FF,
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),

                        child: Text(
                          '${courses.length}',
                          style: const TextStyle(
                            color:
                                Color(0xFF4F46E5),
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // COURSE LIST
                  ...courses.map(
                    (course) {
                      final item =
                          course
                              as Map<String, dynamic>;

                      return CourseCard(
                        title:
                            item['title'] as String,

                        code:
                            item['code'] as String,

                        credits:
                            item['credits'] as int,

                        status:
                            item['status'] as String,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// PROFILE CARD
class ProfileCard extends StatelessWidget {
  final String name;
  final String nim;
  final int semester;

  const ProfileCard({
    super.key,
    required this.name,
    required this.nim,
    required this.semester,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [

          // FOTO
          Container(
            width: 82,
            height: 82,

            padding: const EdgeInsets.all(3),

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              border: Border.all(
                color: const Color(0xFF4F46E5),
                width: 3,
              ),
            ),

            child: const CircleAvatar(
              radius: 38,

              backgroundImage: AssetImage(
                'assets/images/profile.jpg',
              ),
            ),
          ),

          const SizedBox(width: 18),

          // IDENTITAS
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  name,

                  maxLines: 2,

                  overflow:
                      TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Color(0xFF172033),
                  ),
                ),

                const SizedBox(height: 10),

                // BADGE NIM + SEMESTER
                Wrap(
                  spacing: 8,
                  runSpacing: 8,

                  children: [

                    // NIM BADGE
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            const Color(0xFFF0F4F8),

                        borderRadius:
                            BorderRadius.circular(
                          9,
                        ),
                      ),

                      child: Text(
                        'NIM: $nim',
                        style:
                            const TextStyle(
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w600,
                          color:
                              Color(0xFF374151),
                        ),
                      ),
                    ),

                    // SEMESTER BADGE
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            const Color(0xFFEDEBFF),

                        borderRadius:
                            BorderRadius.circular(
                          9,
                        ),
                      ),

                      child: Text(
                        'Semester $semester',
                        style:
                            const TextStyle(
                          fontSize: 13,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(0xFF4F46E5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// SUMMARY SECTION
class SummarySection extends StatelessWidget {
  final int totalCourses;
  final int totalCredits;
  final int completed;

  const SummarySection({
    super.key,
    required this.totalCourses,
    required this.totalCredits,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Expanded(
          child: SummaryCard(
            icon:
                Icons.menu_book_rounded,

            value:
                '$totalCourses',

            label:
                'Mata Kuliah',

            iconColor:
                const Color(0xFF4F46E5),

            backgroundColor:
                const Color(0xFFEDEBFF),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: SummaryCard(
            icon:
                Icons.school_rounded,

            value:
                '$totalCredits',

            label:
                'Total SKS',

            iconColor:
                const Color(0xFF059669),

            backgroundColor:
                const Color(0xFFDDF8EE),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: SummaryCard(
            icon:
                Icons.check_circle_rounded,

            value:
                '$completed',

            label:
                'Selesai',

            iconColor:
                const Color(0xFF16A34A),

            backgroundColor:
                const Color(0xFFDCFCE7),
          ),
        ),
      ],
    );
  }
}

// SUMMARY CARD
class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;
  final Color backgroundColor;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.06),

            blurRadius: 8,

            offset:
                const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Container(
            width: 46,
            height: 46,

            decoration:
                BoxDecoration(
              color:
                  backgroundColor,

              borderRadius:
                  BorderRadius.circular(14),
            ),

            child: Icon(
              icon,
              color:
                  iconColor,
              size: 25,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            value,

            style: const TextStyle(
              fontSize: 21,
              fontWeight:
                  FontWeight.bold,
              color:
                  Color(0xFF172033),
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,

            textAlign:
                TextAlign.center,

            style: const TextStyle(
              fontSize: 12,
              color:
                  Color(0xFF596273),
            ),
          ),
        ],
      ),
    );
  }
}

// COURSE CARD
class CourseCard extends StatelessWidget {
  final String title;
  final String code;
  final int credits;
  final String status;

  const CourseCard({
    super.key,
    required this.title,
    required this.code,
    required this.credits,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {

    // STATUS STYLE
    late IconData icon;
    late Color iconColor;
    late Color iconBackground;
    late Color statusColor;
    late Color statusBackground;
    late String statusText;

    if (status == 'done') {

      // HIJAU - SELESAI
      icon =
          Icons.check_circle_rounded;

      iconColor =
          const Color(0xFF16A34A);

      iconBackground =
          const Color(0xFFDCFCE7);

      statusColor =
          const Color(0xFF16A34A);

      statusBackground =
          const Color(0xFFDCFCE7);

      statusText =
          'Selesai';

    } else if (status == 'active') {

      // BIRU - BERJALAN
      icon =
          Icons.play_circle_fill_rounded;

      iconColor =
          const Color(0xFF4F46E5);

      iconBackground =
          const Color(0xFFEDEBFF);

      statusColor =
          const Color(0xFF4F46E5);

      statusBackground =
          const Color(0xFFEDEBFF);

      statusText =
          'Berjalan';

    } else {

      // KUNING - DIRENCANAKAN
      icon =
          Icons.schedule_rounded;

      iconColor =
          const Color(0xFFD97706);

      iconBackground =
          const Color(0xFFFEF3C7);

      statusColor =
          const Color(0xFFD97706);

      statusBackground =
          const Color(0xFFFEF3C7);

      statusText =
          'Direncanakan';
    }

    // COURSE CARD
    return Container(
      width: double.infinity,

      margin:
          const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.07),

            blurRadius: 8,

            offset:
                const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [

          // STATUS ICON
          Container(
            width: 52,
            height: 52,

            decoration:
                BoxDecoration(
              color:
                  iconBackground,

              borderRadius:
                  BorderRadius.circular(15),
            ),

            child: Icon(
              icon,
              color:
                  iconColor,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          // COURSE INFORMATION
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  maxLines: 1,

                  overflow:
                      TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Color(0xFF172033),
                  ),
                ),

                const SizedBox(height: 7),

                Row(
                  children: [

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            const Color(
                          0xFFF1F3F6,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          6,
                        ),
                      ),

                      child: Text(
                        code,

                        style:
                            const TextStyle(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
                          color:
                              Color(0xFF596273),
                        ),
                      ),
                    ),

                    const SizedBox(width: 7),

                    Text(
                      '• $credits SKS',

                      style:
                          const TextStyle(
                        fontSize: 12,
                        color:
                            Color(0xFF596273),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // STATUS BADGE
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),

            decoration:
                BoxDecoration(
              color:
                  statusBackground,

              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: Text(
              statusText,

              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.bold,
                color:
                    statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}