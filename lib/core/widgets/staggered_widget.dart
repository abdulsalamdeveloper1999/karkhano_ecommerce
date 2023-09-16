import 'package:flutter/material.dart';

class StaggeredDualView extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final double spacing;
  final double mainAxisSpacing;
  final double aspectRatio;

  const StaggeredDualView({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.spacing = 0.0,
    this.aspectRatio = 0.5,
    this.mainAxisSpacing = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width = constraints.maxWidth;

        final itemHight = (width * 0.3) / aspectRatio;
        // final height = constraints.maxHeight + itemHight;
        return GridView.builder(
          padding: EdgeInsets.only(top: itemHight / 80, bottom: itemHight),
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: spacing,
          ),
          itemBuilder: (context, index) {
            return Transform.translate(
              offset: Offset(
                0.0,
                index.isOdd ? itemHight * 0.15 : 0.0,
              ),
              child: itemBuilder(context, index),
            );
          },
        );
      },
    );
  }
}
