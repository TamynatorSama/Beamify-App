import 'package:beamify_app/shared/utils/app_theme.dart';
import 'package:beamify_app/shared/utils/custom_button.dart';
import 'package:beamify_app/shared/utils/social_auth_button.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
class EmailVerification extends StatelessWidget {
  const EmailVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 20,
              ),
              buildSocialLogins(
                "assets/icons/Arrow-Left.svg",
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Confirm Account",
                    style: AppTheme.headerStyle,
                  ),
                  Text(
                    "A registration confirmation code Will be sent to your Email Address.",
                    style: AppTheme.bodyText
                        .copyWith(color: Colors.white.withOpacity(0.7)),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                  length: 5,
                  // controller: controller.otpController,
                  defaultPinTheme: PinTheme(
                      height: 50,
                      width: 60,
                      textStyle: AppTheme.buttonStyle.copyWith(color: Colors.white),
                      decoration: BoxDecoration(
                          color: const Color(0xff232429),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(width: 1, color: Colors.grey))),
                ),
                const SizedBox(
                height: 30,
              ),
              CustomButton(text: "Confirm",onTap:(){}),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: (){}, child: Text("Resend code",style: AppTheme.bodyText.copyWith(fontSize: 14),)),
              ),
              const Spacer(),
              RichText(
                                text: TextSpan(
                                    children: [
                                  const TextSpan(
                                      text: "By clicking “ CONFIRM “  you accepted our "),
                                  TextSpan(
                                      text: "Terms & Conditions ",
                                      style: AppTheme.bodyText.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700)),
                                          const TextSpan(
                                      text: " of the "),
                                      TextSpan(
                                      text: "User Agreement",
                                      style: AppTheme.bodyText.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700)),
                                ],
                                    style: AppTheme.bodyText.copyWith(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.6),
                                        fontWeight: FontWeight.w500))),
                                        SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 20,
                          ),
            ],
          )),
    );
  }

}