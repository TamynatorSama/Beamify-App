import 'package:beamify_app/pages/authFlow/login.dart';
import 'package:beamify_app/shared/logo.dart';
import 'package:beamify_app/shared/utils/custom_button.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Column(
          children: [
            Image.asset(
              "assets/images/onboarding_microphone.jpg",
              height: MediaQuery.of(context).size.height * 0.65,
              fit: BoxFit.cover,
            ),
            Expanded(
                child: Container(
              width: double.maxFinite,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff060606), Color(0xff272F31)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
            ))
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            logo(),
            const SizedBox(
              height: 50,
            ),
            CustomButton(
              text: "Start",
              maxWidth: 250,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginWidget()));
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            )
          ],
        ),
      ],
    ));
  }
}
