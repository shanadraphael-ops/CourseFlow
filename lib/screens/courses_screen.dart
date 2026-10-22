import 'package:courseflow/models/assignment.dart';
import 'package:courseflow/models/course.dart';
import 'package:courseflow/repositories/assignment_repository.dart';
import 'package:courseflow/screens/assignment_change_screen.dart';
import 'package:courseflow/widgets/assignment_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoursesNavigator extends StatefulWidget {
  const CoursesNavigator({super.key});

  @override
  State<CoursesNavigator> createState() => CoursesNavigatorState();
}

class CoursesNavigatorState extends State<CoursesNavigator> {
  int _currentIndex = 0;
  int _currentCourseId = 0;
  int _selectedAssignmentId = 0;

  // Preset accent colors for course badges
  final List<Color> _badgeColors = const [
    Color(0xFF6C5CE7), // Indigo
    Color(0xFF00CEC9), // Teal
    Color(0xFFFF7675), // Coral
    Color(0xFFFDCB6E), // Amber
    Color(0xFFe84393), // Pink
    Color(0xFF0984E3), // Blue
  ];

  Color _getCourseColor(int index) {
    return _badgeColors[index % _badgeColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<AssignmentRepository>();
    final courses = repo.courses;
    final assignments = repo.assignments;

    final currentCourse = courses.firstWhere(
      (c) => c.id == _currentCourseId,
      orElse: () => Course(id: 0, name: 'Assignments'),
    );

    final filteredAssignments = assignments
        .where((a) => a.courseId == _currentCourseId)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            // INDEX 0: COURSES DASHBOARD
            _buildCoursesDashboard(courses, assignments),

            // INDEX 1: ASSIGNMENTS FOR SELECTED COURSE
            _buildCourseAssignmentsView(currentCourse, filteredAssignments),

            // INDEX 2: EDIT ASSIGNMENT SCREEN
            _buildEditScreenWrapper(repo),
          ],
        ),
      ),
    );
  }

  // --- VIEW 0: COURSES DASHBOARD ---
  Widget _buildCoursesDashboard(List<Course> courses, List<Assignment> assignments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Banner Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Enrolled Courses',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${courses.length} Active Courses  •  ${assignments.length} Total Assignments',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF636E72),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Course List
        Expanded(
          child: courses.isEmpty
              ? _buildEmptyState('No courses enrolled yet.', Icons.school_outlined)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    final courseAssignments = assignments
                        .where((a) => a.courseId == course.id)
                        .toList();
                    final color = _getCourseColor(index);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            setState(() {
                              _currentCourseId = course.id;
                              _currentIndex = 1;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Left Icon Badge
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      course.name.isNotEmpty ? course.name[0].toUpperCase() : 'C',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Course Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF2D3436),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${courseAssignments.length} Assignments',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Chevron Indicator
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.grey.shade400,
                                  size: 28,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // --- VIEW 1: ASSIGNMENTS LIST FOR COURSE ---
  Widget _buildCourseAssignmentsView(Course course, List<Assignment> assignments) {
    return Column(
      children: [
        // Custom Back Bar & Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${assignments.length} Total Tasks',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Assignment List Body
        Expanded(
          child: assignments.isEmpty
              ? _buildEmptyState('No assignments found for this course.', Icons.assignment_turned_in_outlined)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: assignments.length,
                  itemBuilder: (context, index) {
                    final assignment = assignments[index];
                    return AssignmentWidget(
                      assignment: assignment,
                      onPress: (selectedId) {
                        setState(() {
                          _selectedAssignmentId = selectedId;
                          _currentIndex = 2;
                        });
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  // --- VIEW 2: EDIT SCREEN WRAPPER ---
  Widget _buildEditScreenWrapper(AssignmentRepository repo) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
              const Text(
                'Edit Assignment Parameters',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: AssignmentChangeScreen(
            id: _selectedAssignmentId,
            visibility: true,
            onPress: (id, diff, pr, estTime) {
              repo.changeAssignment(id, diff, pr, estTime, 0);
              setState(() {
                _currentIndex = 1;
              });
            },
          ),
        ),
      ],
    );
  }

  // Helper Widget for Empty States
  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: Colors.deepPurple),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}