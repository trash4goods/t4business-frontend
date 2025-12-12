// core/widgets/animated_world_map.dart
import 'package:flutter/material.dart';

class AnimatedWorldMap extends StatefulWidget {
  const AnimatedWorldMap({super.key});

  @override
  State<AnimatedWorldMap> createState() => _AnimatedWorldMapState();
}

class _AnimatedWorldMapState extends State<AnimatedWorldMap>
    with TickerProviderStateMixin {
  late AnimationController _routeAnimationController;
  late AnimationController _pulseAnimationController;

  final List<MapRoute> _routes = [
    MapRoute(
      start: const Offset(0.15, 0.3),
      end: const Offset(0.35, 0.2),
      delay: 0,
      color: const Color(0xFF065930),
    ),
    MapRoute(
      start: const Offset(0.35, 0.2),
      end: const Offset(0.5, 0.25),
      delay: 2,
      color: const Color(0xFF065930),
    ),
    MapRoute(
      start: const Offset(0.1, 0.15),
      end: const Offset(0.3, 0.45),
      delay: 1,
      color: const Color(0xFF065930),
    ),
    MapRoute(
      start: const Offset(0.6, 0.15),
      end: const Offset(0.4, 0.45),
      delay: 0.5,
      color: const Color(0xFF065930),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimationControllers();
    _startAnimations();
  }

  void _setupAnimationControllers() {
    _routeAnimationController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );

    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _routeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _routeAnimationController.reset();
        _routeAnimationController.forward();
      }
    });

    _pulseAnimationController.repeat();
  }

  void _startAnimations() {
    _routeAnimationController.forward();
  }

  @override
  void dispose() {
    _routeAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFAF5E5), // Light blue
            Color(0xFFFAF5E5), // Light indigo
          ],
        ),
      ),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _routeAnimationController,
          _pulseAnimationController,
        ]),
        builder: (context, child) {
          return CustomPaint(
            painter: WorldMapPainter(
              routeProgress: _routeAnimationController.value,
              pulseAnimation: _pulseAnimationController.value,
              routes: _routes,
            ),
          );
        },
      ),
    );
  }
}

class MapRoute {
  final Offset start;
  final Offset end;
  final double delay;
  final Color color;

  MapRoute({
    required this.start,
    required this.end,
    required this.delay,
    required this.color,
  });
}

class WorldMapPainter extends CustomPainter {
  final double routeProgress;
  final double pulseAnimation;
  final List<MapRoute> routes;

  WorldMapPainter({
    required this.routeProgress,
    required this.pulseAnimation,
    required this.routes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawWorldMapDots(canvas, size);
    _drawAnimatedRoutes(canvas, size);
  }

  void _drawWorldMapDots(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF065930).withOpacity(0.4)
          ..style = PaintingStyle.fill;

    const double dotRadius = 1.0;
    const double gap = 12.0;

    for (double x = 0; x < size.width; x += gap) {
      for (double y = 0; y < size.height; y += gap) {
        final normalizedX = x / size.width;
        final normalizedY = y / size.height;

        if (_isInMapShape(normalizedX, normalizedY)) {
          canvas.drawCircle(Offset(x, y), dotRadius, paint);
        }
      }
    }
  }

  bool _isInMapShape(double x, double y) {
    // Simple continent shapes
    return (
    // North America
    ((x < 0.25 && x > 0.05) && (y < 0.4 && y > 0.1)) ||
        // South America
        ((x < 0.25 && x > 0.15) && (y < 0.8 && y > 0.4)) ||
        // Europe
        ((x < 0.45 && x > 0.3) && (y < 0.35 && y > 0.15)) ||
        // Africa
        ((x < 0.5 && x > 0.35) && (y < 0.65 && y > 0.35)) ||
        // Asia
        ((x < 0.7 && x > 0.45) && (y < 0.5 && y > 0.1)) ||
        // Australia
        ((x < 0.8 && x > 0.65) && (y < 0.8 && y > 0.6)));
  }

  void _drawAnimatedRoutes(Canvas canvas, Size size) {
    final currentTime = routeProgress * 15; // Total animation time in seconds

    for (final route in routes) {
      final elapsed = currentTime - route.delay;
      if (elapsed <= 0) continue;

      const duration = 3.0; // Route animation duration
      final progress = (elapsed / duration).clamp(0.0, 1.0);

      final startPoint = Offset(
        route.start.dx * size.width,
        route.start.dy * size.height,
      );
      final endPoint = Offset(
        route.end.dx * size.width,
        route.end.dy * size.height,
      );
      final currentPoint = Offset.lerp(startPoint, endPoint, progress)!;

      // Draw route line
      final linePaint =
          Paint()
            ..color = route.color
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke;
      canvas.drawLine(startPoint, currentPoint, linePaint);

      // Draw start point
      final startPaint =
          Paint()
            ..color = route.color
            ..style = PaintingStyle.fill;
      canvas.drawCircle(startPoint, 3, startPaint);

      // Draw static moving point (removed pulse animation)
      final pointPaint =
          Paint()
            ..color = const Color(0xFF065930)
            ..style = PaintingStyle.fill;
      canvas.drawCircle(currentPoint, 3, pointPaint);

      // Draw end point if route is complete
      if (progress >= 1.0) {
        canvas.drawCircle(endPoint, 3, startPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
