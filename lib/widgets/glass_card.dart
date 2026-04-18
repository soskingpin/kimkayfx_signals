import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double borderRadius;
  final bool isDarkMode;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.onTap,
    this.backgroundColor,
    this.borderRadius = 22.0,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor ?? (isDarkMode ? AppColors.glassBg : AppColors.glassBgDark),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isDarkMode ? AppColors.glassBorder : Colors.white.withOpacity(0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? AppColors.glassShadow : Colors.black.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
