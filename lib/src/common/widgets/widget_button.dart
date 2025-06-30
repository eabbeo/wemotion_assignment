import 'package:flutter/material.dart';
import 'package:wemotion_mobile/src/common/utils/app_colors/app_colors.dart';

Widget buildActionButton(IconData icon, {bool isMore = false}) {
  return CircleAvatar(
    backgroundColor: AppColors.greyColor.withValues(alpha: 0.5),
    child: Icon(icon, color: AppColors.whiteColor, size: isMore ? 20 : 24),
  );
}
