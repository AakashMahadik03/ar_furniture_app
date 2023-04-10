import 'package:decal/widgets/verification/code_form.dart';
import 'package:flutter/material.dart';

class ForgetStage2 extends StatelessWidget {
  const ForgetStage2(this.setData, this.buttonText, {super.key});
  final Function setData;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        EmailCodeForm(
          setData,
          '1234',
          buttonText,
        ),
      ],
    );
  }
}
