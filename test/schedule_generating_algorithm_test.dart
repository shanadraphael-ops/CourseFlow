import 'package:courseflow/models/flexible_assignment.dart';
import 'package:courseflow/models/submission.dart';
import 'package:courseflow/utilities/schedule_generating_algorithm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_range_picker/time_range_picker.dart';

TimeRange hours(int start, int end) =>
    TimeRange(startTime: TimeOfDay(hour: start, minute: 0), endTime: TimeOfDay(hour: end, minute: 0));

final TimeRange noTime = hours(0, 0);

FlexibleAssignment task(int id, {int dueInDays = 1, int priority = 3, Submission submission = FlexibleAssignment.sub}) {
  return FlexibleAssignment(
    id: id,
    name: 'Task $id',
    dueAt: DateTime.now().add(Duration(days: dueInDays, hours: 1)),
    priority: priority,
    difficulty: 3,
    estimatedCompletionTime: 60,
    submission: submission,
  );
}

void main() {
  group('newPriorityGenerator', () {
    test('work due today keeps 7/8 of its priority', () {
      final dueSoon = DateTime.now().add(const Duration(hours: 1));
      expect(ScheduleGeneratingAlgorithm.newPriorityGenerator(4, dueSoon), 3.5);
    });

    test('work due sooner scores higher than work due later', () {
      final now = DateTime.now();
      final soon = ScheduleGeneratingAlgorithm.newPriorityGenerator(3, now.add(const Duration(days: 1, hours: 1)));
      final later = ScheduleGeneratingAlgorithm.newPriorityGenerator(3, now.add(const Duration(days: 10, hours: 1)));
      expect(soon, greaterThan(later));
    });
  });

  group('generateSchedule', () {
    final tasks = [for (int i = 1; i <= 6; i++) task(i, dueInDays: i)];

    test('with no free time, nothing is scheduled', () {
      final week = ScheduleGeneratingAlgorithm.generateSchedule(tasks, List.filled(7, noTime));
      expect(week.every((day) => day.isEmpty), isTrue);
    });

    test('work is placed only on days with free time', () {
      final today = DateTime.now().weekday - 1; // Monday = 0
      final ranges = List.filled(7, noTime);
      ranges[today] = hours(16, 19);

      final week = ScheduleGeneratingAlgorithm.generateSchedule(tasks, ranges);

      expect(week[today], isNotEmpty);
      for (int day = 0; day < 7; day++) {
        if (day != today) expect(week[day], isEmpty, reason: 'day $day has no free time');
      }
    });

    test('no assignment is scheduled twice', () {
      final week = ScheduleGeneratingAlgorithm.generateSchedule(tasks, List.filled(7, hours(16, 19)));
      final ids = week.expand((day) => day).map((t) => t.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('handed-in work is not scheduled', () {
      final done = task(99, submission: const Submission(workflowState: 'submitted', late: false));
      final week = ScheduleGeneratingAlgorithm.generateSchedule([...tasks, done], List.filled(7, hours(16, 19)));
      expect(week.expand((day) => day).any((t) => t.id == 99), isFalse);
    });
  });
}
