import 'dart:math';
import 'package:courseflow/models/flexible_assignment.dart';
import 'package:collection/collection.dart';
import 'package:time_range_picker/time_range_picker.dart';

class ScheduleGeneratingAlgorithm {

  
  static double roundToDouble(double value, int places) {
    num mod = pow(10, places);
    return (value * mod).round() / mod;
  }
  static double newPriorityGenerator(int priority, DateTime dueDate) {



    int daysUntilDue = dueDate.difference(DateTime.now()).inDays + 1;

    return roundToDouble((priority*(7/(daysUntilDue+7))), 10);
  }

  static int negativeDifference(DateTime dt1, DateTime dt2) {
    if (dt2.isBefore(dt1)) {
      return dt1.difference(dt2).inDays;
    }
    else {
      return dt1.difference(dt2).inDays;
    }
  }


  static List<List<FlexibleAssignment>> generateSchedule(List<FlexibleAssignment> assignmentList, List<TimeRange> timeRanges) {
    List<FlexibleAssignment> newAssignmentList = assignmentList.where((e) => e.completionStatus == "Not Submitted") 
    .toList()
    .map((e) => e.copyWith(newPriorityGenerator(e.priority, e.dueAt ?? DateTime(9999999)).round()))
    .toList();
    if (newAssignmentList.isEmpty) return [[], [], [], [], [], [], []];

    double averageAssignmentCompletionTime = newAssignmentList
    .map((e) => e.estimatedCompletionTime)
    .toList()
    .average;


    //Creates two lists with differing priorities ordered by estimated completion time
    List<FlexibleAssignment> highPriorityList = newAssignmentList.where((e) => e.priority >= 4).toList();
    List<FlexibleAssignment> lowPriorityList = newAssignmentList.where((e) => e.priority <= 3).toList();

    highPriorityList.sort((a, b) => a.estimatedCompletionTime.compareTo(b.estimatedCompletionTime));
    lowPriorityList.sort((a, b) => a.estimatedCompletionTime.compareTo(b.estimatedCompletionTime));

    //Creates variables for the time range of each day of the week
    TimeRange mondayRange = timeRanges[0];
    TimeRange tuesdayRange = timeRanges[1];
    TimeRange wednesdayRange = timeRanges[2];
    TimeRange thursdayRange = timeRanges[3];
    TimeRange fridayRange = timeRanges[4];
    TimeRange saturdayRange = timeRanges[5];
    TimeRange sundayRange = timeRanges[6];


    List<TimeRange> weekdayValues = [mondayRange,tuesdayRange,wednesdayRange,thursdayRange,fridayRange,saturdayRange,sundayRange];
    int currentDay = DateTime.now().weekday - 1;

    List<List<FlexibleAssignment>> finalAssignmentList = [[],[],[],[],[],[],[]];

    for (int i = 0; i < 7; i++) {

      int currentListIndex = (currentDay + i > 6) ? (currentDay + i) - 7: currentDay + i;
      //Checks for necessary assignments (Ones due the next or same day)
      List<FlexibleAssignment> neededHighPriorityList = highPriorityList.where((e) => negativeDifference(e.dueAt ?? DateTime(99999), DateTime.now().add(Duration(days: i))) < 1).toList();
      List<FlexibleAssignment> neededLowPriorityList = lowPriorityList.where((e) => negativeDifference(e.dueAt ?? DateTime(99999), DateTime.now().add(Duration(days: i))) < 1).toList();
      
      // Convert start and end times to total minutes from midnight
      int startMinutes = (weekdayValues[currentListIndex].startTime.hour * 60) + 
          weekdayValues[currentListIndex].startTime.minute;
      int endMinutes = (weekdayValues[currentListIndex].endTime.hour * 60) + 
          weekdayValues[currentListIndex].endTime.minute;

      // Handle cross-midnight ranges (e.g., 10 PM to 2 AM)
      if (endMinutes < startMinutes) {
        endMinutes += 24 * 60;
      }

      double timeForDay = (endMinutes - startMinutes).toDouble(); // Total minutes for the day

      // Guard against division by zero if no assignments exist
      double avgTime = averageAssignmentCompletionTime > 0 
          ? averageAssignmentCompletionTime 
          : 60.0;

      int assignmentsForDay = (timeForDay / avgTime).round();

      if (neededHighPriorityList.length + neededLowPriorityList.length > assignmentsForDay) {
        int priorityAssignmentDifference = (neededHighPriorityList.length + neededLowPriorityList.length)-assignmentsForDay;
        for (int a = 0; a < priorityAssignmentDifference; a++) {
          if (neededLowPriorityList.isNotEmpty) {
            neededLowPriorityList.removeLast();
          }
          else if (neededHighPriorityList.isNotEmpty) {
            neededHighPriorityList.removeLast();
          }
        }
      }

      highPriorityList.removeWhere((e) => neededHighPriorityList.any((d) => d.id == e.id));
      lowPriorityList.removeWhere((e) => neededLowPriorityList.any((d) => d.id == e.id));
      
      int remainingAssinments = assignmentsForDay % 4;
      int highPLowDAssignmentsLength = (assignmentsForDay/4).floor() + (remainingAssinments/2).floor();
      int highPHighDAssignmentsLength = (assignmentsForDay/4).floor();
      int lowPLowDAssignmentsLength = (assignmentsForDay/4).floor() + (remainingAssinments/2).floor() + remainingAssinments % 2;
      int lowPHighDAssignmentsLength = (assignmentsForDay/4).floor();

      List<FlexibleAssignment> highPLowDAssignments = neededHighPriorityList.where((e) => e.difficulty <= 3).toList();
      if (highPLowDAssignments.length > highPLowDAssignmentsLength) {
        int excess = highPLowDAssignments.length - highPLowDAssignmentsLength;
        highPHighDAssignmentsLength = max(0, highPHighDAssignmentsLength - excess);
        highPLowDAssignmentsLength = highPLowDAssignments.length; 
      }
      List<FlexibleAssignment> highPHighDAssignments = neededHighPriorityList.where((e) => e.difficulty >= 4).toList();
      if (highPHighDAssignments.length > highPHighDAssignmentsLength) {
        int excess = highPHighDAssignments.length - highPHighDAssignmentsLength;
        lowPLowDAssignmentsLength = max(0, lowPLowDAssignmentsLength - excess);
        highPHighDAssignmentsLength = highPHighDAssignments.length; 
      }
      List<FlexibleAssignment> lowPLowDAssignments = neededLowPriorityList.where((e) => e.difficulty <= 3).toList();
      if (lowPLowDAssignments.length > lowPLowDAssignmentsLength) {
        int excess = lowPLowDAssignments.length - lowPLowDAssignmentsLength;
        lowPHighDAssignmentsLength = max(0, lowPHighDAssignmentsLength - excess);
        lowPLowDAssignmentsLength = lowPLowDAssignments.length; 
      }
      List<FlexibleAssignment> lowPHighDAssignments = neededLowPriorityList.where((e) => e.difficulty >= 4).toList();

      List<FlexibleAssignment> remainingHighPriorityList = highPriorityList.where((e) => !highPLowDAssignments.any((d) => d.id == e.id) && !highPHighDAssignments.any((d) => d.id == e.id)).toList();
      List<FlexibleAssignment> remainingLowPriorityList = lowPriorityList.where((e) => !lowPLowDAssignments.any((d) => d.id == e.id) && !lowPHighDAssignments.any((d) => d.id == e.id)).toList();
      int difference = highPLowDAssignmentsLength - highPLowDAssignments.length;
      if (highPLowDAssignments.length < highPLowDAssignmentsLength)  {
        for (int a = 0; a < difference; a++){if (remainingHighPriorityList.isNotEmpty){highPLowDAssignments.add(remainingHighPriorityList.first); highPriorityList.remove(remainingHighPriorityList.first);remainingHighPriorityList.removeAt(0);}}
      }
      if (highPHighDAssignments.length < highPHighDAssignmentsLength)  {
        difference = highPHighDAssignmentsLength - highPHighDAssignments.length; for (int a = 0; a < difference; a++){if (remainingHighPriorityList.isNotEmpty){highPHighDAssignments.add(remainingHighPriorityList.last); highPriorityList.remove(remainingHighPriorityList.last);remainingHighPriorityList.removeLast();}}
      }
      if (lowPLowDAssignments.length < lowPLowDAssignmentsLength)  {
        difference = lowPLowDAssignmentsLength - lowPLowDAssignments.length; for (int a = 0; a < difference; a++){if (remainingLowPriorityList.isNotEmpty) {lowPLowDAssignments.add(remainingLowPriorityList.first); lowPriorityList.remove(remainingLowPriorityList.first);remainingLowPriorityList.removeAt(0);}}
      }
      if (lowPHighDAssignments.length < lowPHighDAssignmentsLength)  {
        difference = lowPHighDAssignmentsLength - lowPHighDAssignments.length; for (int a = 0; a < difference; a++){if (remainingLowPriorityList.isNotEmpty){lowPHighDAssignments.add(remainingLowPriorityList.last); lowPriorityList.remove(remainingLowPriorityList.last); remainingLowPriorityList.removeLast(); }}
      }

      finalAssignmentList[currentListIndex] = highPLowDAssignments + highPHighDAssignments + lowPLowDAssignments + lowPHighDAssignments;
    }

    return finalAssignmentList;
  }
}