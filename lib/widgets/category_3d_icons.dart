import 'dart:math' as math;
import 'package:flutter/material.dart';

class Category3DIcon extends StatelessWidget {
  final String categoryId;
  final double size;

  const Category3DIcon({
    super.key,
    required this.categoryId,
    this.size = 52.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _Category3DPainter(categoryId: categoryId),
      ),
    );
  }
}

class _Category3DPainter extends CustomPainter {
  final String categoryId;

  _Category3DPainter({required this.categoryId});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    switch (categoryId) {
      case 'electrician':
        _drawElectricianBulb(canvas, w, h);
        break;
      case 'plumber':
        _drawPlumberTap(canvas, w, h);
        break;
      case 'carpenter':
        _drawCarpenterHammer(canvas, w, h);
        break;
      case 'mason':
        _drawMasonBricks(canvas, w, h);
        break;
      case 'painter':
        _drawPaintRoller(canvas, w, h);
        break;
      case 'ac_repair':
        _drawACUnit(canvas, w, h);
        break;
      case 'washing_machine':
        _drawWashingMachine(canvas, w, h);
        break;
      case 'refrigerator':
        _drawRefrigerator(canvas, w, h);
        break;
      case 'tv_repair':
        _drawSmartTV(canvas, w, h);
        break;
      case 'ro_repair':
        _drawROPurifier(canvas, w, h);
        break;
      case 'appliance_repair':
        _drawApplianceTools(canvas, w, h);
        break;
      case 'other':
      default:
        _drawOtherGrid(canvas, w, h);
        break;
    }
  }

  // 1. Electrician - 3D Glowing Light Bulb
  void _drawElectricianBulb(Canvas canvas, double w, double h) {
    // Ambient Soft Aura Glow
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFBBF24).withValues(alpha: 0.45),
          const Color(0xFFFDE68A).withValues(alpha: 0.15),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(w * 0.5, h * 0.42), radius: w * 0.48));
    canvas.drawCircle(Offset(w * 0.5, h * 0.42), w * 0.46, auraPaint);

    // Bulb Glass Body
    final bulbPath = Path();
    bulbPath.addOval(Rect.fromCircle(center: Offset(w * 0.5, h * 0.40), radius: w * 0.28));
    bulbPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.58), width: w * 0.32, height: h * 0.24),
      const Radius.circular(6),
    ));

    final bulbPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFBEB),
          Color(0xFFFDE047),
          Color(0xFFF59E0B),
          Color(0xFFD97706),
        ],
        stops: [0.0, 0.35, 0.75, 1.0],
      ).createShader(Rect.fromLTWH(w * 0.2, h * 0.12, w * 0.6, h * 0.6));
    canvas.drawPath(bulbPath, bulbPaint);

    // Inner Glowing Filament
    final filamentPaint = Paint()
      ..color = const Color(0xFFFEF08A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final filamentPath = Path();
    filamentPath.moveTo(w * 0.42, h * 0.46);
    filamentPath.lineTo(w * 0.46, h * 0.32);
    filamentPath.lineTo(w * 0.54, h * 0.32);
    filamentPath.lineTo(w * 0.58, h * 0.46);
    canvas.drawPath(filamentPath, filamentPaint);

    // Specular Highlight (Glass Sheen)
    final sheenPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.38, h * 0.30), width: w * 0.12, height: h * 0.18),
      sheenPaint,
    );

    // Metal Screw Base
    final basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFF334155),
          Color(0xFF64748B),
          Color(0xFF94A3B8),
          Color(0xFF1E293B),
        ],
      ).createShader(Rect.fromLTWH(w * 0.36, h * 0.70, w * 0.28, h * 0.20));

    for (int i = 0; i < 3; i++) {
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.37, h * (0.71 + i * 0.05), w * 0.26, h * 0.045),
        const Radius.circular(3),
      );
      canvas.drawRRect(rrect, basePaint);
    }

    // Base Contact Point
    final contactPaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawCircle(Offset(w * 0.5, h * 0.88), w * 0.06, contactPaint);
  }

  // 2. Plumber - 3D Blue Water Faucet Tap
  void _drawPlumberTap(Canvas canvas, double w, double h) {
    // Pipe back
    final pipePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF38BDF8), Color(0xFF0284C7), Color(0xFF0369A1)],
      ).createShader(Rect.fromLTWH(w * 0.15, h * 0.40, w * 0.25, h * 0.18));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.15, h * 0.40, w * 0.22, h * 0.16),
        const Radius.circular(5),
      ),
      pipePaint,
    );

    // Wall Mount Flange
    final flangePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0284C7), Color(0xFF075985)],
      ).createShader(Rect.fromLTWH(w * 0.14, h * 0.34, w * 0.08, h * 0.28));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.14, h * 0.34, w * 0.08, h * 0.28),
        const Radius.circular(4),
      ),
      flangePaint,
    );

    // Tap Curved Body
    final tapBodyPath = Path();
    tapBodyPath.moveTo(w * 0.32, h * 0.48);
    tapBodyPath.quadraticBezierTo(w * 0.65, h * 0.46, w * 0.68, h * 0.68);
    tapBodyPath.lineTo(w * 0.56, h * 0.70);
    tapBodyPath.quadraticBezierTo(w * 0.53, h * 0.56, w * 0.32, h * 0.56);
    tapBodyPath.close();

    final tapBodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF7DD3FC),
          Color(0xFF0EA5E9),
          Color(0xFF0284C7),
          Color(0xFF0369A1),
        ],
      ).createShader(Rect.fromLTWH(w * 0.3, h * 0.4, w * 0.45, h * 0.35));
    canvas.drawPath(tapBodyPath, tapBodyPaint);

    // Spout Nozzle Ring
    final nozzlePaint = Paint()..color = const Color(0xFF075985);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.54, h * 0.68, w * 0.16, h * 0.08),
        const Radius.circular(3),
      ),
      nozzlePaint,
    );

    // Top Handle / Valve Wheel
    final handlePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF60A5FA), Color(0xFF2563EB), Color(0xFF1E40AF)],
      ).createShader(Rect.fromLTWH(w * 0.40, h * 0.18, w * 0.26, h * 0.18));

    // Handle Wings
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.48, h * 0.25), width: w * 0.34, height: h * 0.10),
        const Radius.circular(5),
      ),
      handlePaint,
    );
    canvas.drawCircle(Offset(w * 0.48, h * 0.25), w * 0.09, handlePaint);

    // Handle Stem
    final stemPaint = Paint()..color = const Color(0xFF0369A1);
    canvas.drawRect(Rect.fromLTWH(w * 0.45, h * 0.29, w * 0.06, h * 0.14), stemPaint);

    // Gloss Highlight
    final tapSheen = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawArc(
      Rect.fromLTWH(w * 0.35, h * 0.45, w * 0.26, h * 0.20),
      -math.pi * 0.8,
      math.pi * 0.5,
      false,
      tapSheen,
    );
  }

  // 3. Carpenter - 3D Hammer
  void _drawCarpenterHammer(Canvas canvas, double w, double h) {
    canvas.save();
    canvas.translate(w * 0.5, h * 0.5);
    canvas.rotate(-math.pi * 0.22);
    canvas.translate(-w * 0.5, -h * 0.5);

    // Wooden Handle
    final handlePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFFFDBA74),
          Color(0xFFEA580C),
          Color(0xFFC2410C),
          Color(0xFF9A3412),
        ],
      ).createShader(Rect.fromLTWH(w * 0.42, h * 0.32, w * 0.16, h * 0.58));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.43, h * 0.32, w * 0.14, h * 0.56),
        const Radius.circular(7),
      ),
      handlePaint,
    );

    // Handle Grip Accent
    final gripPaint = Paint()..color = const Color(0xFF7C2D12);
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(w * 0.43, h * (0.68 + i * 0.05), w * 0.14, 2.0),
        gripPaint,
      );
    }

    // Hammer Steel Head
    final headPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFF1F5F9),
          Color(0xFF94A3B8),
          Color(0xFF475569),
          Color(0xFF1E293B),
        ],
      ).createShader(Rect.fromLTWH(w * 0.20, h * 0.16, w * 0.60, h * 0.20));

    // Striking Face (Right)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.40, h * 0.18, w * 0.36, h * 0.16),
        const Radius.circular(4),
      ),
      headPaint,
    );

    // Striking Cap
    final capPaint = Paint()..color = const Color(0xFF64748B);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.74, h * 0.17, w * 0.07, h * 0.18),
        const Radius.circular(3),
      ),
      capPaint,
    );

    // Claw Curve (Left)
    final clawPath = Path();
    clawPath.moveTo(w * 0.42, h * 0.19);
    clawPath.quadraticBezierTo(w * 0.26, h * 0.19, w * 0.20, h * 0.32);
    clawPath.lineTo(w * 0.26, h * 0.33);
    clawPath.quadraticBezierTo(w * 0.30, h * 0.26, w * 0.42, h * 0.26);
    clawPath.close();
    canvas.drawPath(clawPath, headPaint);

    canvas.restore();
  }

  // 4. Mason / Raj Mistri - 3D Stack of Bricks
  void _drawMasonBricks(Canvas canvas, double w, double h) {
    void drawBrick(double x, double y, double bw, double bh) {
      // Top 3D Face
      final topPaint = Paint()..color = const Color(0xFFFB923C);
      final topPath = Path();
      topPath.moveTo(x + 4, y);
      topPath.lineTo(x + bw, y);
      topPath.lineTo(x + bw - 4, y + 4);
      topPath.lineTo(x, y + 4);
      topPath.close();
      canvas.drawPath(topPath, topPaint);

      // Front Face
      final frontPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEA580C), Color(0xFFC2410C), Color(0xFF9A3412)],
        ).createShader(Rect.fromLTWH(x, y + 4, bw - 4, bh - 4));

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y + 4, bw - 4, bh - 4),
          const Radius.circular(3),
        ),
        frontPaint,
      );

      // Right 3D Face
      final rightPaint = Paint()..color = const Color(0xFF7C2D12);
      final rightPath = Path();
      rightPath.moveTo(x + bw - 4, y + 4);
      rightPath.lineTo(x + bw, y);
      rightPath.lineTo(x + bw, y + bh - 4);
      rightPath.lineTo(x + bw - 4, y + bh);
      rightPath.close();
      canvas.drawPath(rightPath, rightPaint);
    }

    // Row 1 (Top single brick)
    drawBrick(w * 0.35, h * 0.22, w * 0.32, h * 0.16);

    // Row 2 (Middle 2 bricks)
    drawBrick(w * 0.20, h * 0.41, w * 0.30, h * 0.16);
    drawBrick(w * 0.52, h * 0.41, w * 0.30, h * 0.16);

    // Row 3 (Bottom 3 bricks)
    drawBrick(w * 0.12, h * 0.60, w * 0.26, h * 0.16);
    drawBrick(w * 0.40, h * 0.60, w * 0.26, h * 0.16);
    drawBrick(w * 0.68, h * 0.60, w * 0.22, h * 0.16);
  }

  // 5. Painter - 3D Paint Roller
  void _drawPaintRoller(Canvas canvas, double w, double h) {
    // Roller Foam Cylinder
    final rollerPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFEF08A),
          Color(0xFFFBBF24),
          Color(0xFFF59E0B),
          Color(0xFFD97706),
        ],
      ).createShader(Rect.fromLTWH(w * 0.22, h * 0.22, w * 0.56, h * 0.20));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.22, h * 0.22, w * 0.56, h * 0.20),
        const Radius.circular(8),
      ),
      rollerPaint,
    );

    // Roller Highlight
    final sheen = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.26, h * 0.26), Offset(w * 0.74, h * 0.26), sheen);

    // Metal Frame Rod
    final rodPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF60A5FA), Color(0xFF2563EB), Color(0xFF1D4ED8)],
      ).createShader(Rect.fromLTWH(w * 0.20, h * 0.30, w * 0.60, h * 0.35))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final rodPath = Path();
    rodPath.moveTo(w * 0.22, h * 0.32);
    rodPath.lineTo(w * 0.18, h * 0.32);
    rodPath.lineTo(w * 0.18, h * 0.50);
    rodPath.lineTo(w * 0.50, h * 0.50);
    rodPath.lineTo(w * 0.50, h * 0.60);
    canvas.drawPath(rodPath, rodPaint);

    // Purple Handle Grip
    final handlePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFFA855F7), Color(0xFF7E22CE), Color(0xFF581C87)],
      ).createShader(Rect.fromLTWH(w * 0.44, h * 0.60, w * 0.12, h * 0.26));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.44, h * 0.60, w * 0.12, h * 0.26),
        const Radius.circular(5),
      ),
      handlePaint,
    );
  }

  // 6. AC Repair - 3D Split AC Unit
  void _drawACUnit(Canvas canvas, double w, double h) {
    // Main AC Body
    final acPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9), Color(0xFFCBD5E1)],
      ).createShader(Rect.fromLTWH(w * 0.10, h * 0.30, w * 0.80, h * 0.36));

    final acRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.10, h * 0.30, w * 0.80, h * 0.36),
      const Radius.circular(8),
    );

    // Shadow
    canvas.drawRRect(
      acRect.shift(const Offset(0, 3)),
      Paint()..color = Colors.black.withValues(alpha: 0.10),
    );
    canvas.drawRRect(acRect, acPaint);

    // Louver / Vent Line (Bottom)
    final ventPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(w * 0.14, h * 0.56), Offset(w * 0.86, h * 0.56), ventPaint);

    // Digital LED Display (Right)
    final ledPaint = Paint()..color = const Color(0xFF0284C7);
    canvas.drawCircle(Offset(w * 0.78, h * 0.44), 3.0, ledPaint);

    // Brand Line (Center)
    final brandPaint = Paint()..color = const Color(0xFFCBD5E1);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.48, h * 0.44), width: w * 0.16, height: 2.0),
        const Radius.circular(1),
      ),
      brandPaint,
    );

    // Soft Breeze Waves (Bottom Glow)
    final breezePaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final breezePath1 = Path();
    breezePath1.moveTo(w * 0.28, h * 0.72);
    breezePath1.quadraticBezierTo(w * 0.38, h * 0.78, w * 0.48, h * 0.74);
    canvas.drawPath(breezePath1, breezePaint);

    final breezePath2 = Path();
    breezePath2.moveTo(w * 0.54, h * 0.74);
    breezePath2.quadraticBezierTo(w * 0.64, h * 0.78, w * 0.74, h * 0.72);
    canvas.drawPath(breezePath2, breezePaint);
  }

  // 7. Washing Machine - 3D Modern Machine
  void _drawWashingMachine(Canvas canvas, double w, double h) {
    // Body
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFBAE6FD), Color(0xFF38BDF8), Color(0xFF0284C7)],
      ).createShader(Rect.fromLTWH(w * 0.20, h * 0.16, w * 0.60, h * 0.68));

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.20, h * 0.16, w * 0.60, h * 0.68),
      const Radius.circular(10),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    // Top Panel Drawer & Dial
    final panelPaint = Paint()..color = const Color(0xFF075985);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.25, h * 0.22, w * 0.22, h * 0.08),
        const Radius.circular(3),
      ),
      panelPaint,
    );
    canvas.drawCircle(Offset(w * 0.68, h * 0.26), 4.5, panelPaint);

    // Drum Glass Door (Outer Ring)
    final doorOuterPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFE2E8F0), Color(0xFF64748B), Color(0xFF1E293B)],
      ).createShader(Rect.fromCircle(center: Offset(w * 0.50, h * 0.55), radius: w * 0.20));

    canvas.drawCircle(Offset(w * 0.50, h * 0.55), w * 0.20, doorOuterPaint);

    // Drum Glass (Inner Blue Reflection)
    final doorInnerPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF67E8F9), Color(0xFF0369A1), Color(0xFF082F49)],
      ).createShader(Rect.fromCircle(center: Offset(w * 0.50, h * 0.55), radius: w * 0.15));

    canvas.drawCircle(Offset(w * 0.50, h * 0.55), w * 0.15, doorInnerPaint);

    // Door Glass Highlight
    final sheenPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(w * 0.50, h * 0.55), radius: w * 0.11),
      -math.pi * 0.7,
      math.pi * 0.6,
      false,
      sheenPaint,
    );
  }

  // 8. Refrigerator - 3D Double Door Fridge
  void _drawRefrigerator(Canvas canvas, double w, double h) {
    final fridgePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF8FAFC), Color(0xFFCBD5E1), Color(0xFF94A3B8)],
      ).createShader(Rect.fromLTWH(w * 0.24, h * 0.15, w * 0.52, h * 0.70));

    final fridgeRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.24, h * 0.15, w * 0.52, h * 0.70),
      const Radius.circular(8),
    );
    canvas.drawRRect(fridgeRect, fridgePaint);

    // Top / Bottom Door Split Divider
    final dividerPaint = Paint()
      ..color = const Color(0xFF475569)
      ..strokeWidth = 1.8;
    canvas.drawLine(Offset(w * 0.24, h * 0.42), Offset(w * 0.76, h * 0.42), dividerPaint);

    // Freezer Handle
    final handlePaint = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.28, h * 0.32, 3.5, h * 0.08),
        const Radius.circular(2),
      ),
      handlePaint,
    );

    // Main Door Handle
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.28, h * 0.46, 3.5, h * 0.18),
        const Radius.circular(2),
      ),
      handlePaint,
    );

    // Metallic Sheen
    final sheen = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(w * 0.68, h * 0.18), Offset(w * 0.68, h * 0.80), sheen);
  }

  // 9. TV Repair - 3D Smart TV
  void _drawSmartTV(Canvas canvas, double w, double h) {
    // TV Frame
    final framePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF334155), Color(0xFF0F172A)],
      ).createShader(Rect.fromLTWH(w * 0.12, h * 0.20, w * 0.76, h * 0.50));

    final frameRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, h * 0.20, w * 0.76, h * 0.50),
      const Radius.circular(6),
    );
    canvas.drawRRect(frameRect, framePaint);

    // TV Screen (Vibrant OLED Blue Glow)
    final screenPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF60A5FA), Color(0xFF3B82F6), Color(0xFF1D4ED8)],
      ).createShader(Rect.fromLTWH(w * 0.15, h * 0.23, w * 0.70, h * 0.44));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.15, h * 0.23, w * 0.70, h * 0.44),
        const Radius.circular(4),
      ),
      screenPaint,
    );

    // Screen Reflection / Flare
    final flarePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    final flarePath = Path();
    flarePath.moveTo(w * 0.15, h * 0.23);
    flarePath.lineTo(w * 0.45, h * 0.23);
    flarePath.lineTo(w * 0.15, h * 0.55);
    flarePath.close();
    canvas.drawPath(flarePath, flarePaint);

    // Stand Stem & Base
    final standPaint = Paint()..color = const Color(0xFF1E293B);
    canvas.drawRect(Rect.fromLTWH(w * 0.46, h * 0.70, w * 0.08, h * 0.08), standPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.35, h * 0.77, w * 0.30, h * 0.045),
        const Radius.circular(3),
      ),
      standPaint,
    );
  }

  // 10. RO Repair - 3D Water Purifier
  void _drawROPurifier(Canvas canvas, double w, double h) {
    // Machine Body
    final roPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF93C5FD), Color(0xFF3B82F6), Color(0xFF1D4ED8)],
      ).createShader(Rect.fromLTWH(w * 0.22, h * 0.18, w * 0.56, h * 0.64));

    final roRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.22, h * 0.18, w * 0.56, h * 0.64),
      const Radius.circular(10),
    );
    canvas.drawRRect(roRect, roPaint);

    // Top Display & Logo
    final topPanelPaint = Paint()..color = const Color(0xFF1E3A8A);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.28, h * 0.24, w * 0.44, h * 0.10),
        const Radius.circular(4),
      ),
      topPanelPaint,
    );
    canvas.drawCircle(Offset(w * 0.64, h * 0.29), 2.5, Paint()..color = const Color(0xFF22C55E));

    // Transparent Bottom Water Tank
    final tankPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF60A5FA).withValues(alpha: 0.8),
          const Color(0xFF1E40AF).withValues(alpha: 0.9),
        ],
      ).createShader(Rect.fromLTWH(w * 0.28, h * 0.46, w * 0.44, h * 0.30));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.28, h * 0.46, w * 0.44, h * 0.30),
        const Radius.circular(6),
      ),
      tankPaint,
    );

    // Water Tap
    final tapPaint = Paint()..color = const Color(0xFFF1F5F9);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.46, h * 0.54, w * 0.08, h * 0.12),
        const Radius.circular(2),
      ),
      tapPaint,
    );
  }

  // 11. Appliance Repair - 3D Crossed Tools (Wrench + Screwdriver)
  void _drawApplianceTools(Canvas canvas, double w, double h) {
    // 1st Tool: Wrench (Slanted)
    canvas.save();
    canvas.translate(w * 0.5, h * 0.5);
    canvas.rotate(math.pi * 0.25);
    canvas.translate(-w * 0.5, -h * 0.5);

    final wrenchPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFFCBD5E1), Color(0xFF64748B), Color(0xFF334155)],
      ).createShader(Rect.fromLTWH(w * 0.42, h * 0.15, w * 0.16, h * 0.70));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.44, h * 0.25, w * 0.12, h * 0.50),
        const Radius.circular(4),
      ),
      wrenchPaint,
    );

    // Wrench Head (Top)
    final headPath = Path();
    headPath.addOval(Rect.fromCircle(center: Offset(w * 0.50, h * 0.22), radius: w * 0.15));
    canvas.drawPath(headPath, wrenchPaint);

    // Cutout in wrench head
    canvas.drawRect(
      Rect.fromCenter(center: Offset(w * 0.50, h * 0.16), width: w * 0.10, height: h * 0.14),
      Paint()..blendMode = BlendMode.clear,
    );

    canvas.restore();

    // 2nd Tool: Screwdriver (Opposite Slant)
    canvas.save();
    canvas.translate(w * 0.5, h * 0.5);
    canvas.rotate(-math.pi * 0.25);
    canvas.translate(-w * 0.5, -h * 0.5);

    // Steel Shaft
    final shaftPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFF1F5F9), Color(0xFF64748B)],
      ).createShader(Rect.fromLTWH(w * 0.46, h * 0.15, w * 0.08, h * 0.40));
    canvas.drawRect(Rect.fromLTWH(w * 0.47, h * 0.15, w * 0.06, h * 0.38), shaftPaint);

    // Tip
    final tipPaint = Paint()..color = const Color(0xFF334155);
    canvas.drawRect(Rect.fromLTWH(w * 0.48, h * 0.12, w * 0.04, h * 0.04), tipPaint);

    // Handle
    final toolHandlePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF94A3B8), Color(0xFF475569), Color(0xFF1E293B)],
      ).createShader(Rect.fromLTWH(w * 0.42, h * 0.50, w * 0.16, h * 0.35));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.43, h * 0.50, w * 0.14, h * 0.35),
        const Radius.circular(5),
      ),
      toolHandlePaint,
    );

    canvas.restore();
  }

  // 12. Other - 3D 4-Dots Grid
  void _drawOtherGrid(Canvas canvas, double w, double h) {
    final dotPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF64748B),
          Color(0xFF475569),
          Color(0xFF1E293B),
        ],
      ).createShader(Rect.fromLTWH(w * 0.2, h * 0.2, w * 0.6, h * 0.6));

    final double dotRadius = w * 0.11;
    final List<Offset> positions = [
      Offset(w * 0.35, h * 0.35),
      Offset(w * 0.65, h * 0.35),
      Offset(w * 0.35, h * 0.65),
      Offset(w * 0.65, h * 0.65),
    ];

    for (final pos in positions) {
      // Soft ambient shadow
      canvas.drawCircle(
        pos.translate(0, 2),
        dotRadius,
        Paint()..color = Colors.black.withValues(alpha: 0.15),
      );
      // Main 3D Sphere
      canvas.drawCircle(pos, dotRadius, dotPaint);

      // Specular highlight dot
      canvas.drawCircle(
        pos.translate(-2, -2),
        dotRadius * 0.35,
        Paint()..color = Colors.white.withValues(alpha: 0.55),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
