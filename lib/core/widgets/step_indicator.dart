import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({super.key, required this.steps, required this.currentStep});

  final List<String> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final leftStep = i ~/ 2;
          final done = leftStep < currentStep;
          return Expanded(
            child: Container(height: 2, color: done ? AppColors.accent : AppColors.surfaceElevated),
          );
        }
        final stepIndex = i ~/ 2;
        final isActive = stepIndex == currentStep;
        final isDone = stepIndex < currentStep;
        return Column(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: isActive || isDone ? AppColors.accent : AppColors.surfaceElevated,
              child: Text(
                '${stepIndex + 1}',
                style: TextStyle(
                    color: isActive || isDone ? Colors.black : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
            const SizedBox(height: 4),
            Text(steps[stepIndex],
                style: TextStyle(
                    color: isActive ? AppColors.accent : AppColors.textSecondary, fontSize: 11)),
          ],
        );
      }),
    );
  }
}