import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:courseflow/models/assignment.dart';
import 'package:courseflow/repositories/assignment_repository.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onNavigateToSchedule;
  final VoidCallback? onNavigateToCourses;

  const HomeScreen({
    super.key,
    this.onNavigateToSchedule,
    this.onNavigateToCourses,
  });

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<AssignmentRepository>();
    final List<Assignment> assignments = repo.assignments;

    final DateTime now = DateTime.now();

    // Calculations for quick metrics
    final pendingAssignments = assignments.where((a) => !a.submitted).toList();
    final completedAssignments = assignments.where((a) => a.submitted).toList();

    final dueToday = pendingAssignments.where((a) {
      if (a.dueAt == null) return false;
      return a.dueAt!.year == now.year &&
          a.dueAt!.month == now.month &&
          a.dueAt!.day == now.day;
    }).toList();

    // Urgent / Next up tasks (sorted by due date)
    final upcomingTasks = List<Assignment>.from(pendingAssignments)
      ..sort((a, b) {
        if (a.dueAt == null) return 1;
        if (b.dueAt == null) return -1;
        return a.dueAt!.compareTo(b.dueAt!);
      });

    final topUrgentTasks = upcomingTasks.take(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 0. DEMO MODE NOTICE (no Canvas token configured)
              if (repo.isDemoMode) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded, size: 18, color: Colors.amber.shade900),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Demo mode: showing sample courses and assignments',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 0b. CANVAS LOADING NOTICE
              if (repo.isLoading) ...[
                const Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Loading from Canvas…',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // 0c. CANVAS ERROR NOTICE WITH RETRY
              if (repo.loadError != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline_rounded, size: 18, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Could not load from Canvas: ${repo.loadError}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: repo.fetchAndLoadAssignments,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 1. TOP GREETING & DATE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE, MMM d').format(now),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Welcome Back! 👋',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.deepPurple.shade100,
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 2. QUICK STATS SUMMARY ROW
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Due Today',
                      count: '${dueToday.length}',
                      icon: Icons.error_outline_rounded,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Pending',
                      count: '${pendingAssignments.length}',
                      icon: Icons.pending_actions_rounded,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Done',
                      count: '${completedAssignments.length}',
                      icon: Icons.check_circle_outline_rounded,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // 3. ACTION SHORTCUT BANNER CARDS
              Row(
                children: [
                  Expanded(
                    child: _buildShortcutCard(
                      title: 'Weekly Schedule',
                      subtitle: 'View generated plan',
                      icon: Icons.calendar_month_rounded,
                      color: const Color(0xFF6C5CE7),
                      onTap: onNavigateToSchedule,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildShortcutCard(
                      title: 'My Courses',
                      subtitle: '${repo.courses.length} enrolled',
                      icon: Icons.school_rounded,
                      color: const Color(0xFF00CEC9),
                      onTap: onNavigateToCourses,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // 4. NEXT UP / URGENT TASKS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Next Up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  if (pendingAssignments.length > 3)
                    TextButton(
                      onPressed: onNavigateToCourses,
                      child: const Text('See All'),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              if (topUrgentTasks.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.stars_rounded, size: 40, color: Colors.amber),
                      SizedBox(height: 8),
                      Text(
                        'All caught up!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'No pending assignments right now.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: topUrgentTasks
                      .map((task) => _buildUrgentTaskTile(context, task))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget: Metric Box
  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Shortcut Card
  Widget _buildShortcutCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget: Task Preview Item
  Widget _buildUrgentTaskTile(BuildContext context, Assignment task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 36,
            decoration: BoxDecoration(
              color: task.priority >= 4 ? Colors.redAccent : Colors.deepPurple,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  task.dueAt == null
                      ? 'No due date'
                      : 'Due ${DateFormat('MMM d, h:mm a').format(task.dueAt!)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${task.estimatedCompletionTime}m',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}