import 'package:flutter/material.dart';
import 'package:naturascan/Utils/constants.dart';

import '../../models/seaState.dart';
import 'customDropDown.dart';
import 'customText.dart';

class ShippingTypeSelectWidget extends StatefulWidget {
     final TextEditingController typeBController;
   const ShippingTypeSelectWidget({
    super.key,
    required this.typeBController
  });

  @override
  State<ShippingTypeSelectWidget> createState() => _ShippingTypeSelectWidgetState();
}

class _ShippingTypeSelectWidgetState extends State<ShippingTypeSelectWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 22),
          child: CustomText(
            text: "Type de la sortie",
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        CustomDropDownInputField(
          value: widget.typeBController.text.isEmpty
              ? null
              : widget.typeBController.text,
          items: Constants.type.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(),
                ));
          }).toList(),
          onChanged: (p0) {
            setState(() {
             widget.typeBController.text = p0;
            });
          },
        ),
      ],
    );
  }
}
