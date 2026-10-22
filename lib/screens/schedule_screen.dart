import 'package:courseflow/models/submission.dart';
import 'package:courseflow/utilities/schedule_generating_algorithm.dart';
import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:courseflow/models/assignment.dart';
import 'package:courseflow/models/flexible_assignment.dart';
import 'package:courseflow/repositories/assignment_repository.dart';
import 'package:provider/provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {

  int stackIndex = 0;
  //Ranges of time availiable for each day of the week
  TimeRange? mondayRange;
  TimeRange? tuesdayRange;
  TimeRange? wednesdayRange;
  TimeRange? thursdayRange;
  TimeRange? fridayRange;
  TimeRange? saturdayRange;
  TimeRange? sundayRange;

  List<String> days = [];
  int currentDay = 0;

  @override
  void initState() {
    super.initState();

    days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    currentDay = DateTime.now().weekday - 1;
    
  }

  

  String timeRangeToString(TimeRange range) {
    return "${range.startTime.hourOfPeriod}:${range.startTime.minute == 5 ? "05" : (range.startTime.minute == 0 ? "00": range.startTime.minute)} ${range.startTime.period.name} to ${range.endTime.hourOfPeriod}:${range.endTime.minute == 5 ? "05" : (range.endTime.minute == 0 ? "00": range.endTime.minute)} ${range.endTime.period.name} ";
  }
  List<Assignment> _assignments = [];
  List<bool> areExpanded = [false,false,false,false,false,false,false];

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<AssignmentRepository>(); 
    _assignments = repo.assignments;

    final List<String> dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final int currentWeekday = DateTime.now().weekday - 1;

    List<List<FlexibleAssignment>> schedule = ScheduleGeneratingAlgorithm.generateSchedule(
      _assignments.map((e) {
        return FlexibleAssignment(
          id: e.id,
          name: e.name,
          submission: e.submission ?? Submission(workflowState: "", late: false),
          difficulty: e.difficulty,
          priority: e.priority,
          dueAt: e.dueAt,
          estimatedCompletionTime: e.estimatedCompletionTime,
        );
      }).toList(), 
    [
      mondayRange ?? TimeRange(startTime: TimeOfDay(hour: 0, minute: 0), endTime: TimeOfDay(hour: 0, minute: 0)),
      tuesdayRange ?? TimeRange(startTime: TimeOfDay(hour: 0, minute: 0), endTime: TimeOfDay(hour: 0, minute: 0)),
      wednesdayRange ?? TimeRange(startTime: TimeOfDay(hour: 0, minute: 0), endTime: TimeOfDay(hour: 0, minute: 0)),
      thursdayRange ?? TimeRange(startTime: TimeOfDay(hour: 0, minute: 0), endTime: TimeOfDay(hour: 0, minute: 0)),
      fridayRange ?? TimeRange(startTime: TimeOfDay(hour: 0, minute: 0), endTime: TimeOfDay(hour: 0, minute: 0)),
      saturdayRange ?? TimeRange(startTime: TimeOfDay(hour: 0, minute: 0), endTime: TimeOfDay(hour: 0, minute: 0)),
      sundayRange ?? TimeRange(startTime: TimeOfDay(hour: 0, minute: 0), endTime: TimeOfDay(hour: 0, minute: 0))
      ]
    );
    
    return IndexedStack(
      index: stackIndex,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Time availiable on Monday: ${mondayRange != null ? timeRangeToString(mondayRange!): "None yet "}",
              textAlign: TextAlign.left,
            ),
            ElevatedButton(
              onPressed: () async {
                  mondayRange = await showTimeRangePicker(
                    context: context,
                    use24HourFormat: false
                  );
                  setState(() {});
              }, 
              child: Text("Change")
            ),
            const SizedBox(height: 20),
            Text(
              "Time availiable on Tuesday: ${tuesdayRange != null ? timeRangeToString(tuesdayRange!): "None yet "}",
              textAlign: TextAlign.left,
            ),
            ElevatedButton(onPressed: () async {
                tuesdayRange = await showTimeRangePicker(
                  context: context,
                  use24HourFormat: false
                );
                setState(() {});
            }, 
            child: Text("Change")),
            const SizedBox(height: 20),
            Text(
              "Time availiable on Wednesday: ${wednesdayRange != null ? timeRangeToString(wednesdayRange!): "None yet "}",
              textAlign: TextAlign.left,
            ),
            ElevatedButton(onPressed: () async {
                wednesdayRange = await showTimeRangePicker(
                  context: context,
                  use24HourFormat: false
                );
                setState(() {});
            }, 
            child: Text("Change")),
            const SizedBox(height: 20),
            Text(
              "Time availiable on Thursday: ${thursdayRange != null ? timeRangeToString(thursdayRange!): "None yet "}",
              textAlign: TextAlign.left,
            ),
            ElevatedButton(onPressed: () async {
                thursdayRange = await showTimeRangePicker(
                  context: context,
                  use24HourFormat: false
                );
                setState(() {});
            }, 
            child: Text("Change")),
            const SizedBox(height: 20),
            Text(
              "Time availiable on Friday: ${fridayRange != null ? timeRangeToString(fridayRange!): "None yet "}",
              textAlign: TextAlign.left,
            ),
            ElevatedButton(onPressed: () async {
                fridayRange = await showTimeRangePicker(
                  context: context,
                  use24HourFormat: false
                );
                setState(() {});
            }, 
            child: Text("Change")),
            const SizedBox(height: 20),
            Text(
              "Time availiable on Saturday: ${saturdayRange != null ? timeRangeToString(saturdayRange!): "None yet "}",
              textAlign: TextAlign.left,
            ),
            ElevatedButton(onPressed: () async {
                saturdayRange = await showTimeRangePicker(
                  context: context,
                  use24HourFormat: false
                );
                setState(() {});
            }, 
            child: Text("Change")),
            const SizedBox(height: 20),
            Text(
              "Time availiable on Sunday: ${sundayRange != null ? timeRangeToString(sundayRange!): "None yet "}",
              textAlign: TextAlign.left,
            ),
            ElevatedButton(onPressed: () async {
                sundayRange = await showTimeRangePicker(
                  context: context,
                  use24HourFormat: false
                );
                setState(() {});
            }, 
            child: Text("Change")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  stackIndex = 1;
                });
              }, 
              child: Text("Submit")
            )
          ]
        ),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          itemCount: 7,
          itemBuilder: (context, i) {
            final int dayIndex = (currentWeekday + i) % 7;
            final String dayTitle = dayNames[dayIndex];
            final List<FlexibleAssignment> dayTasks = schedule[dayIndex];

            final int totalMinutes = dayTasks.fold(
              0,
              (sum, task) => sum + task.estimatedCompletionTime,
            );

            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- DAY HEADER ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              dayTitle,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        if (dayTasks.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${dayTasks.length} tasks • ${totalMinutes}m',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // --- TASK LIST / EMPTY STATE ---
                    if (dayTasks.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'No assignments scheduled — Rest Day',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dayTasks.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, taskIndex) {
                          final task = dayTasks[taskIndex];
                          return _buildTaskTile(context, task);
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ]
    );
  }

  Widget _buildTaskTile(BuildContext context, FlexibleAssignment task) {
    Color getPriorityColor(int priority) {
      if (priority >= 4) return Colors.redAccent;
      if (priority == 3) return Colors.orangeAccent;
      return Colors.blueAccent;
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Priority Bar Indicator
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: getPriorityColor(task.priority),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          // Task Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name ?? "",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${task.estimatedCompletionTime} mins',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.bar_chart_rounded,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Diff: ${task.difficulty}/5',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
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