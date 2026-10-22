import 'package:courseflow/models/assignment.dart';
import 'package:collection/collection.dart';

class AssignmentTimeAlgorithm {
  static Map<List, int?> estimateAssignmentTime (List<Assignment> assignments){
    List<List<dynamic>> assignmentTypes = [];
    List<int> assignmentEstimations = [];

    List<Assignment> newAssignments = assignments.where((element) => element.completionTime != 0,).toList();

    for (int i = 0; i < newAssignments.length; i++) {
      if (assignmentTypes.any(
        (element) => element[0] == newAssignments[i].courseId &&
        element[1] == newAssignments[i].difficulty
      ) == false) {
        assignmentTypes.add([
          newAssignments[i].courseId,
          newAssignments[i].difficulty
        ]);
      }
    }



    for (int i = 0; i < assignmentTypes.length; i++) {
      List<int>  assignmentList = newAssignments.where((element) => 
        element.courseId == assignmentTypes[i][0] &&
        element.difficulty == assignmentTypes[i][1]
      )
      .toList()
      .map((e) => e.completionTime,)
      .toList();
      bool isMatching = newAssignments.where((element) =>
        element.courseId == assignmentTypes[i][0] &&
        element.difficulty == assignmentTypes[i][1]
      ,)
      .toList().length > 2;

      if (isMatching) {
        assignmentEstimations.add(assignmentList.average.round());
      }
      else {
        assignmentEstimations.add(0);
      }
    }



    return Map.fromIterables(assignmentTypes, assignmentEstimations);

  }
}