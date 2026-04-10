import 'package:daily_you/time_manager.dart';
import 'package:daily_you/widgets/entry_calendar.dart';
import 'package:daily_you/widgets/ios_day_cell.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// An infinite-scrolling 3-column grid of day cells.
///
/// Today is at the bottom. Scrolling up reveals older months,
/// loading month-by-month on demand — like iOS Calendar.
class IosCalendarGrid extends StatefulWidget {
  final ScrollController? scrollController;
  final Widget? rewindCard;
  final Widget? emptyState;
  final Widget? yearInReviewBanner;

  const IosCalendarGrid({
    super.key,
    this.scrollController,
    this.rewindCard,
    this.emptyState,
    this.yearInReviewBanner,
  });

  @override
  State<IosCalendarGrid> createState() => _IosCalendarGridState();
}

class _IosCalendarGridState extends State<IosCalendarGrid>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  static const int _totalMonths = 300; // ~25 years back

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomScrollView(
      controller: widget.scrollController,
      // Start at the bottom (today) — user scrolls up for past months
      reverse: true,
      slivers: [
        // Bottom padding (appears at bottom since reverse=true)
        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        // Toolbar pinned at top-of-viewport via reverse
        SliverToBoxAdapter(
          child: _buildToolbar(context, theme, isDark),
        ),
        if (widget.rewindCard != null)
          SliverToBoxAdapter(
            child: widget.rewindCard!,
          ),
        if (widget.emptyState != null)
          SliverToBoxAdapter(
            child: widget.emptyState!,
          ),
        if (widget.yearInReviewBanner != null)
          SliverToBoxAdapter(
            child: widget.yearInReviewBanner!,
          ),
        // Build month sections: index 0 = current month (bottom)
        ...List.generate(_totalMonths, (monthIndex) {
          return _buildMonthSliver(context, monthIndex, theme, isDark);
        }),
        // Top padding (appears at top of scroll)
        const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
      ],
    );
  }

  Widget _buildToolbar(BuildContext context, ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 8, 8),
      child: Row(
        children: [
          Text(
            DateFormat("MMMM y", TimeManager.currentLocale(context))
                .format(DateTime.now()),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
          const Spacer(),
          const CalendarViewModeSelector(),
        ],
      ),
    );
  }

  Widget _buildMonthSliver(
    BuildContext context,
    int monthIndex,
    ThemeData theme,
    bool isDark,
  ) {
    final now = DateTime.now();
    // monthIndex 0 = current month, 1 = last month, etc.
    final monthDate = DateTime(now.year, now.month - monthIndex, 1);
    final daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;

    // For the current month, only show up to today
    final int lastDay =
        (monthDate.year == now.year && monthDate.month == now.month)
            ? now.day
            : daysInMonth;

    // Days in chronological order (1, 2, 3, ...)
    final days = List.generate(
      lastDay,
      (i) => DateTime(monthDate.year, monthDate.month, i + 1),
    );

    return SliverMainAxisGroup(
      slivers: [
        // Day grid (appears first because list is reversed)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.78,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  IosDayCell(date: days[days.length - 1 - index]),
              childCount: days.length,
            ),
          ),
        ),
        // Month header (appears above grid because list is reversed)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              DateFormat("MMMM yyyy", TimeManager.currentLocale(context))
                  .format(monthDate)
                  .toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
