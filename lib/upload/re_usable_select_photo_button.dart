import 'package:flutter/material.dart';
import 'package:foundoor/utils/color_constants.dart';

class SelectPhoto extends StatelessWidget {
  final String textLabel;
  final IconData icon;

  final void Function()? onTap;

  const SelectPhoto({
    Key? key,
    required this.textLabel,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 9,
        primary: Colors.grey.shade200,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              icon,
              color: ColorConstants.appColor,
            ),
            const SizedBox(
              width: 14,
            ),
            Text(
              textLabel,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF336B87),
              ),
            )
          ],
        ),
      ),
    );
  }
}
