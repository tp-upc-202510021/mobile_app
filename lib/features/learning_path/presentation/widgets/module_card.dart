import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class ModuleCard extends StatelessWidget {
  final String title;
  final String level;
  final bool isBlocked;
  final bool isApproved;

  const ModuleCard({
    super.key,
    required this.title,
    required this.level,
    required this.isBlocked,
    required this.isApproved,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor = isApproved ? Colors.green[50]! : Colors.white;
    final Color borderColor = isApproved ? Colors.green : Colors.grey[300]!;
    final IconData statusIcon = isApproved
        ? Icons.check_circle
        : Icons.lock_clock;
    final Color statusColor = isApproved ? Colors.green : Colors.orange;
    final String statusText = isApproved ? 'Completado' : 'Pendiente';

    return FCard(
      style: FCardStyle(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        contentStyle: FCardContentStyle(
          padding: const EdgeInsets.all(16),
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          subtitleTextStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
      child: Row(
        children: [
          // Icon or illustration
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(FIcons.book, size: 32, color: Colors.blueAccent),
          ),
          const SizedBox(width: 16),

          // Text and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // // Level subtitle
                // Text(
                //   'Nivel: $level',
                //   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                // ),
                const SizedBox(height: 8),

                // Status badge
                Row(
                  children: [
                    Icon(statusIcon, size: 18, color: statusColor),
                    const SizedBox(width: 6),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 13,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // // Optional lock overlay
          // if (isBlocked)
          //   const Icon(Icons.lock, color: Colors.redAccent, size: 24),
        ],
      ),
    );
  }
}
