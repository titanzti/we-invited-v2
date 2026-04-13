import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_theme.dart';

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({
    super.key,
    required this.navigationShell,
  });

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allows content to scroll behind the floating navbar
      body: navigationShell,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryDark.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.85),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NavBarItem(
                        icon: Icons.home_filled,
                        label: 'Feed',
                        isSelected: navigationShell.currentIndex == 0,
                        onTap: () => _goBranch(0),
                      ),
                      _NavBarItem(
                        icon: Icons.add_circle,
                        label: 'Host',
                        isSelected: navigationShell.currentIndex == 1,
                        isProminent: true,
                        onTap: () => _goBranch(1),
                      ),
                      _NavBarItem(
                        icon: Icons.person,
                        label: 'Profile',
                        isSelected: navigationShell.currentIndex == 2,
                        onTap: () => _goBranch(2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ).animate().slideY(begin: 1.5, duration: 800.ms, curve: Curves.easeOutExpo),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isProminent;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isProminent = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppTheme.primaryBlue : Colors.grey.shade500;
    
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuart,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 12,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isProminent 
              ? AppTheme.primaryDark 
              : (isSelected ? AppTheme.primaryBlue.withOpacity(0.1) : Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isProminent ? Colors.white : color,
              size: isProminent ? 28 : 24,
            ),
            if (isSelected && !isProminent) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ).animate().fade(duration: 200.ms).slideX(begin: 0.2),
            ]
          ],
        ),
      ),
    );
  }
}
