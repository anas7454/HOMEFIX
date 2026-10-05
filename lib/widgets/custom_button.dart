import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';
import '../app/theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final double? width;
  final double height;
  final IconData? icon;
  final double borderRadius;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.width,
    this.height = 40.0,
    this.icon,
    this.borderRadius = 20.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = backgroundColor ?? AppColors.primaryOrange;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: effectiveColor.withValues(alpha: 0.35),
            blurRadius: 12.0,
            spreadRadius: 0.0,
            offset: const Offset(0, 4.0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 18.0,
                    width: 18.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        text,
                        style: textStyle ??
                            const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                      ),
                      if (icon != null) ...[
                        const SizedBox(width: 6.0),
                        Icon(
                          icon,
                          color: Colors.white,
                          size: 18.0,
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

