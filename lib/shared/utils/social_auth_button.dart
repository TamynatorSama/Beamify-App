import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildSocialLogins(String icon,{Function()? onTap}) => GestureDetector(
    onTap: onTap,
    child: Container(
        height: 50,
        width: 55,
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: icon.contains("facebook")?7 :0),
        decoration: BoxDecoration(
          color: const Color(0xff232429),
          border: Border.all(width: 1,color: Colors.white),
          borderRadius: BorderRadius.circular(12)
        ),
        child: SvgPicture.asset(icon,height: icon.contains("facebook")?40 :30,width: icon.contains("facebook")?40 :30,),
      ),
  );