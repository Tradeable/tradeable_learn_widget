import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/app_theme.dart';

class SahiTopBar extends StatelessWidget implements PreferredSizeWidget {
  final int streakDays;
  final int xp;
  final int unreadNotificationCount;
  final String? profileImageUrl;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final Widget? leading;

  const SahiTopBar({
    super.key,
    this.streakDays = 140,
    this.xp = 0,
    this.unreadNotificationCount = 1,
    this.profileImageUrl,
    this.onNotificationTap,
    this.onProfileTap,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return SafeArea(
      bottom: false,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: colors.sahiTopBarBg,
          boxShadow: [
            BoxShadow(
              color: colors.sahiTopBarBorder.withAlpha(40),
              offset: const Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ],
            Image.asset(
              'assets/sahi.png',
              package: 'tradeable_learn_widget/lib',
            ),
            Text(
              'Academy',
              style: TextStyle(
                fontSize: 14,
                color: colors.secondary,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatChip(
                  icon: Icons.local_fire_department_rounded,
                  value: '$streakDays-day streak',
                  color: colors.sahiStreakColor,
                  iconColor: colors.sahiStreakIconColor,
                  textColor: colors.secondary,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  icon: Icons.bolt_rounded,
                  value: '${xp}XP',
                  color: colors.sahiXpColor,
                  iconColor: colors.sahiXpTextColor,
                  textColor: colors.sahiXpTextColor,
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onNotificationTap,
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Center(
                          child: Icon(
                            Icons.notifications_outlined,
                            size: 22,
                            color: colors.sahiNotificationIconColor,
                          ),
                        ),
                        if (unreadNotificationCount > 0)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(
                                minWidth: 8,
                                minHeight: 8,
                              ),
                              decoration: BoxDecoration(
                                color: colors.sahiNotificationBadgeColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onProfileTap,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.sahiProfileAvatarBg.withAlpha(60),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: profileImageUrl != null
                        ? Image.network(
                            profileImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              size: 20,
                              color: colors.sahiProfileIconColor,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 20,
                            color: colors.sahiProfileIconColor,
                          ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final Color iconColor;
  final Color textColor;
  final IconData icon;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.color,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
