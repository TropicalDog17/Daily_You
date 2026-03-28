import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StreakCard extends StatelessWidget {
  final bool isVisible;
  final String title;
  final IconData icon;

  const StreakCard(
      {super.key,
      this.isVisible = false,
      this.title = "",
      this.icon = Icons.bolt});

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    // Find the number to style it
    final RegExp regex = RegExp(r'\d+');
    final match = regex.firstMatch(title);

    if (match == null) {
      return const SizedBox.shrink();
    }

    final formatter = NumberFormat('#,###');
    final int numberStart = match.start;
    final int numberEnd = match.end;

    if (!isVisible) {
      return const SizedBox.shrink();
    }

    final cardContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
            size: 18,
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: title.substring(0, numberStart),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              TextSpan(
                text: formatter
                    .format(int.parse(title.substring(numberStart, numberEnd))),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              TextSpan(
                text: title.substring(numberEnd),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (isIOS) {
      return Container(
        margin: const EdgeInsets.only(right: 6, bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                Theme.of(context).colorScheme.outline.withValues(alpha: 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: cardContent,
      );
    }

    return Card.filled(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: cardContent,
      ),
    );
  }
}
