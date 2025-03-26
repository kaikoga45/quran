import 'package:flutter/cupertino.dart';
import 'package:quran/common/constants/color_constant.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoActivityIndicator(),
        SizedBox(
          height: 10.0,
        ),
        Text(
          'LOADING',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorConstant.osloGrey,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }
}
