import 'package:courseflow/models/assignment.dart';
import 'package:courseflow/models/submission.dart';
import 'package:flutter_test/flutter_test.dart';

Assignment makeAssignment({required int dueInDays, Submission? submission}) {
  return Assignment(
    id: 1,
    name: 'Essay',
    courseId: 101,
    dueAt: DateTime.now().add(Duration(days: dueInDays)),
    submission: submission,
  );
}

void main() {
  group('completionStatus', () {
    test('handed in on time shows Submitted', () {
      final a = makeAssignment(dueInDays: -1, submission: const Submission(workflowState: 'graded', late: false));
      expect(a.completionStatus, 'Submitted');
    });

    test('handed in late shows Submitted late', () {
      final a = makeAssignment(dueInDays: -1, submission: const Submission(workflowState: 'submitted', late: true));
      expect(a.completionStatus, 'Submitted late');
    });

    test('not handed in and not yet due shows Not Submitted', () {
      final a = makeAssignment(dueInDays: 2);
      expect(a.completionStatus, 'Not Submitted');
    });

    test('not handed in and overdue shows Missing', () {
      final a = makeAssignment(dueInDays: -2);
      expect(a.completionStatus, 'Missing');
    });
  });

  test('copyWith keeps current values when given 0', () {
    final a = Assignment(id: 1, name: 'Essay', courseId: 101, difficulty: 3, priority: 4, estimatedCompletionTime: 60);
    final b = a.copyWith(0, 5, 0, 45);
    expect(b.difficulty, 3);
    expect(b.priority, 5);
    expect(b.estimatedCompletionTime, 60);
    expect(b.completionTime, 45);
  });
}
