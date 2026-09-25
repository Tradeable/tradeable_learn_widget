import 'package:flutter/material.dart';

class ContinueJourneyButton extends StatelessWidget {
  final String text;
  final bool enabled;
  final VoidCallback? onPressed;
  final VoidCallback? onDisabledTap;
  final Color startColor;
  final Color endColor;
  final Color? disabledBackgroundColor;
  final Color enabledTextColor;
  final Color disabledTextColor;
  final IconData enabledIcon;
  final IconData disabledIcon;
  final double height;
  final double borderRadius;
  final double fontSize;
  final double iconSize;
  final double spacing;

  const ContinueJourneyButton({
    super.key,
    required this.text,
    required this.startColor,
    required this.endColor,
    this.enabled = true,
    this.onPressed,
    this.onDisabledTap,
    this.disabledBackgroundColor,
    this.enabledTextColor = Colors.white,
    this.disabledTextColor = Colors.white,
    this.enabledIcon = Icons.arrow_forward_rounded,
    this.disabledIcon = Icons.lock_outline,
    this.height = 52,
    this.borderRadius = 8,
    this.fontSize = 15,
    this.iconSize = 18,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    final contentColor = enabled ? enabledTextColor : disabledTextColor;
    final icon = enabled ? enabledIcon : disabledIcon;

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: enabled || disabledBackgroundColor == null
            ? LinearGradient(colors: [startColor, endColor])
            : null,
        color: enabled ? null : disabledBackgroundColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : onDisabledTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: contentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                ),
              ),
              SizedBox(width: spacing),
              Icon(icon, color: contentColor, size: iconSize),
            ],
          ),
        ),
      ),
    );
  }
}
