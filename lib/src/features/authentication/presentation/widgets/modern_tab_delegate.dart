import 'package:flutter/material.dart';

class ModernTabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final bool isDark;

  ModernTabDelegate(this.tabBar, {this.isDark = false});

  @override
  double get minExtent => tabBar.preferredSize.height + 16;

  @override
  double get maxExtent => tabBar.preferredSize.height + 16;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDark ? const Color(0xFF09090B) : const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(ModernTabDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar || isDark != oldDelegate.isDark;
  }
}
