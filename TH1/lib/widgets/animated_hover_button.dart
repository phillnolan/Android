import 'package:flutter/material.dart';

class AnimatedHoverButton extends StatefulWidget {
  const AnimatedHoverButton({
    super.key,
    required this.child,
    this.scaleFactor = 1.03, // Default scale factor for hover
    this.duration = const Duration(milliseconds: 200),
  });

  final Widget child;
  final double scaleFactor;
  final Duration duration;

  @override
  State<AnimatedHoverButton> createState() => _AnimatedHoverButtonState();
}

class _AnimatedHoverButtonState extends State<AnimatedHoverButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedScale(
        scale: _isHovering ? widget.scaleFactor : 1.0,
        duration: widget.duration,
        child: widget.child,
      ),
    );
  }
}
