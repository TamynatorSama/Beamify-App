import 'package:beamify_app/shared/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget logo() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SvgPicture.asset("assets/icons/logo_track.svg",width: 160,),
      const SizedBox(height: 15,),
      Column(
        children: [
          Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/icons/headphones.svg"),
          Text("Beamify",style: AppTheme.logoTextStyle,)
        ],
      ),
      Text("Words come alive",style: AppTheme.bodyText.copyWith(color: AppTheme.primaryColor,fontWeight: FontWeight.w600),)
        ],
      )
    ],
  );
}
