import 'package:beamify_app/shared/utils/app_theme.dart';
import 'package:flutter/material.dart';

class Seek extends StatefulWidget {
  final bool seekAble;
  const Seek({super.key, this.seekAble = true});

  @override
  State<Seek> createState() => _SeekState();
}

class _SeekState extends State<Seek> {
  double currentSeekPosition = 10;
  double finalSeekPosition = 30;
  double maxSeekWidth = 0;

  void updateDrag(DragUpdateDetails details) {
    if (!widget.seekAble) return;
    print("max $maxSeekWidth");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "22:33",
          style: AppTheme.bodyText,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            double overlayWidth = (currentSeekPosition / finalSeekPosition) *
                constraints.maxWidth;

            maxSeekWidth = constraints.maxWidth;

            return GestureDetector(
                // behavior: HitTestBehavior.opaque,
                // onHorizontalDragStart: (details) => print(details.localPosition),
                onHorizontalDragUpdate: updateDrag,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.black.withOpacity(0.2),
                  child: Stack(
                    children: [
                      Container(
                        width: constraints.maxWidth,
                        height: 6,
                        decoration: const ShapeDecoration(
                            color: Colors.white, shape: StadiumBorder()),
                      ),
                      Container(
                        width: overlayWidth,
                        height: 6,
                        decoration: const ShapeDecoration(
                            color: AppTheme.primaryColor,
                            shape: StadiumBorder()),
                      ),
                      // ),
                    ],
                  ),
                ));
          }),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          "45:33",
          style: AppTheme.bodyText,
        ),
      ],
    );
  }
}
