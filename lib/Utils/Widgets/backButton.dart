import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naturascan/Utils/constants.dart';

class AppBarBack extends StatelessWidget {
  const AppBarBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
      child: InkWell(
        onTap: () {
          Get.back();
        },
        child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.black.withOpacity(0.1)),
            child: const Center(
              child: Icon(
                Icons.arrow_back,
                color: Constants.colorPrimary,
              ),
            )),
      ),
    );
  }
}
