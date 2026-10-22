import 'dart:convert';

import 'package:courseflow/models/assignment.dart';
import 'package:courseflow/repositories/assignment_repository.dart';
import 'package:courseflow/utilities/assignment_time_algorithm.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a typed estimate changes only the edited assignment', () {
    final repo = AssignmentRepository(); // no token in tests, so demo mode with sample data
    final before = {for (final a in repo.assignments) a.id: a.estimatedCompletionTime};

    repo.changeAssignment(3001, 0, 0, 45, 0);

    for (final a in repo.assignments) {
      expect(a.estimatedCompletionTime, a.id == 3001 ? 45 : before[a.id], reason: 'assignment ${a.id}');
    }
  });

  group('time learning', () {
    Assignment logged(int id, int minutes) =>
        Assignment(id: id, name: 'HW $id', courseId: 1, difficulty: 3, completionTime: minutes);

    test('3 logged times for the same course and difficulty give their average', () {
      final estimates = AssignmentTimeAlgorithm.estimateAssignmentTime([logged(1, 30), logged(2, 60), logged(3, 90)]);
      expect(estimates.values.single, 60);
    });

    test('2 logged times are not enough to predict', () {
      final estimates = AssignmentTimeAlgorithm.estimateAssignmentTime([logged(1, 30), logged(2, 60)]);
      expect(estimates.values.single, 0);
    });

    test('the 3rd logged time updates the estimates right away', () {
      final repo = AssignmentRepository(); // sample data: 3009, 3015 and 3020 share course 150, difficulty 4
      repo.changeAssignment(3009, 0, 0, 0, 60);
      repo.changeAssignment(3015, 0, 0, 0, 90);
      repo.changeAssignment(3020, 0, 0, 0, 120);

      for (final id in [3009, 3015, 3020]) {
        final a = repo.assignments.firstWhere((a) => a.id == id);
        expect(a.estimatedCompletionTime, 90, reason: 'assignment $id should use the average of 60, 90 and 120');
      }
    });
  });

  test('saved edits come back after a save and reload', () {
    final edited = [
      Assignment(id: 1, name: 'Essay', courseId: 101, difficulty: 4, priority: 5, estimatedCompletionTime: 90, completionTime: 80),
      Assignment(id: 2, name: 'Quiz', courseId: 101),
    ];
    final storedText = jsonEncode(AssignmentRepository.editsToSave(edited));

    final freshFromCanvas = [
      Assignment(id: 1, name: 'Essay', courseId: 101),
      Assignment(id: 2, name: 'Quiz', courseId: 101),
    ];
    final restored = AssignmentRepository.applySavedEdits(freshFromCanvas, jsonDecode(storedText) as Map<String, dynamic>);

    expect(restored[0].difficulty, 4);
    expect(restored[0].priority, 5);
    expect(restored[0].estimatedCompletionTime, 90);
    expect(restored[0].completionTime, 80);
    expect(restored[1].difficulty, 0, reason: 'unedited assignments stay unedited');
  });
}
