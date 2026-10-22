import 'package:courseflow/models/assignment.dart';
import 'package:courseflow/repositories/assignment_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AssignmentWidget extends StatefulWidget {
  final Assignment assignment;
  final Function(int) onPress;

  const AssignmentWidget({
    super.key,
    required this.assignment,
    required this.onPress,
  }) : _assignment = assignment;

  final Assignment _assignment;

  @override
  State<AssignmentWidget> createState() => AssignmentWidgetState();
}

class AssignmentWidgetState extends State<AssignmentWidget> {
  bool _isExpanded = false;
  final TextEditingController _completionTimeController = TextEditingController();

  @override
  void dispose() {
    _completionTimeController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Submitted':
        return Colors.green;
      case 'Missing':
        return Colors.red;
      case 'Submitted late':
        return Colors.orange;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<AssignmentRepository>();
    final int id = widget._assignment.id;
    final String status = widget._assignment.completionStatus;

    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- COLLAPSED HEADER ROW ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget._assignment.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: _isExpanded ? 3 : 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.event,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget._assignment.dueAt == null
                                  ? 'No Due Date'
                                  : DateFormat("MMM d, yyyy 'at' hh:mm a")
                                      .format(widget._assignment.dueAt!),
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
                  const SizedBox(width: 8),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(status),
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),

              // --- EXPANDED DETAILS SECTION ---
              if (_isExpanded) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Assignment Details',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_note, color: Colors.deepPurple),
                      onPressed: () => widget.onPress(id),
                      tooltip: 'Edit Assignment Parameters',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  Icons.timer_outlined,
                  'Estimated Time',
                  widget._assignment.estimatedCompletionTime == 0
                      ? 'No Prediction'
                      : '${widget._assignment.estimatedCompletionTime} mins',
                ),
                _buildDetailRow(
                  Icons.bar_chart_rounded,
                  'Difficulty',
                  widget._assignment.difficulty == 0
                      ? 'Not Set'
                      : '${widget._assignment.difficulty} / 5',
                ),
                _buildDetailRow(
                  Icons.priority_high_rounded,
                  'Priority',
                  widget._assignment.priority == 0
                      ? 'Not Set'
                      : '${widget._assignment.priority} / 5',
                ),
                const SizedBox(height: 16),
                // Completion Time Form
                Text(
                  'Log Actual Completion Time',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _completionTimeController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Minutes spent (e.g. 45)',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () {
                        final val = int.tryParse(_completionTimeController.text) ?? 0;
                        if (val > 0) {
                          repo.changeAssignment(id, 0, 0, 0, val);
                          _completionTimeController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Completion time updated!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}