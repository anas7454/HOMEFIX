import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final Widget? bottom;
  final double bottomHeight;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool showDefaultActions;

  final bool showBackButton;

  const CustomAppBar({
    Key? key,
    this.title = '',
    this.titleWidget,
    this.bottom,
    this.bottomHeight = 0,
    this.actions,
    this.onBackPressed,
    this.showDefaultActions = true,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF8EE), // Cream
            Color(0xFFFFD180), // Soft Orange
            Color(0xFFFF7043), // HomeFix Deep Orange
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Soft Wave Effect Background
            Positioned.fill(
              child: CustomPaint(
                painter: _WavePainter(),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                    children: [
                      if (showBackButton)
                        // Circular Back Button
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF001F3F), size: 18), // Navy
                            onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
                          ),
                        )
                      else
                        const SizedBox(width: 16),
                      const SizedBox(width: 16),
                      // Title
                      Expanded(
                        child: titleWidget ?? Text(
                          title,
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF001F3F), // Navy color
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Actions (Default Calendar + More)
                      if (actions != null) 
                        ...actions!
                      else if (showDefaultActions) ...[
                        IconButton(
                          icon: const Icon(Icons.calendar_month, color: Color(0xFF001F3F)),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert, color: Color(0xFF001F3F)),
                          onPressed: () {},
                        ),
                      ],
                    ],
                  ),
                ),
                ),
                if (bottom != null) bottom!,
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + bottomHeight);
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.5, 
      size.width * 0.5, size.height * 0.3
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.1, 
      size.width, size.height * 0.3
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
