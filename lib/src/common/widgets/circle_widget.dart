import 'package:flutter/material.dart';
import 'package:wemotion_mobile/src/common/utils/app_colors/app_colors.dart';

class CircleWithFiveDirections extends StatelessWidget {
  const CircleWithFiveDirections({
    super.key,
    required this.pointNorth,
    required this.pointWest,
    required this.pointSouth,
    required this.pointEast,
    required this.mainCircleColor,
  });
  final int pointNorth;
  final int pointWest;
  final int pointSouth;
  final int pointEast;
  final Color? mainCircleColor;

  @override
  Widget build(BuildContext context) {
    double mainCircleSize = 20;
    double smallCircleSize = 20;
    double middleCircleSize = 20;

    return SizedBox(
      width: mainCircleSize + smallCircleSize * 2,
      height: mainCircleSize + smallCircleSize * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main Central Circle
          Container(
            width: 15,
            height: 15,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            alignment: Alignment.center,
          ),

          // Top (North)
          pointNorth > 0
              ? Positioned(
                  top: 0,
                  child: smallCircle(
                    color: AppColors.whiteColor,
                    label: pointNorth.toString(),
                  ),
                )
              : SizedBox(),

          // Bottom (South)
          pointSouth > 0
              ? Positioned(
                  bottom: 0,
                  child: smallCircle(
                    color: AppColors.whiteColor,
                    label: pointSouth.toString(),
                  ),
                )
              : SizedBox(),

          // Left (West)
          pointWest > 0
              ? Positioned(
                  left: 0,
                  child: smallCircle(
                    color: AppColors.whiteColor,
                    label: pointWest.toString(),
                  ),
                )
              : SizedBox(),

          // Right (East)
          pointEast > 0
              ? Positioned(
                  right: 0,
                  child: smallCircle(
                    color: AppColors.whiteColor,
                    label: pointEast.toString(),
                  ),
                )
              : SizedBox(),

          // Middle Circle on top of the main one
          Container(
            width: middleCircleSize,
            height: middleCircleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mainCircleColor,
            ),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }

  Widget smallCircle({required Color color, String? label}) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      alignment: Alignment.center,
      child: Text(
        label ?? '',
        style: const TextStyle(
          color: AppColors.blackColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
