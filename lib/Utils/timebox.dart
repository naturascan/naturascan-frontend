import 'package:flutter/material.dart';
import 'package:naturascan/Utils/Utils.dart';

import 'constants.dart';
import 'Widgets/customText.dart';

Row timeBox(BuildContext context,
    {required String title,
    required TextEditingController controller,
    FontWeight? fontWeight,
    required onTap}) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 22),
            child: CustomText(
              text: title,
              fontSize: 22,
              fontWeight: fontWeight ?? FontWeight.w700,
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 150,
            height: 50,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomText(
                  text: Utils.formatTime(int.tryParse(controller.text) ?? DateTime.now().millisecondsSinceEpoch),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.timer, color: Constants.colorPrimary),
                ),
              ],
            ),
          ),
        )
      ]);
}
