import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';


class NetworkDialog extends StatelessWidget {
  final String message;
  const NetworkDialog({
    super.key,
    required this.message
  });

  @override
  Widget build(BuildContext context) {
    print('eererrere');
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Icon(
              Icons.network_locked,
              size: 70,
            ),
             CustomText(
              text: "$message Prolème de connexion. Veuillez vérifier votre connexion et réssayer.\nMerci.",
              fontSize: 18,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                        child: const CustomText(text: "Ok"))),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}



class ErrorDialog extends StatelessWidget {
  final String message;
  const ErrorDialog({
    super.key,
    required this.message
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Icon(
              Icons.error,
              size: 70,
            ),
             CustomText(
            text: "$message\nMerci.",
              fontSize: 18,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                        child: const CustomText(text: "Ok"))),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
