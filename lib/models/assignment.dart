import 'package:courseflow/models/submission.dart';

class Assignment {
  final int id;
  String name;
  final DateTime? dueAt;
  final int courseId;
  final Submission? submission;
  int estimatedCompletionTime = 0;
  int difficulty = 0;
  int priority = 0;
  int completionTime = 0;

  Assignment({
    required this.id, 
    required this.name, 
    this.dueAt, 
    required this.courseId, 
    this.submission, 
    this.estimatedCompletionTime = 0, 
    this.difficulty = 0, 
    this.priority = 0,
    this.completionTime = 0
  });

  bool get submitted =>
  (submission?.workflowState == 'submitted' || submission?.workflowState == 'graded' || submission?.workflowState == 'pending_review') ? true:false;

  bool get late =>
  submission?.late == true ? true:false;

  String get completionStatus {
    if (submitted == true && !late) {return 'Submitted';}
    if ((dueAt ?? DateTime(9999999)).isBefore(DateTime.now()) && submitted == false) {return 'Missing';}
    if (submitted == false) { return 'Not Submitted';}
    return 'Submitted late';
  }

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as int,
      name: json['name'] as String,
      dueAt: json['due_at'] != null
        ? DateTime.parse(json['due_at'])
        : null,
      courseId: json['course_id'] as int,
      submission: (json['submission'] != null) ? Submission(
        workflowState: json['submission']['workflow_state'] as String, late: json['submission']['late'] as bool
      ) : null,
      estimatedCompletionTime: 0,
      priority: 0,
      difficulty: 0,
      completionTime: 0
    );
  }

  @override
  String toString() {
    return 'Assignment(id: $id, name: $name, dueAt: $dueAt, courseId: $courseId, submitted: $submitted, late: $late, estimatedCompletionTime: $estimatedCompletionTime, priority: $priority, difficulty: $difficulty, completionTime: $completionTime)';
  }

  Assignment copyWith(int estTime, int priorit, int difficult, int completionTim) {
    return Assignment(
      id: id,
      name: name,
      dueAt: dueAt,
      courseId: courseId,
      submission: submission,
      difficulty: difficult == 0 ? difficulty: difficult,
      priority: priorit == 0 ? priority: priorit,
      estimatedCompletionTime: estTime == 0 ? estimatedCompletionTime: estTime,
      completionTime: completionTim == 0 ? completionTime : completionTim
    );
  }
}