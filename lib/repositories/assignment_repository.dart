import 'package:courseflow/models/assignment.dart';
import 'package:courseflow/models/course.dart';
import 'package:courseflow/utilities/assignment_time_algorithm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AssignmentRepository extends ChangeNotifier{
  // 🌟 Local cache holding the active assignments state in memory
  List<Assignment> _assignments = [Assignment(
    id: 3001,
    name: 'Calculus Problem Set 4',
    courseId: 201,
    dueAt: DateTime.now().add(const Duration(days: 0)),
    estimatedCompletionTime: 120, // 2.0 hrs
    difficulty: 4,
    priority: 5,
  ),
  Assignment(
    id: 3002,
    name: 'Physics Lab 3 Pre-Lab Report',
    courseId: 150,
    dueAt: DateTime.now().add(const Duration(days: 0)),
    estimatedCompletionTime: 60, // 1.0 hr
    difficulty: 3,
    priority: 4,
  ),
  Assignment(
    id: 3003,
    name: 'Psychology Ch. 4 Reading Quiz',
    courseId: 120,
    dueAt: DateTime.now().add(const Duration(days: 0)),
    estimatedCompletionTime: 60, // 1.0 hr
    difficulty: 2,
    priority: 3,
  ),
  Assignment(
    id: 3004,
    name: 'CS 101 Code Review & Formatting',
    courseId: 101,
    dueAt: DateTime.now().add(const Duration(days: 0)),
    estimatedCompletionTime: 60, // 1.0 hr
    difficulty: 3,
    priority: 4,
  ),

  // --- DUE DAY 1 (TOMORROW) ---
  Assignment(
    id: 3005,
    name: 'CS 101 Binary Search Tree Project',
    courseId: 101,
    dueAt: DateTime.now().add(const Duration(days: 1)),
    estimatedCompletionTime: 180, // 3.0 hrs
    difficulty: 5,
    priority: 5,
  ),
  Assignment(
    id: 3006,
    name: 'History Short Analysis Essay',
    courseId: 110,
    dueAt: DateTime.now().add(const Duration(days: 1)),
    estimatedCompletionTime: 90, // 1.5 hrs
    difficulty: 3,
    priority: 4,
  ),
  Assignment(
    id: 3007,
    name: 'Literature Response Journal',
    courseId: 102,
    dueAt: DateTime.now().add(const Duration(days: 1)),
    estimatedCompletionTime: 45, // 0.75 hr
    difficulty: 2,
    priority: 2,
  ),

  // --- DUE DAY 2 ---
  Assignment(
    id: 3008,
    name: 'Calculus Midterm Review Sheet',
    courseId: 201,
    dueAt: DateTime.now().add(const Duration(days: 2)),
    estimatedCompletionTime: 150, // 2.5 hrs
    difficulty: 5,
    priority: 5,
  ),
  Assignment(
    id: 3009,
    name: 'Physics Momentum & Energy HW',
    courseId: 150,
    dueAt: DateTime.now().add(const Duration(days: 2)),
    estimatedCompletionTime: 90, // 1.5 hrs
    difficulty: 4,
    priority: 4,
  ),
  Assignment(
    id: 3010,
    name: 'Psychology Discussion Board Post',
    courseId: 120,
    dueAt: DateTime.now().add(const Duration(days: 2)),
    estimatedCompletionTime: 60, // 1.0 hr
    difficulty: 2,
    priority: 3,
  ),

  // --- DUE DAY 3 ---
  Assignment(
    id: 3011,
    name: 'Literature Thesis & Outline Draft',
    courseId: 102,
    dueAt: DateTime.now().add(const Duration(days: 3)),
    estimatedCompletionTime: 120, // 2.0 hrs
    difficulty: 4,
    priority: 4,
  ),
  Assignment(
    id: 3012,
    name: 'CS 101 Recursion Homework',
    courseId: 101,
    dueAt: DateTime.now().add(const Duration(days: 3)),
    estimatedCompletionTime: 90, // 1.5 hrs
    difficulty: 3,
    priority: 3,
  ),
  Assignment(
    id: 3013,
    name: 'History Primary Source Reading',
    courseId: 110,
    dueAt: DateTime.now().add(const Duration(days: 3)),
    estimatedCompletionTime: 60, // 1.0 hr
    difficulty: 2,
    priority: 2,
  ),
  Assignment(
    id: 3014,
    name: 'Calculus Quiz 4 Prep',
    courseId: 201,
    dueAt: DateTime.now().add(const Duration(days: 3)),
    estimatedCompletionTime: 45, // 0.75 hr
    difficulty: 3,
    priority: 4,
  ),

  // --- DUE DAY 4 ---
  Assignment(
    id: 3015,
    name: 'Physics Optics Lab Report',
    courseId: 150,
    dueAt: DateTime.now().add(const Duration(days: 4)),
    estimatedCompletionTime: 150, // 2.5 hrs
    difficulty: 4,
    priority: 4,
  ),
  Assignment(
    id: 3016,
    name: 'Psychology Experiment Reflection',
    courseId: 120,
    dueAt: DateTime.now().add(const Duration(days: 4)),
    estimatedCompletionTime: 90, // 1.5 hrs
    difficulty: 3,
    priority: 3,
  ),
  Assignment(
    id: 3017,
    name: 'Literature Poetry Analysis Essay',
    courseId: 102,
    dueAt: DateTime.now().add(const Duration(days: 4)),
    estimatedCompletionTime: 60, // 1.0 hr
    difficulty: 2,
    priority: 2,
  ),

  // --- DUE DAY 5 (SATURDAY) ---
  Assignment(
    id: 3018,
    name: 'CS 101 Hash Maps Implementation',
    courseId: 101,
    dueAt: DateTime.now().add(const Duration(days: 5)),
    estimatedCompletionTime: 150, // 2.5 hrs
    difficulty: 4,
    priority: 5,
  ),
  Assignment(
    id: 3019,
    name: 'History Midterm Essay Outline',
    courseId: 110,
    dueAt: DateTime.now().add(const Duration(days: 5)),
    estimatedCompletionTime: 90, // 1.5 hrs
    difficulty: 3,
    priority: 3,
  ),

  // --- DUE DAY 6 (SUNDAY) ---
  Assignment(
    id: 3020,
    name: 'Physics Problem Set 5',
    courseId: 150,
    dueAt: DateTime.now().add(const Duration(days: 6)),
    estimatedCompletionTime: 120, // 2.0 hrs
    difficulty: 4,
    priority: 4,
  ),
  Assignment(
    id: 3021,
    name: 'Psychology Final Paper Outline',
    courseId: 120,
    dueAt: DateTime.now().add(const Duration(days: 6)),
    estimatedCompletionTime: 120, // 2.0 hrs
    difficulty: 3,
    priority: 4,
  ),
  ];
  List<Course> _courses = [Course(id: 101, name: 'CS 101 - Data Structures'),
  Course(id: 201, name: 'MATH 201 - Calculus II'),
  Course(id: 150, name: 'PHYS 150 - University Physics'),
  Course(id: 102, name: 'ENG 102 - Literature & Comp'),
  Course(id: 110, name: 'HIST 110 - World History'),
  Course(id: 120, name: 'PSYCH 101 - General Psychology'),];

  // 🌟 Personal Canvas token and URL, passed in with --dart-define-from-file=canvas_secrets.json
  static const String canvasToken = String.fromEnvironment('CANVAS_TOKEN');
  static const String canvasUrl = String.fromEnvironment('CANVAS_URL');
  static const String userAgent = 'CourseFlow/0.1 (student project)';

  // 🌟 Loading and error state for the Canvas fetch
  bool _isLoading = false;
  String? _loadError;

  // 🌟 With a real token, start empty so sample data never looks like real data
  AssignmentRepository() {
    if (!isDemoMode) {
      _assignments = [];
      _courses = [];
    }
  }

  // 🌟 Getter to access the cached assignments across files
  List<Assignment> get assignments => _assignments;
  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get loadError => _loadError;

  // 🌟 Without a token or URL the app runs in demo mode with the sample data above
  bool get isDemoMode => canvasToken.isEmpty || canvasUrl.isEmpty;

  // 🌟 Fetches and stores the assignments in memory, then alerts the app
  Future<List<Assignment>> fetchAndLoadAssignments() async {
    if (isDemoMode) return _assignments;

    _isLoading = true;
    _loadError = null;
    notifyListeners();

    try {
      final Uri url = Uri.parse('$canvasUrl/api/v1/courses?enrollment_state=active');

      _courses = (await getAllPages(url, canvasToken.trim(), 'Courses'))
        .map((json) => Course.fromJson(json))
        .toList();

      final List<dynamic> data = await getAssignmentData(
        _courses,
        canvasToken.trim(),
        canvasUrl
      );

      _assignments = data
        .map((item) => Assignment.fromJson(item as Map<String, dynamic>))
        .toList();
    } catch (e) {
      // 🌟 Keep the reason for the Home screen and drop any half-loaded data
      _loadError = e.toString();
      _courses = [];
      _assignments = [];
    } finally {
      _isLoading = false;
      // 🌟 Notify all listening pages to update their UI
      notifyListeners();
    }

    return _assignments;
  }


  void changeAssignment(int id, int difficulty, int priority, int estComp, int compTime) {
    if (_assignments.isEmpty) return;

    final index = _assignments.indexWhere((e) => e.id == id);
    if (index == -1) return;
    
    Map estTimeMap = AssignmentTimeAlgorithm.estimateAssignmentTime(_assignments);
    _assignments = assignments.map(
      (e) {
        int found = 0;
        // The typed estimate belongs to the edited assignment only
        int completionTime = e.id == id ? estComp : 0;
        estTimeMap.forEach((key, value) {
          if (
            (key[0]) == e.courseId &&
            (key[1]) == e.difficulty
          ) {
            found = value;
          }
        });
        if (
          found != 0
        ) {
          completionTime = found;
        }
        
        return e.copyWith(completionTime, 0, 0, 0);
      }
    ).toList();

    _assignments[index] = _assignments[index].copyWith(
      0, priority, difficulty, compTime
    );

    notifyListeners();
  }


  static Future<String> getMockAssignmentData() async {
    return await rootBundle.loadString('assets/mock_data/assignments.json');
  }


  static Future<List<dynamic>> getAssignmentData(List<Course> courses, String token, String domain) async {
    List<dynamic> assignments_ = [];

    for (int i = 0; i < courses.length; i++)
    {
      final Uri assignmentUri = Uri.parse('$domain/api/v1/courses/${courses[i].id}/assignments?include=submission');
      assignments_.addAll(await getAllPages(assignmentUri, token, 'Assignments'));
    }

    return assignments_;
  }


  // 🌟 Canvas sends results in pages; ask for 100 per page and follow each "next" link
  static Future<List<dynamic>> getAllPages(Uri firstPage, String token, String label) async {
    List<dynamic> items = [];
    Uri? pageUri = firstPage.replace(
      queryParameters: {...firstPage.queryParameters, 'per_page': '100'}
    );

    while (pageUri != null) {
      final response = await http.get(
        pageUri,
        headers: {
          'authorization': 'Bearer $token',
          'accept': 'application/json',
          'user-agent': userAgent
        }
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw 'Failed to load $label ${response.statusCode}';
      }

      items.addAll(jsonDecode(response.body) as List);

      // Link header looks like: <https://...&page=2>; rel="next", <https://...>; rel="last"
      final nextLink = RegExp(r'<([^>]+)>;\s*rel="next"').firstMatch(response.headers['link'] ?? '');
      pageUri = nextLink == null ? null : Uri.parse(nextLink.group(1)!);
    }

    return items;
  }
}