import 'package:budget/struct/settings.dart';
import 'package:budget/motion.dart';
import 'package:flutter/material.dart';

class AnimatedExpanded extends StatefulWidget {
  const AnimatedExpanded({
    this.expand = false,
    required this.child,
    this.duration = AppMotion.standard,
    this.sizeCurve = Curves.easeOutCubic,
    this.axis = Axis.vertical,
    super.key,
  });

  final Widget child;
  final bool expand;
  final Duration duration;
  final Curve sizeCurve;
  final Axis axis;

  @override
  State<AnimatedExpanded> createState() => _AnimatedExpandedState();
}

class _AnimatedExpandedState extends State<AnimatedExpanded>
    with SingleTickerProviderStateMixin {
  late final AnimationController expandController;
  late Animation<double> sizeAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    expandController = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.expand ? 1 : 0,
    );
    _configureCurves();
  }

  void _configureCurves() {
    sizeAnimation = expandController.drive(CurveTween(curve: widget.sizeCurve));
    fadeAnimation = expandController.drive(CurveTween(curve: Curves.easeOut));
  }

  void _updateAnimation() {
    expandController.duration = AppMotion.resolve(context, widget.duration,
        enabled: appStateSettings["batterySaver"] != true &&
            appStateSettings["appAnimations"] != 2);
    if (expandController.duration == Duration.zero) {
      expandController.value = widget.expand ? 1 : 0;
    } else if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateAnimation();
  }

  @override
  void didUpdateWidget(covariant AnimatedExpanded oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sizeCurve != widget.sizeCurve) _configureCurves();
    _updateAnimation();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SizeTransition(
        axis: widget.axis,
        axisAlignment: 1,
        sizeFactor: sizeAnimation,
        child: widget.child,
      ),
    );
  }
}

class AnimatedSizeSwitcher extends StatelessWidget {
  const AnimatedSizeSwitcher({
    required this.child,
    this.sizeCurve = Curves.easeOutCubic,
    this.sizeDuration = AppMotion.chart,
    this.switcherDuration = AppMotion.quick,
    this.sizeAlignment = AlignmentDirectional.center,
    this.clipBehavior = Clip.hardEdge,
    this.enabled = true,
    super.key,
  });

  final Widget child;
  final Curve sizeCurve;
  final Duration sizeDuration;
  final Duration switcherDuration;
  final AlignmentDirectional sizeAlignment;
  final Clip clipBehavior;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.resolve(context, sizeDuration,
        enabled: enabled &&
            appStateSettings["batterySaver"] != true &&
            appStateSettings["appAnimations"] != 2);
    if (duration == Duration.zero) return child;
    return AnimatedSize(
      clipBehavior: clipBehavior,
      duration: duration,
      curve: sizeCurve,
      alignment: sizeAlignment,
      child: AnimatedSwitcher(
        duration: switcherDuration,
        child: child,
      ),
    );
  }
}
