import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
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
      extendBody: true,
      body: Stack(
        children: [
          // 1. Background Content
          navigationShell,
          
          // 2. Liquid Glass Navbar Overlay
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: SafeArea(
              bottom: true,
              child: LiquidGlassLayer(
                settings: LiquidGlassSettings(
                  thickness: 24, // Extreme warping
                  blur: 25, // High frost
                  glassColor: AppTheme.surfaceWhite.withOpacity(0.15), // Highly transparent so we see the glass effect!
                  lightIntensity: 2.0, // High gloss
                  ambientStrength: 1.0,
                  refractiveIndex: 1.6, // Strong refraction
                ),
                child: LiquidGlass(
                  shape: LiquidRoundedSuperellipse(borderRadius: 36),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    constraints: const BoxConstraints(minHeight: 76),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Center(
                            child: _NavBarItem(
                              icon: Icons.home_filled,
                              label: 'Feed',
                              isSelected: navigationShell.currentIndex == 0,
                              onTap: () => _goBranch(0),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: _NavBarItem(
                              icon: Icons.add,
                              label: 'Host',
                              isSelected: navigationShell.currentIndex == 1,
                              isProminent: true,
                              onTap: () => _goBranch(1),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: _NavBarItem(
                              icon: Icons.person,
                              label: 'Profile',
                              isSelected: navigationShell.currentIndex == 2,
                              onTap: () => _goBranch(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().slideY(begin: 1.5, duration: 800.ms, curve: Curves.easeOutExpo),
            ),
          ),
        ],
      ),
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
    if (isProminent) {
      // The massive dark center + icon
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutQuart,
          width: 64,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primaryDark,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: AppTheme.surfaceWhite,
              size: 28,
            ),
          ),
        ),
      );
    }

    final color = isSelected ? AppTheme.primaryBlue : AppTheme.textMetadata.withOpacity(0.7);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Deep Apple Control Center style glass highlight
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutQuart,
              opacity: isSelected ? 1.0 : 0.0,
              child: FakeGlass( // Switching to FakeGlass for nested objects to avoid WebGL / Shader clipping issues 
                shape: LiquidRoundedSuperellipse(borderRadius: 24),
                settings: LiquidGlassSettings(
                  blur: 20,
                  glassColor: AppTheme.primaryBlue.withOpacity(0.4), // Very obvious blue tint
                  saturation: 2.5, // Extreme vibrancy Apple effect
                ),
                child: const SizedBox.expand(),
              ),
            ),
            // The Icon
            Icon(
              icon,
              color: color,
              size: 26,
              semanticLabel: label,
            ),
          ],
        ),
      ),
    );
  }
}
