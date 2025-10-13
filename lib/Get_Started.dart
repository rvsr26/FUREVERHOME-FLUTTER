import 'dart:math';
import 'package:flutter/material.dart';
import 'login_Page.dart';
import 'dart:ui';

class Started extends StatelessWidget {
  const Started({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome',
          style: TextStyle(
            fontFamily: "Boyers",
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 4,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0E4839),
      ),
      body: Stack(
        children: [
          // Vibrant background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFE0B2),
                    Color(0xFFFFCC80),
                    Color(0xFFF6FFF8),
                    Color(0xFFD6EADF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // Layered paw icons
          Positioned.fill(child: CustomPaint(painter: PawBackgroundPainter())),
          // Glassmorphism card with content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 36,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.82),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.08),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.orange.shade100,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Hero pet illustration
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.18),
                                blurRadius: 32,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Image.asset("assets/unnamed.png", height: 180),
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          "Welcome to FurEver Home!",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0E4839),
                            fontFamily: "Boyers",
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Find, adopt, and care for your perfect pet companion.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          "All your pet’s needs in one beautiful app.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            style:
                                ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  elevation: 8,
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ).copyWith(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                        (states) => null,
                                      ),
                                  foregroundColor: MaterialStateProperty.all(
                                    Colors.white,
                                  ),
                                  elevation: MaterialStateProperty.all(8),
                                ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFEF6C00),
                                    Color(0xFFFF9800),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                constraints: const BoxConstraints(
                                  minHeight: 48,
                                ),
                                child: const Text(
                                  "Get Started",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🎨 Custom Painter for spaced paw icons
class PawBackgroundPainter extends CustomPainter {
  final Random _random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < 10; i++) {
      final dx = _random.nextDouble() * size.width;
      final dy = (i * size.height / 10) + _random.nextDouble() * 40;

      // ✅ Random rotation
      final angle = _random.nextDouble() * pi / 2 - pi / 4;

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(angle);

      textPainter.text = TextSpan(
        text: String.fromCharCode(Icons.pets.codePoint),
        style: TextStyle(
          fontSize: 50,
          fontFamily: Icons.pets.fontFamily,
          package: Icons.pets.fontPackage,
          color: Colors.black.withOpacity(0.08),
        ),
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset.zero);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
