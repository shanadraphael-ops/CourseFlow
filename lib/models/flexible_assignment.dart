import 'submission.dart';

class FlexibleAssignment {
  final int id;
  String? name;
  final DateTime? dueAt;
  final int? courseId;
  Submission submission;
  int estimatedCompletionTime = 0;
  int difficulty = 0;
  int priority = 0;
  int completionTime = 0;

  static const sub = Submission(workflowState: "", late: false);

  FlexibleAssignment({
    required this.id, 
    this.name = "", 
    this.dueAt, 
    this.courseId = 0, 
    this.submission = sub, 
    this.estimatedCompletionTime = 0, 
    this.difficulty = 0, 
    this.priority = 0,
    this.completionTime = 0
  });


  bool get submitted =>
  (submission.workflowState == 'submitted' || submission.workflowState == 'graded' || submission.workflowState == 'pending_review') ? true:false;

  bool get late =>
  submission.late == true ? true:false;

  String get completionStatus {
    if (submitted == true && !late) {return 'Submitted';}
    if (submitted == false) { return 'Not Submitted';}
    if ((dueAt ?? DateTime(9999999)).isBefore(DateTime.now()) && submitted == false) {return 'Missing';}
    return 'Submitted late';
  }

  factory FlexibleAssignment.fromJson(Map<String, dynamic> json) {
    return FlexibleAssignment(
      id: json["id"] as int,
      priority: json["priority"] as int,
      dueAt: DateTime.parse(json["due_at"]),
      difficulty: json["difficulty"] as int,
      estimatedCompletionTime: json["estimated_completion_time"]
    );
  }

  @override
  String toString() {
    return "id : $id, priority: $priority, difficulty: $difficulty, due_at: ${dueAt.toString()}, estimated_completion_time: $estimatedCompletionTime}";
  }

  FlexibleAssignment copyWith(int priority_) {
    return FlexibleAssignment(
      id: id,
      dueAt: dueAt,
      name: name,
      courseId: courseId,
      submission: submission,
      completionTime: completionTime,
      difficulty: difficulty,
      estimatedCompletionTime: estimatedCompletionTime,
      priority: priority_
    );
  }

}