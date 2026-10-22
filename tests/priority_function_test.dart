import 'package:courseflow/utilities/schedule_generating_algorithm.dart';

void main() {
  int priority = 1;
  DateTime dueDate = DateTime(2026, 9, 30);
  double estimatedAnswer = 0.3181818182;

  if (ScheduleGeneratingAlgorithm.newPriorityGenerator(priority, dueDate) != estimatedAnswer) {
    print( "Test Failed. Result should have been $estimatedAnswer but result was ${ScheduleGeneratingAlgorithm.newPriorityGenerator(priority, dueDate)}");
  }
  
}