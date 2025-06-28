import 'package:flutter/material.dart';
import 'package:wemotion_mobile/src/common/utils/app_colors/app_colors.dart';

class CircleWithFiveDirections extends StatelessWidget {
  const CircleWithFiveDirections({
    super.key,
    required this.pointNorth,
    required this.pointWest,
    required this.pointSouth,
    required this.pointEast,
  });
  final String pointNorth;
  final String pointWest;
  final String pointSouth;
  final String pointEast;

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
          pointNorth.isNotEmpty
              ? Positioned(
                  top: 0,
                  child: smallCircle(
                    color: AppColors.whiteColor,
                    label: pointNorth,
                  ),
                )
              : SizedBox(),

          // Bottom (South)
          pointSouth.isNotEmpty
              ? Positioned(
                  bottom: 0,
                  child: smallCircle(
                    color: AppColors.whiteColor,
                    label: pointSouth,
                  ),
                )
              : SizedBox(),

          // Left (West)
          pointWest.isNotEmpty
              ? Positioned(
                  left: 0,
                  child: smallCircle(
                    color: AppColors.whiteColor,
                    label: pointWest,
                  ),
                )
              : SizedBox(),

          // Right (East)
          pointEast.isNotEmpty
              ? Positioned(
                  right: 0,
                  child: smallCircle(
                    color: AppColors.whiteColor,
                    label: pointEast,
                  ),
                )
              : SizedBox(),

          // Middle Circle on top of the main one
          Container(
            width: middleCircleSize,
            height: middleCircleSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.pinkColor,
            ),
            alignment: Alignment.center,
            // child: const Text('M', style: TextStyle(color: Colors.white)),
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
