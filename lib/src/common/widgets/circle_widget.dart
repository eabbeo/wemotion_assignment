import 'package:flutter/material.dart';
import 'package:wemotion_mobile/src/common/utils/app_colors/app_colors.dart';

class CircleWithFiveDirections extends StatelessWidget {
  const CircleWithFiveDirections({super.key});

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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              // color: Colors.blue,
            ),
            alignment: Alignment.center,
            child: const Text(
              'C',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),

          // Top (North)
          Positioned(
            top: 0,
            child: smallCircle(color: AppColors.whiteColor, label: 'N'),
          ),

          // Bottom (South)
          Positioned(
            bottom: 0,
            child: smallCircle(color: AppColors.whiteColor, label: 'S'),
          ),

          // Left (West)
          Positioned(
            left: 0,
            child: smallCircle(color: AppColors.whiteColor, label: 'W'),
          ),

          // Right (East)
          Positioned(
            right: 0,
            child: smallCircle(color: AppColors.whiteColor, label: 'E'),
          ),

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
