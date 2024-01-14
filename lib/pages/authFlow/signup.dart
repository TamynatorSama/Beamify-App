import 'package:beamify_app/pages/authFlow/email_verification.dart';
import 'package:beamify_app/shared/utils/app_theme.dart';
import 'package:beamify_app/shared/utils/custom_button.dart';
import 'package:beamify_app/shared/utils/custom_input_field.dart';
import 'package:beamify_app/shared/utils/social_auth_button.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

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
                    "Create Account",
                    style: AppTheme.headerStyle,
                  ),
                  Text(
                    "Register now and start exploring  all that our app has to offer.",
                    style: AppTheme.bodyText
                        .copyWith(color: Colors.white.withOpacity(0.7)),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    clipBehavior: Clip.antiAlias,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(children: [
                          Form(
                              child: Column(
                            children: [
                              CustomInputField(
                                  hintText: "Email or Phone number",
                                  controller: TextEditingController()),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomInputField(
                                hintText: "Choose a password",
                                controller: TextEditingController(),
                                isPassword: true,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomInputField(
                                hintText: "Confirm your password",
                                controller: TextEditingController(),
                                isPassword: true,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomInputField(
                                hintText: "Choose a username",
                                controller: TextEditingController(),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomButton(text: "Sign up", onTap: () =>Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EmailVerification()))),
                          const SizedBox(
                            height: 25,
                          ),
                          ConstrainedBox(constraints: BoxConstraints(maxWidth: 300),child: Text("By logging. your agree to our  Terms & Conditions  and Privacy Policy.",textAlign: TextAlign.center,style: AppTheme.bodyText.copyWith(color: Colors.white.withOpacity(0.7),fontSize: 13),),),
                          const SizedBox(
                            height: 15,
                          ),
                          Opacity(
                            opacity: 0.7,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  height: 1,
                                  color: Colors.white,
                                )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    "Or sign up using ",
                                    style: AppTheme.bodyText
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  height: 1,
                                  color: Colors.white,
                                ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Wrap(
                            spacing: 30,
                            children: [
                              buildSocialLogins("assets/icons/facebook.svg"),
                              buildSocialLogins("assets/icons/google.svg"),
                              buildSocialLogins("assets/icons/apple.svg")
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: RichText(
                                text: TextSpan(
                                    children: [
                                  const TextSpan(
                                      text: "Already have an account? "),
                                  TextSpan(
                                      text: " Login",
                                      style: AppTheme.bodyText.copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600))
                                ],
                                    style: AppTheme.bodyText.copyWith(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.6),
                                        fontWeight: FontWeight.w600))),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 20,
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

}
