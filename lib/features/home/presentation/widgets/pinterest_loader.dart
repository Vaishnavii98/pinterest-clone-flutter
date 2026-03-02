import 'dart:math';
import 'package:flutter/material.dart';

class PinterestLoader extends StatefulWidget {
  const PinterestLoader({super.key, this.size = 40});

  final double size;

  @override
  State<PinterestLoader> createState() => _PinterestLoaderState();
}

class _PinterestLoaderState extends State<PinterestLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: List.generate(4, (index) {
              final angle =
                  (_controller.value * 2 * pi) + (index * pi / 2);

              return Transform.translate(
                offset: Offset(
                  cos(angle) * (widget.size / 3),
                  sin(angle) * (widget.size / 3),
                ),
                child: Container(
                  height: widget.size / 6,
                  width: widget.size / 6,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}