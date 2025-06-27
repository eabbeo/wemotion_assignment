import 'package:flutter/material.dart';

class CircleWithFiveDirections extends StatelessWidget {
  const CircleWithFiveDirections({super.key});

  @override
  Widget build(BuildContext context) {
    double mainCircleSize = 25;
    double smallCircleSize = 25;
    double middleCircleSize = 25;

    return SizedBox(
      width: mainCircleSize + smallCircleSize * 2,
      height: mainCircleSize + smallCircleSize * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main Central Circle
          Container(
            width: mainCircleSize,
            height: mainCircleSize,
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
            child: smallCircle(color: Colors.red, label: 'N'),
          ),

          // Bottom (South)
          Positioned(
            bottom: 0,
            child: smallCircle(color: Colors.green, label: 'S'),
          ),

          // Left (West)
          Positioned(
            left: 0,
            child: smallCircle(color: Colors.orange, label: 'W'),
          ),

          // Right (East)
          Positioned(
            right: 0,
            child: smallCircle(color: Colors.purple, label: 'E'),
          ),

          // Middle Circle on top of the main one
          Container(
            width: middleCircleSize,
            height: middleCircleSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            alignment: Alignment.center,
            child: const Text(
              'M',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget smallCircle({required Color color, String? label}) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      alignment: Alignment.center,
      child: Text(
        label ?? '',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
