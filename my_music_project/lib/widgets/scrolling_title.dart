import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class ScrollingTitle extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const ScrollingTitle({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Marquee(
        text: text,
        style: style ?? Theme.of(context).textTheme.headlineSmall,
        scrollAxis: Axis.horizontal,
        blankSpace: 40.0,
        velocity: 30.0,
        startPadding: 8.0,
        pauseAfterRound: const Duration(seconds: 1),
        fadingEdgeStartFraction: 0.1,
        fadingEdgeEndFraction: 0.1,
        showFadingOnlyWhenScrolling: true,
      ),
    );
  }
}