// core/widgets/google_sign_in_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:t4g_for_business/core/app/app_images.dart';
import '../app/themes/app_colors.dart';

class GoogleSignInButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleSignInButton({super.key, this.onPressed, this.isLoading = false});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: MouseRegion(
          onEnter: (_) => _onHover(true),
          onExit: (_) => _onHover(false),
          child: AnimatedBuilder(
            animation: _hoverController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        _isHovered
                            ? const Color(0xFFF1F5F9)
                            : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.lightBorder, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.isLoading ? null : widget.onPressed,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.isLoading)
                              const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.lightTextSecondary,
                                  ),
                                ),
                              )
                            else
                              _buildGoogleIcon(),
                            const SizedBox(width: 12),
                            Text(
                              widget.isLoading
                                  ? 'Signing in...'
                                  : 'Login with Google',
                              style: const TextStyle(
                                color: AppColors.lightTextPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return SvgPicture.asset(
      AppImages.googleIcon,
      height: 20,
      width: 20,
      fit: BoxFit.fill,
    );
  }
}

class GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Google "G" icon recreation

    // Blue
    paint.color = const Color(0xFF4285F4);
    canvas.drawPath(
      Path()
        ..moveTo(size.width, size.height * 0.5)
        ..lineTo(size.width * 0.5, size.height * 0.5)
        ..lineTo(size.width * 0.5, size.height * 0.75)
        ..lineTo(size.width * 0.77, size.height * 0.75)
        ..arcToPoint(
          Offset(size.width, size.height * 0.5),
          radius: const Radius.circular(2),
        ),
      paint,
    );

    // Green
    paint.color = const Color(0xFF34A853);
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * 0.5)
        ..lineTo(0, size.height * 0.75)
        ..arcToPoint(
          Offset(size.width * 0.5, size.height),
          radius: Radius.circular(size.width * 0.5),
        )
        ..lineTo(size.width * 0.5, size.height * 0.5),
      paint,
    );

    // Yellow
    paint.color = const Color(0xFFFBBC05);
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * 0.5)
        ..lineTo(size.width * 0.5, size.height * 0.5)
        ..lineTo(size.width * 0.5, 0)
        ..arcToPoint(
          Offset(0, size.height * 0.25),
          radius: Radius.circular(size.width * 0.5),
        ),
      paint,
    );

    // Red
    paint.color = const Color(0xFFEA4335);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.5, 0)
        ..arcToPoint(
          Offset(size.width, size.height * 0.5),
          radius: Radius.circular(size.width * 0.5),
        )
        ..lineTo(size.width * 0.77, size.height * 0.25)
        ..arcToPoint(
          Offset(size.width * 0.5, 0),
          radius: const Radius.circular(2),
        ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
