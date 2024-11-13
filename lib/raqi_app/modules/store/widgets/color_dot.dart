import 'package:flutter/material.dart';
import 'package:nafith/raqi_app/app/global/styles/colors.dart';
import 'package:nafith/raqi_app/modules/store/widgets/check_mark.dart';
import 'package:nafith/raqi_app/shared/components/constants.dart';

class ColorDot extends StatelessWidget {
  const ColorDot({
    super.key,
    required this.color,
    this.isActive = false,
    this.press,
  });
  final Color color;
  final bool isActive;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: AnimatedContainer(
        duration: defaultDuration,
        padding: EdgeInsets.all(isActive ? defaultPadding / 4 : 0),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              Border.all(color: isActive ? ColorRaqi.purple100 : Colors.transparent),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color,
            ),
            AnimatedOpacity(
              opacity: isActive ? 1 : 0,
              duration: defaultDuration,
              child: const CheckMark(),
            ),
          ],
        ),
      ),
    );
  }
}
