import 'package:flutter/material.dart';
import '../theme/argus_colors.dart';

class ArgusCard extends StatelessWidget {
  const ArgusCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>();
    final defaultBg = colors?.panelBackground ?? Colors.white;
    final defaultBorder = colors?.panelBorder ?? Colors.grey;

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: borderColor ?? defaultBorder,
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }
}

class ArgusPanel extends StatelessWidget {
  const ArgusPanel({
    super.key,
    required this.child,
    this.header,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.backgroundColor,
    this.borderColor,
  });

  final Widget child;
  final Widget? header;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>();
    final defaultBg = colors?.panelBackground ?? Colors.white;
    final defaultBorder = colors?.panelBorder ?? Colors.grey;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: borderColor ?? defaultBorder,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: borderColor ?? defaultBorder,
                    width: 1,
                  ),
                ),
              ),
              child: DefaultTextStyle.merge(
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors?.textPrimary,
                    ),
                child: header!,
              ),
            ),
          ],
          Padding(
            padding: padding,
            child: child,
          ),
        ],
      ),
    );
  }
}
