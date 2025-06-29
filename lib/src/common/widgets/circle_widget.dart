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
  final String pointNorth;
  final String pointWest;
  final String pointSouth;
  final String pointEast;
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
          _shouldShowCircle(pointNorth)
              ? Positioned(
                  top: 0,
                  child: smallCircle(
                    color: AppColors.whiteColor,
                    label: pointNorth,
                  ),
                )
              : const SizedBox(),

          // Bottom (South)
          _shouldShowCircle(pointSouth)
              ? Positioned(
                  bottom: 0,
                  child: smallCircle(
                    color: AppColors.whiteColor,
                    label: pointSouth,
                  ),
                )
              : const SizedBox(),

          // Left (West)
          _shouldShowCircle(pointWest)
              ? Positioned(
                  left: 0,
                  child: smallCircle(
                    color: AppColors.whiteColor,
                    label: pointWest,
                  ),
                )
              : const SizedBox(),

          // Right (East)
          _shouldShowCircle(pointEast)
              ? Positioned(
                  right: 0,
                  child: smallCircle(
                    color: AppColors.whiteColor,
                    label: pointEast,
                  ),
                )
              : const SizedBox(),

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

  // Helper method to determine if a circle should be shown
  bool _shouldShowCircle(String value) {
    // If the value is 'P' or similar non-numeric, show it
    if (int.tryParse(value) == null) {
      return true;
    }
    // If it's numeric, check if it's greater than 0
    return int.parse(value) > 0;
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

// import 'package:flutter/material.dart';
// import 'package:wemotion_mobile/src/common/utils/app_colors/app_colors.dart';

// class CircleWithFiveDirections extends StatelessWidget {
//   const CircleWithFiveDirections({
//     super.key,
//     required this.pointNorth,
//     required this.pointWest,
//     required this.pointSouth,
//     required this.pointEast,
//     required this.mainCircleColor,
//   });
//   final String pointNorth;
//   final String pointWest;
//   final String pointSouth;
//   final String pointEast;
//   final Color? mainCircleColor;

//   @override
//   Widget build(BuildContext context) {
//     double mainCircleSize = 20;
//     double smallCircleSize = 20;
//     double middleCircleSize = 20;

//     return SizedBox(
//       width: mainCircleSize + smallCircleSize * 2,
//       height: mainCircleSize + smallCircleSize * 2,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Main Central Circle
//           Container(
//             width: 15,
//             height: 15,
//             decoration: const BoxDecoration(shape: BoxShape.circle),
//             alignment: Alignment.center,
//           ),

//           // Top (North)
//           int.parse(pointNorth) > 0
//               ? Positioned(
//                   top: 0,
//                   child: smallCircle(
//                     color: AppColors.whiteColor,
//                     label: pointNorth.toString(),
//                   ),
//                 )
//               : SizedBox(),

//           // Bottom (South)
//           int.parse(pointSouth) > 0
//               ? Positioned(
//                   bottom: 0,
//                   child: smallCircle(
//                     color: AppColors.whiteColor,
//                     label: pointSouth.toString(),
//                   ),
//                 )
//               : SizedBox(),

//           // Left (West)
//           int.parse(pointWest) > 0
//               ? Positioned(
//                   left: 0,
//                   child: smallCircle(
//                     color: AppColors.whiteColor,
//                     label: pointWest.toString(),
//                   ),
//                 )
//               : SizedBox(),

//           // Right (East)
//           int.parse(pointEast) > 0
//               ? Positioned(
//                   right: 0,
//                   child: smallCircle(
//                     color: AppColors.whiteColor,
//                     label: pointEast.toString(),
//                   ),
//                 )
//               : SizedBox(),

//           // Middle Circle on top of the main one
//           Container(
//             width: middleCircleSize,
//             height: middleCircleSize,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: mainCircleColor,
//             ),
//             alignment: Alignment.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget smallCircle({required Color color, String? label}) {
//     return Container(
//       width: 20,
//       height: 20,
//       decoration: BoxDecoration(shape: BoxShape.circle, color: color),
//       alignment: Alignment.center,
//       child: Text(
//         label ?? '',
//         style: const TextStyle(
//           color: AppColors.blackColor,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }
